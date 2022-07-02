% parallelism
% zdszero
% 2022-05-03

### Popen

用Popen创建多个异步执行的进程，然后自己管理

```python
from subprocess import Popen, PIPE
import time

running_procs = [
    Popen(['/usr/bin/my_cmd', '-i %s' % path], stdout=PIPE, stderr=PIPE)
    for path in '/tmp/file0 /tmp/file1 /tmp/file2'.split()]

while running_procs:
    for proc in running_procs:
        retcode = proc.poll()
        if retcode is not None: # Process finished.
            running_procs.remove(proc)
            break
        else: # No process is done, wait a bit and check again.
            time.sleep(.1)
            continue

    # Here, `proc` has finished with return code `retcode`
    if retcode != 0:
        """Error handling."""
    handle_results(proc.stdout)
```

### concurrent

* working with `futures.Future`

```python
from concurrent import futures

with futures.ThreadPoolExecutor() as executor:
    # each iterable element is the parameter of callable
    executor.map(callable, iterable)
```

```python
from concurrent import futures

with futures.ThreadPoolExecutor() as executor:
    # each iterable element is the parameter of callable
    todos = []
    for it in iterable:
        fut = executor.submit(callable, it)
        todos.append(fut)
    for fut in futures.as_completed(todos):
        res = fut.result()
```
