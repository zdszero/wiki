% TMP
% zdszero
% 2022-06-27

## 可判断机制的完善

检查思路：按照时间序列记录所有发送和接受包的动作以及相应的信息

动作包含SEND和RECV，分别代表发送包和接受包

然后对于每一个动作，也会记录对应包的信息，对于SEND，需要关注的是发送包的序列号seqno以及对应时间time，对于RECV，需要关注的是ackno和time

```
SEND    SEND    SEND    ...... RECV
packet1 packet2 packet3 ...... packetn
```

```
MOTIONS: action sequence, either SEND or RECV
PACKETS: packet sequence of MOTIONS
COUNT: length of sequence MOTIONS

function Check()
    expected_ack = 0
    expected_motion = RECV
    last_time = PACKETS[0].time
    for i = 0 to WINDOW_SIZE-1 do
        motion = MOTIONS[i]
        if motion != SEND then
            return false
        end
    end
    for i = WINDOW_SIZE to COUNT-1 do
        motion = MOTIONS[i]
        packet = PACKETS[i]
        if motion == SEND then
            if packet.time - last_time < timeout then
                return false
            else
                last_time = packet.time
                check if all outbound packets are resent
            end
        else
            if !IsValidAck(packet.ackno) then
                continue
            else
                check if the following packets are sent
            end
        end
    end
    return true
end
```

## 自动判分

* 方案1：

对于所有的测试用例，每一个用例有一个对应的分数，对于每一个测试用例，运用判题器对学生的结果进行判断，如果通过则获得改测试用例的分数。

* 方案2：

在方案1的基础上，用实验设计者提供的标准答案运行每一个测试用例，得到运行时间和发包数量作为判断基准。在运行学生的代码时，统计其运行时间以及发包数量，与判断基准进行比较，根据公式计算出学生在该测试用例的得分。
