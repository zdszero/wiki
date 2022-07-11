% comparator
% zdszero
% 2022-07-09

__base comparator__

```cpp
class Comparator {
public:
    virtual Compare(const Slice& a, const Slice &b);
    // find a short string in [start, limit)
    // setting start to that string
    virtual void FindShortestSeperator(string* start, const Slice& limit);
    // change *key to a short string >= key
    virtual void FindShortSuccessor(string* key);
};
```

__bytewise compartor__

compare like cstring

* `FindShortestSeperator`: 从第一个不同的位置向后，找到一个start比limit小的字节，将其++（如果可以的话），然后修改start长度，如果没有修改任何字节的话，则说明start是limit的前缀
* `FindShortSuccessor`: 从前到后找到第一个可以++的byte增加，然后修改key长度即可，如果都没有的话不改变key

__internal key comparator__

```
| User Key | SequenceNumber (7B) | Type (1B) |
```

Order by:

* increasing user key (according to user-supplied comparator)
* decreasing sequence number
* decreasing type (though sequence# should be enough to disambiguate)
