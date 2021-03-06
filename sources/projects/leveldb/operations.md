% operations
% zdszero
% 2022-07-09

## 写操作

### 整体流程

![write overall process](../../../docs/images/image_2022-07-09-15-39-34.png)

### batch

无论是Put/Del操作，还是批量操作，底层都会为这些操作创建一个batch实例作为一个数据库操作的最小执行单元。

![batch structure](../../../docs/images/image_2022-07-09-15-34-22.png)

```
class WriteBatch {
    friend class WriteBatchInternal;
public:
    class Handler {
        virtual void Put(const Key& key, const Key& value);
        virtual void Delete(cosnt Slice& key);
    };
};

class MemTableInserter {
public:
    SequenceNumber sequence_;
    MemTable* mem_;

    virtual void Put(const Key& key, const Key& value);
    virtual void Delete(cosnt Slice& key);
};
```


### 合并写

第一个获取到写锁的写操作

* 第一个写入操作获取到写入锁；
* 在当前写操作的数据量未超过合并上限，且有其他写操作pending的情况下，将其他写操作的内容合并到自身；
* 若本次写操作的数据量超过上限，或者无其他pending的写操作了，将所有内容统一写入日志文件，并写入到内存数据库中；
* 通知每一个被合并的写操作最终的写入结果，释放或移交写锁；

其他写操作：

* 等待获取写锁或者被合并；
* 若被合并，判断是否合并成功，若成功，则等待最终写入结果；反之，则表明获取锁的写操作已经oversize了，此时，该操作直接从上个占有锁的写操作中接过写锁进行写入；
* 若未被合并，则继续等待写锁或者等待被合并；

![write combination](../../../docs/images/image_2022-07-09-15-44-43.png)

### 原子性

leveldb的任意一个写操作（无论包含了多少次写），其原子性都是由日志文件实现的。一个写操作中所有的内容会以一个日志中的一条记录，作为最小单位写入。

考虑以下两种异常情况：

1. 写日志未开始，或写日志完成一半，进程异常退出；
2. 写日志完成，进程异常退出；

前者中可能存储一个写操作的部分写已经被记载到日志文件中，仍然有部分写未被记录，这种情况下，当数据库重新启动恢复时，读到这条日志记录时，发现数据异常，直接丢弃或退出，实现了写入的原子性保障。

后者，写日志已经完成，写入日志的数据未真正持久化，数据库启动恢复时通过redo日志实现数据写入，仍然保障了原子性。

## 读操作

leveldb提供给用户两种进行读取数据的接口：

1. 直接通过Get接口读取数据；
2 首先创建一个snapshot，基于该snapshot调用Get接口读取数据；

两者的本质是一样的，只不过第一种调用方式默认地以当前数据库的状态创建了一个snapshot，并基于此snapshot进行读取。

快照就是数据库在某一个时刻的状态。基于一个快照进行数据的读取，读到的内容不会因为后续数据的更改而改变。

### 快照

每一个序列号，其实就代表着leveldb的一个状态。换句话说，每一个序列号都可以作为一个状态快照。

![snapshot](../../../docs/images/image_2022-07-09-16-22-27.png)

例：图中用户在序列号为98的时刻创建了一个快照，并且基于该快照读取key为“name”的数据时，即便此刻用户将"name"的值修改为"dog"，再删除，用户读取到的内容仍然是“cat”。

在获取到一个快照之后，leveldb会为本次查询的key构建一个internalKey（格式如上文所述），其中internalKey的seq字段使用的便是快照对应的seq。 __通过这种方式可以过滤掉所有seq大于快照号的数据项__。

同时，利用快照可以完成数据库中的并发操作。

### 整体流程

![read overall process](../../../docs/images/image_2022-07-09-16-24-44.png)

__注意__

leveldb在每一层sstable中查找数据时，都是按序依次查找sstable的。

0层的文件比较特殊。由于0层的文件中可能存在key重合的情况，因此在0层中，文件编号大的sstable优先查找。理由是文件编号较大的sstable中存储的总是最新的数据。

非0层文件，一层中所有文件之间的key不重合，因此leveldb可以借助sstable的元数据（一个文件中最小与最大的key值）进行快速定位，每一层只需要查找一个sstable文件的内容。
