% round1
% zdszero
% 2022-07-14

# 初赛

## 要求

1）程序正确性验证

验证数据读写的正确性，这部分的耗时不计入运行时间的统计。如果正确性测试不通过，则终止，评测失败。

2）初赛性能评测

引擎使用的本地内存和远端内存限制在 8 GB 和 32 GB。 每个线程分别插入 12 M个Key大小为 16 Bytes，Value为 128 Bytes的KV对象，接着以 7 ：1 的读写比例访问调用 64 M次。数据符合Zipfian热点分布，其中90% 的读访问具有热点的特征，大部分的读访问集中在少量的Key上面。

所有value的存储总共需要$12M \times 128B \times 16 \div 1024 = 24GB$

总共会写入$12M \times 16 = 192M$个数据，缓存10%的话，就是需要缓存19.2M各数据，共需要2.4G的内存

## kv demo

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

## 优化思路

* local cache
* use local memory efficiently
* write to remote
    * use local cache to decrease the write number
    * batch KV together, write to remote in one RDMA write
* reader writer latch
