% template
% zdszero
% 2022-07-15

* __先写需要指定的模板参数，再把能推导出来的模板参数放在后面。__

```cpp
template <typename DstT, typename SrcT>
DstT c_style_cast(SrcT v) {
    return (DstT)(v);
}
```

* __typename__

声明一个类型，`class <typename T>`

嵌套从属名称

```cpp
template <typename C>
void f(const C& container, typename container::iterator iter);
```

事实上类型C::const_iterator依赖于模板参数C， 模板中依赖于模板参数的名称称为从属名称（dependent name）， 当一个从属名称嵌套在一个类里面时，称为嵌套从属名称（nested dependent name）。 其实C::const_iterator还是一个嵌套从属类型名称（nested dependent type name）。

* __trait__

C++提供一系列traits模板，用来提供类型信息，比如：

```cpp
template <typename IterT>
void work_with_iterator(IterT itr) {
    typename std::iterator_traits<Iter>::value_type tmp(*itr);
    // typedef typename std::iterator_traits<Iter>::value_type value_type;
}

// you can also do with without traits
template <typename container>
void work_with_iterator(typename container::iterator itr) {
    typename container::value_type val(*itr);
}
```

* __整形也可以是template参数__

按照C++ Template最初的想法，模板不就是为了提供一个类型安全、易于调试的宏吗？有类型就够了，为什么要引入整型参数呢？

宏除了代码替换，还有一个最基本的用途就是定义一个常数。所以整形模板参数最基本的用途，也是定义一个常数。

```cpp
template <typename T, typename Size>
struct array {
    T data[Size];
};

Array<int, 16> arr;
```

模板的匹配是在编译器完成的，所以模板实例化使用的参数，必须在编译器就能确定。像`int x = 3; Array<int, x> arr;`就是错误的。

* __特化__

特化（specialization）是根据一个或多个特殊的整数或类型，给出模板实例化的一个指定内容。当模板实例化时提供的模板参数不能匹配到任何的特化形式的时候，它就会去匹配类模板的“原型”形式。

部分特化/偏特化 和 特化 相当于是模板实例化过程中的if-then-else。这使得我们根据不同类型，选择不同实现的需求得以实现

```cpp
template <typename T>
class AddFloatOrMulInt {
    static T Do(T a, T b) {
        return T(0);
    }
}

template <>
class AddFloatOrMulInt<int> {
    static T Do(int a, int b) {
        return a + b;
    }
}

template <>
class AddFloatOrMulInt<int> {
    static T Do(int a, int b) {
        return a + b;
    }
}
```

和继承不同，类模板的“原型”和它的特化类在实现上是没有关系的，并不是在类模板中写了 ID 这个Member，那所有的特化就必须要加入 ID 这个Member，或者特化就自动有了这个成员。

* __two-phase name lookup__

Template definition time: when the template is initially parsed, long before it is instantiated, the compiler parses the template and looks up any "non-dependent" names. A name is "non-dependent" if the results of name lookup do not depend on any template parameters, and therefore will be the same from one template instantiation to another.

Template instantiation time: when the template is instantiated, the compiler looks up any "dependent" names, now that it has the full set of template arguments to perform lookup. The results of this lookup can (and often do!) vary from one template instantiation to another.
