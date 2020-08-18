JavaScript作为一个根据原型建立的面向对象语言，和我们熟知的基于类的面向对象编程语言有很大的差异。如果不理解其中的本质含义，则无法深入理解JavaScript的诸多特性，以及由此产生的诸多“坑”。

# 原型

## 原型是什么

在讨论“原型”的概念之前，我们先来讨论一下“类”，也就是Java、C++等语言所使用的概念。

在基于类的编程语言中，都要先抽象出一个“类”，用来统一表示同一种对象。然后用这个抽象类创建出一个个实例（泛化），也就是对象object。最后，类和类之间通过组合、继承等特性共建出一个可以互动的系统，从而用这套人为创建的系统来模拟、操纵现实中的物理世界。它的三大特性为：
- 封装
- 继承
- 多态

然而，在原型这一概念之下，则有相当程度的不同之处。

基于原型的编程范式提倡程序员关注实例对象的一系列行为，然后根据行为的不同划分出不同的原型，而不是事先抽象出一个类，再关注具体的对象。它最大的特点是可以动态修改对象的行为，具有高度灵活性。

**如果把基于类的对象称为“自上而下”式的顶层设计，那么基于原型的对象则可以被称为“自下而上”式的动态演化。**

> 这就像专业人士可能喜欢在看到老虎的时候，喜欢用猫科豹属豹亚种来描述它，但是对一些不那么正式的场合，“大猫”可能更为接近直观的感受一些（插播一个冷知识：比起老虎来，美洲狮在历史上相当长时间都被划分为猫科猫属，所以性格也跟猫更相似，比较亲人）。

基于原型的面向对象系统通过“复制”的方式来创建新对象。一些语言的实现中，还允许复制一个空对象。这实际上就是创建一个全新的对象。

原型系统的“复制”操作有两种实现思路：
- 并不是真正的复制一个对象，而是使新对象持有一个原型的引用；
- 切实的复制一个对象，复制对象和被复制对象再无任何关联。

JavaScript选择了前一种方式。

## JavaScript中的原型

抛开一切复杂的语法规则，JavaScript的原型系统的实质只有两条：
- 如果所有对象都有私有字段[[prototype]]，那就是对象的原型；
- 读一个属性，如果对象本身没有，则会继续访问对象的原型，直到原型为空或者找到为止。

从 ES6 以来，JavaScript提供了一系列内置函数，以便更为直接地访问操纵原型。三个方法分别为：

- `Object.create` 根据指定的原型创建新对象，原型可以是`null`；
- `Object.getPrototypeOf` 获得一个对象的原型；
- `Object.setPrototypeOf` 设置一个对象的原型。

利用这三个方法，我们完全可以抛开基于类的面向对象思维，用原型的概念实现抽象和复用。

```js
// 作为“原型”的猫
var cat = {
    say(){
        console.log("meow~");
    },
    jump(){
        console.log("jump");
    }
}

// 作为“原型”的老虎
var tiger = Object.create(cat,  {
    say:{
        writable:true,
        configurable:true,
        enumerable:true,
        value:function(){
            console.log("roar!");
        }
    }
})


var anotherCat = Object.create(cat);

anotherCat.say();
// meow~

var anotherTiger = Object.create(tiger);

anotherTiger.say();
// jump
```

## 早期版本中的原型

在ES3之前的版本中，“类”的定义是一个私有属性 [[class]]，语言标准为内置类型诸如Number、String、Date等指定了[[class]]属性，以表示它们的类。语言使用者唯一可以访问[[class]]属性的方式是Object.prototype.toString。

```js
var o = new Object;
var n = new Number;
var s = new String;
var b = new Boolean;
var d = new Date;

console.log([o, n, s, b, d].map(v => Object.prototype.toString.call(v))); 
// 0: "[object Object]"
// 1: "[object Number]"
// 2: "[object String]"
// 3: "[object Boolean]"
// 4: "[object Date]"
```

在ES5开始，[[class]] 私有属性被 `Symbol.toStringTag` 代替，`Object.prototype.toString` 的意义从命名上不再跟 `class` 相关。我们甚至可以自定义 `Object.prototype.toString` 的行为，以下代码展示了使用Symbol.`toStringTag`来自定义 `Object.prototype.toString` 的行为：
```js
var o = { [Symbol.toStringTag]: "MyObject" }
console.log(o + "");
// [object MyObject]
```

`new`操作是JavaScript面向对象体系中非常重要的一部分，在ES6之前，`new`和函数对配合基本上撑起了JavaScript的对象系统。`new` 运算接受一个构造器和一组参数，实际上做了以下这些事：

- 以构造器的 `prototype` 属性（注意与私有字段[[prototype]]的区分）为原型，创建新对象；
- 将 `this` 和调用参数传给构造器，执行；
- 如果构造器返回的是对象，则返回，否则返回第一步创建的对象。

实际上，它提供了两种方式用于操作对象的属性，其一是在构造器上添加属性；其二实在构造器的`prototype`上添加属性。

```js
function c1(){
    this.p1 = 1;
    this.p2 = function(){
        console.log(this.p1);
    }
} 
var o1 = new c1;
o1.p2();


function c2(){
}
c2.prototype.p1 = 1;
c2.prototype.p2 = function(){
    console.log(this.p1);
}

var o2 = new c2;
o2.p2();
```

在没有Object.create、Object.setPrototypeOf 的早期版本中，`new` 运算是唯一一个可以指定[[prototype]]的方法（当时的mozilla提供了私有属性__proto__，但是多数环境并不支持），所以，当时已经有人试图用它来代替后来的 Object.create，我们甚至可以用它来实现一个Object.create的不完整的polyfill，见以下代码：
```js
Object.create = function(prototype) {
    var cls = function(){}
    cls.prototype = prototype;
    return new cls;
}
```
这段代码创建了一个空函数作为类，并把传入的原型挂在了它的`prototype`，最后创建了一个它的实例，根据`new`的行为，这将产生一个以传入的第一个参数为原型的对象。这个函数无法做到与原生的`Object.create`一致，一个是不支持第二个参数，另一个是不支持null作为原型，所以放到今天意义已经不大了。

## ES6中的类

ES6中，`class`成为JavaScript官方支持的关键字，可以像其他语言一样定义类，并且还支持`extends`关键字来实现继承，setter、getter也支持。至此，基于类的编程范式成为JavaScript的官方支持的编程范式。基本用法如下：

```js
class Rectangle {
  constructor(height, width) {
    this.height = height;
    this.width = width;
  }
  // Getter
  get area() {
    return this.calcArea();
  }
  set area(area) {
      this.area = area;
  }
  // Method
  calcArea() {
    return this.height * this.width;
  }
}
```
实现继承的用法：
```js
class Animal { 
  constructor(name) {
    this.name = name;
  }
  
  speak() {
    console.log(this.name + ' makes a noise.');
  }
}

class Dog extends Animal {
  constructor(name) {
    super(name); // call the super class constructor and pass in the name parameter
  }

  speak() {
    console.log(this.name + ' barks.');
  }
}

let d = new Dog('Mitzie');
d.speak(); // Mitzie barks.
```
所以从此以后，我们都应该使用`class`关键字正正经经地定义类，而不是用各种怪异的手法模拟对象。

# JavaScript内置对象

如果只有用户自定义的对象，也不能写出一个合法且有用的程序。例如，和数据相关的Array，和时间相关的Date，缺少这些对象，实在算不上一个让人满意的程序。

幸好，JavaScript已经提供了这些内置对象，它们可以被分为很多种，下面就一一介绍。

## JavaScript对象分类

可以把JavaScript对象分为以下几类：

- 宿主对象（host Objects）：由JavaScript宿主环境提供的对象，它们的行为完全由宿主环境决定。
- 内置对象（Built-in Objects）：由JavaScript语言提供的对象。
    - 固有对象（Intrinsic Objects ）：由标准规定，随着JavaScript运行时创建而自动创建的对象实例。
    - 原生对象（Native Objects）：可以由用户通过Array、RegExp等内置构造器或者特殊语法创建的对象。
    - 普通对象（Ordinary Objects）：由{}语法、Object构造器或者class关键字定义类创建的对象，它能够被原型继承。

## 宿主对象

ECMAScript给出的定义如下：
>object supplied by the host environment to complete the execution environment of ECMAScript. NOTE: Any object that is not native is a host object.

宿主对象就是，由宿主环境提供，用以构建完整的ECMAScript执行环境的对象。

JavaScript宿主中最熟悉的就是浏览器了，当然也有操作系统，比如node的执行引擎V8。

在浏览器环境中，所有的BOM和DOM都是宿主对象，BOM中的window上又有很多属性，如document。实际上，这个全局对象window上的属性，一部分来自浏览器环境，另一部分则来自JavaScript语言（用`var`定义的全局变量，最终都会变成`window`对象的属性）。

### BOM
Browser Object Model (BOM)是Web的重要组成部分，里面包含众多对象，如下：
- Window
- Location
- Navigator
- Scree
- History

### DOM
JavaScript Document Object Model (DOM)提供了众多API用于操作DOM元素。包括：
- 选择元素，`getElementBy`*；
- 遍历元素，`parentNode`、`firstChild`等；
- 操作元素，`createElement`、`innerHTML`、`append`、`insertBefore`、`replaceChild`等；
- 操作属性，`setAttribute`、`getAttribute`、`hasAttribute`等；
- 操作CSS样式，`style`、`getComputedStyle`、  、`height`等；
- 事件处理，`onclick`、`onscroll`、`load`、`addEventListener`、`mouseover`、`keyup`等；
- 表单处理。

## 内置对象

ECMA-262 把内置对象（built-in object）定义为：由 ECMAScript 实现提供的、独立于宿主环境的所有对象，在 ECMAScript 程序开始执行时出现。所以，在JavaScript引擎初始化的时候就会创建好，我们直接拿来用即可。

### 固有对象

固有对象是由标准规定，随着JavaScript运行时创建而自动创建的对象实例。

固有对象在任何JS代码执行前就已经被创建出来了，它们通常扮演者类似基础库的角色。我们前面提到的“类”其实就是固有对象的一种。ECMA标准为我们提供了一份固有对象表，里面含有150+个[固有对象](https://www.ecma-international.org/ecma-262/9.0/index.html#sec-well-known-intrinsic-objects)。

### 原生对象

ECMAScript给出的定义：
>object in an ECMAScript implementation whose semantics are fully defined by this specification rather than by the host environment. NOTE Standard native objects are defined in this specification. Some native objects are built-in; others may be constructed during the course of execution of an ECMAScript program.

也就是说，能够通过语言本身的构造器创建的对象称作原生对象。

在JavaScript标准中，提供了30多个构造器。按照不同应用场景，分成了以下几个种类。

![原生对象](./images/js-native-objects.png)

这些对象可以用`new`运算符创建新对象，但是却无法用extends进行继承。可以这么认为：这些对象都是为了特定能力或者性能，而设计出来的特权对象。

