%title ARQ

## GBN

```
vars:
    pbuffer
    winsize
    timer
    msglen
    next_msg_idx = 0
    next_S = 0

sender():
    while true:
        if pbuffer.size() < winsize and next_msg_idx < msglen:
            sender.send(win[next_S])
            pbuffer.add(win[next_S])
            next_S = (next_S + 1) % winsize
            next_msg_idx++
            timer.reset()
        resp = receiver.recv()
        while pbuffer.size() > 0 and pbuffer.front().seq_no != resp.seq_no:
            pbuffer.pop()
        if timer.timeout():
            for p in pbuffer:
                sender.send(p)
```
