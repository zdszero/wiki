% PDA
% zdszero
% 2022-06-15

## Context-free Grammers

### def

4-tuple $(V, \Sigma, R, S)$

variables, terminals, rules, start variable

### ambiguity

二义性文法：某个串可以通过两种不同的最左推导得到。

### CNF

grammar is in `Chomsky Normal Form` if every rule is of the form

$$A \rightarrow BC$$

$$A \rightarrow a$$

* a: terminal
* A、B、C: variables
* $S \rightarrow \varepsilon$ is permitted

**convert grammar into CNF**

1. add a new start variable
2. remove $\varepsilon$-productions: from bottom to top
3. remove unit-productions

$A \rightarrow B$ where B is also a production

4. add new variables as need

adhere to $A \rightarrow a$ and $A \rightarrow BC$

## PDA

6-tuple $(Q, \Sigma, \Gamma, \delta, q_{0}, F)$

1. Q: set of states
2. $\Sigma$: input alphabet
3. $\Gamma$: stack alphabet
4. $\delta: Q \times \Sigma_{\varepsilon} \times \Gamma_{\varepsilon} \rightarrow P(Q \times \Gamma_{\varepsilon})$
5. $q_{0}$: start state
6. $F$: accept states

## pumping lemma

如果一个语言s是上下文无关，则它的所有串可以被拆分为s = uvxyz，并且满足如下条件

1. for each $i \ge 0$, $uv^{i}xy^{i}z \in A$
2. $|vy| > 0$
3. $|vxy| \le p$，这里p叫做pumping length，可以为任意值，对于一个实例设定一个值就可以

证明一个语言不是正则语言，举一个反例不满足pumping lemma即可
