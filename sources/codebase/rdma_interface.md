% rdma interface
% zdszero
% 2022-07-16

## rdma memory pool

```cpp
class RDMAMemPool {
public:
    typedef struct {
        uint64_t addr;
        uint32_t rkey;
    } rdma_mem_t;

    RDMAMemPool(ConnectionManager *conn_manager)
        : m_rdma_conn_(conn_manager), m_current_mem_(0), m_rkey_(0), m_pos_(0) {}
    ~RDMAMemPool() { destory(); }

    int get_mem(uint64_t size, uint64_t &addr, uint32_t &rkey);

private:
    void destory();

    uint64_t m_current_mem_; // 当前使用的远程内存
    uint32_t m_rkey_;        // RDMA remote key
    uint64_t m_pos_;         // 当前使用的remote mem的可用位置

    std::vector<rdma_mem_t> m_used_mem_; // 已经使用过的远程内存空间
    ConnectionManager *m_rdma_conn_;
    std::mutex m_mutex_;
};
```

__get_mem__

remote key对应RDMA remote机器上的一段内存空间，在这一段内存空间中，我们可以使用addr来访问其中的某一段内存。

```cpp
// 每次申请的内存大小为1MB
#define RDMA_ALLOCATE_SIZE (1 << 20ul)

// 返回0代表成功
int get_mem(uint64_t size, uint64_t &addr, uint32_t &rkey) {
    // 如果申请大小过大，失败
    if (size > RDMA_ALLOCATE_SIZE) return -1;

    std::lock_guard<std::mutex> lk(m_mutex_);

retry:
    // 如果 当前已经获取远程内存 并且 内存容量足够
    if (m_pos_ + size < RDMA_ALLOCATE_SIZE && m_current_mem_ != 0) {
        addr = m_pos_;
        rkey = m_rkey_;
        m_pos_ += size;
        return 0;
    }

    // 将已经使用完的内存信息保存，暂时无用
    if (m_current_mem_ != 0) {
        rdma_mem_t rdam_mem;
        rdma_mem.addr = m_current_mem_;
        rdma_mem.rkey = m_rkey_;
        m_used_mem_.push_back(rdam_mem);
    }

    // 向remote继续申请内存
    int ret = m_rdma_conn_->register_remote_memory(m_current_mem_, m_rkey_,
                                                   RDMA_ALLOCATE_SIZE);
    // 如果远程内存池出现错误，失败
    if (ret) return -1;
    // 已经获取新的远程内存，重新尝试分配
    m_pos_ = 0;
    goto retry;
}
```

## connection manager

```cpp
class ConnectionManager {
public:
    ConnectionManager() {}
    ~ConnectionManager() {}

    // 从remote的addr位置 读取 size字节到内存的ptr位置
    int remote_read(void *ptr, size_t size, uint64_t remote_addr, uint32_t rkey);
    // 从内存的ptr位置读取size字节 写入 remote的addr位置
    int remote_write(void *ptr, size_t size, uint64_t remote_addr, uint32_t rkey);


    int init(const std::string ip, const std::string port, uint32_t rpc_conn_num,
             uint32_t one_sided_conn_num);
    int register_remote_memory(uint64_t &addr, uint32_t &rkey, uint64_t size);

private:
    ConnQue *m_rpc_conn_queue_;
    ConnQue *m_one_sided_conn_queue_;
};
```

## connection

```cpp
class RDMAConnection {
 public:
  int init(const std::string ip, const std::string port);
  int register_remote_memory(uint64_t &addr, uint32_t &rkey, uint64_t size);
  int remote_read(void *ptr, uint64_t size, uint64_t remote_addr,
                  uint32_t rkey);
  int remote_write(void *ptr, uint64_t size, uint64_t remote_addr,
                   uint32_t rkey);

 private:
  char *m_reg_buf_;
  struct ibv_mr *m_reg_buf_mr_;
};
```

`m_reg_buf_`是注册的本地内存，首先动态创建，其大小为`MAX_REMOTE_SIZE`，为`1ul << 20`即1MB大小，在init函数中通过`rdma_register_memory((void *)m_reg_buf_, MAX_REMOTE_SIZE)`进行注册这块空间，为其配置lkey。
