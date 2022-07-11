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

在table中寻找大于等于key的
