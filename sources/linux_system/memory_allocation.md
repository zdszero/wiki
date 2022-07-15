% memory allocation
% zdszero
% 2022-07-13

## 程序内存结构

```
--------
 stack
   ↓


   ↑
  heap
--------
  bss
--------
  data
--------
  text
--------
```

* text：包含了形成程序可执行代码的机器指令。它是由编译器和汇编器把C、C++或者其他程序的源码转化为机器码产生的。通常，代码段是只读的
* data：包含了所有（已初始化的）的程序变量、字符串、数字和其他数据的存储
* bss：包含了所有未初始化的静态数据，这些数据将被初始化为0
* heap：包含了进程动态申请的内存
* stack：包含了局部变量，函数参数，指针拷贝

__heap__

```c
#include <stdlib.h>

void *malloc(size_t size);
void *calloc(size_t numitems, size_t size);
void *realloc(void *ptr, size_t size);
```

__stack__

faster, but  the memory that it allocates is automatically freed when the stack frame is removed

## 动态内存管理

heap的顶部，被一个brk(break) 指针标示，在heap申请内存的时候，需要请求操作系统增加brk。同样，在heap上释放内存的时候需要请求操作系统减小brk。

在Linux /Unix操作系统中，有一个sbrk的系统调用可以让我们实现修改brk指针

- 调用sbrk(0)可以返回当前brk指针的地址
- 调用sbrk(x),brk指针增加x字节，内存被申请
- 调用sbrk(-x),brk指针减小x字节，内存被释放

__malloc__

无法保证内存块之间是连续的，因为可能存在mmap()映射的内存，或者存在一些被释放的内存。需要用链表的形式保存已经分配的内存。

```
struct header_t {
    size_t size;
    unsigned is_free;
    struct header_t *next;
};

struct header_t *head, *tail;
```

[simple implementation](https://github.com/arjun024/memalloc)

__free__

free() 首先要确定当前要释放的内存块是否位于heap的顶部（链表的尾部）。如果是的话，release it to the OS. 如果不是的话，标记为free，便于以后重用。
