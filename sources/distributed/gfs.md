% gfs
% zdszero
% 2022-07-01

**Google File System**: a distributed file system that work on a large cluster

## 思考

1. master

## intro

1. components failures are common
2. files are huge
3. most files are mutated by appending new data

## design

### assumption

read: large read most of the time, some times random small reads

### interface

not posix compliant, usual operations are supported: `create, delete, open, close, read, write`

additional operations: `snapshot, record append`

snapshot: create a copy at low cost

record append: concurrent append from multiple users with atomicity

### architecture

![gfs architecture](../../docs/images/image_2022-07-01-16-08-15.png)

**defs** 

* master
* chunkserver
* client
* chunks

### metadata
