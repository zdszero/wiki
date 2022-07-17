% logic
% zdszero
% 2022-07-16

__compononts__

```
local engine ---> cache ---> remote engine
```

增加cache层后，所有kv engine的write/read都只能和cache交互，write/read不感知remote，只负责从cache读写，cache负责和remote通信，把cache溢出的数据写到remote，cache miss时从远程读取数据返回给kv engine。

__storage__

```
local cache memory ---> pool block ---> cache entry size

|                remote memory                  |
|   pool block  |  pool block   |  pool block   |
| entry | entry | entry | entry | entry | entry |
```

local memory的cache的总容量由离散的各个entry组成，所有的entry中的存储数据（value）字段所分配的动态内存是连续的。

__how to get value by key__

```
key (string of 16 chars) <---> remote_addr

 local engine
  hash_map_
key ---> remote_addr
           offset
           size
         start_addr

        memory pool
         mem_keys_
start_addr ---> rkey

         lru cache
         hash_map_
start_addr ---> ListNode*
```

键值与remote addr一一对应
