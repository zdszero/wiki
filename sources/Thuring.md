% turing machine
% zdszero
% 2022-4-30

## turing machine

### constitution

什么是图灵机？

图灵机是一个 **计算模型**, 是一个概念上的可以进行各种逻辑计算的机器，包含如下部分：

* infinite tape
* read-write head, which can move left or right
* special states:
    * accept
    * reject
    * loop

图灵机是一个提出了 **状态存储** 概念的模型，简单的来说，就是有一条无限长的磁带，然后有一个磁头可以在上面左右移动，并且可以读读写写，通过这些操作可以模拟问题的求解过程。

### configuration

* current state
* current tape contents
* current head location

**yield**: if configuration C1 yields configuration C2, then turing machine can go from C1 to C2 in one step

简单的来说，就是给定一个输入字符时，图灵机会根据当前的配置（当前的状态，磁头在磁带上的位置，当前位置上的内容），来决定下一步的操作：是否修改这个位置的内容？磁头向左还是向右移动？跳转到哪一个状态？

### defination

**Turing machine** is a 7-tuple, $(Q,\ \Sigma,\ \Gamma,\ \delta,\ q_0,\ q_{accept},\ q_{reject})$

1. $Q$ is the **set of states**
2. $\Sigma$ is the **input alphabet** not containing the blank symbol ␣
3. $\Gamma$ is **tape alphabet**, where $␣ \subseteq \Gamma$ and $\Sigma \subseteq \Gamma$
4. $\delta$: $Q \times \Gamma \rightarrow Q \times \Gamma \times \{L, R\}$ is the **transition function**
5. $q_0 \in Q$: **start state**
6. $q_{accept} \in Q$: **accept state**
7. $q_{reject} \in Q$: **reject state**

### variants

#### multitape turing machine

prove single tape TM is equivalant to multitape TM

enlightment：

* store all the tapes in one tape
* transform a move in the multitape TM into one or more moves in single tape TM

```
multitape TM with 3 tapes
    b->a,L
A1 --------> A2
    1->0,L
B1 --------> B2
    y->x,R
C1 --------> C2

single tape TM
        b1y->a0x,LLR
S1 -----------------------> S2
```

简单来说就是用一个磁带存储多个磁带的内容，并且设置delimeter，然后处理的时候扫描几趟，分别处理即可。

#### nondeterministic turing machine

$\delta$: $Q \times \Gamma \rightarrow P\{Q \times \Gamma \times \{L, R\}\}$ is the **transition function**

* tape1: input tape
* tape2: simulation tape
* tape3: address tape

在tape2模拟的过程中，根据tape3提供的内容选取下一个状态转移，如果被reject的话，将tape3中的内容变换到下一个结点。

### problems

* 为什么图灵机要接受string作为input？

Strings can easily represent polynomials, graphs, grammars, automata, and any combination of those objects. A Turing machine may be programmed to decode the representation so that it can be interpreted in the way we intend.
