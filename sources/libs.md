% python libs

## concurrency

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
