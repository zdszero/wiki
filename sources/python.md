%title pythonic

## pythonic object

make an object support python standard functions

### string functions

* `__str__`
* `__format__`

### math ops

* `__add__`
* `__iadd__`
* `__mul__`
* `__imul__`
* `__eq__`

## hash

* `__hash__`

to support `hash()` function, because objects that compare equal should have the same hash

### decorator

* `@classmethod`
* `@staticmethod`
* `@property`: getter

### statements

* `__iter__`: `for elem in obj`
* `__enter__, __exit__`: context manager
