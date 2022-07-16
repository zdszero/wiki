% logic
% zdszero
% 2022-07-16

__compononts__

```
local engine ---> cache ---> remote engine
```

cache充当local engine之间的桥梁，local engine

__storage__

```
local cache memory ---> pool block ---> cache entry size
```

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
