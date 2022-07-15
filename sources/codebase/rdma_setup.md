% rdma setup
% zdszero
% 2022-07-14

* __step1: 加载内核模块__

Soft-iWARP在2019年进入Linux内核主线，5.3及之后的版本可以直接使用命令安装。

```
sudo modprobe siw
```

* __step2: 安装所需库__

```
# arch linux
paru -S rdma-core

# ubuntu
sudo apt-get install libibverbs1 libibverbs-dev librdmacm1  librdmacm-dev rdmacm-utils ibverbs-utils libibumad-dev libpci-dev
```

* __step3: 添加Soft-iWARP设备__

```
sudo rdma link add siw_0 type siw netdev xxx
```

* __step4: 测试__

```
# 查看siw设备
ibv_devinfo

# 用ip addr查看网卡对应地址
ip addr

# server
rping -s

# client
rping -c -a <ip_addr> -v
```
