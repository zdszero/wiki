% Complexity
% zdszero
% 2022-05-12

## Measuring

### big-O

Say that $f(n) = O(g(n))$ if postive integer $c$ and $n_o$ exist such for every integer $n \ge n_o$,

$$f(n) \le cg(n)$$ 

### small-O

Let $f$ and $g$ be functions: $N \rightarrow R^{+}$, if

$$\lim_{n \to \infty} \frac{f(n)}{g(n)} = 0$$ 

## P

P is the class of languages that are deciable that are deciable in *polynomial time* on a *a demterministic single-tape* Turing machine. In other words,

$$P = \cup_{k} TIME(n^k)$$ 

* how to prove that an algorithm runs in polynomial time ?

give a polynomial upper bound on the number of stages that the algorithm uses when it runs on an input of length n.

## NP

NP is the class of languages that have *polynomial time verifiers*

> A language is in NP, iff it is decided by some nondeterministic polynomial time Turing machine

> A language A is *polynomially verifiable* if it has a polynomial time verifier

NTIME(t(n)) = {L |L is a language decided by an O(t(n)) time nondeterministic Turing machine}

$$NP = \cup_{k} NTIME(n^k)$$

### verifier

A **verifier** for a language A is an algorithm *V*, where 

$$A = \text{\{w | V accepts <w,c> for some string c\}}$$

A *polynomial time verifier* runs in polynomial time in the length of w

### classic problems

* **Hamiltonian path**

a direct path that goes through each node exactly once in the graph.

![Hamiltonian path image](../docs/images/image_2022-06-01-19-39-39.png)

* **CLIQUE**

A *k-clique* is a clique that contains *k* nodes, wherein every two nodes are connected by an edge

$$CLIQUE = \text{\{<G,k> |G is an undirected graph with a k-clique\}}$$

![Clique image](../docs/images/image_2022-06-01-22-12-46.png)

* **SUBSET-SUM**

$$SUBSET-SUM = \text{\{<S,t> | S = {$x_1, \cdots, x_k$}, and for some {$y_1, \cdots, y_l$} $\subseteq$ {$x_1, \cdots, x_k$}, we have $\sum y_i$ = t\}}$$

## NPC

A *Boolean formula* is an expression involving Boolean variables and operations.

$$SAT = \text{\{<$\varphi$> | $\varphi$ is a satisfiable Boolean formula\}}$$

### map-reducibility
