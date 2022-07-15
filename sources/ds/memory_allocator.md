% memory allocator
% zdszero
% 2022-07-15

## 设计策略

- 单线程（Single-threaded）：如果一个Arena只会被一个线程使用，就不需要用同步原语(比如锁或原子变量)来保护数据。不存在使用Arena的客户端被其他线程阻塞的风险，这在实时环境中是很重要的。
- 固定大小的分配（Fixed-size allocations）：如果Arena只分配固定大小的内存块，那么通过使用一个空闲列表，在没有内存碎片的情况下有效地回收内存可以相对容易实现。
- 有限的生命周期（Limited lifetime）：如果Arena中分配的对象只会在有限和定义良好的生命周期内存在，那么Arena可以推迟回收分配的对象，并一次性释放所有内存。一个典型的例子是在服务器应用程序中处理请求时创建的对象。当请求完成时，在请求期间分配的所有内存都可以在一个步骤中回收。当然，Arena需要足够大的内存块来处理请求期间的所有分配，而不需要不断回收内存;否则，这一策略将不起作用。

## 实现

### short alloc

使用栈上的空间

```cpp
template <size_t N, size_t Align = 8>
class Arena {
private:
    char buf_[N];
    char *ptr_;
    void AlignUp()

    size_t AlignUp(size_t n) {
        return (n + Align - 1) & ~(Align - 1);
    }
    bool PointerInBuffer(char *p) {
        return (buf_ < p) && (p < buf_ + N);
    }

public:
    Arena(): ptr_(buf_){}
    Arena(const Arena&) = delete;
    Arena& operator(const Arena&) = delete;

    char* Allocate(size_t n) {
        size_t aligned_n = AlignUp(n);
        size_t avail_bytes = static_cast<size_t>(buf_ + N - ptr_);
        if (aligned_n < avail_bytes) {
            char *ret = ptr_;
            ptr_ += aligned_n;
            return ret;
        }
        return static_cast<char*>(::operator new(n));
    }

    void Deallocate(char *p, size_t n) {
        if (PointerInBuffer(p)) {
            n = AlignUp(n);
            if (p + n == ptr) {
                ptr_ = p;
            }
        } else {
            ::operator delete(p);
        }
    }
};
```

### leveldb

1. 统计内存表的内存使用信息
2. 统计所有动态内存的位置

```cpp
class Arena {
private:
    vector<char*> blocks_;
    atomic<size_t> memory_usage_;
    char* alloc_;
    size_t alloc_bytes_remaining_;

    char* AllocateNewBlock(size_t block_size);

public:
    Arena();

    Arena(const Arena&) = delete;
    Arena& operator=(const Arena&) = delete;

    char* Allocate(size_t bytes);
    char* AllocateAligned(size_t bytes);
};
```
