% Decidability
% zdszero
% 2022-04-30

## Decidability

### DFA

Here are some examples (all of them are decidable):

1. $A_{DFA}$ =  { <B, w> | B is a DFA that accepts input stirng w }

use TM $M$ to run w on B, which saves the current state of B and the next input token.

2. $A_{NFA}$ =  { <B, w> | B is a NFA that accepts input stirng w }

use TM to convert NFA to DFA first

3. $A_{REX}$ =  { <B, w> | B is a regular expression that accepts input stirng w }

use TM convert REX to NFA first

4. $E_{DFA}$ = { <A\> | A is a DFA and L(A) = $\emptyset$ }

use bfs to traverse all states

5. $DQ_{DFA}$ = { <A,B> | A and B are DFAs and L(A) = L(B) }
