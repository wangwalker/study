HTML标签可以分为很多种，比如：
- 文档元信息类；
- 语义类；
- 媒体替换类；
- 链接类等等。

虽然这部分知识看起来简单，没有什么深奥的东西，但是却非常多，因此只能是”入门简单，精通困难“。

# 语义类标签

所有语言都是由各种不同的符号组成的。但是，这些符号本身并没有任何含义，只有在被赋予一定含义之后才能被使用，这时候符号才有了一定信息，对语言来说，就是语义。

>语义是我们说话表达的意思，多数的语义实际上都是由文字来承载的。语义类标签则是纯文字的补充，比如标题、自然段、章节、列表，这些内容都是纯文字无法表达的，我们需要依靠语义标签代为表达。

语义类标签主要承载着解释的功能，它们的视觉表现基本相同，主要是为了增加代码的可读性，不但可以让人读懂，也为了让机器知道其所表达的含义。比如：
- nav，表示导航相关信息；
- section，表示逻辑分区、分组等；
- article、header、footer等表示文档结构信息。

但是，在现代互联网产品中，HTML用于**描述软件界面多过于富文本**。

而在软件界面里，实际上几乎是没有语义的，因为软件界面面对的是用户，他们只对视觉表现感兴趣，通过良好的视觉表现人们可以理解软件界面对表达的含义。比如在购物车中，每个商品就一定得用`ul`包起来吗？其实不然，经过精心设计的`div`和`span`是完全可以胜任的。

**不过，在很多场景，语义类标签有着无可替代的优点**
- 语义类标签对开发者更为友好，使用语义类标签增强了可读性，即便是在没有CSS的时候，开发者也能够清晰地看出网页的结构，也更为便于团队的开发和维护。
- 除了对人类友好之外，语义类标签也十分适宜机器阅读。它的文字表现力丰富，更适合搜索引擎检索（SEO），也可以让搜索引擎爬虫更好地获取到更多有效信息，有效提升网页的搜索量，并且语义类还可以支持读屏软件，根据文章可以自动生成目录等等。

然而，无论在什么时候，对于“度”的把握都是一件不那么容易的事。有时候，还是会或多或少地用错一些标签，比如对`ul`不加节制的使用。如果对所有并列关系都得用上`ul`标签，那么会造成大量标签冗余，这会对机器阅读造成混淆，并给CSS编写增加负担。

## 自然语言类

### ruby
>语义标签的使用的第一个场景，也是最自然的使用场景，就是：作为自然语言和纯文本的补充，用来表达一定的结构或者消除歧义。

看这两张图片：

![语义1](./images/html-ruby-1.png)

![语义2](./images/html-ruby-2.jpg)

面对这种场景，用各种注释都达不到目的。因此在HTML5中，加入了`ruby`这样的标签，它由ruby、rt、rp三个标签来实现。

### em strong
比较下面几句话，感受其中的意思。

```
今天我吃了一个苹果。

昨天我吃了一个香蕉。
今天我吃了一个苹果。

昨天我吃了两个苹果。
今天我吃了一个苹果。
````
试着读一读，就会知道强调的是哪部分信息，有时候是**数量**的多少，而有时候是到**名称**。`em`就是用来强调语气的语义类标签。

而`strong`是在视觉表现上加强。所以，它和`strong`有着天壤之别。

## 结构类

### hgroup h1~h6 section

好的文章都是有结构的，比如中国古代小说中的”章-回“，西方戏剧中的”幕“。

在HTML中，同样也需要文章(档)结构类标签，比如`h`，`hgroup`，`header`等等，来表示文章的结构。对机器而言，这些标签会帮助生成一个树形结构目录，由各级标题组成。但是，这个结构和HTML的嵌套关系会有一定差异。

h1-h6是最基本的标题，它们表示了文章中不同层级的标题。有些时候，我们会有副标题，为了避免副标题产生额外的一个层级，我们使用hgroup标签。

从HTML 5开始，有了`section`标签，这个标签可不仅仅是一个**有语义的div**，它会改变`h1`-`h6`的语义。`section`的嵌套会使得其中的`h1`-`h6`下降一级，因此，在HTML5以后，我们只需要`section`和`h1`就足以形成文档的树形结构：
```HTML
<section>
    <h1>HTML语义</h1>
    <p>balah balah balah balah</p>
    <section>
        <h1>弱语义</h1>
        <p>balah balah</p>
    </section>
    <section>
        <h1>结构性元素</h1>
        <p>balah balah</p> 
    </section>
......
</section>
```
这段代码同样会形成前面例子的标题结构：
- HTML语义
    - 弱语义
    - 结构性元素
    - ……

### header aside footer article

随着越来越多的浏览器推出“阅读模式”，以及各种非浏览器终端的出现，语义化的HTML适合机器阅读的特性变得越来越重要。

应用了语义化结构的页面，可以明确地提示出页面信息的主次关系，它能让浏览器很好地支持“阅读视图功能”，还可以让搜索引擎的命中率提升，同时，它也对视障用户的读屏软件更友好。
```HTML
<body>
    <header>
        <nav>
            ……
        </nav>
    </header>
    <aside>
        <nav>
            ……
        </nav>
    </aside>
    <section>……</section>
    <section>……</section>
    <section>……</section>
    <footer>
        <address>……</address>
    </footer>
</body>
```
在这个结构中，section还可以和header、aside、footer进行深层次嵌套。除此之外，还可以使用article，表示一篇具有独立性质的文章，它和body比较相似。

一个典型的场景是多篇新闻展示在同一个新闻专题页面中，这种类似报纸的多文章结构适合用article来组织。

```HTML
<body>
    <header>……</header>
    <article>
        <header>……</header>
        <section>……</section>
        <section>……</section>
        <section>……</section>
        <footer>……</footer>
    </article>
    <article>
        ……
    </article>
    <article>
        ……
    </article>
    <footer>
        <address></address>
    </footer>
</body>
```
在这个结构中，出现的标签：
- header，如其名，通常出现在首部，表示导航或者介绍性的内容；
- footer，通常出现在尾部，包含一些作者信息、相关链接、版权信息等；
- header和footer通常是body和article的直接子元素；
- aside，表示跟文章主体不那么相关的部分，它可能包含导航、广告等工具性质的内容；
- address，经常被误用，真正表示的是文章（作者）的联系方式，而非给机器阅读的地址。

## 富文本类

### abbr dfn 

`abbr`表示缩写，例如WWW是World Wide Web的缩写，就该用下面的代码表示
```html
<abbr title="World Wide Web">WWW</abbr>.
```

`dfn`表示定义一个名词，在视觉表现上会按斜体显示，例如分别定义了Internet和World Wide Web，就应该这么使用
```html
The terms Internet and World Wide Web are often used without much distinction. However, the two are not the same. 
The <dfn>Internet</dfn> is a global system of interconnected computer networks.
In contrast, the <dfn>World Wide Web</dfn> is a global collection of documents and other resources, linked by hyperlinks and URIs. 
```

### figure figcaption

`figure`表示和文章相关的图表、图像、照片等流内容。里面可以和`img`、`p`等标签配合使用。
`figcaption`表示图表图像的标题。

```html
<figure style="float: right;">
    <img src="http://static001.geekbang.org/static/time/quote/World%20Wide%20Web%20-%20Wikipedia_files/300px-Web_Index.svg.png"/>
    <figcaption>The NeXT Computer used by Tim Berners-Lee at CERN.</figcaption>
</figure>
```
其真实的显示效果如下：

![caption](./images/caption.png)

### blockquote q cite

这三个标签都是和引述相关的。
- blockquote，表示段落级引述内容；
- q，表示行内的引述内容；
- cite，表示引述的作品名。

### pre samp code

这三个标签都表示按照特定格式进行排版，而不希望浏览器做过多的处理。
- pre，表示这部分内容是预先排版过的，不需要浏览器进行排版；
- samp，用来定义计算机程序的样本文本；
- code，表示代码。

```html
<pre><samp>
GET /home.html HTTP/1.1
Host: www.example.org
</samp></pre>
```

### 其他

|  标 签  |  含 义  |
| --- | --- |
| `small` | 之前表示字体缩小(已废弃)，HTML5表示补充评论。 |
| `s` | 之前表示划线(已废弃)，HTML5表示错误的内容，经常用于电商领域的打折价格。 |
| `i` | 之前表示斜体(已废弃)，HTML5表示读的时候变调。 |
| `b `| 之前表示黑体(已废弃)，HTML5表示关键字。 |
| `u `| 之前表示下划线，HTML5表示避免歧义的注解。 |
| `time` | 表示日期时间信息，为了让机器阅读更加方便。|
| `data` | 跟time类似，表示给机器阅读的内容，可自由定义。|
| `var` | 变量，多用于计算机和数学领域。 |
| `sub`/`sup` | 上下标，多用于科学领域。|
| `mark` | 表示高亮，常用在笔记中，让内容更加醒目。|
| | |