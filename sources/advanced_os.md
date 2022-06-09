% advanced_os
% zdszero
% 2022-06-09

* 什么是分布式系统？

一个分布式系统是多个独立计算机的集合，该系统在用户看来就象一台单个计算机一样。

* 分布式系统的三个特性

模块性、并行性、自治性

* 分布式系统与计算机网络的区别

都提供了一个面向报文的异构性通信环境。

在全局管理、并行操作、自治控制等方面分布式系统有着更高的要求，其主要区别在于系统的高层软件（操作系统、语言、数据库、应用软件）上。

* 分布式系统硬件分类

弗林分类法，采用基于 **指令流数目** 和 **数据流数目** 作为分类依据

1. SISD(single instruction single   data)
2. SIMD(single instruction multiple data)
3. MISD(multiple instruction single data)
4. MIMD(multiple instruction multiple data)


我们把所有MIMD分为两类：具有共享存储器的多处理器系统；没有共享存储器的多计算机系统。

根据互连网络结构的不同，以上两个分类还可进一步细分：总线型、开关型。

另一种分类：紧耦合、松散耦合
