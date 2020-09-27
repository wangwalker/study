# 脚本和模块
## 概念
在ES5之前的版本中，JavaScript源代码只有一种类型：脚本。但是，从ES6开始，还加入了另一种源代码类型：模块。

从概念上，可以认为脚本是主动性的JavaScript代码段，是控制宿主完成一定任务的代码；而模块是被动性的JavaScript代码段，是等待被调用的库。

现代浏览器支持用script标签引入脚本或模块，但如果引入的是模块，则要加入type="module"。

```html
<script type="module" src="somemodule.js"></script>
```

这样，一个JavaScript程序的普遍代码结构如下：
- 脚本
    - 语句
- 模块
    - import声明
    - export声明
    - 语句

## import

import声明表示引入某个模块，既可以引入整个模块中的内容，也可以引入部分内容，区别在于有没有from关键字。

```js
// 引入整个模块
import "module1.js"
// 引入部分内容
import {Class1, Class2, function1} from "module2.js"
// 引入模块中的所有内容，并以类似类属性的方式调用。只有必要时才建议这么使用，因为可能可能会引入无用变量。
import * as x from "module3.js"
```

引入整个模块只能保证里面的代码被执行，而无法获取里面的任何内容。相反，使用from则可以引入模块中的一部分，并把它们变成本地变量。

另外，还有一种import写法：

```js
import x from "module3.js"
```

这种写法引入的是模块中的默认值，这里的` x `可自定义，默认值是和default搭配的export语句，后面有解释。

```js
// 📃 m1.js
export var num = 1;

export function increaseNum(){
    num++;
    console.log("increased variable 'num'")
}

// 📃 m2.js
import {num, increaseNum} from "./m1.js"

console.log(num)    // 1
increaseNum()       // increased variable 'num'
console.log(num)    // 2
```

通过这个例子，我们知道了导入的变量还是原来的变量，只是修改名称之后放在了其他位置而已。在实际工作中，用这种方式在多个模块之间共享变量是一个可选的方案。

## export
### 连写

将export和声明语句写在一起，比如：

```js
// export an array
export let months = ['Jan', 'Feb', 'Mar','Apr', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

// export a constant
export const MODULES_BECAME_STANDARD_YEAR = 2015;

// export a class
export class User {
  constructor(name) {
    this.name = name;
  }
}
```

### 不连写

将export和声明语句分开写，比如：

```js
// 📃 say.js
function sayHi(user) {
  alert(`Hello, ${user}!`);
}

function sayBye(user) {
  alert(`Bye, ${user}!`);
}

export {sayHi, sayBye};
```

### as

export也可以和as连用，给变量重命名，比如对于上面的代码，可以这么写：

```js
// 📃 say.js
...
export {sayHi as hi, sayBye as bye};

// 📃 main.js
import * as say from './say.js';

say.hi('John');     // Hello, John!
say.bye('John');    // Bye, John!
```

### default

default和export配合，表示导出一个默认变量值，可以和class与function连用。

```js
// 📃 user.js

// 方式1：直接添加default
export default class User {
  constructor(name) {
    this.name = name;
  }
}

// 方式2：分开声明和default
class User {
  constructor(name) {
    this.name = name;
  }
}

export default User;
// or
export {User as default};
```

在这种场景中，import语句不需要使用大括号{}，而且可自定义变量值的名称。

| Named export | Default export |
| - | - |
| `export class User {...}` | `export default class User {...}` |
| `import {User} from ...` | `import User from ...` |
| ~ | `import MyUser from ...` |


在工程实践中，更建议一个模块中只包含一个变量，并作为默认变量值导出，同时结合文件夹和文件结构组织代码，形成良好的代码风格。

### export ... from

`export ... from`表示从其他模块导出变量。这种方式适合将多个模块中的变量及默认值统一放入一个访问入口，能起到优化代码的作用。例如这种情况：

```js
auth/
    index.js
    user.js
    helpers.js
    tests/
        login.js
    providers/
        github.js
        facebook.js
        ...
```

现在要把所有模块中的内容放在index.js中统一导出，既可以这样写：

```js
import {login, logout} from './helpers.js';
export {login, logout};

// import default as User and export it
import User from './user.js';
export {User};
...
```

也可以这样写：

```js
export {login, logout} from './helpers.js';
export {default as User} from './user.js';
...
```

当然，第二种方式比第一种方式简便多了。

# 预处理

预处理是指，在JavaScript引擎执行代码之前，会提前处理声明变量var、let、const，函数声明function，类声明class，以明确所有变量的基本信息，比如类型。

## var

var声明永远作用于模块、脚本和函数体级别。在预处理阶段，不关心赋值部分，只管声明部分。

```js
var a = 1;

function foo() {
    console.log(a);
    var a = 2;
}

foo();
```

在这个例子中，在函数foo作用于内，因为又声明了一个a，所以不会访问外面的a，但是在console.log时，还没有赋值，所以是undefined。

如果给里面的声明语句加上控制语句if：

```js
var a = 1;

function foo() {
    console.log(a);
    if(false) {
        var a = 2;
    }
}

foo();
```

经过执行发现还是undefined，这是因为虽然if(false)里面的语句不会被执行，但是在预处理阶段并不管这些，var会穿透一切语句结构，所以和前面的一样。

## function

function和var类似，但是在新的JavaScript标准中，对其进行了一些修改，使其更加复杂。主要是function声明不但在作用域中加入变量，还会赋值。

```js
console.log(foo);
function foo(){
    console.log("foo")
}
```

经过执行得知，输出了函数值。如果再加入if：

```js
console.log(foo);
if (true) {
    function foo(){
        console.log("foo")
    }
}
```

当加入控制语句if后，在预处理阶段只会声明变量，而不会赋值，所以得到了undefined。

再看另一个例子：

```js
console.log(b)
function b() { };
var b = 1 ;
console.log(b)
```

经过执行发现先打印函数值，在打印1。这说明：
1. function声明的预处理优先级高于var；
2. 变量名相同时，后面带有赋值语句的变量声明会覆盖前面的（除过class，let会报错），当然这是符合直觉的。

## class

class声明在全局的行为和function与var都不太一样。例如下面的例子：

```js
console.log(c1)
class c1 {
    constructor(a) {
        this.a = a
    }
}
```
经过执行验证，在class声明之前就使用class，会报错。再来看看另一个例子：

```js
var c = 1;
function foo(){
    console.log(c);
    class c {}
}
foo();
```

同样，还是报错，但是去掉函数体内的class声明，则正常打印1。这至少说明在函数体内的class声明语句经过了某些预处理，它会在作用域中创建变量，并且要求访问它时抛出错误。这样更符合我们一般的认知，如果还没有声明，那么应该抛出错误信息。

# 指令序言

脚本和模块都支持一种特别的语法：指令序言，最早是为了use strict设计的，它规定了一种给JavaScript代码添加元信息的方式。

## use strict

use strict表示JavaScript代码是在严格模式下执行，而非普通模式。在严格模式下，顾名思义，就是代码在执行时具有更加严格的规则来约束其行为。根据[阮一峰老师的博客](https://www.ruanyifeng.com/blog/2013/01/javascript_strict_mode.html)，严格模式有下面这些目的：
> - 消除Javascript语法的一些不合理、不严谨之处，减少一些怪异行为;
> - 消除代码运行的一些不安全之处，保证代码运行的安全；
> - 提高编译器效率，增加运行速度；
> - 为未来新版本的Javascript做好铺垫。

另外，严格模式有两种使用方式，一是在整个脚本中，另一个是在单个函数体内使用。

在整个脚本中使用时，必须放在文件第一行，否则无效。

```js
use strict;

console.log("this is on strict mode")
function f(){
    console.log(this);
};
f.call(null);   // null
```

在严格模式下，普通函数中的this将严格按照传入进去的值执行。而如果不在严格模式下，则为global。

同样，在函数中使用严格模式，也必须将us strict放在第一行。

```js
function useStrict() {
    "use strict";
    return this;
}
useStrict();    // undefined
```

## no lint

no lint表示此文件不需要进行进行语法检查，可以这么写：

```js
"no lint";
"use strict";
function doSth(){
    //...
}
...
```

# 总结

