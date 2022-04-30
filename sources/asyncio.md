% asyncio

## overview

* coroutine, task, future
* event loop
* streams

## event loop

### socket functions

**note:** sock must be `non-blocking` socket 

all socket methods `func(params ...)` are transformed into `loop.sock_func(sock, params...)`

### problems

* difference between `process, thread scheduling` and `event loop scheduling`

It is the job of OS schedulers to allocate CPU time to drive threads and processes.

In contrast, asyncio's event loop is implemented in application-layer. It manages a queue of pending coroutines, drives them one by one, monitors events triggered by I/O operations initiated by coroutines, and passes back control back to the corresponding coroutine when each event happens.

* how does event loop schedule different coroutines

One coroutine may await another coroutine, and these coroutines make up a `await chain`. The `await chain` eventually reaches a low-level awaitable, which returns a plain generator that the event loop can drive in response to events such as timers or network I/O.

* `loop.same_func()` vs `asyncio.same_func()`

* how asyncio functions work with loop

## awaitables

* coroutines
* tasks: created by `asyncio.create_task()`
* futures: a special low-level awaitable object that represents an eventual result of an asynchronous operation.

## coroutine

### coroutine types

**native coroutine**

`async def`: define a native coroutine

`await`: delegate from a native coroutine to another native coroutine

**classic coroutine**

A generator function that comsumes data sent to it via `my_coro.send(data)` calls, and reads that data using `yield` in an expression. Can use `yield from` to delegate to other classic coroutine. Classic coroutine is no longer supported by `asyncio`

**generator-based coroutine**

use `@types.coroutine` to marks a generator function as a coroutine

### methods

* `gather(*aws)`
* `create_task()`
* `wait_for(aw, timeout)`

### problems

* task and thread difference

`Task` derives a coroutine object, `Thread` invokes a callable

There’s no API to terminate a thread from the outside; instead, you must send a signal—like setting the `done Event` object. For tasks, there is the `Task.cancel()` instance method, which raises `CancelledError` at the await expression where the coroutine body is currently suspended.

## Task

Task object inherits from Future object. It can be created by `asynio.create_task(coro)` or `loop.create_task()`

### methods

* `cancel()`
* `canclled()`
* `done()`
* `add_done_callback(callback)`
* `remove_done_callback(callback)`
* `get_coro()`
* `get_name()`
* `set_name()`

## Streams

High level modules to work with connections. You can happily work with `asyncio.Reader` and `asyncio.Writer` object and not worry about the other sockets stuff

### objects

**StreamReader**

```
read(n)
readexactly(n)
    raise IncompleteReadError is EOF is reached before reading n bytes
readline()
readuntil(seperator=b'\n')
at_eof() -> bool
```

all read methods return coroutine, so it should be used with `await`

**StreamWriter** 

```
write(data)
writelines(lst)
drain()

close()
wait_closed()

write_eof()
is_closing() -> bool
```

usage

```
writer.write(data) or writer.writelines(lst)
await writer.drain()

writer.close()
writer.wait_closed()
```

### methods

* `open_connection(host, port) -> reader, writer`
* `start_server(client_connected_cb, host, port, limit, ...)`

## Synchronization Primitives

### objects

the statement `async with` is just like C++ RAII

**Lock**

```python
lock = asyncio.Lock()

async with lock:
    # access shared state here

lock.release()
```

* `locked() -> bool`

**Event**

Wait on some flag which can be set and reset

* `wait()`
* `set()`
* `is_set()`
* `clear()`

**Condition**

Combines the functionality of an Event and a Lock.

It is possible to have multiple Condition objects share one Lock

```python
cond = asyncio.Condition(lock=None)

async with cond:
    await cond.wait()
    # or
    await cond.wait_for(predicate)

# the same as
await cond.acquire()
try:
    await cond.wait()
finally:
    cond.release()

cond.notify(n)
cond.notify_all()
```

**Semephore**

* `acquire()`
* `release()`
* `locked()`

## Future

### Problems

* difference between future and task

future is the more general concept of a container of an async result, akin to a JavaScript promise. Task is a subclass of future specialized for executing coroutines.
