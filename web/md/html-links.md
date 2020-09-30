# 链接

在HTML中，除过可见的链接`a`，还有很多不可见的链接`link`，它们都表示HTML文档和其他文档或者资源的连接关系。`link`标签可分为两种：一种是超链接型标签，一种是外部资源链接。

## link

不可见的`link`标签也是**一种元信息类标签，它是为了搜索引擎和浏览器以及插件服务的**。可以分为两类：

- 超链接类：会生成超链接，但又不会像a标签那样显示在网页中。
- 外部资源类：会把外部的资源链接到文档中，还会下载这些资源，并且做出一些处理。

另外，除过元信息类标签的用法，很多外部资源型`link`标签还能被放在`body`中，从而把外部资源连接进文档中。

`link`标签主要通过`rel`属性区分，内容用`href`属性表示。

```html
<link rel="alternate" href="...">
```

### 超链接类link

超链接类`link`是一种被动型链接，在用户不操作的情况下，它们不会被下载。

#### canonical

`canonical`型的`link`提示页面它的的主URL。在网站中常常有多个URL指向同一页面的情况，搜索引擎访问这类页面时会去掉重复的页面，这个`link`会提示搜索引擎保留哪个URL。

例如Google主页的link标签：
```html
<link href="/?ie=UTF-8&amp;rct=j" rel="canonical">
```

#### altername

`alternate`型`link`表示当前页面的变形，比如在不同格式、不同语言或不同设备版本状态下对应的页面。它们通常也是给搜索引擎看的。

```html
<link rel="alternate" type="application/rss+xml" title="RSS" href="...">
```

#### prev & next

在很多应用中，页面呈序列状排布，比如浏览图片库、电子书。这时候，就可以使用`prev`和`next`型的`link`，分别告诉搜索引擎和浏览器它的前后项是什么。

```html
<link rel="prev" href="http://stackoverflow.com/documentation/java/topics">
<link rel="next" href="http://stackoverflow.com/documentation/css/topics">
```

#### manifest

`manifest`是PWA（Progressive Web Apps）技术的一部分，可以让Web应用像原生应用一样在设备上运行，可提升体验。但到目前为止，只有一部分平台支持（Chrome）。`manifest`型的`link`主要提供了一份资源清单，用来指定Web Apps名称、图标、运行模式等。

这是来自MDN的例子：
```js
{
  "name": "HackerWeb",
  "short_name": "HackerWeb",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#fff",
  "description": "A simply readable Hacker News app.",
  "icons": [{
    "src": "images/touch/homescreen48.png",
    "sizes": "48x48",
    "type": "image/png"
  }, {
    "src": "images/touch/homescreen72.png",
    "sizes": "72x72",
    "type": "image/png"
  }, {
    "src": "images/touch/homescreen168.png",
    "sizes": "168x168",
    "type": "image/png"
  }, {
    "src": "images/touch/homescreen192.png",
    "sizes": "192x192",
    "type": "image/png"
  }],
  "related_applications": [{
    "platform": "play",
    "url": "https://play.google.com/store/apps/details?id=cheeaun.hackerweb"
  }]
}
```

对应的`link`标签如下（来自得到Web版）：
```html
<link rel="manifest" href="/pwa/iget_web.webmanifest">
```

#### Others

其他超链接型`link`标签表示某些和当前文档相关的资源，可以视为一种带链接功能的`meta`标签。

- `rel=“author”`，链接到本页面的作者，一般是 `mailto:`协议；
- `rel=“help”`，链接到本页面的帮助页；
- `rel=“license”`，链接到本页面的版权信息页；
- `rel=“search”`，链接到本页面的搜索页面。

### 外部资源型

外部资源型`link`标签会被浏览器主动下载，并且根据`rel`类型会做出不同处理。

#### icon

当前页面或者站点的icon，是唯一一个外部资源类元信息`link`，浏览器普遍会将icon显示在窗口左上角处。如果没有提供，多数浏览器会使用域名根目录下的`favicon.ico`资源。因此为了性能考虑，务必提供`icon`型`link`标签。

```html
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
<!-- iOS设备需要用apple-touch-icon和apple-touch-startup-image替代 -->
<link rel="apple-touch-icon" href="../pages/igetWeb/assets/images/global/pwa_logo.png">
```
 
#### 预处理类

每一个网页的显示，都要经过DNS解析、建立HTTP连接、传输数据、分词、解析并构建DOM树、合成绘制和渲染，最终将所有数据显示出来。这个流程非常复杂耗时，按照正常的流程下来，经常达不到预期的效果和体验。

预处理类`link`就是为了提高性能，允许我们控制浏览器，提前做一部分工作，或者获取一些资源。
- `dns-prefetch`，提前对一个域名做dns查询。
- `preconnect`，提前对一个服务器建立tcp连接。
- `prefetch`，提前取`href`指定的url的内容。
- `preload`，提前加载`href`指定的url。
- `prerender`，提前渲染`href`指定的url。

比如得到Web版首页：
```html
<link rel="dns-prefetch" href="https://staticcdn.igetget.com">
<link rel="dns-prefetch" href="https://cdn2.luojilab.com">
<link rel="preload" href="https://imgcdn.umiwi.com/ttf/dedaojinkaiw03.ttf" as="font" type="font/ttf" crossorigin="" onload="DeDaoJinKaiOnload()">
```

#### modulepreload

`modulepreload`型`link`的作用是预先加载一个JavaScript的模块。这可以保证JS模块不必等到执行时才加载。这里的所谓加载，是指完成下载并放入内存中，并不会执行对应的JavaScript代码。

例如这个例子，`app.js`模块中包含`helper.js`、`irc.js`和`fog-machine.js`三个模块。为了提高性能，可预先加载这些模块。
```html
<link rel="modulepreload" href="app.js">
<link rel="modulepreload" href="helpers.js">
<link rel="modulepreload" href="irc.js">
<link rel="modulepreload" href="fog-machine.js">
<script type="module" src="app.js">
```

#### stylesheet

这应该是大多数人最熟悉的`link`标签使用方法。它通过引入一个CSS文件创建样式表，如果有type属性，必须为`"text/css"`。

```html
<link rel="stylesheet" href="xxx.css" type="text/css">
```

## a

`a`标签是“anchor”的缩写，表示锚点，用于链接和定位目标点。当`a`有`href`属性时，表示链接，当有`name`属性时表示目标点。

### rel

`a`和`link`的很多属性都是一样的，比如`rel`。两者`rel`相同的类型包括下面这些：
- `alternate`
- `author`
- `help`
- `license`
- `next`
- `prev`
- `search`

对于这些类型的元信息类超链接`link`和普通`a`链接，`rel`的语义都是相同的。

除此之外，还有一些`a`标签独有的`rel`类型：
- `tag`，表示本网页所属的标签；
- `bookmark`，到上级章节的链接。

`a`标签还有一些辅助`rel`类型，用于提示浏览器或搜索引擎做一些处理：
- `nofollow`，此链接不会被搜索引擎索引；
- `noopener`，此链接打开的网页无法使用`opener`来获得当前页面的窗口；
- `noreferrer`，此链接打开的网页无法使用`referrer`来获得当前页面的url；
- `opener`，可以使用`window.opener`来访问当前页面的`window`对象，这是`a`标签的默认行为。

### target

通过target属性指定将在何处显示链接资源，取值可以为是：
- `_self`，默认。在相同的框架中打开被链接文档。
- `_blank`，在新窗口中打开被链接文档。
- `_parent`，在新窗口中打开被链接文档。
- `_top`，在整个窗口中打开被链接文档。
- `name`，在指定的框架中打开被链接文档。

例如下面这段代码：
```html
<h3>Table of Contents</h3>
<ul>
  <li><a href="/example/html/pref.html" target="view_window">Preface</a></li>
  <li><a href="/example/html/chap1.html" target="view_window">Chapter 1</a></li>
  <li><a href="/example/html/chap2.html" target="view_window">Chapter 2</a></li>
  <li><a href="/example/html/chap3.html" target="view_window">Chapter 3</a></li>
</ul>
```

在这种情况下，重复点击不同链接将会打开同一个窗口。

## area

`area`和`a`很相似，唯一不同的是，它不再表示文本型链接，而表示区域性链接。

`area`是整个`html`规则中唯一支持非矩形热区的标签，它的`shape`属性支持三种类型。

- 圆形：`circle`或者`circ`，coords支持三个值，分别表示中心点的x,y坐标和圆形半径r。
- 矩形：`rectangle`或者`rect`，coords支持两个值，分别表示两个对角顶点x1，y1和x2，y2。
- 多边形：`polygon`或者`poly`，coords至少包括6个值，表示多边形的各个顶点。

area一个比较实用的场景是在地图中，点击不同区域可以进入相应的页面：

```html
<img src="http://s2.sinaimg.cn/middle/69906822ga1e24ba6e971&690" width="444" height="395" alt="中国地图" usemap="#province"/>
<map name="province" id="province">
    <area shape="rect" coords="80,112,110,125"  alt="新疆" href="https://baike.baidu.com/item/%E6%96%B0%E7%96%86/132263?fr=aladdin">
    <area shape="rect" coords="77,209,110,229"  alt="西藏" href="https://baike.baidu.com/item/%E8%A5%BF%E8%97%8F/130045">
    <area shape="rect" coords="150,176,185,192"  alt="青海" href="https://baike.baidu.com/item/%E9%9D%92%E6%B5%B7/31638">
    <area shape="rect" coords="197,236,235,261"  alt="四川" href="https://baike.baidu.com/item/%E5%9B%9B%E5%B7%9D/212569">
    <area shape="rect" coords="170,300,211,325"  alt="云南" href="https://baike.baidu.com/item/%E4%BA%91%E5%8D%97/206207">
    <area shape="circle" coords="227,200,8"  alt="甘肃" href="https://baike.baidu.com/item/%E7%94%98%E8%82%83">
    <area shape="circle" coords="240,177,5"  alt="宁夏" href="https://baike.baidu.com/item/%E7%94%98%E8%82%83">
    <area shape="circle" coords="285,133,8"  alt="内蒙古" href="https://baike.baidu.com/item/%E7%94%98%E8%82%83">
</map>
```

# 总结

HTML所有标签中，除过元信息类、语义类和媒体替换类标签之外，还有链接类标签。为什么互联网能够如此繁荣发展，很多程度上就是因为这些起着连接作用的链接，它们让全世界所有能够触网的资源连接在一起，彼此互动，协同进步。

这些链接主要由两类组成：
- `link`：一种不可见的元信息类标签，主要为浏览器和搜索引擎服务。它又可以分为：
  - 超链接类：被动性链接，在用户不主动操作时，并不会下载处理；
  - 外部资源类：比如`icon`型的`link`，还有用于提高性能体验的预处理类`link`，比如`dns-prefetch`、`preload`等。
- `a`：可见链接标签，承担着链接显性资源的主要责任，互联网上多为此种链接。它的很多属性和`link相`似，但是还有一些独特属性。