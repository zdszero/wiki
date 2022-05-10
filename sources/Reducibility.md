% Reducibility
% zdszero
% 2022-05-05

## Concepts

### computable function

A **reduction** is a way of converting one problem to another problem in such a way that the second problem can be used to solve the first problem. 

## Reducibility

### samples

1. $A_{TM} = \text{\{<M,w> | M is a TM and M decides input w\}}$
2. $HALT_{TM} = \text{\{<M,w> | M is a TM and M halts on input w\}}$
3. $E_{TM} = \text{\{<M> | M is a TM and L(M) = $\emptyset$\}}$
4. $EQ_{TM} = \text{\{<$M_1$, $M_2$>, | $M_1$ and $M_2$ are TMs and L($M_1$) = L($M_2$)\}}$
5. $PCP$ (Post Correspondence Problem)

### PCP

#### defination

**An instance** of the PCP is a collection of dominos

$$P = \{\frac{t_1}{b_1}, \frac{t_2}{b_2}, \cdots, \frac{t_k}{b_k}\}$$

**A match** is a sequence $i_1, i_2, \dots, i_l$ where $t_{i_1}t_{i_2}\cdots t_{i_l} = b_{i_1}b_{i_2}\cdots b_{i_l}$

$PCP = \text{\{<P> | P is an instance of the PCP with a match\}}$ 

#### provement

consider the **MPCP** problem

$$MPCP = \text{\{<P> | P is an instance of PCP with at match that starts with the first domino, i.e, [$\frac{t_1}{b_1}$]\}}$$ 

the key is to reduce $A_{TM}$ to a PCP: encode $<M, w>$ into a PCP instance, there is a solution to the PCP iff there is an acceptable computation history.

* encode each transition into a tile
    * start
    * move right
    * move left
    * single copy
    * end

So the process of a TM deciding a string w is transformed into finding an instance of PCP with a match

* If you can find a solution to $PCP$, then you have found a legal accepting computation history for $A_{TM}$ 
* If you could decide the answer, then you can decide $A_{TM}$
* While we know $A_{TM}$ is undecidable, so $PCP$ is also undecidable 

### problems

* 为什么PCP问题不可解？

因为每个domino出现的个数可以是任意次的，所以不能通过遍历所有排列方式来求解
