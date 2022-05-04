% IPC
% zdszero
% 2022-05-04

## communication

### pipe

a pipe is simply a buffer maintained by kernel

* limited capacity
* unidirectional
* byte stream

### fifos

pipe can be used only between parent and child process, while fifo (can be called named pipe) can be used between unrelated processes.

* sematics of reading n bytes from pipe, the current bytes available in pipe is p

| O_NONBLOCK enabled? | p = 0, write end open | p = 0, write end closed | p < n        | p >= n       |
| :-:                 | :-:                   | :-:                     | :-:          | :-:          |
| NO                  | block                 | return 0(EOF)           | read p bytes | read n bytes |
| YES                 | fail (EAGAIN)         | return 0(EOF)           | read p bytes | read n bytes |

* sematics of writing n bytes to pipe, the buffer size is p

| O_NONBLOCK enable? | n <= p        | n > p                                                           | read end close  |
| :-:                | :-:           | :-:                                                             | :-:             |
| NO                 | write n bytes | write available bytes, return until all bytes have been written | SIGPIPE + EPIPE |
| YES                | write n bytes | write available bytes, EAGAIN                                   | SIGPIPE + EPIPE |


简单来说，这里的非阻塞就是当前操作如果不能成功，比如打开管道时另一方还没有打开，写数据时缓冲区不够全部写入了，马上返回一个错误值`EAGAIN`

## synchronization
