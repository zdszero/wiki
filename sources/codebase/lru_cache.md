% lru cache
% zdszero
% 2022-07-16

## list node

```
struct ListNode {
    uint64_t key;
    CacheEntry value;
    ListNode *prev;
    ListNode *next;
    bool clean;
};
```

## lru cache

```
class LRUCache {
public:
    queue<ListNode*> free_nodes;
    RDMAMemPool *mem_pool;
    unordered_map<uint64_t, ListNode*> hash_map; 
};
```
