来自Stack Overflow上的，关于JavaScript的一些最常被问的问题。

# Index

1. 数组去重
2. 多行字符串

## 1. 数组去重
```js
let names = ["Mike","Matt","Nancy","Adam","Jenny","Nancy","Carl"];

let uniqueNames = [...new Set(names)];
// or more native way
uniqueNames = names.filter(function(item, pos) {
    return names.indexOf(item) == pos;
})
```

## 2. 创建多行字符串

在ES6以及之后的版本中，可用字符串模板创建。
```js
var html = `
  <div>
    <span>Some HTML here</span>
  </div>
`;
```
在之前的版本中，可以通过在行位添加`\n`来创建。
```js
var string = 'This is\n' +
'a multiline\n' + 
'string';
```