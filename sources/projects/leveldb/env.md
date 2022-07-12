% file
% zdszero
% 2022-07-12

__interface__

```
class WritableFile {
public:
    virtual Status Append(const Slice& data) = 0;
    virtual Status Close() = 0;
    virtual Status Flush() = 0;
    virtual Status Sync() = 0;
};

class SequentialFile {
public:
    virtual Status Read(size_t n, Slice* result, char* scratch) = 0;
    virtual Status Skip(uint64_t n) = 0;
};

class RandomAccessFile {
public:
    virtual Status Read(size_t n, Slice* result, char* scratch) = 0;
};
```
