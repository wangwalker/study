# 新特性

### 泛型

##### 语法

**泛型是对类型的编程**。如果某个类、方法可适用于多个类型，这时候用泛型可有效提高编程效率。**在一个优秀的强类型编程语言中，泛型是必不可少的基础设施**。比如C++、Java、Swift等。

在泛型编程中，泛型只是一个占位符，用任何非保留关键字都可以，但选择合适的关键字能够让代码具有较好的可读性，比如在Swift中常见的`T`、`Element`、`Key`、`Value`，它们都能很好的解释自己的功能。

泛型的语法是在函数名、类名（包括struct、enum）后加上`<T>`即可。

```swift
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}
```

下面定义一个支持泛型的栈。用`where`关键字可以添加限制，比如要遵从`CustomStringConvertible`协议。

```swift
public struct Stack<Element> where Element: CustomStringConvertible {
    private var items: [Element] = []
    public mutating func push(_ item: Element) {
        items.append(item)
    }
    public mutating func pop() -> Element {
        return items.removeLast()
    }
}
extension Stack {
    var topItem: Element? { items.first }
    var count: Int {
        return items.count
    }
}
```

##### 协议

注意📢，协议`protocol`并不支持泛型语法，但是可以用`associatedtype Item`语法定义关联类型，算是泛型在协议中的特殊语法。在协议中使用关联类型之后，Swift的类型推断器会识别出具体的类型，当然你也可以明确的指出来。

```swift
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
struct IntStack: Container {
    // original IntStack implementation
    var items: [Int] = []
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    // 下面这句写不写都可以。
    // 如果不写，Swift的type inference会识别出此处的具体类型信息
    typealias Item = Int
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}
```

除此之外，还可以给关联类型添加限制条件，比如要遵从某种协议。并且还支持更加复杂的限制条件，详细见：[Swift doc](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID192)

```swift
protocol Container {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
```

##### 不透明类型

顾名思义，不透明类型就是让你看不清类型信息的全貌，只能看见隐隐约约地看见一部分。**不透明类型只用在函数、方法的返回值类型上**。

> You can think of an opaque type like being the reverse of a generic type. 

泛型可以让函数、方法、类等以抽象化的方式指定输入参数和返回值的类型，但不透明类型只是让函数、方法的返回值类型以抽象化的方式指定。

语法上用关键字`some`修饰返回值的类型，表示某一种特定的类型，通常是协议名。需要特别注意的是，如果函数、方法有多种返回值可能性，那么这所有可能的返回值的类型必须一直，否则编译器会报错。

```swift
func invalidFlip<T: Shape>(_ shape: T) -> some Shape {
    if shape is Square {
        return shape // Error: return types don't match
    }
    return FlippedShape(shape: shape) // Error: return types don't match
}
```

那么，**协议和不透明类型之间的区别是什么**？

答案是，当返回值类型是协议时，会让代码更加灵活，只要遵从此协议即可，即使有多种可能性，而且每种可能性都是目标协议的子协议，也可以。但不透明类型会保证只返回一种特定类型，也就是说，不透明类型的限制层次更高一点。

