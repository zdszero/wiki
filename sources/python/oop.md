% oop
% zdszero
% 2022-05-04

## OOP

### duck typing

> 当看到一只鸟走起来像鸭子、游泳起来像鸭子、叫起来也像鸭子，那么这只鸟就可以被称为鸭子

在鸭子类型中，我们不关系对象的继承关系，只要它实现了某个类型的方法，我们就可以认为它是那个类型的。

## pythonic object

make an object support python standard functions

### string

* `__repr__`: how python view this object
* `__str__`
* `__format__`

### bytes

* `__bytes__`: call bytes() on that object will trigger this function

### math

* `__add__`
* `__iadd__`
* `__mul__`
* `__imul__`
* `__eq__`
* `__abs__`

### hash

* `__hash__`

to support `hash()` function, because objects that compare equal should have the same hash

### memory

* `__dict__, __slot__`

using `__slot__` will tell python to create a more compat memory model, but at the same time the `__dict__` attribute is disabled, and you cannot add attributes to that class.

### fields and methods

* `@classmethod`
* `@staticmethod`
* `@property`: getter
* `__len__`
* `__getitem__`: simulate sequence behavior, slice and index can be used to get the element
* `__getattr__`: invoked when attribute lookup fails
* `__setattr__`: use this function to customize variable setting logic
* `__delattr__`

### statements

* `__iter__`: `for elem in obj`
* `__enter__, __exit__`: context manager

### private member convention

* use name mangling, which prefix variables with to leading underscore `__`

```
>>> class Foo:
...     def __init__(self, x, y, z) -> None:
...         self.__x = x
...         self.__y = y
...         self._z = z
...
>>> f = Foo(3.0, 4.0, 5.0)
>>> f.__dict__
{'_Foo__x': 3.0, '_Foo__y': 4.0, '_z': 5.0}
```

python intepretor automatically change the var name to avoid it being overriden

* **conventionly**, use one leading underscore 
