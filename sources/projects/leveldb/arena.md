% arena
% zdszero
% 2022-07-09

Manage a vector of blocks (each block's size is 4KB).

__public functions__

* `Allocate(size_t bytes)`
* `AllocateAligned(size_t bytes)`

__private members__

* `vector<char *> blocks_`
* `atomic<size_t> memory_usage_`
* `char *alloc_ptr_`
* `size_t alloc_bytes_remaining_`
