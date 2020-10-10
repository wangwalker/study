在HTML诞生之初，它主要是为超（富）文本服务的，很多规则和启发也来自于出版行业。但是自二十一世纪以来，Web标准和各种Web应用蓬勃发展，网页的功能逐渐从呈现“文本信息”过渡到承载“软件界面和功能”。

文字排版的思路是“改变文字和盒的相对位置，把它放进特定的版面中”，而软件界面的思路则是“改变盒的大小，使得它们的结构保持固定”，因此CSS的正常流布局逐渐满足不了市场需求了。

# Flex弹性布局

2009年，W3C提出Flex布局，可以更加简单、灵活的实现各种页面布局，并且还可以实现响应式变化。

## 原理
### 设计

Flex排版的核心是`display:flex`和`flex`属性，它们配合使用。具有`display:flex`的元素可称为flex容器，它的子元素或者盒被称作flex项。

flex项如果有flex属性，就会根据flex方向代替元素的宽和高，用剩余空间填充子元素尺寸，这就是典型的“根据外部容器决定内部尺寸”的思路。

### 实现

首先，Flex布局支持横向和纵向，这样就需要做一个抽象，我们把Flex延伸的方向称为“主轴”，把跟它垂直的方向称为“交叉轴”。这样，flex项中的`width`和`height`就会称为交叉轴尺寸或者主轴尺寸。

同时，Flex又支持反向排布，这样我们又需要抽象出交叉轴起点、交叉轴终点、主轴起点、主轴终点，它们可能是容器`top`、`left`、`bottom`、`right`。在实际代码中，是用`flex-start`和`flex-end`表示主轴和交叉轴的起点和终点。

另外，Flex布局中有一种特殊的情况，那就是flex容器没有被指定主轴尺寸，这个时候，实际上Flex属性完全没有用了，所有Flex尺寸都可以被当做0来处理，Flex容器的主轴尺寸等于其它所有`flex`项主轴尺寸之和。

上面是Flex布局的实现思想，具体的排版细节可以分为下面三个步骤。

**第一步，把flex项分行。**

有Flex属性的flex项可以暂且认为主轴尺寸为0，所以，它一定可以放进当前行。

接下来把flex项逐个放入行，不允许换行的话，就直接把所有flex项放进同一行。允许换行的话，就先设定主轴剩余空间为Flex容器主轴尺寸，每放入一个flex项就把主轴剩余空间减掉它的主轴尺寸，直到某个flex项放不进去为止，换下一行，重复前面动作。

分行过程中，会顺便对每一行计算两个属性：交叉轴尺寸和主轴剩余空间，交叉轴尺寸是本行所有交叉轴尺寸的最大值，而主轴剩余空间前面已经说过。

**第二步，计算每个flex项的主轴尺寸和位置。**

如果Flex容器是不允许换行的，并且最后主轴尺寸超出了Flex容器，就要做等比缩放。如果Flex容器有多行，那么根据前面的分行算法，必然有主轴剩余空间，这时候，我们要找出本行所有的带Flex属性的flex项，把剩余空间按Flex比例分给它们。

之后，就可以根据主轴排布方向，确定每个flex项的主轴位置坐标了。

如果本行完全没有带flex属性的flex项，`justify-content`机制就要生效了，它的几个不同的值会影响剩余空白如何分配。

**第三步，计算flex项的交叉轴的尺寸和位置。**

交叉轴的计算首先是根据`align-content`计算每一行的位置，这跟`justify-content`类似。再根据`align-items`和flex项的`align-self`来确定每个元素在行内的位置。

计算完主轴和交叉轴，每个flex项的坐标、尺寸就都确定了，这样就完成了整个的flex布局。

## 使用

任何容器都可以指定为flex布局，行内元素也可以用`inline-flex`：
```css
.box {
    display: flex; 
}
```
### 基本概念

在flex弹性布局中，主轴和交叉轴是必须了解的两个概念：

* 主轴（main axis）开始端为main start，结束端为main end
* 交叉轴（cross axis），开始端为cross start，结束端为cross end，

用它们来控制布局内项目之间的依赖、约束关系。

### 容器属性

flex容器一共有6个属性：
* `flex-direction`：决定主轴的方向，水平row，垂直column
* `flex-wrap`：在主轴方向上是否换行显示
* `flex-flow`：`flex-direction`和`flex-wrap`的合并
* `justify-content`：容器内元素在主轴上的对齐方式
* `align-items`：容器内元素在交叉轴上的对齐方式
* `align-content`：有多个轴线时的对齐方式，如果容器内项目只有一根轴线，则不起任何作用

#### flex-direction 

flex-direction决定了主轴方向。可以取的值有：
```css
.box {
  flex-direction: row | row-reverse | column | column-reverse;
}
```
* `row`：默认值，从左到右显示
* `row-revers`e：从右到左显示
* `column`：从上到下显示
* `column-reverse`：从下到上显示

|flex-direction|图示|
|-|-|
|`row`|![row](https://walker-files.oss-cn-beijing.aliyuncs.com/images/study/flex/flex-direction-row.png)|
|`row-reverse`|![row-reverse](https://walker-files.oss-cn-beijing.aliyuncs.com/images/study/flex/flex-direction-row-reverse.png) 
|`column`|![column](https://walker-files.oss-cn-beijing.aliyuncs.com/images/study/flex/flex-direction-column.png) 
|`column-reverse`|![column-reveres](https://walker-files.oss-cn-beijing.aliyuncs.com/images/study/flex/flex-direction-column-reverse.png) 

#### flex-wrap 

如果容器内项目超过了主轴长度，是否要换行显示。

```css
.box {
  flex-wrap: nowrap | wrap | wrap-reverse;
}
```
* `nowrap`; 不换行，默认值，这就意味着会有一些项目会被隐藏掉
* `wrap`; 换行，将超出部分项目显示在下一行
* `wrap-reverse`; 换行，但是将前面的放在下面，后面的放在上面

#### flex-flow 

`flex-direction`和`flex-wrap`的简写形式。

```css
.box {
  flex-flow: row nowrap | column nowrap| row wrap | column wrap | ...;
}
```

#### justify-content 

justify-content决定了flex项在主轴上的对齐方式。取值有：
* `flex-start`：默认值， 主轴开始端对齐，row为左对齐，column为上对齐, ...
* `center`：居中对齐
* `flex-end`：主轴结束端对齐，row为右对齐，column为下对齐，...
* `space-around`：容器内每个项目两边的间隔都相同
* `space-between`：容器内两侧的项目和容器对齐，其他项目与项目之间的间隔相同

```css
.box {
  justify-content: flex-start | center | flex-end | space-around | space-between;
}
```

#### align-items 

flex项在交叉轴上的对齐方式。

```css
.box {
  justify-content: flex-start | center | flex-end | baseline | stretch;
}
```
* `flex-start`：默认值， 交叉轴开始端对齐
* `center`：居中对齐
* `flex-end`：交叉轴结束端对齐
* `baseline`：按项目中第一行文字为基线对齐
* `stretch`：默认值，如果项目未设置高度或设为auto，将占满整个容器的高度

#### align-content 

有多条轴线时，主轴在交叉轴上的对齐方式。

```css
.box {
  justify-content: flex-start | center | flex-end |space-between | space-around | stretch;
}
```
和`justify-content`与`align-items`的对齐方式类似

### 项目属性
容器内项目的属性有6个，当容器大小发生变化时，或者当所有项目的布局无法被满足时，应该如何进行调整。
* `order`; 排列顺序，整数值，值越小越靠前
* `flex-grow`; 当还有多余空间是，如何分配。number类，值越大，被分配的多余空间越大
* `flex-shrink`; 容器尺寸不足时，如何缩小。number类，值越大，被压缩的空间越大
* `flex-basic`; 原始空间大小：auto表示本身大小，也可以用number指定
* `flex`; 上面三者的简写。两个快捷值：
    - `auto`（1 1 auto)：表示按等比例缩放
    - `none`（0 0 auto）：表示不进行任何缩放操作
* `align-self`; 独自对齐方式。可选项有：
    - `flex-start`; 
    - `center`; 
    - `flex-end`; 
    - `baseline`; 
    - `stretch`;

详细讲解见[阮一峰老师博客文章](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html)。

## 经典布局

在没有flex布局的年代里，CSS三大经典问题：垂直居中问题，两列等高问题，自适应宽，这三个问题一直是前端工程师们躲不开的难题。好在人民群众的力量是无限的，想出了各种“黑科技”解决了这些问题，比如著名的table布局、负margin、float与clear等等。

下面，我们就用flex布局解决这些问题。说实话，现在实在太简单了。

### 垂直居中

```html
<!DOCTYPE html>
<head>
  <style>
    #parent {
      display:flex;
      width:300px;
      height:300px;
      outline:solid 1px;
      justify-content:center;
      align-content:center;
      align-items:center;
    }
    #child {
      width:100px;
      height:100px;
      outline:solid 1px;
    }
  </style>
</head>
<body>
  <div id="parent">
  <div id="child">
  </div>
</div>
</body>
```

### 两列等高

```html
<!DOCTYPE html>
<head>
  <style>
    .parent {
      display:flex;
      width:300px;
      justify-content:center;
      align-content:center;
      align-items:stretch;
    }
    .child {
      width:100px;
      outline:solid 1px;
    }
  </style>
</head>
<body>
  <div class="parent">
    <div class="child" style="height:300px;">
    </div>
    <div class="child">
    </div>
  </div>
</body>
```

### 自适应宽

```html
<!DOCTYPE html>
<head>
  <style>
    .parent {
      display:flex;
      width:300px;
      height:200px;
      background-color:pink;
    }
    .child1 {
      width:100px;
      background-color:lightblue;
    }
    .child2 {
      width:100px;
      flex:1;
      outline:solid 1px;
    }
  </style>
</head>
<body>
  <div class="parent">
    <div class="child1">
    </div>
    <div class="child2">
    </div>
  </div>
</body>
```

# 总结

Flex弹性布局的出现是为了满足软件界面和功能不断丰富、复杂的市场需求，它的核心诉求是子元素的尺寸要能够动态响应父元素尺寸变化，并保持一定的结构特征。

在实现原理上，为了满足灵活多变的布局方式，flex布局引入一组非常重要的概念：
- 主轴(main axis)：flex项延伸的方向，决定着下一个flex项的排列位置；
- 交叉轴(cross axis)：和主轴垂直的方向，决定着主轴遇见换行情景时的具体行为细节。

对flex容器来说，整个布局工作可分为三步：
- 第一步：所有flex项按照自身尺寸和主轴尺寸进行分行。简单来说，当主轴空间容纳不下flex项时，进行分行；
- 第二步：根据上一步所得的分行信息，和每一行上flex项特征，计算本行所有flex项的主轴尺寸和布局信息；
- 第三步：通过`align-content`、`align-items`和`align-self`三个属性计算所有flex项在交叉轴上的尺寸和布局信息。

它总共有以下6个属性：
- `flex-direction`：定义了主轴方向；
- `flex-wrap`：定义了主轴如何换行；
- `flex-flow`：前两个属性的简写；
- `justify-content`：定义flex项在主轴上的对齐方式；
- `align-items`：定义flex项在交叉轴上的对齐方式；
- `align-content`：当有多条主轴时，定义了它们的对齐方式。

另外，对于每一个flex项，也有对应的属性定义不同行为特征。

总的来说，flex布局的出现让形式丰富多样的网页布局成为可能，一方面解放了工程师们的创造力，另一方面满足了要求越来越多、越来越复杂的市场需求。