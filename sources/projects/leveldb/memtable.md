% memtable
% zdszero
% 2022-07-11

__skip list template__

```
template <typename Key, typename Comparator>
class SkipList {
    struct Node;
};

template <typename Key, typename Comparator>
struct SkipList<Key, Comparator>::Node {
    Key const key;
};
```

__memtable class__

```
class MemTable {
private:
    struct KeyComparator {
        const InternalKeyComparator comparator;
        explicit KeyComparator(const InternalKeyComparator& c): comparator(c) {}
        bool operator()(const char* a, const char* b);
    };
    typedef SkipList<char *, KeyComparator> Table;

    Table table_;
};
```

注意这里KeyComparator::operator()的实现：选取两个entry的表示lookup key的prefix，调用comparator.Compare()进行比较。

所以skip list中的node是按照entry中的lookup key进行排序的，

__add__

how to encode `klength + internal key + value size + value` into bytes and store it in memory

```cpp
void MemTable::Add(SequenceNumber s, ValueType type, const Slice& key,
                   const Slice& value) {
    int key_size = key.size();
    int internal_key_size = key.size() + 8;
    int val_size = value.size();
    // 计算<K,V>长度并且分配内存
    int encoded_len = VarintLength(internal_key_size) + internal_key_size
                    + VarintLength(val_size) + val_size;
    char* buf = arena_.Allocate(encoded_len);
    // 依次存储LookupKey中的各项
    char* p = buf;
    p = EncodeVarint32(p, internal_key_size);
    std::memcpy(p, key.data(), key_size);
    p += key_size;
    EncodeFixed64(p, (s << 8) | type);
    p += 8;
    p = EncodeVarint32(p, val_size);
    std::memcpy(p, value.data(), val_size);
    // assert确保繁琐的过程正确
    assert(p + val_size == buf + encoded_len);
    table_.Insert(buf);
}
```

__get__

在table中寻找大于包含key的entry

```cpp
Slice GetLengthPrefixedSlice(const char *data) {
    uint32_t len;
    char *p = GetVarint32Ptr(data, data + 5, &len);
    return Slice(p, len);
}

bool Get(const LookupKey& key, string* value, Status* s) {
    Slice memkey = key.memtable_key();
    Table::Iterator iter(table_);
    iter.Seek(memkey);
    if (iter.Valid()) {
        // | key_length | user_key | tag (sequence | type) | value_length | value |
        const char* entry = iter.key();
        uint32_t key_length;
        const char* key_ptr = GetVarint32Ptr(entry, entry + 5, &key_length);
        // 比较entry中的user key和lookup key中的user key是否相同
        if (user_comparator.Compare(Slice(key_ptr, key_length - 8), key.user_key()) == 0) {
            // 获取entry中的type字段
            const uint64_t tag = DecodeFixed64(key_ptr + key_length - 8);
            const uint8_t type = tag & 0xff;
            if (type == kTypeValue) {
                Slice v = GetLengthPrefixedSlice(key_ptr + key_length);
                value.assing(v.data(), v.size());
                return true;
            } else if (type == kTypeDeletion) {
                *s = Status::NotFound(Slice());
                return false;
            }
        }
    }
}
```
