# Index

1. `{}`在JavaScript中有哪些用法？
2. 为什么JavaScript是单线程的？
3. `==` VS `===`
4. `typeof` VS `instanceof`
5. `??` VS `||`
6. `for ... in` VS `for ... of`

# 1.`{ }`在JavaScript中的用法
## Q：

既然函数是对象，那么在函数对象内部，就应该可以使用键值对添加属性和方法，但实际上并不会有任何效果。

```js
function Person(name, gender) {
    this.name = name;
    this.gender = gender;
    age: 20; // 用键值对添加属性
}
var p = new Person("Walker", "male")
var p = Person {name: "Walker", gender: "male"}
p.age // undefined
```

## A：

JavaScript里，一对花括号`{ }`实际上有下面三种作用：
- 可以在函数声明/函数表达式中用于括住函数体。如问题所示；
- 可以是块语句（block statement）用于把若干语句打包为一块，例如用于`while`、`for`等控制流语句中；
- 可以是对象字面量（Object Literal；或者叫对象初始化器，Object Initializer）。如问题中强行添加的`age`属性。

实际上，下面这两种写法所生成的AST完全不同。
```js
// 1
function Person(name, gender) {
    this.name = name;
    this.gender = gender;
}
// 2
var person = {
    name : "walker",
    gender: "male"
}
```

通过[esprima](https://esprima.org/demo/parse.html)查看不同代码的AST：
- [函数Person的AST](https://esprima.org/demo/parse.html?code=%2F%2F%20Life%2C%20Universe%2C%20and%20Everything%0Afunction%20Person(name%2C%20gender)%20%7B%0A%20%20%20%20this.name%20%3D%20name%3B%0A%20%20%20%20this.gender%20%3D%20gender%3B%0A%20%20%20%20age%3A%2020%3B%20%2F%2F%20%E7%94%A8%E9%94%AE%E5%80%BC%E5%AF%B9%E6%B7%BB%E5%8A%A0%E5%B1%9E%E6%80%A7%0A%7D)
- [直接量Person的AST](https://esprima.org/demo/parse.html?code=%2F%2F%20Life%2C%20Universe%2C%20and%20Everything%0Avar%20person%20%3D%20%7B%0A%20%20%20%20name%20%3A%20%22walker%22%2C%0A%20%20%20%20gender%3A%20%22male%22%0A%7D)

# 2.为什么JavaScript是单线程的？
## Q:

为什么JavaScript没有选择使用多线程充分利用机器的性能，而是只用单线程呢？

## A:

>JavaScript的单线程，与它的用途有关。作为浏览器脚本语言，JavaScript的主要用途是与用户互动，以及操作DOM。这决定了它只能是单线程，否则会带来很复杂的同步问题。比如，假定JavaScript同时有两个线程，一个线程在某个DOM节点上添加内容，另一个线程删除了这个节点，这时浏览器应该以哪个线程为准？
>
>所以，为了避免复杂性，从一诞生，JavaScript就是单线程，这已经成了这门语言的核心特征，将来也不会改变。
>
>为了利用多核CPU的计算能力，HTML5提出Web Worker标准，允许JavaScript脚本创建多个线程，但是子线程完全受主线程控制，且不得操作DOM。所以，这个新标准并没有改变JavaScript单线程的本质。

实际上，跟GUI相关的框架（QT、GTK、MFC、Android、iOS）采用的全是这种模型，所有跟UI相关的操作，就像浏览器中的DOM操作一样，必须在单线程（在很多GUI框架中称为主线程）中执行。因为只有这样，才能保证数据的一致性，才能构架一个稳定可用的系统。

# 3. `==` VS `===`
## Q:

抽象（非严格）相等比较 `==` 和 严格相等比较 `===` 是如何运行的，才造成如此差异？

## A:
### 非严格相等比较 `==`
`==` 在进行比较时，先会进行类型转换，将两边的值转换为相同类型，主要是通过`ToNumber`和`ToPrimitive`，然后再做比较。具体而言，按照下面的规则进行转换：
- `undefined`与`null`相等；
- 字符串和`bool`都转为数字再比较；
- 对象转换成`primitive`类型再比较。
- 对象如果转换成了primitive类型后，如果跟等号另一边类型恰好相同，则不需要再转换成数字。

这样，就可以理解一些反直觉的案例。

![非严格相等比较](../images/js-equality-comparability.png)

### 严格相等比较 `===`
严格相等比较更符合实际工作需要，在比较时并不进行隐式转换。所以如果两个值的类型不同，那么就不全等；而如果两个被比较的值类型相同，值也相同，则两个值全等。具体比较规则如下：
- 两个字符串相同，当且仅当字符序列相同，长度也相同。
- 两个number相同，当且仅当其数值相同；`NaN`和任何值都不相同，包括NaN。
- 两个Boolean相同，当且仅当同时为`true`或者`false`。
- 两个Object相同，当且仅当它们同时引用自同一个对象。

# 4. `typeof` VS `instanceof`
## Q:

`typeof`和`instanceof`有哪些区别，分别适用于哪些场景？

## A:
### typeof

typeof返回一个字符串，表示操作数的基本类型信息。截止ES2020，JavaScript更有8种基本类型，分别如下：
- Undefined，返回`"undefined"`
- Null，返回"`object"`，
- Number，返回`"number"`
- Boolean，返回`"boolean"`
- String，返回`"string"`
- Object，返回`"object"`
- Symbol，ES6新加入，返回`"symbol"`
- BigInt，ES2020加入的，返回`"bigint"`

这里，**最出乎意料的是`Null`返回`"object"`**，这是因为自JavaScript诞生以来，就是如此。后来有提案建议修复这种bug，但是被拒绝了，主要是为了兼容以前的项目。


### instanceof

`instanceof`用于检测一个实例是否属于某个类或者继承自此类，在细节上是通过检测右侧构造器的`prototype`是否出现在左侧实例对象的原型链中。主要为对象Object的实例服务，更进一步是为**普通对象**服务的。

JavaScript中的对象可以分为两类：
- 宿主对象，由宿主环境提供，行为也由宿主决定。
- 内置对象，JavaScript提供的对象，除宿主对象之外的所有对象。
  - 固有对象，由标准规定，随着JavaScript运行时被创建而创建的对象。
  - 原生对象，用户通过`Array`、`Date`、`RegExp`等构造器创建的对象。
  - 普通对象，用户自定义的对象，通过`{ },` `function`、`class`等创建的对象。

```js
class A {}
function B() {}

let a = new A()
let b = new B()

a instanceof A        // true
a instanceof Object   // true

b instanceof B        // true
b instanceof Object   // true
b instanceof Function // false

A instanceof Function // true
A instanceof Object   // true

B instanceof Function // true
B instanceof Object   // true

[] instanceof Array   // true

let now = new Date()

now instanceof Date   // true
now instanceof Object // true
```

在实现细节上，是通过检测一步步检测原型链来完成的。
```js
obj.__proto__ === Class.prototype?
obj.__proto__.__proto__ === Class.prototype?
obj.__proto__.__proto__.__proto__ === Class.prototype?
```

# 5. `??` VS `||`
## Q:
`??`和`||`都可以进行非空检测，它们的区别是什么？

## A:
### `??`
`??`是语言标准定义的新语法，只有一部分浏览器支持，它表示返回第一个非`undefined`或者非`null`值。实际上，`??`也并不是什么新玩意，完全可以用三元运算符替代它。除此之外，它的优先级比较低，建议一般加上括号。

```js
let result = a ?? b
// ==
let result = (a != null && a != undefined) ? a : b;
```

### `||`
`||`是逻辑或运算，用来获取第一个真值。因为在JavaScript中，`false`、`0`、`""`、`null`和`undefined`都是非真值，而且在所有环境下都支持，所以`||`的使用范围更广，比如，经常可以看见通过`||`设置默认值的案例。

```js
let height = 0;

alert(height || 100); // 100
alert(height ?? 100); // 0
```

因此可以看出，在特定场景下`??`是更好的选择，但需要运行环境的支持；而`||`是普遍支持的写法，使用的较多，但对非空和非真的检测不那么精确。

# 6. `for ... in` VS `for ... of`
## Q:
`for ... in` 和 `for ... of`都可以用来遍历，它们的区别是什么？

### `for ... in`

来自MDN的定义是：
> `for ... in` 语句以任意顺序遍历除Symbol以外的可枚举属性。

实际上，`for ... in`是为遍历对象属性而构建的，得到的是String类型的key，主要用于调试。对于数组遍历，更应该用Array.protoptype.forEach和for ... of。

### `for ... of`
`for ... of`只能用在可迭代对象上，包括 Array，Map，Set，String，TypedArray，arguments对象等，或者如果其他对象实现了[[Symbol.iterator]]，也可以使用。和`for ... in`不一样，`for ... of`遍历得到的是value。

```js
let arr = [3, 5, 7];
arr.foo = "hello";

for (var i in arr) {
  console.log(i); 
}
// "0","1","2","foo"
for (var i of arr) {
  console.log(i); 
}
// "3","5","7"

let pets = new Set(["Cat", "Dog", "Hamster"]);
pets["species"] = "mammals";

for (let pet in pets) {
   console.log(pet);
}
// "species"
for (let pet of pets) {
   console.log(pet);
}
// "Cat","Dog","Hamster"

let tom = {
    'name': 'Tom',
    'gender': 'male',
    sayHi(){
        console.log('Hello')
    }
}
for (let p in tom) {
   console.log(p);
}
// 'name','gender','sayHi'
for (let p of tom) {
   console.log(p);
}

let tomPlus = {
    'name': 'Tom',
    'gender': 'male',
    [Symbol.iterator]() {
    return {
      i: 0,
      next() {
        if (this.i < 3) {
          return { value: this.i++, done: false };
        }
        return { value: undefined, done: true };
      }
    };
  }
}
for (let p of tomPlus) {
   console.log(p);
}
// 0,1,2
```