在JavaScript中，函数是一等公民，可以像传递值一样传递函数，用法非常灵活，这主要是由于JavaScript是一个多范式的编程语言，既支持面向对象（基于原型的面向对象，ES6中也提供了class语法支持），也支持函数式编程。

下面，我们就了解一下这些重要且强大的特性。

# Function

既然在JavaScript中，函数也是值，而每个值都有它的类型，那么函数是什么类型呢？

首先，JavaScript的函数是对象类型，再具体一点，是Function类型。

```js
function sum(a, b) {
  return a + b;
}

typeof sum;                 // "function"
sum instanceof Function;    // true
Function instanceof Object; // true
```

Function就是函数对象，是Object的子类，有两个属性：`name`和`length`，以及其他自定义属性。

## 属性
### `name`

`name`表示函数对象的名字，这可能有点奇怪，因为通常在我们声明函数时，必须提供一个名字，`name`属性就对应于此。但是在函数表达式中，`name`却不是这样，`function`关键字后通常不再会有任何内容。

```js
// 声明函数中，name是定义的名称
function sayHi() {
  alert("Hi");
}

alert(sayHi.name); // sayHi

// 函数表达式中，name默认是变量名称
let sayHi = function() {
  alert("Hi");
};

alert(sayHi.name); // sayHi
```

但是，也有一些情况`function`并没有`name`属性，比如匿名函数。

在函数表达式中，还可以为函数提供一个名称，这时候函数表达式就变成了命名函数表达式Named Function Expression，简称NFE。

```js
let sayHi = function func(who) {
  alert(`Hello, ${who}`);
}

sayHi("Walker");  // Hello, Walker
sayHi.name;       // func
```

它还是一个函数表达式，只不过多了一个名字`func`，那么这个名字`func`的作用是什么呢？有两个：

1. `func`允许在函数内部调用它自己，`sayHi`并不可见；
2. 在函数外部，`func`并不可见，而只有`sayHi`可见。

所以，在命名函数表达式中，函数名和变量名的职责非常清楚，前者只能在函数的内部词法作用域中使用，而后者只能在函数的外部词法作用域中使用。

```js
let sayHi = function func(who) {
  if (who) {
    alert(`Hello, ${who}`);
  } else {
    // sayHi("Guest"); // Error: sayHi is not a function
    func("Guest");
  }
};

sayHi();  // Hello, Guest
func();   // Uncaught ReferenceError: func is not defined
```

### length

顾名思义，`length`表示函数的参数数量。但是，它只表示固定参数数量，也就是说并不包含`...args`所表示的可变参数数量。

单纯看`length`的作用，其实没有什么值得讨论的东西。但是，通过内省这种方式，它可以操作多个函数，达到实现多态的效果。比如这个例子：

```js
function ask(question, ...handlers) {
  let isYes = confirm(question);

  for(let handler of handlers) {
    if (handler.length == 0) {
      if (isYes) handler();
    } else {
      handler(isYes);
    }
  }
}

ask("Question?", () => alert('You said yes'), result => alert(result));
```

根据不同的答案，进行相应的操作，这种在不同状态下，执行不同的逻辑就是一种多态实现。

## 参数

### `...args`
JavaScript的函数可接受任意数量参数而不报错，正常情况下，它只使用所需参数，多余的会被抛弃。如果传入的参数量不够，则表示传入了`undefined`。

如果要传入一个参数序列，可以使用展开运算符`...`+参数名称，表示一个数组型的可变参数，可容纳多个参数。*注意：可变参数必须是函数的最后一个参数。*

```js
function sumAll(...args) { // 数组名为 args，可为任意自定义名称
  let sum = 0;

  for (let arg of args) sum += arg;

  return sum;
}

alert( sumAll(1) ); // 1
alert( sumAll(1, 2) ); // 3
alert( sumAll(1, 2, 3) ); // 6
```

### `arguments`
在以前的版本中，`arguments`是唯一一个获取函数所有参数的方法。但是，`arguments`是一个类数组，也是可迭代对象，但它终究不是数组。它不支持数组方法，因此我们不能调用 `arguments.map(...)` 等方法。并且，**箭头函数也没有`arguments`**。

```js
function sumAll() { // 数组名为 args
  let sum = 0;

  for (let arg of arguments) sum += arg;

  return sum;
}

alert( sumAll(1) ); // 1
alert( sumAll(1, 2) ); // 3
alert( sumAll(1, 2, 3) ); // 6
```

## 动态创建

除过常规的函数声明方式，还有另外一种通过关键字`new`和`Function`创建的方式：

```js
let func = new Function([arg1, arg2, ...argN], functionBody)

let sum = new Function('a', 'b', 'return a + b');

alert( sum(1, 2) ); // 3
```

这种方式使用的很少，因为所有参数都要用字符串表示，所以实际使用场景多为了**动态创建函数**，比如从服务器获得对应字符串序列，然后通过这种语法创建函数，实现相应功能。

# 递归

递归是指，在函数的定义中使用函数自身。它是一种强大而优雅的方法付，其核心思想是”分而治之“，可有效降低复杂度，很多PL都提供语法支持，JavaScript就是其中一例。

递归尤其适合具有树状结构的数据结构的处理，比如各种遍历算法都可基于递归简单而优雅地实现。当然，很多问题不用递归，用循环也可以实现，比如对于乘方的计算：

```js
function pow(x, n) {
  let result = 1;

  // multiply result by x n times in the loop
  for (let i = 0; i < n; i++) {
    result *= x;
  }

  return result;
}

alert( pow(2, 3) ); // 8
```

但是，如果用递归实现，则非常简单。

```js
function pow(x, n) {
  if (n == 1) {
    return x;
  } else {
    return x * pow(x, n - 1);
  }
}

alert( pow(2, 3) ); // 8
```

在递归算法中，一般将问题分成两部分：
```js
              if n==1  = x // 递归边界条件
             /
pow(x, n) =
             \
              else     = x * pow(x, n - 1)
```

其中最重要的是递归比边界条件，如果处理不好边界问题，则很容易造成死循环。

另外，如果递归深度太深，则容易造成栈溢出，因此就有了一些优化算法，比如[尾递归](https://www.ruanyifeng.com/blog/2015/04/tail-call.html)，或者使用缓存以空间换时间等。

# 函数式
## 装饰器
### 实现

用一个函数修改另一个函数默认行为的方式就是装饰器的实现原理。通常情况下，装饰器都是为了增强函数的默认行为，比如提高性能，增加某些功能。

```js
function sleep(n) {
  return new Promise(function(resolve, reject) {
    setTimeout(resolve, n*1000);
  })
}
async function slow(x) {
  // there can be a heavy CPU-intensive job here
  await sleep(2);
  alert(`Called with ${x}`);
  return x;
}

function cachingDecorator(func) {
  let cache = new Map();

  return function(x) {
    if (cache.has(x)) {    // if there's such key in cache
      return cache.get(x); // read the result from it
    }

    let result = func(x);  // otherwise call func

    cache.set(x, result);  // and cache (remember) the result
    return result;
  };
}

slow = cachingDecorator(slow);
slow(4);  // waiting for 2 seconds
slow(4);  // instantly return
```

在一些需要消耗大量时间的任务中，将结果缓存起来，以免下一次又重新计算，是装饰器的一个常用场景。

### `this`

在一些场景中，尤其是在对象的方法中，函数的执行依赖于执行上下文和`this`值，如果在装饰器中不绑定`this`值的绑定，则容易出现问题。在JavaScript中，有三种方式绑定`this`值。

#### `func.call`

内置函数[`func.call`(context, ...args)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call)的第一个参数是待绑定的`this`值，后面是分开的函数参数。

```js
let worker = {
  someMethod() {
    return 1;
  },

  slow(x) {
    alert("Called with " + x);
    return x * this.someMethod(); // (*)
  }
};

function cachingDecorator(func) {
  let cache = new Map();
  return function(x) {
    if (cache.has(x)) {
      return cache.get(x);
    }
    let result = func.call(this, x); // 绑定this为原来函数的this
    cache.set(x, result);
    return result;
  };
}

worker.slow = cachingDecorator(worker.slow);

alert( worker.slow(2) ); 
alert( worker.slow(2) ); 
```

#### `func.apply`

`call`和`apply`的作用类似，区别只在于传入函数参数的方式不同，前者是分开传递，而后者是作为一个数组传递。这样就有一个好处，可不用关注参数的具体细节，只用`arguments`代替就好。

```js
let wrapper = function() {
  return func.apply(this, arguments);
};
```

#### `func.bind`

从名字上就可以看出，`bind`用来给函数绑定某些值。具体而言，就是执行上下文`this`或者参数。用法和`call`类似。

```js
let user = {
  firstName: "John",
  say(phrase) {
    alert(`${phrase}, ${this.firstName}!`);
  }
};

let say = user.say.bind(user);

say("Hello"); // Hello, John
say("Bye"); // Bye, John
```

#### 区别

通过上面的内容，我们已经清楚了`call`、`apply`和`bind`都可以为函数绑定`this`值，还可以传入函数的参数。那么，它们之间的区别在哪里呢？

- `call`和`apply`的功能更相似，都是在绑定`this`和参数之后，立即执行得到结果；而`bind`只是绑定`this`和参数，并没有立即执行；
- `call`和`bind`的语法更相似，都是分开传参；而`apply`是将参数作为一个整体`arguments`传入。

## 偏函数

偏函数是指，把原函数的某些参数固定住，返回一个使用更加方便的新函数的做法。比如：

```js
function mul(a, b) {
  return a * b;
}

let double = mul.bind(null, 2);
let triple = mul.bind(null, 3);

double(3);  // 6
triple(5);  // 15
```

上面的`double`和`triple`都是`mul`的偏函数。这里的`bind`绑定的是参数，而像上面通过`bind`绑定`this`的用法，也算是偏函数的一种用法。

为了方便使用，我们可以定义一个函数，将传入函数的`this`值和一些参数同时绑定给它，例如：

```js
function partial(func, ...argsBound) {
  return function(...args) {
    return func.call(this, ...argsBound, ...args);
  }
}

function now() {
  return "Now is " + new Date().getHours() + ':' + new Date().getMinutes();
}

// Usage:
let user = {
  firstName: "John",
  say(time, phrase) {
    alert(`[${time}] ${this.firstName}: ${phrase}!`);
  }
};

user.sayNow = partial(user.say, now());

user.sayNow("Hello");  // [Now is 15:5] Hello, Walker!
```

# 总结

函数是每个PL中最重要的内容之一，而在JavaScript中，函数的重要性更加不言而喻。

首先，由于每个函数`function`都是Function的实例，因此用对象视角解读`function`是不可避免的。
- 属性
  - `name`：除过匿名函数，其余函数的`name`属性都不为空。而且在NFE中，还可以单独定义`name`，用来在函数此法作用域内使用；
  - `length`：表示除过可变参数之外的参数数量，可以此实现多套逻辑，达到多态的效果；
  - `...args`：可变参数，如果存在，必须是最后一个参数；
  - `arguments`：表示所有参数，是`iterable`类型，并非数组型，使用时要注意。
- 创建
  - `new Function(arg1, arg2, ..., body)`：所有参数都是字符串类型，主要通过服务器返回数据动态创建函数；
  - `function ...` ：通过`function`关键字创建，是常规方式。
- 函数式
  - 装饰器，用一个函数增强另一个函数的行为，比如提高性能，增加功能。需要注意`this`值的绑定，可通过下面三种方式实现：
    - `call`
    - `apply`
    - `bind`
  - 偏函数，把原函数的某些参数固定住，返回一个使用更加方便的新函数，也需要注意`this`值。
- 递归：在函数内调用自身的方法，优雅而强大，但是要注意边界条件，如果递归深度太深，需要优化，可参考：
  - 尾递归
  - 加缓存