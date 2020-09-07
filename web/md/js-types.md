虽然JavaScript语言对大多数人来说已经非常熟悉了，但有些问题依然值得深入讨论。比如下面这些：

- 为什么有的编程规范要求用 `void 0` 代替 `undefined` ？
- 字符串有最大长度吗？
- 0.1 + 0.2 不是等于0.3么？为什么JavaScript里不是这样的？
- ES6新加入的Symbol是个什么东西？
- 为什么给对象添加的方法能用在基本类型上？

如果你还对这些问题还不是很熟悉，那么请往下看。

# 7种语言类型

JavaScript作为一种OOP，其每一个值都有对应的数据类型。JavaScript共有7中语言类型，如下：

1. Undefined
2. Null
3. Boolean
4. String
5. Number
6. Symbol
7. Object

## Undefined

`Undefined` 表示未定义，它只有一个值 `undefined`。任何变量在赋值前都是 `Undefined` 类型，值为 `undefined`，就是 `Undefined` 类型的唯一值。

但是问题就出在 `undefined` 在JavaScript语言中是一个**变量**，而非一个**关键字**，这就导致一个致命的结果，可能在有意无意中被修改。这是JavaScript公认的设计失误之一。

所以，为了避免异常情况的发生，建议使用 `void 0` 来获取 `undefined` 的值。

## Null

`Null` 表示空类型，也只有一个值 `null`，表示“定义了，但是为空”。

和undefined不同的是，`null` 是JavaScript中的一个关键字，所以可以放心的用 `null` 获取 `null` 的值。

## Boolean

布尔类型，只有两个值`true`，`false`。

## String

字符串类型，用于表示文本数据。String的最大长度是2^53-1，这在一般程序中是够用的。

但是，这个长度并不是字符实际的长度。因为String的真实意义并非字符串，而是字符串的UTF16编码，我们字符串的操作 `charAt`、`charCodeAt`、`length` 等方法针对的都是UTF16 编码。所以，字符串的最大长度，实际上是受字符串的编码长度影响的。

> 现行的字符集国际标准，字符是以 Unicode 的方式表示的，每一个 Unicode 的码点表示一个字符，理论上，Unicode 的范围是无限的。UTF是Unicode的编码方式，规定了码点在计算机中的表示方法，常见的有 UTF16 和 UTF8。 Unicode 的码点通常用 U+??? 来表示，其中 ??? 是十六进制的码点值。 0-65536（U+0000 - U+FFFF）的码点被称为基本字符区域（BMP）。

JavaScript中的字符串一旦创建出来，则不能修改，所以它也有值类型特性。

## Number

Number类型表示通常意义上的数字，和数学中的有理数大致对应。由于在计算机中涉及到精度问题，JavaScript中的Number有 `18437736874454810627` (即2^64-2^53+3) 个值。

除了表示常规数字，JavaScript还规定了几个例外情况：
- `NaN`，占用了 9007199254740990，这原本是符合IEEE规则的数字；
- `Infinity`，无穷大；
- `-Infinity`，负无穷大。

由于在JavaScript中有`+0` 和 `-0`之分，对于涉及到0的除运算要格外小心，需借助 `Infinity` 和 `-Infinity` 来区分。

这样，由于精度限制问题，在浮点数运算中有时候会出现类似 `0.1+0.2 != 0.3` 的问题。实际上，这里错误的并不是结果，而是浮点数比较方法。

```js
> console.log( Math.abs(0.1 + 0.2 - 0.3) <= Number.EPSILON);
  true
```

## Symbol

Symbol 是 ES6 中引入的新类型，它是一切非字符串的对象key的集合，在ES6规范中，整个对象系统被用Symbol 重塑。

根据我个人的理解，正如它的字面意思：符号、标志，它表示JavaScript中所有对象的唯一标识符，就像身份证号码一样，解决的是变量区分和资源定位的问题。比如，对象的属性名如何和属性值建立关联。

创建 Symbol 的方式是使用全局的 Symbol 函数。例如：
```js
var mySymbol = Symbol("my symbol");
```
例如，我们可以使用 `Symbol.iterator` 来自定义`for…of` 在对象上的行为：
```js
var o = new Object

o[Symbol.iterator] = function() {
    var v = 0
    return {
        next: function() {
            return { value: v++, done: v > 10 }
        }
    }        
};

for(var v of o) 
    console.log(v); // 0 1 2 3 ... 9
```

## Object

JavaScript作为一门面向对象编程语言，类是整个语言的基础。

但是，JavaScript中的类和其他语言（Java、C++等）中的类有一定差异。因为，JavaScript的类是基于原型实现的；而其他诸如Java的语言是基于预先定义的类实现的。

由于是基于原型的实现方式，JavaScript中的类只是对象的一个私有属性，而原型则成为至关重要的一员，用于构建JavaScript的整个继承体系。

JavaScript中的几个基本类型，都在对象类型中有一个“亲戚”。它们是：

- Number；
- String；
- Boolean；
- Symbol。

所以，必须知道  `2` 和 `new Number(2)` 是完全不同的值，前者是Number类型，后者是对象Object类型。

Number、String、Boolean三个类型比较特殊，当和`new`搭配时，表示新建对象；当直接调用时，表示类型转换。但是，Symbol比较特殊，它只能作为构造器使用，和 `new` 搭配会报错。

实际上，JavaScript语言在设计上视图模糊对象和基本类型的关系。比如，在基本类型上可以调用对应类型的对象方法，甚至在原型上添加的方法可以在基本类型上使用，比如下面的代码：
```js
"abc".charAt(0); // a

Symbol.prototype.hello = () => console.log("hello");

var a = Symbol("a");
console.log(typeof a); //symbol，a并非对象
a.hello(); //hello，有效
```

为什么会这样呢？ 

这是因为诸如 `a.b` 的行为都涉及到“装箱”操作，它会根据基础类型生成一个临时对象，使得我们能够在基础类型上调用对应对象的方法。

请注意：**装箱机制会频繁产生临时对象，在一些对性能要求较高的场景下，我们应该尽量避免对基本类型做装箱转换。**

## 类型转换

因为JavaScript是弱类型语言，所以类型转换发生非常频繁，大部分常见运算都会先进行类型转换。大部分类型转换符合人类的直觉，但是如果我们不去理解类型转换的严格定义，很容易造成一些代码中的判断失误。

比如 `==` 比较运算，它属于设计失误，在实践中通常被禁止使用，转而使用 `===` 。

下面是常见类型之间的转换规则：

![类型转换](../images/type-convertion.jpg)

除此之外，还有一些可以显式调用的类型转换方法：

### `parseInt`、`parseFloat`

在不传入第二个参数的情况下，`parseInt` 只支持16进制前缀 `0x`，而且会忽略非数字字符，也不支持科学计数法。在一些古老的浏览器环境中，`parseInt` 还支持0开头的数字作为8进制前缀，这是很多错误的来源。所以在任何环境下，都建议传入parseInt的**第二个参数**。

```js
parseInt("10");			  // 10
parseInt("19",10);		// 19 (10+9)
parseInt("11",2);		  // 3 (2+1)
parseInt("17",8);		  // 15 (8+7)
parseInt("1f",16);		// 31 (16+15)
parseInt("010");		  // 未定：10 或 8
```

`parseFloat()` 函数可解析一个字符串，并返回一个浮点数。

该函数先判断指定字符串中的首个字符是否是数字。如果是，则对字符串进行解析，直到到达数字的末端为止；否则返回`NaN`。建议通过调用 `isNaN()` 函数来判断 `parseFloat` 的返回结果是否是 NaN。

### 拆箱操作

和装箱操作对应的是“拆箱”操作，也就是说把对象转变为基本类型，比如Number和String之间的转换，都要先进行拆箱操作，取出基本类型，然后再把基本类型转换为对应地String或者Number。

在JavaScript标准中，规定了 `ToPrimitive` 内置函数，用于实现拆箱，它有一个参数 `hint`，用来表示要转换的类型，有三个取值：`number`、`string`、`default`。

但是，如果没有实现 `ToPrimitive`，则会尝试调用 `valueOf` 和 `toString` 来获得拆箱后的基本类型。如果 `valueOf` 和 `toString` 都不存在，或者没有返回基本类型，则会产生类型错误 `TypeError`。

```js
let user = {
  name: "John",
  money: 1000,

  [Symbol.toPrimitive](hint) {
    alert(`hint: ${hint}`);
    return hint == "string" ? `{name: "${this.name}"}` : this.money;
  }
};

alert(user);        // hint: string -> {name: "John"}
alert(+user);       // hint: number -> 1000
alert(user + 500);  // hint: default -> 1500

let user = {
  name: "John",
  money: 1000,

  // for hint="string"
  toString() {
    return `{name: "${this.name}"}`;
  },

  // for hint="number" or "default"
  valueOf() {
    return this.money;
  }

};

alert(user);        // toString -> {name: "John"}
alert(+user);       // valueOf -> 1000
alert(user + 500);  // valueOf -> 1500
```
详细解说可以参考[这里](https://javascript.info/object-toprimitive)。

# 对象

JavaScript的对象和其他语言有很多不同之处，比如其他语言都要定义好“类”，才可以创建对象，而JavaScript则可以不用预先定义类；反而，它却可以动态给对象添加属性，而其他语言却有点困难…

前面已经说了，JavaScript的对象系统是以“原型”这一概念实现的，除过原型，还有下面两种方式可以用来实现对象系统：
- 类，预先定义好“类”，然后批量生成对象，如Java、C++、Objective-C等；
- duck-typing，只要走起来像鸭子、游泳像鸭子、叫起来也像鸭子，那么它就是一只鸭子，动态语言通常会支持，比如Python、Go。

那么，我们先来看看在人类思维模式下，对象究竟是什么。

>对象这一概念在人类的幼儿期形成，这远远早于我们编程逻辑中常用的值、过程等概念。在幼年期，我们总是先认识到某一个苹果能吃（这里的某一个苹果就是一个对象），继而认识到所有的苹果都可以吃（这里的所有苹果，就是一个类），再到后来我们才能意识到三个苹果和三个梨之间的联系，进而产生数字“3”（值）的概念。

JavaScript使用的原型概念，实际上非常符合我们人类在经过万亿年进化之后才形成的认知模式。从小时候一无所知开始，慢慢接触的事物越来越多，自我得到扩展，慢慢地又可以举一反三，进行类比，物理世界的所有客观存在都被映射到我们的大脑中，并形成了独特的标记。这样不断扩充我们自己的认知，最终形成一套独特而高效的世界观。原型的含义就是这样，在概念和范围上从小到大，不断扩展，从已知到未知，从直观到抽象，最终延伸出整个体系。

只不过，JavaScript推出之时受管理层之命被要求模仿Java，所以，JavaScript创始人Brendan Eich在“原型运行时”的基础上引入了new、this等语言特性，使之“看起来更像Java”。

## 对象特征

不管是何种OOP，总结来看，它们都有这些特征：

1. 对象具有唯一标识性：即使完全相同的两个对象，也并非同一个对象。
2. 对象有状态：对象具有状态，同一对象可能处于不同状态之下。
3. 对象具有行为：即对象的状态，可能因为它的行为产生变迁。

JavaScript同样也满足这三条。

一般而言，各种语言的对象唯一标识性都是用内存地址来体现的。

关于对象的第二个和第三个特征“状态和行为”，不同语言会使用不同的术语来抽象描述它们，比如C++中称它们为“成员变量”和“成员函数”，Java中则称它们为“属性”和“方法”。

在 JavaScript中，将状态和行为统一抽象为“属性”，考虑到 JavaScript中将函数设计成一种特殊对象，所以 JavaScript中的行为和状态都能用属性来抽象。例如下面的对象就含有两个属性：
```js
var student = {
    age: 10,
    study() {
        console.log("I'm studying");
    }
};
```

在这种方式下，JavaScript对象拥有了极高的动态特性，这是因为**JavaScript赋予了使用者在运行时为对象添改状态和行为的能力**。

## 两类属性

JavaScript对象的属性可以分为两类，一类是**数据属性**，一类是**访问器属性**。

数据属性，比较接近于其它语言的属性概念，核心是属性值。数据属性具有四个特征。

- value：就是属性的值。
- writable：决定属性能否被赋值。
- enumerable：决定 `for in` 能否枚举该属性。
- configurable：决定该属性能否被删除或者改变特征值。

访问器（getter/setter）属性，它也有四个特征：

- getter：函数或undefined，在取属性值时被调用。
- setter：函数或undefined，在设置属性值时被调用。
- enumerable：决定`for in`能否枚举该属性。
- configurable：决定该属性能否被删除或者改变特征值。

通常用于定义属性的代码会产生数据属性，其中的 `writable`、`enumerable`、`configurable` 都默认为`true`。我们可以使用内置函数 `Object.getOwnPropertyDescripter` 来查看，可以使用 `Object.defineProperty` 定义属性属性，如以下代码所示：
```js
var student = {
    age: 10,
    get study() {
        console.log("getter I'm studying");
    },
    set study(a) {
        console.log("setter I'm studying");
    }
};
> Object.getOwnPropertyDescriptor(student, 'age')
{value: 10, writable: true, enumerable: true, configurable: true}

> Object.getOwnPropertyDescriptor(student, 'study')
{enumerable: true, configurable: true, get: ƒ, set: ƒ}
```

这样，我们就理解了，实际上JavaScript对象在运行时是一个“属性的集合”，属性以字符串或者Symbol为key，以数据属性特征值或者访问器属性特征值为value。对象也是这些属性集合的索引结构。

## 内置对象

如果只有用户自定义的对象，还不能写出一个合法且有用的程序。例如，和数据相关的Array，和时间相关的Date，缺少这些对象，实在算不上一个让人满意的程序。

幸好，JavaScript已经提供了这些内置对象，它们可以被分为很多种，下面就一一介绍。

可以把JavaScript对象分为以下几类：

- 宿主对象（host Objects）：由JavaScript宿主环境提供的对象，它们的行为完全由宿主环境决定。
- 内置对象（Built-in Objects）：由JavaScript语言提供的对象，也就是除过宿主对象之外的所有对象。
    - 固有对象（Intrinsic Objects ）：由标准规定，随着JavaScript运行时被创建而自动创建的对象。
    - 原生对象（Native Objects）：用户可以通过Array、RegExp等内置构造器或者特殊语法创建的对象。
    - 普通对象（Ordinary Objects）：用户通过{}语法、Object构造器或者class关键字定义类创建的对象，它能够被原型继承。

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
- Screen
- History

### DOM
JavaScript Document Object Model (DOM)提供了众多API用于操作DOM元素。包括：
- 选择元素，`getElementBy*`；
- 遍历元素，`parentNode`、`firstChild`等；
- 操作元素，`createElement`、`innerHTML`、`append`、`insertBefore`、`replaceChild`等；
- 操作属性，`setAttribute`、`getAttribute`、`hasAttribute`等；
- 操作CSS样式，`style`、`getComputedStyle`  、`height`等；
- 事件处理，`onclick`、`onscroll`、`load`、`addEventListener`、`mouseover`、`keyup`等；
- 表单处理。

## 内置对象

ECMA-262 把内置对象（built-in object）定义为：由 ECMAScript 提供的、独立于宿主环境的所有对象，在 ECMAScript 程序开始执行时出现。所以，在JavaScript引擎初始化的时候就会创建好，我们直接拿来用即可。

### 固有对象

固有对象是由标准规定，随着JavaScript运行时启动而自动创建的对象实例。

固有对象在任何JS代码执行前就已经被创建出来了，它们通常扮演者类似基础库的角色。我们前面提到的“类”其实就是固有对象的一种。ECMA标准为我们提供了一份固有对象表，里面含有150+个[固有对象](https://www.ecma-international.org/ecma-262/9.0/index.html#sec-well-known-intrinsic-objects)。

### 原生对象

ECMAScript给出的定义：
>object in an ECMAScript implementation whose semantics are fully defined by this specification rather than by the host environment. NOTE Standard native objects are defined in this specification. Some native objects are built-in; others may be constructed during the course of execution of an ECMAScript program.

也就是说，能够通过语言本身的构造器创建的对象称作原生对象。

在JavaScript标准中，提供了30多个构造器。按照不同应用场景，分成了以下几个种类。

![原生对象](../images/js-native-objects.png)

这些对象可以用 `new` 运算符创建新对象，但是却无法用 `extends` 继承。可以这么认为：这些对象都是为了特定能力或者性能，而设计出来的特权对象。