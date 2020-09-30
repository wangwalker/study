词法是每一门编程语言的不可或缺的一部分，它和语法、语义一起完整构成了一门语言，它主要规定了语言的合法用词规则。在编译原理汇总，和词法相关的工作是词法分析，是指通过状态机或者正则表达式将输入的字符序列转换成最小单元——标记（token）的过程。

# 概述

在JavaScript中，可以将源代码分为这几类：
- WhiteSpace，空白字符
- LineTerminator，换行符
- Comment，注释
- Token，词
    - IdentifierName，标识符名称，包括关键字和变量名
    - Punctuator，符号，包括运算符和大括号
    - NumericLiteral，数字直接量
    - StringLiteral，字符直接量
    - Template，字符串模板

这些是所有编程语言比较通用的部分。不过，JavaScript还有一些比较特殊之处。

# 特殊规则
## 除法和正则表达式

我们都知道，JavaScript不但支持除法运算符“` / `”和“` /= `”，还支持用斜杠括起来的正则表达式“` /abc/ `”。这就发生了冲突。

另外，JavaScript词法的另一个特别之处是字符串模板，模板语法大概是这样的：

```js
`Hello, ${name}`
```

理论上，` ${} `内部可以放任何JavaScript代码，而这些代码是以` } `结尾的，也就是说，这部分词法不允许出现` } `运算符。

这些都是编译器无法处理的情况。为了解决这些问题，JavaScript又定义了四种规则，来分辨不同语境下的词法。

|Context|除法|正则表达式|
|-|-|-|
|允许 "`}`"|InputElementDiv|InputElementRegExp|
|不允许 "`}`"|InputElementTemplateTail|InputElementRegExpOrTemplateTail|

更进一步，标准还不得不把除法、正则表达式直接量和”` } `”从经过词法分析之后得来的Token序列中抽出来。同时，把原本的Token改为Common Token。

## 空白符 WhiteSpace

在JavaScript中，支持的空白符有：

- `<HT>`[U+0009]，也叫TAB，是字符串中的` \t `;
- `<VT>`[U+000B]，垂直方向上的TAB键` \v `，很少用到；
- `<FF>`[U+000C]，Form Feed，分页符，是字符串中的` \f `；
- `<SP>`[U+0020]，最普通的空格；
- `<NBSP>`[U+00A0]，非断行空格（NO-Break Space），是`<SP>`的变体，HTML中常用的` nbsp `就是它；
- `<ZWNBSP>`[U+FEFF]，ES5新加入的空白符，是Unicode中的零宽非断行空格；

## 换行符 LineTerminator

JavaScript只提供了四种换行符：

- `<LF>`[U+000A]，最正常的换行符，字符串中的` \n `;
- `<CR>`[U+000D]，真正意义上的回车，字符串中的` \r `，在一些Windows编辑器中为` \r\n `;
- `<LS>`[U+2028]，Unicode中的行分隔符；
- `<PS>`[U+2029]，Unicode中的段分隔符；

大部分LineTerminator在被词法分析器扫码出来之后，会被语法分析器抛弃，但是换行符会影响JavaScript的两个重要语法特性：**自动加入分号“；”和“NO Line Terminator”规则**。

# 一般规则
## 标识符名称 IdentifierName

IdentifierName可以以美元符`$`下划线`_`或者Unicode字母开始，除了开始字符以外，IdentifierName中还可以使用Unicode中的连接标记、数字、以及连接符号。

IdentifierName可以是Identifier、NullLiteral、BooleanLiteral或者keyword，在ObjectLiteral中，IdentifierName还可以被直接当做属性名称使用。

JavaScript中的关键字有：

```js
await break case catch class const continue debugger default delete do else export extends finally for function if import ininstance of new return super switch this throw try typeof var void while with yield
```

除此之外，还有1个为未来使用而保留的关键字：` enum `。

在严格模式下，有一些额外为未来使用而保留的关键字：

```js
implements package protected interface private public
```

## 符号 Punctuator

所有符号包含：
```js
{ ( ) [ ] . ... ; , < > <= >= == != === !== + - * % ** ++ -- << >> >>> & | ^ ! ~ && || ? : = += -= *= %= **= <<= >>= >>>= &= |= ^= => / /= }
```

## 数字直接量 NumericLiteral

avaScript规范中规定的数字直接量可以支持四种写法：十进制数、二进制整数、八进制整数和十六进制整数。

十进制的Number可以带小数，小数点前后部分都可以省略，但是不能同时省略，我们看几个例子：

```js
.1
10.
12.12
```

这些都是合法的数字直接量。但同时，又会出现一些特殊问题，比如：

```js
12.toString()
```

12之后的“ `.` ”就有了歧义，编译器不知道到底该如何处理。因为“ `.` ”既可以作为数字直接量的小数点，也可以作为装箱造作的点运算符。于是，为了编译器能够识别这种写法，就需要加入一个空格或者再加一个“` . `":

```js
12 .toString()
12..toString()
```

另外，可支持科学计数法，或` 0x `16进制，` 0b `二进制` 0o `八进制。

## 字符串直接量 StringLiteral

分为两种，单引号和双引号。

```js
' Single Quotation String Characters '
" Double Quotation String Characters "
```

单引号内可以出现双引号，双引号内可以出现单引号，均支持单斜杠“ `\` ”转义。

## 正则表达式直接量 RegularExpressionLiteral

正则表达式由Body和Flags两部分组成，例如：

```js
/RegularExpressionBody/g

/[/]/.test("/");
```

Body部分至少需要一个字符，而且不能为“` * `”。而且，并非机械地见到“` / `”就停止，在正则表达式[ ]中的“` / `”就会被认为是普通字符，如上面的例子。

## 字符串模板 Template

一个字符串模板会被JavaScript拆成多个部分，比如：

```js
`a${b}c${d}e`
```

这段字符串模板，会被JavaScript认为是这样的：

```js
`a${
b
}c${
d
}e`
```

对应的，被拆成5个部分：
- \``a${`，模板头
- `}c${`，模板中段
- `}e\`\`，模板尾
- `b d`，普通标识符

# 总结

了解词法规则是学习一门语言的第一步。JavaScript的词法规则有和其他语言相似的部分，也有和其他语言不同的部分。

具体而言，JavaScript的词法规则包括了空白符号、换行符、注释、标识符名称、符号、数字直接量、字符串直接量、正则表达式直接量、字符串模板。