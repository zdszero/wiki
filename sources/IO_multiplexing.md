%title IO multiplexing

## fork

fork based server

```c
int sock = socket(AF_INET, SOCK_STREAM, 0);
int clnt_sock;
pid_t pid;
if (bind(sock, (struct sockaddr *)&addr, sizeof(addr)) == -1) error();
if (listen(sock, 5) == -1) error();
for (;;) {
	clnt_sock = accept(&clnt_addr, &clnt_addr_size);
	if (clnt_sock == -1) continue;
	pid = fork();
	if (pid == 0) { // 服务器处理 }
	else { close(clnt_sock); }
}
```

## thread

thread based server

```c
for (;;) {
	clnt_sock = accept();
	pthread_create(&thread_id, NULL, handle_clnt, (void *) &clnt_sock);
	pthread_detach(thread_id);
}

void *handle_clnt(void *arg) {
	// implementation
}
```

## select

```c
fd_set reads, temp;
FD_ZERO(reads);
FD_SET(serv_sock, reads);

while (1) {
  temp = reads;
  nfds = select();
  for (i = 0; i < nfds; i++) {
    if (FD_ISSET(i, temp)) {
      if (i == serv_sock) {
        clnt_sock = accept();
        FD_SET(clnt_sock, reads);
      } else {
        str_len = read();
        if (str_len == 0) {
          // EOF，清除连接
          FD_CLR();
        } else {
         // 处理读到的数据
        }
      }
    }
  }
}
```

## epoll

```c
// create epoll fd to scan fds
int epfd = epoll_create(EP_SIZE);
FILE *fd = fopen(fname, opt);
// create epoll event: consider fd and trigger event
struct epoll_event event;
event.data.fd = fd;
event.events = EPOLLIN;
// register the event on epoll fd
epoll_ctl(epfd, EPOLL_ADD, fd, &event);
// wait for fds changes and returns the number changed
epoll_wait(epfd, events, maxevents, timeout);
```

### Level Trigger

```c
// 与上述注册流程相同
while (1) {
  int nfds = epoll_wait(...);
  for (i = 0; i < nfds; i++) {
    if (events[i].data.fd == SERV) {
      clnt_sock = accept();
      // 添加client套接字到epoll中
    } else {
      str_len = read(events[i].data.fd, buf, BUF_SIZE);
      // ...
    }
  }
}
```

### Edge Trigger

```c
// 其他相同
event.events = EPOLLIN | EPOLLET;
while (1) {
  int nfds = epoll_wait(...);
  for (i = 0; i < nfds; i++) {
    if (events[i].data.fd == SERV) {
      clnt_sock = accept();
      // 注册clinet socket为非阻塞
      int flag = fcntl(fd, F_GETFL, 0);
      fctnl(fd, F_SETFL, flag | O_NONBLOCK);
      // 添加client套接字到epoll中
    } else {
      // 由于后续不会再产生epoll_wait事件，所以在这里写一个循环来读取所有的数据
      while (1) {
        str_len = read(events[i].data.fd, buf, BUF_SIZE);
        // ...
        if (str_len == 0) {
          // EOF and remove sock
        } else if (str_len < 0) {
          // end reading
          if (errno == EAGAIN)
            break;
        } else {
          // 处理数据
        }
      }
    }
  }
}
```
