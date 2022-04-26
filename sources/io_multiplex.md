%title IO multiplex

## some concepts

### concurrency vs parallesim

parallesim: use different cores in cpu to execute multiple tasks at the same time

concurrency: a program should be disigned into several parts which can be executed out of order or in partial order, withouting effecting the final result

### blocking vs nonblocking

blocking: 当程序在等待某个操作被完成时（比如IO操作），当前程序被挂起，直到该操作完成，程序才继续执行。

nonblocking: 程序无需等待操作被完成，继续执行接下来的代码段。

### sync vs async

sync: 不同程序单元为了完成某个任务，在执行过程中需靠某种通信方式以协调一致，称这些程序单元是同步执行的。

async: 为完成某个任务，不同程序单元之间过程中无需通信协调，也能完成任务的方式。

### 异步编程

以进程、线程、协程、函数作为程序执行的基本单位，结合回调、事件循环、信号量等机制，以提高程序整体运行效率的一种方式。

### C10k/C10M

C10k（concurrently handling 10k connections）是一个在1999年被提出来的技术挑战，如何在一颗1GHz CPU，2G内存，1gbps网络环境下，让单台服务器同时为1万个客户端提供FTP服务。而到了2010年后，随着硬件技术的发展，这个问题被延伸为C10M，即如何利用8核心CPU，64G内存，在10gbps的网络上保持1000万并发连接，或是每秒钟处理100万的连接。（两种类型的计算机资源在各自的时代都约为1200美元）

## select

## epoll
