% mapreduce
% zdszero
% 2022-06-19

## def

map: takes an input pair and produces a set of intermidiate key/value pairs.

reduce: accepts an intermidiate key I and a set of values from that key. It merges together these values
to form a possibly smaller set of values.

## model

![mapreduce model](../../docs/images/image_2022-06-19-11-01-20.png)

### master

the state of each map/reduce task: idle, in-progress, completed

identidy of each worker machine

### worker

## fault tolerance

### worker failure

master pings every worker at some interval

### master failure

master write periodic checkpoints of the master data structure, if master dies, a new copy can be started from the last checkpoint.

## locality

GFS

master takes the file locations into account and attempts to schedule task according to the information

## back tasks

straggler: some machine that is very slow

When a MapReduce operation is close to completion, the master schedules backup executions of the remaining in-progress tasks. The task is marked as completed whenever either the primary or the backup execution completes

## refinements

* partitioning functions: split some content into a partition
* ordering garantee
* combinator functions
* various input and output types
* skipping bad records
* sequential local execution for debugging
* counters
