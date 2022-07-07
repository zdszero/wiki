% atomic
% zdszero
% 2022-07-07

## atomic

__usage__

保证多个线程对于一个对象的操作是原子性的，也可以避免编译器重新安排代码执行的顺序。

__compared with volatile__

`volatile` is not used for concurrent programming, is the way we tell compilers that we’re dealing with special memory. Its meaning to compilers is “Don’t perform any optimizations on operations on this memory.”

```
volatile int x;

auto y = x;   // cannot be optimized away
y = x;

x = 10;  // cannot be optimized away
x = 20;
```
