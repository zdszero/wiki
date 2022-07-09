% slice
% zdszero
% 2022-07-09

a __view__ of actual memory

* __data member__

start location: `const char *data_`, length: `size_t size_`

* __operator overload__

implement `operator!=` using `operator==`

```cpp
bool operator==(const Slice& x, const Slice& y) {
  return ((x.size() == y.size()) &&
          (memcmp(x.data(), y.data(), x.size()) == 0));
}

bool operator!=(const Slice& x, const Slice& y) { return !(x == y); }

char operator[](size_t n) cosnt {
    asssert(n < size_);
    return data_[n];
}
```

* __other utilities__

`remove_prefx(size_t n)`, `clear()`
