% local engine
% zdszero
% 2022-07-16

__internal value__

```
typedef struct internal_value_t {
  uint64_t remote_addr;
  uint32_t rkey;
  uint8_t size;
} internal_value_t;
```

internal value包含remote server的相关信息，大小为13B

__hash map slot__

```
class hash_map_slot {
 public:
  char key[16];
  interval_value_t internal_value;
  hash_map_slot *next;
};
```

__hash map__

```
#define BUCKET_NUM 1048576

class hash_map_t {
 public:
  hash_map_slot *m_bucket[BUCKET_NUM];
  hash_map_slot *find(const string &key);
  void insert(const string &key, interval_value_t internal_value, hash_map_slot *new_slot);
};
```

每个哈希表包含1048576 = 2^20个桶，在插入时计算`hash<string>(key) & (BUCKET_NUM - 1)`来获取对应桶的下标。

插入时从头部插入，查找时遍历对应的链表。

__local engine__

```
class LocalEngine : public Engine {
 public:
  bool write(const std::string key, const std::string value);
  bool read(const std::string key, std::string &value);

 private:
  kv::ConnectionManager *m_rdma_conn_;
  hash_map_slot hash_slot_array[16 * 12000000];
  hash_map_t m_hash_map[SHARDING_NUM]; /* Hash Map with sharding. */
  std::atomic<int> slot_cnt{0}; /* Used to fetch the slot from hash_slot_array. */
  std::mutex m_mutex_[SHARDING_NUM];
  RDMAMemPool *m_rdma_mem_pool_;
};
```

16个线程各写入12M个数据，提前创建可以容纳所有索引的array，预计大小为$12M \times 16 \times 23B = 4416MB \approx 4GB$
