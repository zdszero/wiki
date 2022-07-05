% intro
% zdszero
% 2022-06-19

## INDEX

availability, scalability, performance

## CAP

一个分布式系统最多只能同时满足consistency, availability, partition tolerance这三项中其中的两项

### consistency

分布式存储不同结点上存储的信息版本是一致的

### availability

要求系统内的节点们接收到了无论是写请求还是读请求，都要能处理并给回响应结果。

1. 在合理的时间内返回结果
2. 如果内部数据有问题也必须返回结果

### partition tolerance

两个节点之间无法通信。可能是一个节点宕机了，也有可能是两个节点之间的网络出现了问题。

如果出现了分区问题，我们的分布式存储系统还需要继续运行。不能因为出现了分区问题，整个分布式节点全部就熄火了，罢工了，不做事情了。
