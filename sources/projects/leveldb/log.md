% log
% zdszero
% 2022-07-09

leveldb的写操作并不是直接写入磁盘的，而是首先写入到内存。假设写入到内存的数据还未来得及持久化，leveldb进程发生了异常，抑或是宿主机器发生了宕机，会造成用户的写入发生丢失。因此leveldb在写内存之前会首先将所有的写操作写到日志文件中，也就是log文件。当以下异常情况发生时，均可以通过日志文件进行恢复：

1. 写log期间进程异常；
2. 写log完成，写内存未完成；
3. write动作完成（即log、内存写入都完成）后，进程异常；
4. Immutable memtable持久化过程中进程异常；
5. 其他压缩异常（较为复杂，首先不在这里介绍）；

当第一类情况发生时，数据库重启读取log时，发现异常日志数据，抛弃该条日志数据，即视作这次用户写入失败，保障了数据库的一致性；

当第二类，第三类，第四类情况发生了，均可以通过redo日志文件中记录的写入操作完成数据库的恢复。

每次日志的写操作都是一次顺序写，因此写效率高，整体写入性能较好。

此外，leveldb的用户写操作的原子性同样通过日志来实现。

## 结构

```
block := record* trailer?
record :=
  checksum: uint32     // crc32c of type and data[] ; little-endian
  length: uint16       // little-endian
  type: uint8          // One of FULL, FIRST, MIDDLE, LAST
  data: uint8[length]
```

![log structure](../../../docs/images/image_2022-07-09-21-42-55.png)

log → block → chunk (record) → entries

__chunk (record)__

| checksum (4B) | length (2B) | type (1B) | data |
|:-:|:-:|:-:|:-:|
| uint32_t | uint16_t | uint8_t | uint8_t[length] |

type: full, first, middle, last

```
enum RecordType {
    // Zero is reserved for preallocated files
    kZeroType = 0,

    kFullType = 1,

    // For fragments
    kFirstType = 2,
    kMiddleType = 3,
    kLastType = 4
};
```

record中的type的意思是当前record中的data位于slice中的哪个部分

* `kFullType`: 当前Log Block里的空间足以容纳写入的数据，type为kFullType，表示当前Log Record里包含所有的数据；
* `kFirstType`: 当前的Log Block里的空间不足以容纳写入的数据时，将写入的数据拆分，用前面部分将当前Log Block填满，这时候type就是KFirstType，表示当前的Log Record是数据的第一个部分；
* `kMiddleType`: 接下来开始一个新的Log Block，如果这个Log Block依然不能容纳所有的数据，这时候type就是kMiddleType，表示这个Log Record保存了中间部分的数据，后面还有数据；
* `kLastType`: 当剩余的数据可以容纳到新的Log Block时，这时候type就是kLastType，表示这个记录的数据结束了，可以和前面的数据组合起来；
* `kZeroType`: kZeroType是为了兼容mmap相关的代码，这种方式会先将数据分配好，置0，所以当读取日志的文件读取这些0时，就可以跳过这些数据，我们不会写入这种类型的日志记录。

一个record不会开始于一个block的最后6个字节，因为一个不包含任何data的record都需要7个字节。如果一个chunk最后还剩7个字节，那么writer必须写入一个FIRST record，然后将用户数据写入下一个block。

__record:data__

| sequence number | entry number | batch data | ... | batch data |
| :-: | :-: | :-: | :-: | :-: |

## 写

__add logic record__

```cpp
Status Writer::AddRecord(const Slice& slice) {
  const char* ptr = slice.data();
  size_t left = slice.size();

  // Fragment the record if necessary and emit it.  Note that if slice
  // is empty, we still want to iterate once to emit a single
  // zero-length record
  Status s;
  bool begin = true;
  do {
    const int leftover = kBlockSize - block_offset_;
    assert(leftover >= 0);
    if (leftover < kHeaderSize) {
      // Switch to a new block
      if (leftover > 0) {
        // Fill the trailer (literal below relies on kHeaderSize being 7)
        static_assert(kHeaderSize == 7, "");
        dest_->Append(Slice("\x00\x00\x00\x00\x00\x00", leftover));
      }
      block_offset_ = 0;
    }

    // available size in current block
    const size_t avail = kBlockSize - block_offset_ - kHeaderSize;
    // Invariant: we never leave < kHeaderSize bytes in a block.
    assert(avail >= 0);

    // fragment might be the whole record data
    const size_t fragment_length = (left < avail) ? left : avail;

    RecordType type;
    const bool end = (left == fragment_length);
    if (begin && end) {
      type = kFullType;
    } else if (begin) {
      type = kFirstType;
    } else if (end) {
      type = kLastType;
    } else {
      type = kMiddleType;
    }

    s = EmitPhysicalRecord(type, ptr, fragment_length);
    ptr += fragment_length;
    left -= fragment_length;
    begin = false;
  } while (s.ok() && left > 0);
  return s;
}
```

`begin`意思是当前fragment是slice中的第一个fragment，`end`意思是当前fragment是slice中的最后一个fragment，可以通过这两个flag来判断当前fragment的type。

__add physical record__

```cpp
Status Writer::EmitPhysicalRecord(RecordType t, const char* ptr,
                                  size_t length) {
  assert(length <= 0xffff);  // Must fit in two bytes
  assert(block_offset_ + kHeaderSize + length <= kBlockSize);

  // Format the header
  char buf[kHeaderSize];
  buf[4] = static_cast<char>(length & 0xff);
  buf[5] = static_cast<char>(length >> 8);
  buf[6] = static_cast<char>(t);

  // Compute the crc of the record type and the payload.
  uint32_t crc = crc32c::Extend(type_crc_[t], ptr, length);
  crc = crc32c::Mask(crc);  // Adjust for storage
  EncodeFixed32(buf, crc);

  // Write the header and the payload
  Status s = dest_->Append(Slice(buf, kHeaderSize));
  if (s.ok()) {
    s = dest_->Append(Slice(ptr, length));
    if (s.ok()) {
      s = dest_->Flush();
    }
  }
  block_offset_ += kHeaderSize + length;
  return s;
}
```

## 读

__log reader__

```
class Reader {
    SequentialFile *file_;
    Slice buffer_;
};
```

__read logic record__

```
// record is only a view of string, use scratch to store the result
bool Reader::ReadRecord(Slice* record, string* scratch) {
    scratch.clear();
    record.clear();

    // if the reading record is fragmented
    bool in_fragmented_record = false;
    // save the fragment
    Slice fragment;

    while (true) {
        // read physical record into buffer_ and remove the entry header
        const unsigned int record_type = ReadPhysicalRecord(&fragment);

        // the just reading record offset
        uint64_t physical_record_offset =
            end_of_buffer_offset_ - buffer.size() - kHeaderSize - fragment.size();

    }
}
```

__read physical record__

```
unsigned int Reader::ReadPhysicalRecord(Slice* record) {
    while (true) {
        if (buffer_.size() < kHeaderSize) {
            if (!eof) {
                buffer_.clear();
                // read block into buffer
            } else {
                buffer_.clear();
                return kEof;
            }
        }
        // parse header
        const char* header = buffer_.data();
        // check CRC
        // skip physical record that started before initial_offset_
        *result = Slice(header + kHeaderSize, length);
    }
}
```
