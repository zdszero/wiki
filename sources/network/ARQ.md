% ARQ

## GBN

### design

if the seqno ranges from `0 ~ 2^n-1`, which means the bit width of the seqno is n. Then the gbn window size is `2^n - 1`

when receiver receives `seqno`, it should send `ackno = (seqno + 1) % winsize`

sender logic to judge a valid ackno

```
settings: seqno_bit_width = 3, seqno set = (0, 1, 2, 3 ,4 ,5, 6, 7)

if current sending buffer is (3, 4, 5, 6, 7, 0, 1) --- 2 not in
then the valid ackno no is (4, 5, 6, 7, 0, 1, 2) --- 3 not in

if (0 <= ackno <= winsize and ackno != buffer.front().seqno)
    return true
```

### pseudocode

logic

```
sender():
    upon Start:
        send winsize packets to destination
        add sent packets to buffer
        start timer

    upon Receiving Packet:
        if ackno is not valid:
            return
        remove the acked packets from buffer
        send remaining packets to destination (until buffer is full)
        add sent packets to buffer
        reset timer

    upon Timer Timeout:
        resend all the packets in buffer
        reset timer

receiver():
    upon Receiving Packet p:
        if p.seqno != next_expect_seqno:
            return
        add p to receiving pool
        send corresponding ack
```

implementation

```
vars:
    buffer
    winsize
    timer
    msglen
    next_msg_idx = 0
    next_seqno = 0

send(Packet p):
    p = Packet(next_seqno)
    sender.send(p)
    buffer.add(p)
    next_seqno = (next_seqno + 1) % winsize
    next_msg_idx++

sender():
    upon Start:
        while not buffer.full() and next_msg_idx < msglen:
            send(Packet(next_seqno))
        timer.start()

    upon Receiving Packet recv_p:
        ackno = recv_p.ackno
        if not is_valid_ackno(ackno):
            return
        for p in buffer:
            if not buffer.empty() and buffer.front().seqno != ackno:
                buffer.popfront()
        while not buffer.full():
            send(Packet(next_seqno))
        timer.reset()

    upon Timer Timeout:
        for p in buffer:
            send(p)
        timer.reset()

receiver():
    upon Receiving Packet recv_p:
        if recv_p.seqno != next_expect_seqno:
            return
        send(Packet(ackno=next_expect_seqno))
        next_expect_seqno = (next_expect_seqno + 1) % winsize
```

### problems

* receiver receives delayed seq and regards it as the current one

* ack problem, when the sending buffer has size < winsize and delayed ack arrives
