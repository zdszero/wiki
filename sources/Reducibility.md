% Reducibility
% zdszero
% 2022-05-05

## Concepts

A **reduction** is a way of converting one problem to another problem in such a way that the second problem can be used to solve the first problem. 

## Reducibility

### prove undecidability

proof **by contradiction** 

### samples

1. $A_{TM} = \text{\{<M,w> | M is a TM and M decides input w\}}$
2. $HALT_{TM} = \text{\{<M,w> | M is a TM and M halts on input w\}}$
3. $E_{TM} = \text{\{<M> | M is a TM and L(M) = $\emptyset$\}}$
4. $EQ_{TM} = \text{\{<$M_1$, $M_2$>, | $M_1$ and $M_2$ are TMs and L($M_1$) = L($M_2$)\}}$
5. $PCP$ (Post Correspondence Problem)

**An instance** of the PCP is a collection of dominos

$$P = \{\frac{t_1}{b_1}, \frac{t_2}{b_2}, \cdots, \frac{t_k}{b_k}\}$$

**A match** is a sequence $i_1, i_2, \dots, i_l$ where $t_{i_1}t_{i_2}\cdots t_{i_l} = b_{i_1}b_{i_2}\cdots b_{i_l}$

$PCP = \text{\{<P> | P is an instance of the PCP with a match\}}$ 

### problems

* 为什么PCP问题不可解？

因为每个domino出现的个数可以是任意次的，所以不能通过遍历所有排列方式来求解
