% function
% zdszero
% 2022-05-04

## first class objects

when we say function is used as `first class objects`, we usually mean that

* functions can be created in running time
* assigned to a variable or an element in a data structure
* passed to an argument in a function
* functions as return value

## nine flavors of callable objects

* user-defined functions
* built-in functions
* built-in methods
* methods
* classes: when creating instances of class, `__new__` and `__init__` ise called
* class instanses: the class which defines a `__call__` method inside
* generator function: `yield` in function body
* native coroutine function: defined with `async def`

## flexible argument handling

* argument unpacking: ` *args, **kwargs `
* keyword-only arguments: `func(a, *arg, b)`, here `b` is keyword-only
* positional-only parameters: `func(a, b, /)`, here `a,b` is positional-only

Generate a **html tag**

```python
def tag(name, *content, class_=None, **attrs):
    if class_ is not None:
        attrs['class'] = class_
    attr_pairs = (f' {attr}="{value}"' for attr, value in sorted(attrs.items()))
    attr_str = ''.join(attr_pairs)
    if content:
        elements = (f'<{name} {attr_str}>{c}</{name}>' for c in content)
        return '\n'.join(elements)
    else:
        return f'<{name} {attr_str} />'
```

## functional

### operator

在某些函数中将函数作为参数，比如`sorted(key=?)`, `functools.reduce(func, iterable)`，这些函数参数可以从`opeator`包中获取。

* 获取算数运算类的函数，使用`operator.mul`
* 根据元素下标访问，使用`operator.itemgetter`
* 根据元素属性访问，使用`operator.attrgetter`
* 将多个参数的函数转化为单参数函数，使用`operator.methodcaller`

### functools

* decrators：
        * lru_cache
* reduce
* partial

```python
picture = tag('img', class_="my_pic")
picture(src='./test.jpg')
```
