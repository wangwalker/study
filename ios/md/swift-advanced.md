# 函数

在Swift中，函数是一等公民。也就是说，**函数可以像其他变量一样作为对象的属性，函数的参数、返回值一样被传递**。比如，用在函数式编程的相关高阶函数中。

### 返回值类型

##### 无返回值

在每一个函数中，都要指定参数的类型，同时也要指定返回值的类型。如果没有返回值，用`Void`指定，也可以和`->`符号一同省略。

```swift
func greet() -> Void {
    print("Hello")
}
func greet(to name: String) {
    print("Hello, \(name)")
}
greet()
greet(to: "World")
```

##### 多返回值

为了让函数返回多个值作为一个复合的返回值，可以使用元组类型作为返回类型。

```swift
func minMax(arr: [Int]) -> (Int, Int) {
    return (arr.min() ?? 0, arr.max() ?? 0)
}
minMax(arr: [1,3,5])
```

##### 可选项返回值

如果函数可能返回`nil`，那么需要在函数的返回值类型后面加上`?`，表示是可选项。

```swift
func min(arr: [Int]) -> Int? {
    if arr.count == 0 {
        return nil
    }
    return arr.min()
}
```

### 参数

##### 形参、实参

如果Objective-C，Swift中的函数需要指定两个参数标签：

- **实参标签**，用在函数调用的时候，对外使用，放在前面
- **形参标签**，用在函数的实现中，对内使用，放在后面

**默认情况下，形式参数使用它们的形式参数名作为实际参数标签**。所有的形式参数必须有唯一的名字。尽管有可能多个形式参数拥有相同的实际参数标签，唯一的实参数标签有助于让代码的可读性更强。

如果函数的形式参数不想使用实际参数标签，可以用下划线 `_` 忽略。

```swift
/// Returns the distance between two indices.
///
/// - Parameters:
///   - start: A valid index of the collection.
///   - end: Another valid index of the collection. If `end` is equal to
///     `start`, the result is zero.
/// - Returns: The distance between `start` and `end`.
@inlinable public func distance(from start: Int, to end: Int) -> Int
@inlinable public func index(_ i: Int, offsetBy distance: Int) -> Int
```

##### 默认形式参数

可以在形式参数类型后，给形式参数赋一个初始值，来给函数的任意形式参数定义一个默认值。如果定义了默认值，可以在调用函数时省略这个形式参数。

##### 可变形式参数

可变形式参数接受零或者多个特定类型的值。通过在形式参数的类型名称后，插入三个点符号 `...` 来定义可变形式参数。

```swift
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for n in numbers {
        total += n
    }
    return total / Double(numbers.count)
}
```

##### 输入输出形式参数

如果函数能够修改某个形式参数的值，而且要这些改变在函数调用结束之后依然生效，那么就需要用 `inout` 关键字修饰。在实际调用函数时，在变量之前加上 `&` 符号。输入输出形式参数类似于C语言中的指针。

注意📢：输入输出形式参数不能有默认值。

```swift
func swapByBit(a: inout Int, b: inout Int) {
    a = a ^ b
    b = a ^ b
    a = a ^ b
}
var a = 1
var b = 2
swapByBit(a: &a, b: &b)
```

### 函数类型

每一个函数都有一个特定的函数类型，它**由形式参数类型和返回类型组成**。

```swift
func computeBitOnes(n: Int) -> Int {
    var tmp = n
    var count = 0
    while tmp > 0 {
        count += tmp & 1
        tmp = tmp >> 1
    }
    return count
}
```

比如上面的函数的类型是 `Int -> Int` 。**在Swift中，可以像使用其他类型一样使用函数类型**。例如，可以给一个常量或变量定义一个函数类型，并且为变量指定一个相应的函数。实际上，这就是函数作为一等公民的体现。

```swift
var someFunc: (Int) -> Int = computeBitOnes
```

函数有类型之后，就和其他数据类型对齐了，也就意味着函数可以作为参数和返回值用在其他函数中了。

```swift
func addTwoInt(_ a: Int, _ b: Int) -> Int {
    a + b
}
func compute(with otherFunc: (Int, Int) -> Int, a: Int, b: Int) -> Int {
    return otherFunc(a, b)
}
func increase(_ a: Int) -> Int {
    return a + 1
}
func decrease(_ a: Int) -> Int {
    return a - 1
}
func chooseAction(a: Int) -> (Int) -> Int {
    return a > 0 ? increase : decrease
}
compute(with: addTwoInt, a: 1, b: 2)	// 3
chooseAction(a: 10)(100)							// 101
```

### 内嵌函数

Swift支持在函数的内部定义另外一个函数。然而，Objective-C并不支持内嵌函数。例如，上面的例子可以改成这样。

```swift
func chooseAction(a: Int) -> (Int) -> Int {
    func increase(_ a: Int) -> Int {
        return a + 1
    }
    func decrease(_ a: Int) -> Int {
        return a - 1
    }
    return a > 0 ? increase : decrease
}
```

# 闭包

闭包几乎是所有现代编程语言都会支持的一个重要特性，比如Objective-C中的block就是闭包，JavaScript中的函数本身就支持闭包等。

**函数和闭包都是能够实现特定功能的代码块**，闭包的引入会大大增加语言的表达能力。函数和闭包之间最大的**区别在于，闭包能够捕获和存储当前上下文中的变量和常量的引用**。Swift会自动对这些引用变量或常量进行内存管理。

闭包有三种形式：

- ① 全局函数是一个有名字但不会捕获任何值的闭包
- ② 内嵌函数是一个有名字且能从其上层函数捕获值的闭包
- ③ 闭包表达式是一个轻量级语法所写的，可以捕获其上下文中常量或变量值的匿名闭包

### 闭包表达式

闭包表达式是一种在简短行内就能写完闭包的语法。

##### 语法

**闭包表达式语法能够使用常量形式参数、变量形式参数和输入输出形式参数，但不能提供默认值。可变形式参数也能使用，但需要在形式参数列表的最后面使用。元组也可被用来作为形式参数和返回类型**。

```swift
{(parameter) -> (return type) in 
	statement
}
```

##### 实例

Swift 的标准库提供了一个叫做 `sorted(by:) ` 的方法，会根据提供的排序闭包将已知类型的数组进行排序。一旦它排序完成， `sorted(by:) ` 方法会返回与原数组类型大小相同的一个新数组，该数组的元素是已排序好的。原始数组不会被 sorted(by:) 方法修改。

```swift
let names = ["Jack", "Tom", "John", "Walker", "Steve"]
func backwards(_ a: String, _ b: String) -> Bool {
    return a > b
}
var reversedNames: [String]

reversedNames = names.sorted(by: backwards)
// 闭包表达式
reversedNames = names.sorted(by: {(s1: String, s2: String) -> Bool in
    return s1 > s2
})
// 从语境中推断类型
reversedNames = names.sorted(by: {(s1, s2) -> Bool in return s1 > s2})
// 在单表达式闭包中隐式返回
reversedNames = names.sorted(by: {(s1, s2) -> Bool in s1 > s2})
// 简写参数名，用$0 $1 $2引用闭包的实际参数值
reversedNames = names.sorted(by: {$0 > $1})
// 甚至还可以用运算符函数
reversedNames = names.sorted(by: >)
```

##### 尾随闭包

如果需要将一个很长的闭包表达式作为函数最后一个实际参数传递给函数，那么可以使用尾随闭包来**增强函数的可读性**。尾随闭包是一个被书写在函数形式参数的括号外面（后面）的闭包表达式。

```swift
reversedNames = names.sorted {(s1, s2) -> Bool in s1 > s2}
// or
reversedNames = names.sorted { $0 > $1}
```

> **联想到尾递归**
>
> 递归，自身对自身的调用，是一种可读性很强、逻辑清晰，但效率不高的程序设计方法。因为每调用一次函数都会消耗栈空间，所以调用的次数越多，栈空间消耗的越快。如果在递归算法中忘记边界条件，那么随着函数被调用的次数增多，程序奔溃是迟早的事。**尾递归是对递归的一种优化**，通过将函数自身的调用放在函数的最后面，这样在本次调用要结束时再次调用自己，能够有效缓解对栈空间的快速消耗。

### 捕获值

闭包能够从上下文捕获已被定义的常量和变量。即使定义这些常量和变量的原作用域已经不存在，闭包仍能够在其函数体内引用和修改这些值。**作为一种优化，如果某个值没有改变或者在闭包的外面，Swift 可能会使用这个值的拷贝而不是捕获**。

另外，在 Swift 中，**函数和闭包都是引用类型**。所以，无论什么时候赋值一个函数或者闭包给常量或者变量，实际上都是将常量和变量设置为对函数和闭包的引用。

```swift
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
let increaseByThree = makeIncrementer(forIncrement: 3)
increaseByThree()		// 3
increaseByThree()		// 6
let increaseByTen = makeIncrementer(forIncrement: 10)
increaseByTen()			// 10
increaseByTen()			// 20
increaseByTen()			// 30
let anotherIncTen = increaseByTen
anotherIncTen()			// 40
```

既然闭包是引用类型，那么如果某个对象将闭包作为属性，同时在此闭包内有会引用它自己，那么就会造成循环引用。解决方法是使用 `weak` 或 `unowned` 关键字修饰属性。

### 逃逸闭包

**当闭包作为实际参数传递给某个函数时，而且它会在函数返回之后才被调用，就说这个闭包逃逸了**。当声明一个接受闭包作为形式参数的函数时，可以在形式参数前写 `@escaping` 来明确闭包是允许逃逸的。

闭包可以逃逸的一种方法是被储存在定义于函数外的变量里。比如，很多函数接收闭包作为异步任务的回调。函数在启动任务后返回，但是闭包要直到任务完成——闭包需要逃逸，以便于稍后调用。

```swift
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
```

让闭包 `@escaping` 意味着必须在闭包中显式引用 `self`。

```swift
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
func someFunctionWithNonEscapingClosure(completion: () -> Void) {
    completion()
}
class EscapingClass {
    var p: Int = 0
    func doSth() {
        someFunctionWithEscapingClosure { self.p = 10 }
        someFunctionWithNonEscapingClosure { p = 20 }
    }
}
let p = EscapingClass()
p.doSth()
```

### 自动闭包

自动闭包能够自动把实际参数包装成一个闭包。为什么会存在这种闭包？这是因为在很多闭包中，在闭包符号 `{}` 中只有简单的表达式语句，看起来非常累赘。这时候用 `@autoclosure` 关键字可以简化语法，提高代码的可读性。

```swift
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
// 常规写法
func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } )
// 自动闭包写法
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
// 实际参数中可以去掉{}
serve(customer: customersInLine.remove(at: 0))
```

# OOP

虽然Swift被称为面向协议的语言，但实际上它对面向对象的支持也是非常到位的。

在Swift中，面向对象编程的基本单元除过最基本的类之外，还有枚举、结构体、扩展。从整体的功能上看，枚举、结构体和类具有完全平等的地位，它们都能够定义属性、方法、构造器、下标、嵌套类型等。最大的区别在于，**枚举和结构体是值类型**，**类是引用类型**。

> Types in Swift fall into one of two categories: first, “value types”, where each instance keeps a unique copy of its data, usually defined as a struct, enum, or tuple. The second, “reference types”, where instances share a single copy of the data, and the type is usually defined as a class. 
>
> ### What’s the Difference? 
>
> The most basic distinguishing feature of a *value type* is that copying — the effect of assignment, initialization, and argument passing — creates an *independent instance* with its own unique copy of its data:
>
> ```swift
> // Value type example
> struct S { var data: Int = -1 }
> var a = S()
> var b = a						// a is copied to b
> a.data = 42						// Changes a, not b
> println("\(a.data), \(b.data)")	// prints "42, -1"
> ```
>
> Copying a reference, on the other hand, implicitly creates a shared instance. After a copy, two variables then refer to a single instance of the data, so modifying data in the second variable also affects the original, e.g.:
>
> ```swift
> // Reference type example
> class C { var data: Int = -1 }
> var x = C()
> var y = x						// x is copied to y
> x.data = 42						// changes the instance referred to by x (and y)
> println("\(x.data), \(y.data)")	// prints "42, 42"
> ```

**值类型变量都拥有一份完全独立的数据副本，即使变量值完全相等；引用类型让多个变量共享一块内存，一个改变，全部可见**。值类型和引用类型的区别主要体现在复制操作上。

为什么要分成值类型和引用类型？主要为了数据操作的安全性，尤其在多线程环境中。如果数据总是独立且不可变的，程序的其他部分不会修改数据，那么在多线程环境中，将会减少很多麻烦。

更多说明见：[developer.apple.com](https://developer.apple.com/swift/blog/?id=10)

### 结构体

除过结构体 `struct` 是值类型，它和类 `class` 之间的区别还有：

| 对比   | 结构体                               | 类                                                   |
| ------ | ------------------------------------ | ---------------------------------------------------- |
| 类型   | 值类型                               | 引用类型                                             |
| 继承   | 只能继承协议，不能继承其他结构体     | 既可以继承协议，还能够继承其他类                     |
| 内省   | 不能通过`is`和`as`检查类型           | 可以通过`is`和`as`检查类型并转换                     |
| 初始化 | 只能提供初始化方法，不能提供`deinit` | 既可提供 `init` 方法，还可以提供反初始化方法`deinit` |

```swift
struct Coordinate {
    var x: Float = 0
    var y: Float = 0
    
    init(axis: Int, distance: Float) {
        if axis == 0 {
            x = distance
        } else {
            y = distance
        }
    }
    deinit {
       	// error
    }
}
```

在类似结构体的值类型中，不能在内部使用自己作为某个存储属性的类型。比如链表或树种的节点这种数据类型，就不能用 `struct` 定义。

```swift
struct Node<T> {
  var val: T
  var next: Node	// error: value type 'Node' cannot have a stored property that recursively contains it
}
class Node<T> {
  var val: T
  var next: Node	// works
}
```

为什么会这样？**这是因为在值类型中，每个变量都拥有一块完全独立的内存，这要求它的大小是明确且固定的，否则无法做到完全独立的内存布局**。在上面的例子中，当Node中拥有一个Node类型的变量`next`时，显然会让它的内存布局无限地递归下去，结果就是无法确认内存大小。然而在引用类型中，这种限制很灵活，只需要知道对象的内存地址即可，大小不用如此明确。

更详细的讲解见：[Bidirectional associations using value types in Swift, from Medium](https://medium.com/@leandromperez/bidirectional-associations-using-value-types-in-swift-548840734047)

### 枚举

Swift中枚举的强大之处在于不但能够存储每个`case`的原始值，还能够为每个`case`关联不同类型的值，而且还能通过遵从`CaseIterable`协议遍历所有case。另外，通过 `switch` 遍历枚举时，会自动为每个 `case` 值提供分支。

```swift
enum Direction: CaseIterable {
    case north
    case south
    case east
    case west
}
for d in Direction.allCases {
    print(d)
}

enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrcode(String)
}
let bar = Barcode.upc(1, 2, 3, 4)
let qr = Barcode.qrcode("qr")
```

### 属性

通过`var`或者`let`关键字定义的变量或常量。可以分为：

- `lazy`延迟存储属性
- `get`计算属性，只读计算属性
- 简写`setter`，默认参数newValue
- 简写`getter`，单一表达式
- 属性观察者
  - `willSet`，附带默认常量形式参数newValue
  - `didSet`，附带默认常量形式参数oldValue
- 属性类型
  - 实例存储属性
  - `static`类型属性
  - `class`类型属性，可以在子类中`override`父类的实现

### 方法

枚举、结构体、类中的方法包含多种类型，比如实例方法、类型方法等。

- 实例方法，用`func`定义
  - `self`，实例对象本身
  - `mutating`，表示此实例方法能够修改实例本身的属性
- 类型方法
  - `static`
  - `class`，同样可以在子类中`override`
- 下标，通过`subsript(n: Int) -> Element {} `定义类似`[n]`的下标行为
  - 参数，可以是任意类型，比如`subsript(row: Int, col: Int) -> Bool {}` 
  - `static`类型下标，对应类型方法

### 初始化

结构体和类都需要**指定初始化器**，但如果属性有默认值，调用默认初始化器时会用默认值初始化属性。当然，你可以指定其他自定义初始化器。

##### 值类型的初始化器委托

在值类型结构中，为了避免冗余代码，可以在某个初始化器中调用其他初始化器，称为初始化器委托。

```swift
struct Rect {
    var origin = Point()
    var size = Size()
    init() {}
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
```

##### 类的初始化

**所有类的存储属性（包括继承来的）都必须在初始化期间分配初始值**。类有两种初始化器：

- **指定初始化器**，主要的
  - 每个类至少需要一个，用来初始化所有属性，并调用父类初始化器继续向上初始化。
  - 是初始化开始，并持续初始化过程到父类链的边界。
- **便捷初始化器**，次要的
  - 调用指定初始化器，为某些属性设置默认值，简化初始化过程。
  - 非必须。

```swift
// 指定
init(parameters) {
    statements
}
// 便捷
convenience init(parameters) {
    statements
}
```

##### 类的初始化器委托

**指定初始化器必须从它的直系父类调用指定初始化器，便捷初始化器必须从本类中调用其他初始化器，便捷初始化器最终必须调用一个指定初始化器**。

![initializer-flow](../images/swift-initializer-flow.png)

##### 两段式初始化

类的初始化分为两个阶段。**在第一阶段，从下往上初始化，引入所有属性，并分配初始值。在第二阶段，从上往下初始化，在所有属性的状态被确定之后，还有机会在实例被使用之前，对属性值进行定制**。

两段式让初始化更加安全，同时提供了完备的灵活性。两段式初始化过程可以防止属性值在初始化之前被访问，还可以防止属性值被另一个初始化器意外地赋予不同的值。

##### 安全检查

在初始化器中，安全检查需要四个步骤：

1. 指定初始化器必须保证在向上委托给父类初始化器之前，当前类引入的所有新属性都要完成初始化。
2. 指定初始化器必须先向上委托父类初始化器，然后才能为继承的属性设置新值。否则，指定初始化器赋予的新值将被父类中的初始化器所覆盖。
3. 便捷初始化器必须先委托同类中的其它初始化器，然后再为任意属性赋新值（包括同类里定义的属性）。否则，便捷构初始化器赋予的新值将被自己类中其它指定初始化器所覆盖。
4. 初始化器在第一阶段初始化完成之前，不能调用任何实例方法、不能读取任何实例属性的值，也不能引用 `self` 作为值。

##### 其他初始化器

- 可失败的初始化器`init?`，如果某个初始化条件未满足，可以返回nil表示初始化失败。
- 隐式展开可初始化器`init!`，使用可失败初始化器创建一个隐式展开具有合适类型的可选项实例。
- 必要初始化器`@required`，表明所有该类的子类都必须实现该初始化器。
- 反初始化器`deinit`，类似Objective-C中的`dealloc`，对象释放时自动调用。

