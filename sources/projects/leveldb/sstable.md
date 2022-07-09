% sstable
% zdszero
% 2022-07-09

## sstable

虽然在内存中，所有的数据都是按序排列的，但是当多个memetable数据持久化到磁盘后，对应的不同的sstable之间是存在交集的，在读操作时，需要对所有的sstable文件进行遍历，严重影响了读取效率。因此leveldb后台会“定期“整合这些sstable文件，该过程也称为compaction。随着compaction的进行，sstable文件在逻辑上被分成若干层，由内存数据直接dump出来的文件称为level 0层文件，后期整合而成的文件为level i 层文件，这也是leveldb这个名字的由来。

## memory model

__sstable__

| entry0 | entry1 | ...... | restarts | num_of_restarts | trailer |
|:-:|:-:|:-:|:-:|:-:|:-:|
| 第一个K-V entry | 第二个 | ...... | 分区前缀的offset | 总共压缩的轮数 | 尾部其他信息 |

如果不分区，对每个key的查找，都要从block的头开始，所以进一步细化粒度，对前缀进行分段处理。若干个（Option::block_restart_interval）key做前缀压缩之后，就重新开始下一轮。每一轮前缀压缩的 block offset 保存在 restarts 中，num_of_restarts 记录着总共压缩的轮数（有多少个前缀分区）。


__entry__

一份key-value数据作为block中的一个entry。虑节约空间，leveldb 对 key 的存储进行前缀压缩，每个 entry 中会记录 key 与前一个 key 前缀相同的字节（shared_bytes）以及自己独有的字节（unshared_bytes）。读取时，对 block 进行遍历，每个 key 根据前一个 key 以及 shared_bytes/unshared_bytes 可以构造出来。

| shared_bytes | unshared_bytes | value_bytes | unshared_key_data | value_data |
|:-:|:-:|:-:|:-:|:-:|
| 当前key与前一个key相同的字节前缀数量 | 不同的字节数量 | 值的字节数量 | unshared data存储位置 | value存储位置 |


__trailer__

| type(char) | crc(uint32) |
|:-:|:-:|
| 数据是否进行了压缩 | block的校验码 |

