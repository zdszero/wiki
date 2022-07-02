% python types
% zdszero
% 2022-05-07

## numeric types

* int
* float

## sequence types

* list
* tuple

## binary sequence

### bytes object

bytes object is mutable

creation: 

* literal string: `b""`
* A zero-filled bytes object of a specified length: `bytes(10)`
* From an iterable of integers: `bytes(range(20))`
* Copying existing binary data via the buffer protocol: `bytes(obj)`

```
# get hex string
hex()

# construct bytes from string. The string must contain two hexadecimal digits per byte, with ASCII whitespace being ignored.
bytes.fromhex()

# decode to str
bytes.decode('utf-8')
```

### bytearray object

bytearray is `immutable counterpart` of bytes object

## other built-in types

### functions

* function by `def` statement
* lambda

### dataclass

```
from dataclasses import dataclass

@dataclass
class Foo:
    attr1: type1 = default_val
```

* use `lst: list[str] = filed(default_factory=list)` to specify default value for list
* use `__post_init__` function to do post creation check

## typing

* list
    * `list[str]`
    * `List[str]`
    * `Sequence[str]`
    * `Iterable[str]`
* dict
    * `dict[str, int]`
    * `Mapping[str, int]`
* tuple
    * `tuple[A, B]`
* Optional
    * `plural: Optional[str] = None`
    * `plural: str | None = None`
* Union: any type of the provided types
    * `Union[A, B, C, D]`
* TypeVar
    * `T = TypeVar('T')`
    * `NumberT = TypeVar('NumberT', float, Decimal, Fraction)`
* Protocol
* Callable
    * `Callable[[Parameters], ReturnType]`

difference between `list` and `List`, `dict` and `Mapping`
