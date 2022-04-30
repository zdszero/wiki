% socks

[rfc 1928 -- socks5](https://www.rfc-editor.org/rfc/rfc1928.txt)

## proxy server

### why

* acts as application-layer gateway between networks, offering controled TELNET, FTP and SMTP access.

## socks version

socks4 only support TCP and IPv4.

socks5 5extends the SOCKS Version 4 model to include UDP, and extends the framework to include provisions for generalized strong authentication schemes, and extends the addressing scheme to encompass domain-name and V6 IP addresses.

## socks5 spec

### connection establishment

* greeting message from client

```
  +----+----------+----------+
  |VER | NMETHODS | METHODS  |
  +----+----------+----------+
  | 1  |    1     | 1 to 255 |
  +----+----------+----------+

  o NMETHODS  number of methods supported by clients
  o METHODS   supported methods sequence
```

* server answer

```
  +----+--------+
  |VER | METHOD |
  +----+--------+
  | 1  |   1    |
  +----+--------+

  METHOD
    o  X'00' NO AUTHENTICATION REQUIRED
    o  X'01' GSSAPI
    o  X'02' USERNAME/PASSWORD
    o  X'03' to X'7F' IANA ASSIGNED
    o  X'80' to X'FE' RESERVED FOR PRIVATE METHODS
    o  X'FF' NO ACCEPTABLE METHODS
```

* method-specific sub-negotiation

**USERNAME/PASSWORD**

[rfc 1929 spec](https://www.rfc-editor.org/rfc/rfc1929.html)

```
client request
   +----+------+----------+------+----------+
   |VER | ULEN |  UNAME   | PLEN |  PASSWD  |
   +----+------+----------+------+----------+
   | 1  |  1   | 1 to 255 |  1   | 1 to 255 |
   +----+------+----------+------+----------+

  VER: 0x01

server reply:
                +----+--------+
                |VER | STATUS |
                +----+--------+
                | 1  |   1    |
                +----+--------+

  STATUS:
    o 0x00 indicates success
    o other is failure, server CLOSE the connection
```

### request

* format

```
  +----+-----+-------+------+----------+----------+
  |VER | CMD |  RSV  | ATYP | DST.ADDR | DST.PORT |
  +----+-----+-------+------+----------+----------+
  | 1  |  1  | X'00' |  1   | Variable |    2     |
  +----+-----+-------+------+----------+----------+
```

* fields

```
  o  VER    protocol version: X'05'
  o  CMD
     o  CONNECT X'01'
     o  BIND X'02'
     o  UDP ASSOCIATE X'03'
  o  RSV    RESERVED
  o  ATYP   address type of following address
     o  IP V4 address: X'01'
     o  DOMAINNAME: X'03'
     o  IP V6 address: X'04'
  o  DST.ADDR       desired destination address
  o  DST.PORT desired destination port in network octet
     order
```

### reply

* format

```
  +----+-----+-------+------+----------+----------+
  |VER | REP |  RSV  | ATYP | BND.ADDR | BND.PORT |
  +----+-----+-------+------+----------+----------+
  | 1  |  1  | X'00' |  1   | Variable |    2     |
  +----+-----+-------+------+----------+----------+
```

* fields

```
  o  VER    protocol version: X'05'
  o  REP    Reply field:
     o  X'00' succeeded
     o  X'01' general SOCKS server failure
     o  X'02' connection not allowed by ruleset
     o  X'03' Network unreachable
     o  X'04' Host unreachable
     o  X'05' Connection refused
     o  X'06' TTL expired
     o  X'07' Command not supported
     o  X'08' Address type not supported
     o  X'09' to X'FF' unassigned
  o  RSV    RESERVED
  o  ATYP   address type of following address
```

## problems

* difference between connection establishment and CONNECT request

* primary connection and secondary connection?

* each connection for each type of stream request?
