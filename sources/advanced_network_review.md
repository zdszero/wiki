% Advanced Network Review
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

![fat tree demo](../docs/images/fat_tree_demo.png)

### routing algorithm

* generating aggregation routing table for upper pod switches

```
foreach pod x in [0, k-1] do
    foreach switch z in [(k/2), k-1] do
        foreach subnet i in [0, (k/2)-1] do
            addPrefix(10.x.z.1, 10.x.i.0/24, i);
        end
        addPrefix(10.x.z.1, 0.0.0.0/0, 0);
        foreach host ID i in [2, (k/2)+1] do
            addSuffix(10.x.z.1, 0.0.0.i/8,
            (i-2+z)mod(k/2)+(k/2));
        end
    end
end
```

* generating aggregation routing table for lower pod switches

```
foreach pod x in [0, k-1] do
    foreach switch z in [0, (k/2)-1] do
        addPrefix(10.x.z.1, 0.0.0.0/0, 0);
        foreach host ID i in [2, (k/2)+1] do
            addSuffix(10.x.z.1, 0.0.0.i/8,
            (i-2+z)mod(k/2)+(k/2));
        end
    end
end
```

* generating core switch routing table

```
foreach j in [1, (k/2)] do
    foreach i in [1, (k/2)] do
        foreach destination pod x in [0, (k/2) - 1] do
            addPrefix(10.k.j.i, 10.x.0.0/16)
        end
    end
end
```

## BBR

## Ethane
