CSSOM，即CSS Object Model，CSS对象模型，是对CSS样式表的对象化表示，同时还提供了相关API用来操作CSS样式。

这里有一个问题：既然已经有了DOM树结构来表示HTML文档结构，那为什么不把CSS顺便放在在DOM上，以便我们直接从Element上获取所有样式信息呢？

很明显，如果把CSS信息一起建模在DOM结构上，就会违背”单一职责原则“。因为**正如在网页中HTML承担了语义职能，CSS承担了表现职能一样，在计算机中DOM承担了语义职能，而CSSOM承担了表现职能。**

在W3C标准中，CSSOM包含两部分：
- Model：描述样式表和规则的模型部分；
- View：和元素视图相关的API部分。

在实际工作中，CSSOM Model部分使用的并不多，因为样式表一旦定义好，就不会轻易改变，至多通过`element.style`修改特定样式属性。反而，CSSOM View部分使用的稍微多一点。

注意：`element.style`只是获取某个元素的内联样式，而非完整的样式表。

# CSSOM Model
## 原理

Model部分是CSSOM的本体，通常都是用HTML标签`style`或者`link`标签即可创建：

```html
<style title="cssom">
a {
  color:#233;
}
</style>

<link rel="stylesheet" title="x" href="somestyle.css">
```

比如，对于[这段代码](https://developers.google.com/web/fundamentals/performance/critical-rendering-path/constructing-the-object-model?hl=zh-cn)：

```html
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link href="style.css" rel="stylesheet">
    <title>Critical Path</title>
  </head>
  <body>
    <p>Hello <span>web performance</span> students!</p>
    <div><img src="awesome-photo.jpg"></div>
  </body>
</html>
```

构建DOM的大致过程如下：
- 通过网络获取字节流和字符；
- 对字符序列进行分词操作，得到一个个token；
- 根据token序列分析语法，得到一个个节点node；
- 根据node序列，分析并构建DOM树。

![DOM树构建过程](../images/dom-full-process.png)

假如somestyle.css文件的内容如下：

```css
body { font-size: 16px }
p { font-weight: bold }
span { color: red }
p span { display: none }
img { float: right }
```

构建CSSOM的过程和构建DOM的过程类似，但前者要依赖后者，因为只有HTML内容具有完整的树形结构关系，而CSS样式表并没有。

![CSSOM树结构](../images/cssom-tree.png)

具体而言，在构建CSSOM树时，对于任何一个元素的最终样式，浏览器都会从适用于该节点的最上层节点开始，通过递归的方式不断向下合并更加具体的规则，最终得出完整的结果，这就是向下级联(Cascade)的含义。

## 基本用法
### document.styleSheets

`document.styleSheets`表示文档中的所有样式表，是一个只读的列表。我们可以用方括号运算符下标访问样式表，也可以使用`item`方法来访问，它还有`length`属性表示文档中的样式表数量。基本结构如下所示：

- 0: CSSStyleSheet
    - cssRules:
        - 0: CSSMediaRule
            - conditionText: "(min-width: 47.9385em)"
            - cssRules: CSSRuleList
                - 0: CSSStyleRule
                    - selectorText: ".logo"
                    - cssText: ".logo { width: 200px; height: 44px; }"
                    - parentRule: ...
                    - style: CSSStyleDeclaration
                    - styleMap: {...}
                    - type: 1
            - cssText: "@media (min-width: 47.9385em) {.logo { width: 200px; height: 44px; }}"
            - media: MediaList
            - parentRule: null
        - 1: CSSStyleRule
        - 2: CSSSupportsRule
        - ...
    - media: 
    - disabled: true/false
    - href: url-of-css-file
    - ownerNode: link
    - ownerRule: null
    - parentStyleRule: null/someone
    - title: null/sometitle
    - type: "text/css"
    - rules: generally equel to cssRules
- 1: CSSStyleSheet
- ...

### insertRule removeRule

虽然不能创建样式表，但是可以修改（插入和移除）某个样式表中的内容：

```js
document.styleSheets[0].insertRule("p { color:pink; }", 0)
document.styleSheets[0].removeRule(0)
```

实际上，用这种方式修改元素样式的案例并不多见。反而，直接修改元素的内联样式是比较常见的。比如：

```js
var elem = document.querySelector('#some-element');

// 逐个修改
elem.style.color = 'purple';
elem.style.backgroundColor = '#e5e5e5';

// 整体修改
Object.assign(elem.style, {fontsize:"12px",left:"200px",top:"100px"});
// 或者修改cssText
elem.style.cssText = "display: block; position: absolute";
```

还可以通过创建style标签来修改。

```js
var style = document.createElement('style');
style.innerHTML =
	'.some-element {' +
		'color: purple;' +
		'background-color: #e5e5e5;' +
		'height: 150px;' +
	'}';

// 获取第一个script标签
var ref = document.querySelector('script');
// 将style插在第一个script标签之前
ref.parentNode.insertBefore(style, ref);
```

如上面展开的CSSStyleSheet结构所示，当取到`document.styleSheets[n].cssRules`时，同样也可以支持`item`、`length`和下标运算，但是这些Rules有点特殊，可分为两种：
- at-rule，又分为：
    - CSSCharsetRule，对应@charset
    - CSSImportRule，对应@import
    - CSSMediaRule，对应@media
    - CSSFontFaceRule，对应@font-face
    - CSSPageRule，对应@page
    - CSSNamespaceRule，对应@namespace
    - CSSKeyframesRule，对应@keyframes
    - CSSSupportsRule，对应@supports
- CSSStyleRule，对应普通rule，主要属性有。
    - selectorText：选择器名称；
    - style：具体样式，可像修改内联样式一样操作。

### window.getComputedStyle

这是一个非常重要的方法，用来获取某个元素经过内联计算得到的最终样式。有两个参数，第一个要获取的Element，第二个是伪元素，可选。

```js
window.getComputedStyle(elt, pseudoElt);

window.getComputedStyle(document.body.firstElementChild);
window.getComputedStyle(document.body.firstElementChild, "::after");
```

# CSSOM View

这部分内容可分成三个部分：窗口部分，滚动部分和布局部分。

## 窗口

窗口API用于操作浏览器窗口的位置、尺寸等。有四个API：
- `moveTo(x, y)`：窗口移动到屏幕的特定坐标；
- `moveBy(x, y)`：窗口移动特定距离；
- `resizeTo(x, y)`：改变窗口大小到特定尺寸；
- `resizeBy(x, y)`：改变窗口大小特定尺寸。

但是，**很多浏览器出于安全考虑，有些API并没有实现，有些实现了却进行了特殊限制**。比如，在Chrome中, 只有通过`window.open`创建的窗口才起实际作用。

```js
window.open("about:blank", "_blank" ,"width=1000,height=1000,left=100,right=100" )
```

## 滚动

滚动行为分为视口滚动和元素滚动两种，它们在PC时代可能差别不大，但在移动端产品越来越多的时代，存在着一定差异。

### 视口滚动

视口滚动行为主要由window对象上的一组API控制：
- `scrollX`：属性，表示X方向上的当前滚动距离，有别名 pageXOffset；
- `scrollY`：属性，表示Y方向上的当前滚动距离，有别名 pageYOffset；
- `scroll(x, y)`：使页面滚动到特定位置，有别名`scrollTo`，支持传入配置型参数 {top, left}；
- `scrollBy(x, y)`：使页面滚动特定的距离，支持传入配置型参数 {top, left}。

如果要监控视口的滚动行为，则需要在document对象上绑定事件监听函数：

```js
document.addEventListener("scroll", function(event){
  console.log(window.scrollY)
})
```

### 元素滚动

为了让Element支持滚动，加入了这些API：
- `scrollTop`：属性，表示Y方向上的当前滚动距离。
- `scrollLeft`：属性，表示X方向上的当前滚动距离。
- `scrollWidth`：属性，表示元素内部滚动内容的宽度，一般来说会大于等于元素宽度。
- `scrollHeight`：属性，表示元素内部滚动内容的高度，一般来说会大于等于元素高度。
- `scroll(x, y)`：使元素滚动到特定的位置，有别名`scrollTo`，支持传入配置型参数 {top, left}。
- `scrollBy(x, y)`：使元素滚动到特定的位置，支持传入配置型参数 {top, left}。
- `scrollIntoView(arg)`：滚动元素所在的父元素，使得元素滚动到可见区域，可以通过arg来指定滚到中间、开始或者就近。

同样，也支持监听。

```js
element.addEventListener("scroll", function(event){
  //......
})
```

## 布局

这是整个CSSOM中最常用到的部分，同样要分成全局API和元素上的API。

### 全局

`window`对象上提供的一些全局尺寸信息：

- `window.innerHeight`, `window.innerWidth`：表示视口的高度和宽度。
- `window.outerWidth`, `window.outerHeight`：表示浏览器窗口占据的大小，很多浏览器没有实现，一般来说这两个属性无关紧要。
- `window.devicePixelRatio`：表示物理像素和CSS像素单位的倍率关系，Retina屏是2，后来也出现了一些3倍的Android屏。
- `window.screen`：屏幕尺寸信息
    - `window.screen.width`, `window.screen.height`：设备屏幕宽高尺寸。
    - `window.screen.availWidth`, `window.screen.availHeight`：设备屏幕的可渲染区域尺寸，一些Android机器会把屏幕的一部分预留做固定按钮，所以有这两个属性，实际上一般浏览器不会实现的这么细致。
    - `window.screen.colorDepth`, `window.screen.pixelDepth` 这两个属性是固定值24，应该是为了以后预留。

```js
window.screen

    availHeight: 988
    availLeft: 0
    availTop: 23
    availWidth: 1920
    colorDepth: 24
    height: 1080
    orientation: ScreenOrientation
        angle: 0
        onchange: null
        type: "landscape-primary"
        __proto__: ScreenOrientation
    pixelDepth: 24
    width: 1920
    __proto__: Screen
```

### 元素

获取元素的布局信息，无非就是位置和尺寸大小，位置信息比较确定，一般是起始点，但尺寸信息并不好操作。因为只有具体的“盒”才有尺寸大小信息，而一个元素可能产生多个“盒”。鉴于这种情况，CSSOM提供了两个方法：
- `getClientRects()`：返回一个列表，里面包含元素对应的每一个盒所占据的客户端矩形区域，这里每一个矩形区域可以用 x, y, width, height 来获取它的位置和尺寸。
- `getBoundingClientRect()`：返回元素对应的所有盒构成的外围矩形区域，它更符合我们头脑中的元素盒的概念。

如果我们要获取相对坐标，或者包含滚动区域的坐标，需要一点小技巧：

```js
var offsetX = document.documentElement.getBoundingClientRect().x - element.getBoundingClientRect().x;
```

另外，DOM上还提供了一个方法`document.elementFromPoint(x, y)`，可以通过这个方法获取处在特定坐标点的元素。然后再配合上面的方法，便可得到具体元素的布局信息。

# 总结

正如在网页中，HTML承担了语义职能，CSS承担了表现职能一样；在计算机中，DOM承担了语义职能，而CSSOM承担了表现职能。

模型部分是CSSOM的本体，是所有样式表对象化表示，有助于开发者读取和修改。通过`document.styleSheets`可获取所有样式表，结果是一个只读列表，但可以通过下标运算修改。

实际上，通过这种方式修改样式信息并不多见，更多的是通过`element.style`直接修改内联样式，有多种方式可选。

View部分是CSSOM的核心，可分为三类：窗口、滚动和布局相关API。
- 窗口API用于操作浏览器窗口的位置、尺寸等，但是出于安全考虑，这些API并不总起实际作用；
- 滚动可分为视口滚动和元素滚动，它们之间既有相同，也有不同之处，监听滚动事件是一个常见的操作；
- 布局API总体上使用的最多，借助它们可以轻松获特定元素的位置和尺寸信息，为进一步操作提供可能性。