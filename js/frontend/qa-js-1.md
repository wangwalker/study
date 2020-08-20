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
// 1
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

```