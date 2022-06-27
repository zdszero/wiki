% TMP
% zdszero
% 2022-06-27

检查思路：按照时间序列记录所有发送和接受包的动作以及相应的信息

动作包含SEND和RECV，分别代表发送包和接受包

然后对于每一个动作，也会记录对应包的信息，对于SEND，需要关注的是发送包的序列号seqno以及对应时间time，对于RECV，需要关注的是

```
SEND    SEND    SEND    ...... RECV
packet1 packet2 packet3 ...... packetn
```

```
MOTIONS: action sequence, either SEND or RECV
PACKETS: packet sequence of 
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
