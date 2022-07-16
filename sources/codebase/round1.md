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

## 优化思路

* local cache
* use local memory efficiently
* write to remote
    * use local cache to decrease the write number
    * batch KV together, write to remote in one RDMA write
* reader writer latch
