% memory allocation
% zdszero
% 2022-07-13

__heap__

```c
#include <stdlib.h>

void *malloc(size_t size);
void *calloc(size_t numitems, size_t size);
void *realloc(void *ptr, size_t size);
```

__stack__

faster, but  the memory that it allocates is automatically freed when the stack frame is removed
