原型Prototype是JavaScript对象继承体系的根基，而类和对象是构建复杂系统的有效方法，它们的重要程度不言而喻。

# 原型Prototype
在[前面的文章中](https://github.com/wangwalker/Study/blob/master/web/md/js-prototype.md)，已经对原型的概念和使用方式进行了介绍，并且对原型链也进行了讨论。下面，再来谈谈一些其他问题。

## `F.prototype`

每个函数都有一个属性`prototype`，指向它的原型，只能是对象`object`或者`null`，而不能是其他类型，比如基本类型。

`prototype`只能在调用`new`时使用。如果有动态修改的需求，还可以随时修改，但是在修改之后，并不会修改已经创建的对象的原型，而只能对后续新创建的对象产生影响。

```js
let animal = {
  eats: true
};

function Rabbit(name) {
    this.name = name;
}

Rabbit.prototype = animal;
let rabbit = new Rabbit("One");

let toy = {
    playable: true
}

Rabbit.prototype = toy;
let toyRabbit = new Rabbit("Another")

rabbit.__proto__ === animal // true
toyRabbit.__proto__ === toy // true
```

再来看看另一些例子。在函数对象的原型上直接修改、删除某些属性：

```js
function Rabbit() {}
Rabbit.prototype = {
  eats: true
};

let rabbit = new Rabbit();

// 修改原型对象的属性
Rabbit.prototype.eats = false;

alert( rabbit.eats );   // ① false

// 删除对象属性
delete rabbit.eats;
alert( rabbit.eats );   // ② true

// 删除原型对象上的属性
delete Rabbit.prototype.eats;
alert( rabbit.eats );   // ③ undefined

```

为什么会这样？首先因为：
- 对象的存储是Reference类型，也就是内存地址，如果只修改它的属性，而没有重新赋值，则还是同一个对象，否则就变成另一个对象；
- 原型对象有且仅有一个，用来为所有由它创建的对象共享属性和方法，实现对象之间的继承关系；
- 对象的属性包含它的原型链上的所有对象的属性，但是它只能修改或者删除属于亲自创建的属性，原型链上其他对象的属性只能获取getter

这样，就比较好理解上面例子了：
- ①因为修改了原型，所以后续操作按原型的最新状态执行；
- ②因为`eats`来自原型，它只能被getter，而不能被删除，所以操作无效；
- ③因为直接删除了原型属性，所以后续操作按原型的最新状态执行，删除之后只能为`undefined`。

## `Object.prototype`

在JavaScript中，所有对象对继承自Object，它的原型是`Object.prototype`，再往上寻找，就成了`null`。

```js
let obj = {};

alert(obj.__proto__ === Object.prototype); // true
alert(Object.prototype.__proto__); // null
```

所有原生对象也都继承自Object，比如Array、Date、Function等，下面是它们的继承关系。

![原生对象继承关系](../images/js-object-prototype.png)

```js
let arr = [1, 2, 3];

alert( arr.__proto__ === Array.prototype ); // true

alert( arr.__proto__.__proto__ === Object.prototype ); // true

// 已经达到继承关系链的顶部
alert( arr.__proto__.__proto__.__proto__ ); // null
```

甚至，我们还可以借用原型方法，比如一个对象需要某个原生对象的内置方法，则可以很容易的实现。

```js
let obj = {
  0: "Hello",
  1: "world!",
  length: 2,
};

obj.join = Array.prototype.join;

alert( obj.join(',') ); // Hello,world!
```

这种方式得以奏效，是因为原生对象Array的方法`join`的实现逻辑，只关注对象索引和`length`属性，它并不管对象是不是真正的Array。可以看出，这就是原型概念的微观呈现，它只关注对象的具体行为，并以此划分类型。

下面，给所有function添加一个方法`defer`，允许它们延迟一定时间之后再执行。

```js
Function.prototype.defer = function(ms) {
  setTimeout(this, ms);
};

function f() {
  alert("Hello!");
}

f.defer(1000); // 1秒之后显示Hello!
```

但是这种方式并不能接受参数，可以结合前面说活的装饰器重新实现。

```js
Function.prototype.defer = function(ms) {
    let f = this;
    return function(...args) {
        setTimeout(() => f.apply(this, args), ms);
    }
}
function f(a, b) {
  alert( a + b );
}

f.defer(1000)(1, 2); // 1秒之后：3
```

# 类Class

从ES6开始，类class正式成为JavaScript官方支持的基础设施，并且支持继承。虽然在细节上还是基于原型实现的，但这将对熟悉基于类的面向对象语言的开发者更加友好。

## 基本用法

一个典型的Class如下：

```js
class MyClass {
  prop = value; // property

  constructor(...) { // constructor
    // ...
  }

  method(...) {} // method

  get something(...) {} // getter method
  set something(...) {} // setter method

  [Symbol.iterator]() {} // method with computed name (symbol here)
  // ...
}
```

## 继承
继承，重写父类方法等。

```js
class Animal {

  constructor(name) {
    this.speed = 0;
    this.name = name;
  }

  run(speed) {
    this.speed = speed;
    alert(`${this.name} runs with speed ${this.speed}.`);
  }

  stop() {
    this.speed = 0;
    alert(`${this.name} stands still.`);
  }

}

class Rabbit extends Animal {

  constructor(...args) {
    super(...args);
  }

  hide() {
    alert(`${this.name} hides!`);
  }

  stop() {
    super.stop(); // call parent stop
    this.hide(); // and then hide
  }
}

let rabbit = new Rabbit("White Rabbit");

rabbit.run(5); // White Rabbit runs with speed 5.
rabbit.stop(); // White Rabbit stands still. White rabbit hides!
```

## 静态*
### 静态方法

静态方法是属于类本身的方法，而不是具体的每一个对象的方法。在JavaScript中，当方法前有static关键字，就变成了静态方法，此时，this表示类本身，而非具体的对象。

```js
// 1. 定义在类内
class User {
  static staticMethod() {
    alert(this === User);
  }
}

// 2. 直接赋值
class User { }

User.staticMethod = function() {
  alert(this === User);
};

User.staticMethod(); // true
```

工厂方法：

```js
class Article {
  constructor(title, date) {
    this.title = title;
    this.date = date;
  }

  static createTodays() {
    // remember, this = Article
    return new this("Today's digest", new Date());
  }
}

let article = Article.createTodays();

alert( article.title ); // Today's digest
```

### 静态属性

同样，也是在属性之前加上static关键字，但是不能写在构造器中。

```js
// 写法1
class Article {
  static publisher = "Ilya Kantor";
}

// 写法2
Article.publisher = "Ilya Kantor";

alert( Article.publisher ); // Ilya Kantor
```

对于静态方法和静态属性，继承同样也是适用的。

## 属性

在JavaScript中，类的所有属性默认都是公开的，如果需要限定作用域，需要加上特定符号：
- `_` : protected properties
- `#` : private properties

和其他PL一样，受保护的属性只在当前类及其子类中可见。

```js
class CoffeeMachine {
  _waterAmount = 0;

  set waterAmount(value) {
    if (value < 0) throw new Error("Negative water");
    this._waterAmount = value;
  }

  get waterAmount() {
    return this._waterAmount;
  }

  constructor(power) {
    this._power = power;
  }

}

// create the coffee machine
let coffeeMachine = new CoffeeMachine(100);

// add water
coffeeMachine.waterAmount = -10; // Error: Negative water
```

私有属性和方法只在当前类中可见。

```js
class CoffeeMachine {
  #waterLimit = 200;

  #checkWater(value) {
    if (value < 0) throw new Error("Negative water");
    if (value > this.#waterLimit) throw new Error("Too much water");
  }

}

let coffeeMachine = new CoffeeMachine();

// 获取不到下面方法和属性
coffeeMachine.#checkWater(); // Error
coffeeMachine.#waterLimit = 1000; // Error
```

## Mixin

mixin也是一种代码复用的方法，不过和继承不太一样，它允许其他类不通过继承就可以共享属于它的方法，在某些场合，也被叫做`include`和`interface`。这类做法相对继承的优点在于，它们的继承关系更加直观可控，而不像继承那样复杂，甚至有时候让人捉摸不透。

比如下面的例子：

```js
// mixin
let sayHiMixin = {
  sayHi() {
    alert(`Hello ${this.name}`);
  },
  sayBye() {
    alert(`Bye ${this.name}`);
  }
};

class User {
  constructor(name) {
    this.name = name;
  }
}

// 是通过原型实现的
Object.assign(User.prototype, sayHiMixin);

new User("Dude").sayHi(); // Hello Dude!
```

下面这个例子是DOM元素通过EventMixin处理事件的典型例子，一共三个重要方法：
- `trigger`：当事件发生时，触发执行事件逻辑；
- `on`：注册事件；
- `off`：移除事件。

```js
let eventMixin = {
  /**
   * Subscribe to event, usage:
   *  menu.on('select', function(item) { ... }
  */
  on(eventName, handler) {
    if (!this._eventHandlers) this._eventHandlers = {};
    if (!this._eventHandlers[eventName]) {
      this._eventHandlers[eventName] = [];
    }
    this._eventHandlers[eventName].push(handler);
  },

  /**
   * Cancel the subscription, usage:
   *  menu.off('select', handler)
   */
  off(eventName, handler) {
    let handlers = this._eventHandlers?.[eventName];
    if (!handlers) return;
    for (let i = 0; i < handlers.length; i++) {
      if (handlers[i] === handler) {
        handlers.splice(i--, 1);
      }
    }
  },

  /**
   * Generate an event with the given name and data
   *  this.trigger('select', data1, data2);
   */
  trigger(eventName, ...args) {
    if (!this._eventHandlers?.[eventName]) {
      return; // no handlers for that event name
    }

    // call the handlers
    this._eventHandlers[eventName].forEach(handler => handler.apply(this, args));
  }
};

// 使用
class Menu {
  choose(value) {
    this.trigger("select", value);
  }
}
// Add the mixin with event-related methods
Object.assign(Menu.prototype, eventMixin);

let menu = new Menu();

// add a handler, to be called on selection:
menu.on("select", value => alert(`Value selected: ${value}`));

// triggers the event => the handler above runs and shows:
// Value selected: 123
menu.choose("123");
```

# 总结

原型是JavaScript语言的对象继承体系的核心，即使是自从ES6加入了class语法支持，但实际上类也是在原型的基础上实现的。下面是原型概念的核心内容：
- 牢记两点：
  - `__proto__`属性是对象所独有的；
  - `prototype`属性是函数所独有的；
  - 因为函数也是一种对象，所以同时拥有`__proto__`属性和`prototype`属性。
- `__proto__`：当访问对象属性时，如果该对象`obj`内部不存在这个属性，那么就会去它的原型对象`obj.__proto__`里找，顺着原型链一直向上找，直到`__proto__`为null。
- `prototype`：共享函数所实例化的对象的公有属性和方法。

另外，原型还可以被动态修改，但修改之后只能对后续新建对象产生影响，而不会影响现存对象。除此之外，还有一些特殊情况需要特别对待。

`class`语法的支持让JavaScript和其他语言在类的使用细节上保持了同步，这将降低使用门槛，让我们以熟悉的方式实现代码复用。需要注意的是，在底层上，不管是继承还是`mixin`等，`class`还是以原型概念实现的。