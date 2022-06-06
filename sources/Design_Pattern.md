% Design Pattern
% zdszero
% 2022-06-06

## 工厂模式

1. 有时候对象的创建可能需要多个步骤，可以将创建过程进行封装。

```
Pizza createPizza(String type) {
    if (type.equals(“cheese”)) {
        pizza = new CheesePizza();
    } else if (type.equals(“greek”) {
        pizza = new GreekPizza();
    } else if (type.equals(“pepperoni”) {
        pizza = new PepperoniPizza();
    } else if (type.equals(“clam”) {
        pizza = new ClamPizza();
    } else if (type.equals(“veggie”) {
        pizza = new VeggiePizza();
    }
}
```

2. 将相似对象中的通用的方法作为父类中的方法实现，同时将不同的行为作为抽象方法实现。

```
public abstract class PizzaStore {
    public Pizza orderPizza(String type) {
        Pizza pizza;
        pizza = createPizza(type);
        pizza.prepare();
        pizza.bake();
        pizza.cut();
        pizza.box();
        return pizza;
    }
    protected abstract Pizza createPizza(String type);
    // other methods here
}
```

**优点**

1. 你可以确保同一工厂生成的产品相互匹配。
2. 你可以避免客户端和具体产品代码的耦合。
3. 单一职责原则。 你可以将产品生成代码抽取到同一位置， 使得代码易于维护。
4. 开闭原则。 向应用程序中引入新产品变体时， 你无需修改客户端代码。

## 单例模式

1. 保证一个类只有一个实例。
2. 为该实例提供一个全局访问点。

```
class Singleton {
public:
    Singleton(const Singleton &) = delete;
    Singleton& operator=(const Singleton &) = delete;
    static Singleton *get() {
        if (!instance) {
            instance = new Singleton();
        }
        return instance;
    }
private:
    Singleton() {}
    static Singleton *instance{nullptr};
};
```

## 原型模式
