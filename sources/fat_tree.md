% fat tree
% zdszero
% 2022-06-04

## FatTree

### Addressing

* network address range: `10.0.0.0/8`
* core switch address: `10.k.j.i`
    * j, i: coordicates in the $(k/2)^2$ core switch grid 
* pod switch address: `10.pod.swtich.1`
    * pod: `[0, k-1]`
    * switch: `[0, k-1]`, starting from bottom to top, left to right
* adddress of a host: `10.pod.switch.ID`
