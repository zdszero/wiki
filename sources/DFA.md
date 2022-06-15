% DFA
% zdszero
% 2022-06-14

## DFA

### def

5-tuple $(Q, \Sigma, \delta, q_0, F)$

states, alphabet, transition function, start state, accept state

## Regular Language

### def

A language is called a regular language if some finite automaton recognizes it.

### regular operations

Union, Concatenation, Star

## NFA

### NFA to DFA

* 状态是数字集合`{1,2,3}`
* 注意空字符$\varepsilon$转换，在初始和中间都会转换
* 不要遗漏边
    * $\emptyset$
    * 每个状态都考虑字母表中的所有字母

## pumping lemma

如果一个语言s是正则语言，则它的所有串可以被拆分为s = xyz，并且满足如下条件

1. for each $i \ge 0$, $xy^{i}z \in A$
2. $|y| > 0$
3. $|xy| \le p$，这里p叫做pumping length，可以为任意值，对于一个实例设定一个值就可以

证明一个语言不是正则语言，举一个反例不满足pumping lemma即可
