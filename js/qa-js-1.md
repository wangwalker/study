# 1.`{}`在JavaScript中的用法
### Q：
既然函数是对象，那么在函数对象内部，就应该可以使用键值对添加属性和方法，但实际上并不会有任何效果。
```js
function Person(name, gender) {
    this.name = name;
    this.gender = gender;
    age: 20; // 用键值对添加属性
}
var p = new Person("Walker", "male")
var p = Person {name: "Walker", gender: "male"}
p.age // undefined
```
### A：
JavaScript里，一对花括号`{}`实际上有下面三种作用：
- 可以在函数声明/函数表达式中用于括住函数体。如问题所示；
- 可以是块语句（block statement）用于把若干语句打包为一块，例如用于while、for等控制流语句中；
- 可以是对象字面量（Object Literal；或者叫对象初始化器，Object Initializer）。如问题中强行添加的`age`属性。

实际上，下面这两种写法所生成的AST完全不同。
```js
// 1
function Person(name, gender) {
    this.name = name;
    this.gender = gender;
}
// 2
var person = {
    name : "walker",
    gender: "male"
}
```
```js
// 1 函数的AST
{
  "type": "Program",
  "body": [
    {
      "type": "FunctionDeclaration",
      "id": {
        "type": "Identifier",
        "name": "Person"
      },
      "params": [
        {
          "type": "Identifier",
          "name": "name"
        },
        {
          "type": "Identifier",
          "name": "gender"
        }
      ],
      "body": {
        "type": "BlockStatement",
        "body": [
          {
            "type": "ExpressionStatement",
            "expression": {
              "type": "AssignmentExpression",
              "operator": "=",
              "left": {
                "type": "MemberExpression",
                "computed": false,
                "object": {
                  "type": "ThisExpression"
                },
                "property": {
                  "type": "Identifier",
                  "name": "name"
                }
              },
              "right": {
                "type": "Identifier",
                "name": "name"
              }
            }
          },
          {
            "type": "ExpressionStatement",
            "expression": {
              "type": "AssignmentExpression",
              "operator": "=",
              "left": {
                "type": "MemberExpression",
                "computed": false,
                "object": {
                  "type": "ThisExpression"
                },
                "property": {
                  "type": "Identifier",
                  "name": "gender"
                }
              },
              "right": {
                "type": "Identifier",
                "name": "gender"
              }
            }
          }
        ]
      },
      "generator": false,
      "expression": false,
      "async": false
    }
  ],
  "sourceType": "script"
}
// 2 字面量AST
{
  "type": "Program",
  "body": [
    {
      "type": "VariableDeclaration",
      "declarations": [
        {
          "type": "VariableDeclarator",
          "id": {
            "type": "Identifier",
            "name": "person"
          },
          "init": {
            "type": "ObjectExpression",
            "properties": [
              {
                "type": "Property",
                "key": {
                  "type": "Identifier",
                  "name": "name"
                },
                "computed": false,
                "value": {
                  "type": "Literal",
                  "value": "walker",
                  "raw": "\"walker\""
                },
                "kind": "init",
                "method": false,
                "shorthand": false
              },
              {
                "type": "Property",
                "key": {
                  "type": "Identifier",
                  "name": "gender"
                },
                "computed": false,
                "value": {
                  "type": "Literal",
                  "value": "male",
                  "raw": "\"male\""
                },
                "kind": "init",
                "method": false,
                "shorthand": false
              }
            ]
          }
        }
      ],
      "kind": "var"
    }
  ],
  "sourceType": "script"
}
```
# 2.为什么JavaScript是单线程的？
为什么JavaScript没有选择使用多线程充分利用机器的性能，而是只用单线程呢？

>JavaScript的单线程，与它的用途有关。作为浏览器脚本语言，JavaScript的主要用途是与用户互动，以及操作DOM。这决定了它只能是单线程，否则会带来很复杂的同步问题。比如，假定JavaScript同时有两个线程，一个线程在某个DOM节点上添加内容，另一个线程删除了这个节点，这时浏览器应该以哪个线程为准？
>
>所以，为了避免复杂性，从一诞生，JavaScript就是单线程，这已经成了这门语言的核心特征，将来也不会改变。
>
>为了利用多核CPU的计算能力，HTML5提出Web Worker标准，允许JavaScript脚本创建多个线程，但是子线程完全受主线程控制，且不得操作DOM。所以，这个新标准并没有改变JavaScript单线程的本质。

实际上，跟GUI相关的框架（QT、GTK、MFC、Android、iOS）采用的全是这种模型，所有跟UI相关的操作，就像浏览器中的DOM操作一样，必须在单线程（在很多GUI框架中称为主线程）中执行。因为只有这样，才能保证数据的一致性，才能构架一个稳定可用的系统。