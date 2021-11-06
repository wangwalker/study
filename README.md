# iOS

## Fundation
1. [集合类使用指南](https://github.com/Walkerant/Study/tree/master/ios/md/collection.md) NSArray、NSDictionary和NSSet的排序、查找、枚举操作等。
2. [并发编程实践](https://github.com/Walkerant/Study/tree/master/ios/md/concurrent.md) NSThread、NSOperation、GCD的使用方法和代码片段，以及线程同步机制，尤其强大的GCD，比如分组任务、信号量等。
2. [Block：OC的闭包](https://github.com/Walkerant/Study/tree/master/ios/md/block.md) Block的数据结构、三种类型，常见的声明、使用方式，以及__block和循环引用问题。
3. [RunLoop：任务调度机制](https://github.com/Walkerant/Study/tree/master/ios/md/runloop.md) 也可称为事件循环EventLoop，是很多服务得以被调度的基础，比如GCD、线程、NSTimer、UIEvent等。
4. [Runtime：强大的运行时系统](https://github.com/Walkerant/Study/tree/master/ios/md/runtime.md) Runtime的原理、数据结构、公开接口，消息发送、动态解析和转发，以及Method Swizzling和使用场景。
5. [KVO和KVC：灵活的键值特性](https://github.com/Walkerant/Study/tree/master/ios/md/kvo-kvc.md) KVO可有效实现解耦，三个步骤：注册、处理、移除；KVC让对象扁平化，集合类的聚合操作很方便。

### Media

1. [Quartz 2D绘图引擎](https://github.com/Walkerant/Study/tree/master/ios/md/quartz.md) 也叫Core Graphics，绘图上下文，颜色空间，路径：直线、曲线、子路径，放射变换，渐变，模式，透明图层等。
2. [Core Image：图片处理](https://github.com/Walkerant/Study/tree/master/ios/md/core-image.md) 滤镜概念、创建滤镜、处理流程，内置滤镜分类，滤镜链，人脸检测，提高性能的注意点等。
3. [Core Animation：动画](https://github.com/Walkerant/Study/tree/master/ios/md/core-animation.md) UIView VS CALayer，CALayer可动画属性、图层结构模型，CABasicAnimation、CAKeyFrameAnimation、CAAnimationGroup等。

### Swift

1. [版本迭代及基础知识](https://github.com/Walkerant/Study/tree/master/ios/md/swift-overview.md) 大版本之间的特性演变，和Objective-C之间的区别，编译，基本类型，运算符，遍历方法
2. [一些高级特性](https://github.com/Walkerant/Study/tree/master/ios/md/swift-advanced.md) 函数的实参、形参、类型，闭包语法、类型、捕获值、逃逸闭包、自动闭包，面向对象，值类型和引用类型，属性、方法，初始化过程

# Web
### JavaScript

1. [语言基础：七种基本类型](https://github.com/Walkerant/Study/tree/master/web/md/js-types.md) Undefined、Null、Boolean、String、Number、Symbol、Object，Object的两类属性及其分类。
2. [对象继承：原型和原型链](https://github.com/Walkerant/Study/tree/master/web/md/js-prototype.md) 原型的概念，原型的版本演化，关键字new，ES6中的class，继承体系的核心原型链的概念，显式原型prototype和隐式原型__proto__。
2. [再谈继承体系核心：原型与类](https://github.com/Walkerant/Study/tree/master/web/md/js-prototype-class.md) 原型的一些操作细节，类class的基本用法、继承、静态属性及方法、私有属性，另一种代码复用机制Mixin在JS中的用法。
3. [执行机制核心：事件循环](https://github.com/Walkerant/Study/tree/master/web/md/js-event-loop.md) 涉及到的数据结构，事件循环的运行逻辑，同步、异步任务，回调函数，宏观任务与微观任务，异步管理机制Promise、async、await。
4. [执行机制细节：函数、闭包和执行上下文](https://github.com/Walkerant/Study/tree/master/web/md/js-execution.md) JS中的8种函数，闭包，执行上下文的演变，var和let，this含义以及在不同情况下的具体值，this的实现机制。
5. [语句特别之处：Completion Record](https://github.com/Walkerant/Study/tree/master/web/md/js-statement.md) 它的三个字段type、value、target让JS语句可实现复杂的嵌套结构，针对不同语句类型分析此三字段的具体值。
6. [词法：一些特殊情况](https://github.com/Walkerant/Study/tree/master/web/md/js-lexical.md) 容易引发冲突的词法规则除法和正则表达式的区分，空白符、换行符，数字、字符串直接量和字符串模板。
7. [语法：模块、预处理和指令序言](https://github.com/Walkerant/Study/tree/master/web/md/js-grammar.md) 脚本和模块的区别，支持模块的import、export、default的使用指南，预处理机制及其对变量、函数、类声明的分析，指令序言。
8. [函数对象：一些特性和函数式](https://github.com/Walkerant/Study/tree/master/web/md/js-function.md) 函数对象的属性name、length、arguments和可变参数...args，递归，函数式编程实践装饰器、偏函数，对函数this的绑定方式。

### HTML & CSS

1. [三类基本标签](https://github.com/Walkerant/Study/tree/master/web/md/html-semantic.md) 元信息类head、title、meta等；语义类nav、section、h、header等；媒体替换类script、img、video、audio等。
2. [链接类标签：link、a和area](https://github.com/Walkerant/Study/tree/master/web/md/html-links.md) link也是一种元信息类标签，如canonical、manifest等；a更加常用；area表示区域性链接，如在地图上的链接。
3. [CSS两种语法规则](https://github.com/Walkerant/Study/tree/master/web/md/css-rules.md) at规则，如@charset、@media、@supports等；普通规则，如id、class、attribute、伪类选择器，以及用空格、大于号、加号、波浪线、双竖线组成的复合选择器。
4. [CSS选择器的用法](https://github.com/Walkerant/Study/tree/master/web/md/css-selectors.md) type、id、class、attribute、伪类选择器的用法，由空格、>、~、+、||组成的复合选择器、伪元素的使用指南。
5. [Flex弹性布局](https://github.com/Walkerant/Study/tree/master/web/md/css-flex.md)
 flex的实现原理、使用指南，以及三种经典布局的flex实现方式。

### 浏览器

1. [实现原理一：获取数据](https://github.com/Walkerant/Study/tree/master/web/md/brower-http.md)
2. [浏览器对象模型DOM的四类API](https://github.com/Walkerant/Study/tree/master/web/md/brower-dom-api.md) 节点的继承关系、操作、比较、新建、属性；遍历DOM树的几种常见算法；富文本领域性较强的Range；事件处理、捕获、冒泡和焦点。
3. [CSS对象模型CSSOM](https://github.com/Walkerant/Study/tree/master/web/md/cssom-api.md) 表示样式表和规则的模型部分，获取document.styleSheets、操作；和元素视图相关的API，可分为窗口部分，滚动部分和布局部分。

### 网络协议

1. [HTTP和HTTPS协议](https://github.com/Walkerant/Study/tree/master/web/md/http.md) HTTP：版本演化，URI，报文格式，首部字段，请求格式，方法，状态，TCP连接，性能问题，安全问题；HTTPS：Hash算法，对称、非对称加密算法，单向加密、双向加密，SSL和TLS。
