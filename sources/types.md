%title python types

## numeric types

## sequence types

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
