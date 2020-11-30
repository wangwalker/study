# 简介
## 概述

> Block objects are a C-level syntactic and runtime feature. They are similar to standard C functions, but in addition to executable code they may also contain variable bindings to automatic (stack) or managed (heap) memory. A block can therefore maintain a set of state (data) that it can use to impact behavior when executed.

简单来说，OC中的Block和其他语言中的闭包Closure是相似的——一种带有词法环境信息的函数，可以像函数一样被调用，也可以像变量一样被存储、传递，甚至可以在多线程中使用，不过最常用的还是作为函数回调callback使用。

因为Block是C语言级别的功能，所它可以在C、Objective-C、以及Objective-C++同时使用。

## 数据结构

Block的数据结构定义如下：

```c
struct Block_descriptor {
    // 保留变量
    unsigned long int reserved;
    // 大小
    unsigned long int size;
    // 函数指针
    void (*copy)(void *dst, void *src);
    void (*dispose)(void *);
};

struct Block_layout {
    // isa指针，OC中所有对象都有这一指针，表示对象所属类的信息
    void *isa;
    // 一些附加信息
    int flags;
    // 保留变量
    int reserved;
    // 具体的实现的函数指针
    void (*invoke)(void *, ...);
    struct Block_descriptor *descriptor;
    // 其他将是从定义block的词法作用域中捕获capture来的所有变量
    /* Imported variables. */
};
```

![Block数据结构](https://blog.devtang.com/images/block-struct.jpg)

## 分类

在Objective-C中，一共有三种类型的Block：

- `_NSConcreteGlobalBlock` 全局静态Block，保存在全局静态区，不会访问任何外部变量，释放由操作系统控制。
- `_NSConcreteStackBlock` 栈区Block，保存在栈中，一般作为函数参数出现，当函数返回时会被销毁。
- `_NSConcreteMallocBlock` 堆区Block，保存在堆中，作为对象属性使用较多，当引用计数为0️⃣时会被销毁。

# 使用
## 声明

![Block的语法规则](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Blocks/Art/blocks.jpg)

可以看见，声明一个Block既要指定参数类型，也要指定返回值类型，而且名字和Block体要以 `^` 开头。

```objc
@implementation BlockExample

// Global Block
void (^myGlobalBlock)(int) = ^(int value) {
    printf("double value %d is %d with global block", value, 2*value);
};

// Malloc Block
- (int)doubleInt:(NSNumber *)base{
    int exp = 2;
    
    int (^doubleInt)(int) = ^(int base) {
        return (int)exp*base;
    };
    
    NSLog(@"double 11 is %d with stack block", doubleInt(11));
    myGlobalBlock(11);
    
    return doubleInt([base intValue]);
}
@end
```

更加常用的做法是用`typedef`预定义一些Block。

```objc
typedef void (^MyVoidVoidBlock) (void);
typedef void (^MyVoidIntBlock) (int);
typedef int (^MyIntStringBlock) (char *);
typedef float (^MyFloatBlock)(float, float);
// ...

@interface BlockExample : NSObject
@property (nonatomic, assign) MyVoidVoidBlock someCallback;
@end
```

另外，在[这个网站上](http://goshdarnblocksyntax.com/)，列出了所有可用的声明方式：

```objc
// 本地变量
returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};

// 对象属性
@property (nonatomic, copy, nullability) returnType (^blockName)(parameterTypes);

// 方法参数
- (void)someMethodThatTakesABlock:(returnType (^nullability)(parameterTypes))blockName;
[someObject someMethodThatTakesABlock:^returnType (parameters) {...}];

// C函数参数
void SomeFunctionThatTakesABlock(returnType (^blockName)(parameterTypes));
```
## __block

在Block中，它会copy当前词法环境中的变量，这些变量一共分为五种类型，它们分别是：

- 全局变量，包括静态变量；
- 全局函数对象，主要是C函数；
- 当前词法环境中的本地变量和参数；
- 从其他地方引入的const常量；
- `__block`变量。

一般情况下，Block中copy的变量都是只读类型的，只能引用而不可修改。但是加上**存储修饰符**`__block`之后，则既可以读也可以写。

```objc
__block int x = 123; //  x lives in block storage
 
void (^printXAndY)(int) = ^(int y) {
 
    x = x + y;
    printf("%d %d\n", x, y);
};
printXAndY(456); // prints: 579 456
// x is now 579

```

## 循环引用

在Objective-C基于引用计数的内存管理方案中，当一个对象A持有另一个对象B时，而B同时也持有A时，就会造成循环引用的问题，导致A和B的引用计数一直大于0️⃣，因此A和B永远也释放不了，就会造成内存泄漏。当然有时候实际情况会非常复杂，经常是多个对象共同形成循环引用问题。

对于Block，这类问题尤为明显，它通常是自身引用自身造成的。当一个对象强引用某个Block时，而此Block又要copy自身时，也就是在Block的内部使用`self`时，就会造成retain cycle循环引用的问题。

```objc
// 这些例子中，都是因为自身对自身的引用造成的
- (void)simulateRetainCycle{
    // 编译器会提示这里出现了循环引用问题
    self.someCallback = ^(void) {
        NSString *name = [NSString stringWithFormat:@"%@%zd",
                          self.name, arc4random()%10];
        self.name = name;
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    Student *student = [[Student alloc]init];
    student.name = @"Hello World";

    student.study = ^{
        NSLog(@"my name is = %@",student.name);
    };
}
```

而要打破这种循环引用的问题，就要将避免在对象持有的block直接使用自身`self`。可以通过弱引用修饰符`__weak`解决。

```objc
- (void)simulateRetainCycle{
    __weak typeof(self) weakSelf = self;
    self.someCallback = ^(void) {
        NSString *name = [NSString stringWithFormat:@"%@%u",
                          weakSelf.name, arc4random()%10];
        weakSelf.name = name;
    };
}

// 也可以定义宏
#define WEAKSELF __weak typeof(self)weakSelf = self;
#define WEAKSELF typeof(self) __weak weakSelf = self;
```

另外，也可以使用类似ReactiveCocoa中定义的`@weakify`、`@strongify`这样的宏。实际上，它们也是基于`__weak`和`__strong`实现的。

# 参考
- [Apple官方文档](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Blocks/Articles/00_Introduction.html#//apple_ref/doc/uid/TP40007502-CH1-SW1)
- [唐巧的博文](https://blog.devtang.com/2013/07/28/a-look-inside-blocks/)
- [冰霜之地的博文](https://halfrost.com/ios_block_retain_circle/)