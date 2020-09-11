# 简介
## What
虽然网页内容使用各种标签平铺而成的，但是在浏览器中它们却不是同样的平铺结构，而是被解析为树形结构，所有的标签按照层级关系建模构建成一棵树，这棵树就被称为“文档对象模型”树，英文为Document Of Object，简称DOM树。

## Why
为什么要这么做？一方面是因为“面向对象”编程的强大，几乎所有在操作系统之上构建的大型软件都离不开这一思想和工具，另一方面是因为树形结构是对一切复杂系统的抽象，一本书的结构、一个家族的人员关系、一个公司的上下级关系、甚至一个国家的治理模式，实际上都是一种树形结构。

所以，基于这些思想和工具来构建复杂文档的结构也就可以理解了。

## DOM API分类

DOM API就是DOM树开放给开发者的接口，是对系统能力的延伸，大致会包含4个部分。

- 节点：DOM树形结构中的节点相关API；
- 事件：触发和监听事件相关API；
- Range：操作文字范围相关API；
- 遍历：遍历DOM需要的API。 

# 节点

主要的DOM树节点的继承关系如下：

![DOM节点继承关系](../images/dom-inheritance-simple.png)

使用代码验证：
```js

    alert(document.body.constructor.name) // "HTMLBodyElement"
    alert(document.body) // [object HTMLBodyElement]

    document.body instanceof HTMLBodyElement // true
    document.body instanceof HTMLElement // true
    document.body instanceof Element // true
    document.body instanceof Node // true
    document.body instanceof EventTarget //true
    HTMLInputElement.prototype.__proto__ === HTMLElement.prototype //true
    HTMLAnchorElement.prototype.__proto__ === HTMLElement.prototype // true

```

完整的继承关系如下所示：

![DOM节点继承关系](../images/dom-inheritance.png)

## Node

Node是DOM树继承关系的根节点，相当于一个“抽象类”，提供了操作DOM的基础能力，主要有下面这些API：

- 关系节点
    - `parentNode`，父节点；
    - `childNodes`，孩子节点；
    - `firstChild`，第一个孩子节点；
    - `lastChild`，最后一个孩子节点；
    - `nextSibling`，下一个兄弟节点；
    - `previousSibling`，上一个兄弟节点。
- 操作节点
    - `appendChild`，在后面添加孩子节点；
    - `insertBefore`，在某个节点之前添加；
    - `removeChild`，删除某个节点；
    - `replaceChild`，替换某个节点
    - `cloneNode`，复制一个节点，如果传入参数true，则会连同子元素做深拷贝。
- 比较关系
    - `compareDocumentPosition`，是一个用于比较两个节点中关系；
    - `contains`，检查一个节点是否包含另一个节点；
    - `isEqualNode`，检查两个节点是否完全相同；
    - `isSameNode`，检查两个节点是否是同一个节点，实际上在JavaScript中可以用“===”；
- 新建节点（DOM标准规定文档节点必须由`create`方法创建，而不能用JavaScript的`new`创建）
    - `createElement`
    - `createTextNode`
    - `createCDATASection`
    - `createComment`
    - `createProcessingInstruction`
    - `createDocumentFragment`
    - `createDocumentType`

