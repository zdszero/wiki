% bit
% zdszero
% 2022-07-07

* __align__

```
const int align = (sizeof(void *) > 8) ? sizeof(void*) : 8;
size_t current_mod = alloc_ptr & (align - 1);
size_t slop = (current_mod == 0 ? 0 : align - current_mod);
size_t needed = bytes + slop;
```
