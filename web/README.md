这部分内容以winter老师在[极客时间](https://time.geekbang.org/)上的开设的[《重学前端》](https://time.geekbang.org/column/intro/100023201)课程为[大纲](https://github.com/Walkerant/Study/tree/master/web/md/outline.md)，经过个人查缺补漏，总结输出的前端知识体系。

# JavaScript语言
1. [语言基础：七种基本类型](https://github.com/Walkerant/Study/tree/master/web/md/js-types.md) Undefined、Null、Boolean、String、Number、Symbol、Object，Object的两类属性及其分类。
2. [对象继承：原型和原型链](https://github.com/Walkerant/Study/tree/master/web/md/js-prototype.md) 原型的概念，原型的版本演化，关键字new，ES6中的class，继承体系的核心原型链的概念，显式原型prototype和隐式原型__proto__。
2. [再谈继承体系核心：原型与类](https://github.com/Walkerant/Study/tree/master/web/md/js-prototype-class.md) 原型的一些操作细节，类class的基本用法、继承、静态属性及方法、私有属性，另一种代码复用机制Mixin在JS中的用法。
3. [执行机制核心：事件循环](https://github.com/Walkerant/Study/tree/master/web/md/js-event-loop.md) 涉及到的数据结构，事件循环的运行逻辑，同步、异步任务，回调函数，宏观任务与微观任务，异步管理机制Promise、async、await。
4. [执行机制细节：函数、闭包和执行上下文](https://github.com/Walkerant/Study/tree/master/web/md/js-execution.md) JS中的8种函数，闭包，执行上下文的演变，var和let，this含义以及在不同情况下的具体值，this的实现机制。
5. [语句特别之处：Completion Record](https://github.com/Walkerant/Study/tree/master/web/md/js-statement.md) 它的三个字段type、value、target让JS语句可实现复杂的嵌套结构，针对不同语句类型分析此三字段的具体值。
6. [词法：一些特殊情况](https://github.com/Walkerant/Study/tree/master/web/md/js-lexical.md) 容易引发冲突的词法规则除法和正则表达式的区分，空白符、换行符，数字、字符串直接量和字符串模板。
7. [语法：模块、预处理和指令序言](https://github.com/Walkerant/Study/tree/master/web/md/js-grammar.md) 脚本和模块的区别，支持模块的import、export、default的使用指南，预处理机制及其对变量、函数、类声明的分析，指令序言。
8. [函数对象：一些特性和函数式](https://github.com/Walkerant/Study/tree/master/web/md/js-function.md) 函数对象的属性name、length、arguments和可变参数...args，递归，函数式编程实践装饰器、偏函数，对函数this的绑定方式。

# HTML和CSS
1. [三类基本标签](https://github.com/Walkerant/Study/tree/master/web/md/html-semantic.md) 元信息类head、title、meta等；语义类nav、section、h、header等；媒体替换类script、img、video、audio等。
2. [链接类标签：link、a和area](https://github.com/Walkerant/Study/tree/master/web/md/html-links.md) link也是一种元信息类标签，如canonical、manifest等；a更加常用；area表示区域性链接，如在地图上的链接。
3. [CSS两种语法规则](https://github.com/Walkerant/Study/tree/master/web/md/css-rules.md) at规则，如@charset、@media、@supports等；普通规则，如id、class、attribute、伪类选择器，以及用空格、大于号、加号、波浪线、双竖线组成的复合选择器。
4. [CSS选择器的用法](https://github.com/Walkerant/Study/tree/master/web/md/css-selectors.md) type、id、class、attribute、伪类选择器的用法，由空格、>、~、+、||组成的复合选择器、伪元素的使用指南。
5. [Flex弹性布局](https://github.com/Walkerant/Study/tree/master/web/md/css-flex.md)
 flex的实现原理、使用指南，以及三种经典布局的flex实现方式。

# 浏览器实现原理及API
1. [实现原理一：获取数据](https://github.com/Walkerant/Study/tree/master/web/md/brower-http.md)
2. [浏览器对象模型DOM的四类API](https://github.com/Walkerant/Study/tree/master/web/md/brower-dom-api.md) 节点的继承关系、操作、比较、新建、属性；遍历DOM树的几种常见算法；富文本领域性较强的Range；事件处理、捕获、冒泡和焦点。
3. [CSS对象模型CSSOM](https://github.com/Walkerant/Study/tree/master/web/md/cssom-api.md) 表示样式表和规则的模型部分，获取document.styleSheets、操作；和元素视图相关的API，可分为窗口部分，滚动部分和布局部分。

# Q&A
1. [问题集合「一」：常见问题](https://github.com/Walkerant/Study/tree/master/web/md/qa-js-1.md) 大括号{}的三种作用，单线程模型原因， ==和===之间的区别， typeof和instanceof之间的区别等。
2. [问题集合「二」：来自Stack Overflow](https://github.com/Walkerant/Study/tree/master/web/md/qa-js-2.md) 数组去重，多行字符串的创建