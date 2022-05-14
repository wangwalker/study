### Overview

> The Combine framework provides a declarative Swift API for processing values over time. These values can represent user interface events, network responses, scheduled events, and many other kinds of asynchronous data.
>
> By adopting Combine, you’ll make your code easier to read and maintain, by centralizing your event-processing code and eliminating troublesome techniques like nested closures and convention-based callbacks.

**Combine是为处理随时间而变化的数据的一种声明式（响应式）框架**。它由三个核心组件构成：

- **Publisher**，负责生产事件，比如可以发出通知的NotificationCenter、对象属性、UITextfield的event，以及网络请求等。
- **Subscriber**，负责消费事件，比如负责接收Notification的某个对象。
- **Operator**，负责转换从上游的发布者发出的数据格式，以便订阅者能够使用。

针对Publisher和Subscriber中处理的数据类型，Combine为此各定义了对应的类型:

- **Publisher: Output**
- **Subscriber: Input**
- **Failure**，对应Publisher和Subscriber中可能会出现的错误

其中，它们之间的约束关系：**Publisher.Output == Subscriber.Input** ；同时，**Publisher.Failure == Subscriber.Failure** 

![workflow](https://static001.infoq.cn/resource/image/f3/33/f3cf70f3fe6ea57a01c8316d8c7fe433.png)

通过上图，我们可以看出：**Combine = Publisher + Operator + Subscriber**

### 原理

##### 常见问题

随着业务逻辑变得越来越复杂，如果不采取合理的手段进行**治理**，程序通常会变得**失控**。具体来说，通常是不断增加的嵌套闭包和回调深度耦合在一起，**程序的可读性、可维护性、可扩展性会不断减弱，修复的成本会不断上升，以致于程序（软件）将逐渐丧失其应有的价值**。

##### 解决方案

- 不断**重构**，clean code
- 遵循**标准**和**规范**
  - **设计模式**
  - **DRY/SOLID原则**
  - **响应式/函数式编程**
  - 其他，比如**状态机**、**插件机制**等
- 使用框架
  - 语言：**ReactiveX**，Swift中的**Combine**
  - Web：Java中常用的**Spring**，Python中的**Django**等

##### 发布-订阅模式

Combine也作为一种类似于ReactiveX的响应式编程框架，它是通过**发布-订阅**模式实现的。

在发布订阅模式中，两个最基本的角色就是Publisher发布者和Subscriber订阅者，前者负责**生产**数据/事件，后者负责**消费**数据/事件。

当然，在Publisher和Subscriber之间还存在一种使双方连接在一起的对象，比如在Combine中就是**Subscription**，而在使用发布订阅模式的非常普遍的**消息队列**框架中，一般通过**经纪人Broker**来实现这种连接关系。

![Pub-Sub](https://pic2.zhimg.com/80/v2-b6ed65f370a766620718ad4227d5d4e5_1440w.jpg)

通过这样方式，我们就可以很轻松的做到**按需消费**、**降低耦合**，程序的质量自然而然地会有所好转。

##### 观察者模式

除过发布-订阅模式之外，另一种常用且能够有效**实现解耦**的设计模式是**观察者模式**，原理类似，但在概念上更加精简。

在观察者模式中，能够主动产生事件的一方是**被观察者Observable，或者Subject**，而被动接收事件的一方是**观察者Observer**。通常，被观察者会维护一组观察者列表，当事件发生时，会将其传递给它们，从而实现业务同步和更新。

![Observable](https://pic2.zhimg.com/80/v2-0a7ef7d1a328dc37eadefb29e0ea705d_1440w.jpg)

### Publisher

> Publisher sends sequences of values over time to one or more Subscribers.

发布者随着时间负责生产数据/值/事件，并发布给后面的一个或多个订阅者Subscriber。

```swift
public protocol Publisher {
    
  /// 发布者发出的值的类型
  associatedtype Output
  
  /// 发布者可能发出的错误的类型
  associatedtype Failure : Error
  
  /// 为发布者绑定订阅者，其中发布者发出的值得类型必须和订阅者接收的值的类型一致
  func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input
  
}
```

- **Core Components**
  - **Publisher** 如上所示，定义了发布者会发出的数据/值/事件的类型，可能出现的错误，并提供了用于接收订阅者的方法
  - **AnyPublisher** 官方文档中说是为了**type erasure**，简单来说就是为了消除Publisher中具体的类型信息，让Publisher变得更加通用，类似于 `AnyObject` 的概念。所有的Publisher通过`eraceToAnySubject()`都会转换成AnyPublisher。
  - **Published** 属性包装器，封装对象的某个属性，当其改变时，即可获得对应的事件通知。
  - **Cancellable** 里面只定义了一个方法 `cancel()` ，为什么需要它？是因为在某些场景下，需要**主动取消**某个活动，比如典型的网络请求中，用户可能在后面取消某个正在进行的HTTP请求。
  - **AnyCancellable** 类似AnyPublisher
  - **ConnectablePublisher** 为了防止在某些条件还未准备好，就可能发布某个事件的一种Publisher；直到订阅者主动调用 `connect()` 方法，准备好之后，才会发布某个事件/值。
- **Convenience Publishers**
  - **Future**  以异步的方式发布单个值，然后 `finish` 或者 `fail`
  - **Just** 只发布一次Output，然后完成
  - **Deferred** 提供一个closure，只有在Subscriber订阅时才生成对应的Publisher
  - **Empty** 一个永远不发布内容的发布者，可立即结束
  - **Fail** 发送一个特定Error以立即结束事件
  - **Record** 能够记录一系列输入和完成事件，以便后续重放
  - **Sequence** 将给定的一个序列按序通知到订阅者
  - **Published** 属性包装器，将任意值封装成Publisher
- **Subject** 可以发送自定义数据/值/事件的Publisher
  - **PassthoughSubject** 只是将来自上游的事件传递下去
  - **CurrentValueSubject** 对单个值的封装，当这个值修改时，会自动发出事件
- **Foundation**
  - URLSession Publisher
  - Timer Publisher
  - Notification Publisher

### Subscriber

> Subscriber receives values from a publisher.

订阅者**负责接收并消费**数据/值/事件，从某种意义上讲，Publisher是由Subscriber驱动的。

```swift
public protocol Subscriber: CustomCombineIdentifierConvertible {
  
  /// 订阅者从发布者接收到的值的类型
  associatedtype Input
  
  /// 订阅者可能会接收到的错误的类型，Never表示不接收错误
  associatedtype Failure: Error
  
  /// 告诉订阅者，已成功订阅，可开始从发布者请求数据了
  func receive(subscription: Subscription)
  
  /// 告诉订阅者，发布者已经发布的元素，返回订阅者期望接收的元素数量
  func receive(_ input: Self.Input) -> Subscribers.Demand
  
  /// 告诉订阅者，发布者已经完成发布，可能成功，也可能失败
  func receive(completion: Subscribers.Completion<Self.Failure>)
  
}
```

- **Core Components**
  - **Subscriber**  protocol
  - **Subscribers**
    - **Sink** 最通用且常用的订阅者，可将基于闭包的逻辑嵌入到Combine中。
    - **Assign** 一种简便用法，可直接将接收到的值绑定到**指定类**的KeyPath上。
  - **AnySubscriber** 同样经过 `type erasure` 让Subscriber变得更加通用。
  - **Subscriptions**
    - **Subscription** 用以表示发布者和订阅者之间对应关系，成功订阅时会接收到的消息，只会发送一次。
    - **Value** Publisher发出的数据，只要发送，就会收到，没有次数限制。
    - **Completion** 数据流结束时发送的消息，要么 `.finished` 和 `.failure(Error)`，最多只发送一次，一旦发送，Publisher和Subscriber之间的绑定就会中断。

### Subject

主题Subject是一种特殊的发布者，可通过`send`方法发布自定义数据/值/事件到相应的事件流中，Combine中内置了两个Subject：

- **PassthoughSubject** 只是将事件传递给下游的Publisher和Subscriber。
- **CurrentValueSubject** 会持有一个值，在设置值时发送事件，并保留新的值。

Subject概念的引入，给了Combine，以及所有采用了**发布-订阅模式**框架更大的自由度，让我们可以创建出各种各样的Publisher，以完成具体的业务需求。

```swift
public protocol Subject: AnyObject, Publisher {
  
  /// 发送数据给订阅者
  func send(_ value: self.Output)
  
  /// 发送完成信号给订阅者
  func send(completion: Subscribers.Completion<Self.Failure>)
  
  /// 给订阅者发送一个订阅
  func send(subscription: Subscription)

}
```

一个简单地例子

```swift
var cancellables: Set<AnyCancellable> = []

let pub1 = PassthroughSubject<Int, Never>()
pub1.sink(receiveCompletion: { complete in
    print(complete)
}, receiveValue: { value in
    print(value)
}).store(in: &cancellables)

pub1.send(1)
pub1.send(3)
pub1.send(completion: .finished)

/// 1
/// 3
/// finished

let pub2 = CurrentValueSubject<Int, Never>(0)
pub2.sink(receiveCompletion: { complete in
    print(complete)
}, receiveValue: { value in
    print(value)
}).store(in: &cancellables)

pub2.value = 2
pub2.send(4)
pub2.send(completion: .finished)

/// 0
/// 2
/// 4
/// finished
```

### Operators

操作符Operator是Combine中非常重要的一部分，通过这些内置的操作符能够将来自上游的数据转换为下游所需要的格式，以便进行后续工作。

- **转换**
  - **map/tryMap/flatMap/compactMap/mapError**
    - **compactMap** 会将结果中的 `nil` 去除掉，而这就是**compact**的含义
    - **flatMap** 会将发送的多层嵌套序列值展开为单层序列，然后 `map`
    - **mapError** 负责转换 `Error` 到其他需要的类型
    - **tryMap** 就是为`map` 提供了对抛出错误的支持
  - replaceNil
  - setFailureType
- **过滤**
  - filter/tryFilter
  - removeDuplicates
  - replaceEmpty/replaceError
- **聚合**
  - **collect** 将Publisher发出的**多次单个事件集合**到一起，组成一个序列对象
  - **reduce** 将多个事件**合并**到一起
  - **scan** 和reduce类似，但scan会保留每一次合并之后的结果，而reduce只会保留最终的合并结果
  - **buffer** 对发出的事件提供**缓冲**支持，可根据 `size: Int` 参数指定缓冲大小
- 统计
  - count
  - min/max
- 匹配
  - contains/tryContains
  - allSatisfy/tryAllSatisfy
- 序列
  - drop/tryDrop/dropFirst
  - append/prepend
  - prefix/first/last/output
- **组合**
  - **merge** 将多个Publisher组合在一起，形成一个**交错的事件流**
  - **zip** 也是将多个Publisher组合在一起，但是会发出一个以**tuple组织在一起**的事件流
  - **combineLatest** 也是将多个Publisher组合在一起，也是以tuple组织收到的事件流，但**只要其中一方发出新事件，就会立即发出一个包含此新事件的tuple给下游订阅者**
- 时间相关
  - debounce
  - delay
  - throttle
  - timeout
  - measureInterval
- Other
  - encode/decode
  - **share** 可以让单个Publisher有多个Subscriber，形成**一对多**的连接关系
  - breakpoint/breakpointOnError
  - handleEvents

### Scheduler

不管是哪一种编程范式，但凡要进行一个计算过程，除过要指明What和How之外，还应该指明Where和When，才能够正确地进行计算。

在Combine中，**如果说Publisher、Operator和Subscriber解决的是计算中What和How的问题**，那么**Scheduler解决的则是Where的问题**，即应该在哪里进行计算，比如主线程，或者其他线程。

至于When的问题，其实是在Operator中和时间相关的一系列方法：

- `delay` 延迟，按照指定的时间延迟执行
- `debounce` 防抖，在特定事件段之内只能发出一次最后一次事件，其他事件将会被丢弃
- `throttle` 节流，和debounce类似，但 `throttle` 可以通过 `latest: bool` 来设置发出的事件是最新的还是最先的
- `timeout` 超时，超过指定的时间将终止发布事件

`debounce` 和 `throttle` 这两个"限流"操作符，主要用在**对系统资源比较消耗的场景**，比如网络请求、本地磁盘I/O读写，或者界面渲染等事件。

关于`debounce`的例子：

```swift
let bounces:[(Int,TimeInterval)] = [
 (0, 0),
 (1, 0.25),  // 0.25s interval since last index
 (2, 1),     // 0.75s interval since last index
 (3, 1.25),  // 0.25s interval since last index
 (4, 1.5),   // 0.25s interval since last index
 (5, 2)      // 0.5s interval since last index
]

let subject = PassthroughSubject<Int, Never>()
subject
 .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
 .sink { index in
     print ("Received index \(index)")
 }.store(in: &cancellables)

for bounce in bounces {
 DispatchQueue.main.asyncAfter(deadline: .now() + bounce.1) {
     subject.send(bounce.0)
 }
}

/// Received index 1
/// Received index 2
/// Received index 5
```

关于`throttle`的例子：

```swift
cancellable = Timer.publish(every: 3.0, on: .main, in: .default)
     .autoconnect()
     .print("\(Date().description)")
     .throttle(for: 6.0, scheduler: RunLoop.main, latest: false)
     .sink(
         receiveCompletion: { print ("Completion: \($0).") },
         receiveValue: { print("Received Timestamp \($0).") }
      )
DispatchQueue.global().asyncAfter(deadline: .now() + 15) {
    cancellable.cancel()
}

/// 2022-02-17 05:30:20 +0000: receive value: (2022-02-17 05:30:23 +0000)
/// Received Timestamp 2022-02-17 05:30:23 +0000.
/// 2022-02-17 05:30:20 +0000: receive value: (2022-02-17 05:30:26 +0000)
/// 2022-02-17 05:30:20 +0000: receive value: (2022-02-17 05:30:29 +0000)
/// Received Timestamp 2022-02-17 05:30:26 +0000.
/// 2022-02-17 05:30:20 +0000: receive value: (2022-02-17 05:30:32 +0000)
/// 2022-02-17 05:30:20 +0000: receive value: (2022-02-17 05:30:35 +0000)
/// Received Timestamp 2022-02-17 05:30:32 +0000.
/// 2022-02-17 05:30:20 +0000: receive cancel
```

### 感悟

1976 年，瑞士计算机科学家， Pascal等语言的设计师 Niklaus Emil Wirth 写了一本非常经典的书《Algorithms + Data Structures = Programs》 ，即**算法 + 数据结构 = 程序**。

1979 年，英国逻辑学家和计算机科学家 Robert Kowalski 发表论文说， **Algorithm = Logic + Control**，并且主要是开发**逻辑相关**的工作。

所以，编程的本质就是**处理**算法和数据结构，或者控制逻辑和业务逻辑，而**处理的核心**是**分离它们**，只要分离的高效且干净，就能保持代码整洁，否则就会出现各种问题。

那么，**如何才能更好地分离控制逻辑和业务逻辑**？其实Combine，以及其他相似的框架，比如RxSwift就是一种非常好的实践。当然还有更多其他方法，比如设计模式、设计原则，以及优秀的框架。