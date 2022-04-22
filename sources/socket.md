%title socket

## socket

### methods

**creation**

* `socket(family, type) -> socket`
* `socketpair(family, type) -> (socket, socket)`
* `create_connection(address, timeout, source_addr) -> tcp_socket`
* `create_server(address, family, backlog) -> tcp_socket`

**config** 

* `setblocking(bool)`: the default action is False, if flag is True, then the socket is blocked when no data to receive
* `settimeout(value)`
* `setsockopt(level, optname, value: int)`

**tcp/udp**

server:

* `bind(address)`
* `listen(n)`
* `accept() -> (socket, address)`

client:

* `connect(address)`

**send**

* `send(bytes, [flags]) -> int`
* `sendall(bytes, [flags]) -> None`: keeping sending util all bytes have been sent
* `sendto(bytes, [flags], address)`
* `sendfile(file, offset, count)`

**recv**

* `recv(bufsize, [flags]) -> bytes`
* `recvfrom(bufsize, [flags]) -> (bytes, address)`

**utils** 

DNS utils

* `gethostbyname(hostname) -> str`: perform DNS and returns a IPv4 address in dotted decimal format
* `getaddrinfo(host, port) -> list[(family, type, proto, canonname, sockaddr)]`
    * host can be either IPv4, IPv6 or domain
    * port can be port number or service name like http or ftp

conversion between network octet and host octet

* `htons(x)`
* `htonl(x)`
* `ntohl(x)`
* `ntohs(x)`

conversion from human readable IP representation and network bytes, `a` for string, `p` for protocol

* `inet_aton(ip_string)`: convert dotted decimal to packed binary format
* `inet_ntoa(packed_ip)`
* `inet_pton(addr_family, ip_string)`
* `inet_ntop(addr_family, packed_ip)`

other

* `gethostname() -> str`
* `getsockname() -> (address, port)`

### problems

* What is the common methods of UDP and TCP

`bind` method, UDP can also call `connect` method, then it can call `send` method without specifying the destination address

* What is the difference between `close` and `shutdown`

## socketserver

### class

```
+------------+
| BaseServer |
+------------+
      |
      v
+-----------+        +------------------+
| TCPServer |------->| UnixStreamServer |
+-----------+        +------------------+
      |
      v
+-----------+        +--------------------+
| UDPServer |------->| UnixDatagramServer |
+-----------+        +--------------------+
```

## working with binary

### struct

perform conversion between python values and C struct represented by python bytes object

```
pack(format, iter ...) -> bytes

unpack(format, bytes) -> tuple
```

* format specification

**byte order**

| character | byte order          | size     | alignment |
| :-:       | :-:                 | :-:      | :-:       |
| `@`       | native              | native   | native    |
| `=`       | native              | standard | none      |
| `<`       | little endian       | standard | none      |
| `>`       | big endian          | standard | none      |
| `!`       | network(big endian) | standard | none      |

native size means the `sizeof(type)` is C


**foramt characters** 

| format | c tpye             | standard size |
| :-:    | :-:                | :-:           |
| `b`    | signed char        | 1             |
| `B`    | unsigned char      | 1             |
| `h`    | short              | 2             |
| `H`    | unsigned char      | 2             |
| `i`    | int                | 4             |
| `I`    | unsigned int       | 4             |
| `l`    | long               | 4             |
| `L`    | unsigned long      | 4             |
| `q`    | long long          | 8             |
| `Q`    | unsigned long long | 8             |
