# 简介

我们都知道Objective-C是一门动态语言，也就是说**它会将很多工作从编译器推迟到运行时**，比如类、方法、属性的确定。这意味着Objective-C不仅仅需要编译器，也需要一个运行时系统。

这个运行时Runtime系统赋予Objective-C这门语言强大的能力，让开发者可以在程序运行时创建、修改类及其对象和它们的属性、方法，同时也使得C语言具有了面向对象的能力。

Objective-C的Runtime不但强大，而且高效，因为它是用C语言和汇编语言写成的。具体一点，它是由一系列数据结构和函数组成的动态公共接口，在`/usr/bin/objc/`目录下，在项目中只需引入`<objc/runtime.h`>即可看见所有接口。

# 类与对象
## 基础设施

在实际操作中，我们可以从三个层面与Runtime系统进行交互，分别是通过**OC源码、NSObject定义的方法，以及通过直接调用runtime函数**。而这三种方式的运行，都依赖于一些基础性定义，下面就来谈谈。

### id

如果要问OC中“动态性”最强的类(型)是哪个，那结果一定是id，因为id可以在编译期代表任意类型而不受约束，这就给程序提供了非常灵活的可能性。

从定义中可以看出，id是一个指向objc_object结构体的指针，objc_object结构体中只有一个名为isa的Class类型，而Class又是一个指向objc_class结构体的指针。

```objc
/// id是一个指向objc_object的指针
/// 来自https://opensource.apple.com/source/objc4/objc4-646/runtime/objc-private.h.auto.html
typedef struct objc_object *id;

/// objc_object是一个只含有名为isa的Class组成的结构体
struct objc_object {
    private:
        isa_t isa;

    public:
        // ISA() assumes this is NOT a tagged pointer object
        Class ISA();

        // getIsa() allows this to be a tagged pointer object
        Class getIsa();

        void initIsa(Class cls /*indexed=false*/);
        void initClassIsa(Class cls /*indexed=maybe*/);
        void initProtocolIsa(Class cls /*indexed=maybe*/);
        void initInstanceIsa(Class cls, bool hasCxxDtor);
        // ...

    private:
        void initIsa(Class newCls, bool indexed, bool hasCxxDtor);

        // Slow paths for inline control
        id rootAutorelease2();
        bool overrelease_error();

    #if SUPPORT_NONPOINTER_ISA
        // Unified retain count manipulation for nonpointer isa
        id rootRetain(bool tryRetain, bool handleOverflow);
        bool rootRelease(bool performDealloc, bool handleUnderflow);
        id rootRetain_overflow(bool tryRetain);
        bool rootRelease_underflow(bool performDealloc);
        // ...
    #endif

    #if !NDEBUG
        bool sidetable_present();
    #endif
};


/// Class是一个指向objc_class的指针
typedef struct objc_class *Class;


/// OBJC1对objc_class的定义
struct objc_class {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;  // 类的类，也就是元类

#if !__OBJC2__
    Class _Nullable super_class                              OBJC2_UNAVAILABLE;
    const char * _Nonnull name                               OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
    struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
    struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
#endif

} OBJC2_UNAVAILABLE;


/// OBJC2对objc_object的定义
/// 来自https://opensource.apple.com/source/objc4/objc4-646/runtime/objc-runtime-new.h.auto.html
struct objc_class : objc_object {
    // Class ISA;
    Class superclass;
    cache_t cache;             // formerly cache pointer and vtable
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
    class_rw_t *data() { 
        return bits.data();
    }
    void setData(class_rw_t *newData) {
        bits.setData(newData);
    }
    // ...
}
```

由此，我们可以得知：**对象objc_object的isa指针指向类objc_class，而类objc_class的isa指针又指向类的类，即元类，所有的元类指向根类rootclass，rootclass指向自己，这是水平方向的继承体系，而在垂直方向上的继承体系内，objc_class还有指向父类的superclass指针**。另外，为了提高性能，还有缓存cache等。

![对象和类的继承关系](../images/class-inheriance-diagram.jpg)

### SEL

在运行时，SEL表示方法的名称，它是类内唯一的C字符串。可以通过sel_registerName在运行时注册SEL。

SEL的定义如下：

```c
typedef struct objc_selector *SEL;
```

### IMP

SEL是方法的名称，IMP则是方法的具体实现，是一个函数指针，是由编译器生产的。当通过OC给对象发送消息时，最终执行的就是IMP所指的代码。SEL和IMP是成对出现的。

IMP的定义如下：

```c
typedef void (*IMP)(void id, SEL, ... );
```

### Method

顾名思义，Method表示一个方法，由三部分组成：
- SEL，方法名称；
- IMP，方法实现；
- types，参数类型和返回值类型。

它的定义如下：

```objc
typedef struct method_t *Method;

struct method_t {
    SEL name;
    const char *types;
    IMP imp;

    struct SortBySELAddress :
        public std::binary_function<const method_t&,
                                    const method_t&, bool>
    {
        bool operator() (const method_t& lhs,
                         const method_t& rhs)
        { return lhs.name < rhs.name; }
    };
};
```

## 操作指南

能够通过OC实现的功能，比如setter、getter、创建对象、添加方法等等，都可以通过Runtime提供的能力实现。下面就单纯从语言设计层面了解一下。

### 类对象

类定义相关

```objc
// 获取当前已注册的所有类
int objc_getClassList ( Class *buffer, int bufferCount );

// 创建并返回一个指向所有已注册类的指针列表
Class * objc_copyClassList ( unsigned int *outCount );

// 返回指定类的类定义
Class objc_lookUpClass ( const char *name );
Class objc_getClass ( const char *name );
Class objc_getRequiredClass ( const char *name );

// 返回指定类的元类
Class objc_getMetaClass ( const char *name );
```

通过实例对象获取类的信息

```objc
// 获取给定实例对象的类名
const char * object_getClassName ( id obj );
// 获取实例对象的类
Class object_getClass ( id obj );
// 设置实例对象的类
Class object_setClass ( id obj, Class cls );
```

### 实例对象

对整个对象的操作

```objc
// 返回指定对象的一份拷贝
id object_copy ( id obj, size_t size );
// 释放指定对象占用的内存
id object_dispose ( id obj );
```

操作实例变量

```objc
// 修改实例变量的值
Ivar object_setInstanceVariable ( id obj, const char *name, void *value );
// 获取实例变量
Ivar object_getInstanceVariable ( id obj, const char *name, void **outValue );
// 获取实例变量的值
id object_getIvar ( id obj, Ivar ivar );
// 设置实例变量
void object_setIvar ( id obj, Ivar ivar, id value );
```

### 对象关联

在常规代码实践中，如果要让一个对象和另一个对象产生关联，只有一个办法——让另一个对象成为它的属性property，这需要事先定义好，也就是要在编译期之前确定好。而如果要在运行时动态关联对象，只有通过Runtime提供的能力才能事先。

方法包含：
- `objc_setAssociatedObject`：设置
- `objc_getAssociatedObject`：获取
- `objc_removeAssociatedObjects`：删除

关联策略包含：
- `OBJC_ASSOCIATION_ASSIGN`
- `OBJC_ASSOCIATION_RETAIN_NONATOMIC`
- `OBJC_ASSOCIATION_COPY_NONATOMIC`
- `OBJC_ASSOCIATION_RETAIN`
- `OBJC_ASSOCIATION_COPY`

```objc

static char dynamicKey;

- (void)setAndGetDynamicObject{
    if (objc_getAssociatedObject(self, &dynamicKey)) {
        objc_removeAssociatedObjects(objc_getAssociatedObject(self, &dynamicKey));
    }

    id objcSet = [self generateDynamicObject];
    objc_setAssociatedObject(self, &dynamicKey, objcSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    id objcGet = objc_getAssociatedObject(self, &dynamicKey);
    
    NSLog(@"my dynamic object is %@", objcGet);
}

- (id)generateDynamicObject{
    NSArray *objecs = @[@1, @3, @"Wang", @YES];
    NSUInteger idx = arc4random()%4;
    return [objecs objectAtIndex:idx];
}
```

### objc-相关总结

在Objective-C语言中，运行时runtime库中API的一些总结:

- `objc_`开头的一般是类的创建、注册、注销等操作，也可以通过名字获得（元）类对象；
- `class_`开头的一般是对表示类的内部接口的objc_class结构体的操作，比如获取实例变量、方法等；
- `object_`开头的一般是对实例对象的操作，比如修改instance的属性名和值，方法等；
- `ivar_`、`property_`、`protocal_`开头的一般指对实例变量、属性、协议的操作。

# 消息

Objective-C把一切操作称之为发送消息，比如`[someone doSth]`表示给`someone`发送了一条名为`doSth`的消息。只有在运行时，消息才会和实现进行绑定。

## 发送消息
### objc_msgSend

所有的消息，最终都会被编译器用`objc_msgSend`发送给接收者，第一个参数是消息接受者receiver，第二个是一个Selector，如果有其他参数直接跟在后面。

```objc
objc_msgSend(receiver, selector)
objc_msgSend(receiver, selector, arg1, arg2, ...)
```

`objc_msgSend`通过前两个参数`receiver`和`selector`便可以容易的定位到具体的方法实现，然后将参数传递给具体的方法并执行，最后返回执行结果。

这里的关键之处在于前面提到的对象和类的数据结构`objc_object`和`objc_class`。对于`objc_class`的数据结构，里面包含指向父类`superclass`的指针，以及一个方法分派表，将所有的方法selector和IMP对应起来。而对于`objc_object`的数据结构，里面的`isa`指针指向它所属的类，也就是指向一个`objc_class`。

这样，对象和类的继承体系就被互相联系在一起了，如果某个对象在类的方法分派表中找不见对应的方法，则顺着它的继承关系依次在父类、父类的父类…中寻找，直到最顶层的根类NSObject，如果还没有找见，则给出异常信息。

当然，在实现细节上还有其他要点，比如为了提高消息被处理的速度，运行时系统会缓存方法selector和IMP。

另外，编译器会根据情况在`objc_msgSend`, `objc_msgSend_stret`, `objc_msgSendSuper`, 或 `objc_msgSendSuper_stret`四个方法中挑选一个来调用。如果消息是传递给超类，那么会调用名字带有`Super`的函数；如果消息返回值是数据结构而不是简单值时，那么会调用名字带有`stret`的函数。

![对象继承关系](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Art/messaging1.gif)

### self _cmd

当`objc_msgSend`找到对应的方法后，在传递参数时，还会附带传递两个隐藏参数`self`和`_cmd`，前者代表消息的实际接收者，后者表示此消息的selector。实际上，它们是在编译期自动被加入的。

```objc
- (id)strange {
    id  target = getTheReceiver();
    SEL method = getTheMethod();
 
    if ( target == self || method == _cmd )
        return nil;
    return [target performSelector:method];
}
```

### methodForSelector:

动态绑定很灵活，但在某些特殊的场景中将受到性能影响，比如要在短时间内给某个对象多次发送消息时。

这时候，更加合理的做法是先通过NSObject定义的`methodForSelector:`获取方法的地址，然后直接调用，这将省去不少时间开销。

```objc
void (*setter)(id, SEL, BOOL);
int i;
 
setter = (void (*)(id, SEL, BOOL))[target
    methodForSelector:@selector(setFilled:)];
for ( i = 0 ; i < 1000 ; i++ )
    setter(targetList[i], @selector(setFilled:), YES);
```

## 消息转发

如果消息接收者并不能响应某个消息，那么在运行时系统给出异常之前，还会通过消息转发机制寻求其他可能。具体会经过下面三个流程：
- **动态方法解析**
- **重定向接收者**
- **最后的转发**

### 动态方法解析

可以先通过实现 `resolveInstanceMethod:` 和 `resolveClassMethod:`，然后通过`class_addMethod`动态添加一个方法的实现。

```objc
void dynamicMethodIMP(id self, SEL _cmd) {
    NSLog(@"dynamic method implementation: %@", NSStringFromSelector(_cmd));
}

// 实例方法的动态解析
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    SEL aSel = NSSelectorFromString(@"someDynamicMethod");
    if (sel == aSel) {
        class_addMethod([self class], aSel, (IMP)dynamicMethodIMP, "v@:");
    }
    return [super resolveInstanceMethod:sel];
}

// 类方法的动态解析
+ (BOOL)resolveClassMethod:(SEL)sel{
    SEL aSel = NSSelectorFromString(@"someDynamicMethod");
    if (sel == aSel) {
        class_addMethod([self class], aSel, (IMP)dynamicMethodIMP, "v@:");
    }
    return [super resolveClassMethod:sel];
}
```

### 重定向接收者

如果经过上面的**动态方法解析**之后，依然无法处理消息。这时候运行时系统就会通过 `forwardingTargetForSelector:` 提供一次替换消息接收者的机会。注意：新替换的对象一定不能为self，因为这样会进入死循环。

```objc
@implementation RuntimeExample{
    RunLoopExample *runloop;
}

- (instancetype)init{
    if ((self = [super init])) {
        runloop = [[RunLoopExample alloc] init];
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"forwarding target");
    if ([NSStringFromSelector(aSelector) isEqualToString:NSStringFromSelector(@selector(addTimerForCommonMode))]) {
        NSLog(@"forwarding to 'runloop'");
        return runloop;
    }
    return [super forwardingTargetForSelector:aSelector];
}
```

### 最终的转发

如果经过上面两个途径依然无法处理某个消息，那么就会进入比较”沉重“的最后一个消息转发步骤了。

通过重写`forwardInvocation:`这个在NSObject中定义的方法，根据它的唯一参数——一个封装了原始消息相关信息的NSInvocation对象，将其解构、分析之后给出对应的处理措施。

要注意的是，重写`forwardInvocation:`时，还要重写另一个方法`methodSignatureForSelector:`，用来生成`forwardInvocation:`的唯一参数NSInvocation的方法签名。

```objc
@implementation RuntimeExample{
    RuntimeHelper *anotherObject;
}

- (instancetype)init{
    if ((self = [super init])) {
        anotherObject = [[RuntimeHelper alloc] init];
    }
    return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    SEL sel = [anInvocation selector];
    if ([anotherObject respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:anotherObject];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature && [anotherObject respondsToSelector:aSelector]) {
        signature = [anotherObject methodSignatureForSelector:aSelector];
    }
    return signature;
}
```

另外，基于消息转发机制，还能模拟继承和多继承。具体而言，就是在`forwardInvocation:`中将所有继承对象的方法按规则分派出去，就像是自己的方法一样。

虽然OC的消息转发机制很强大也很灵活，但应该谨慎使用，因为它不但让程序的逻辑变得更加复杂，而且增加了程序的开销，使用过多必然会降低性能。

# Method Swizzle

通过上面这些方法已经可以灵活地实现许多功能，但还是有点限制——需要操纵源码，对于无法获取源码的，比如Apple官方提供的一些能力，显然无法直接修改。在这种情况下，可以用Method Swizzle进行“偷梁换柱”，用一个方法替换另一个方法就能实现直接无法实现的功能。

比如下面的例子在运行时替换了两个方法的实现。

```objc
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel1 = @selector(swizzlingMethod1);
        SEL sel2 = @selector(swizzlingMethod2);
        
        Method m1 = class_getInstanceMethod([self class], sel1);
        Method m2 = class_getInstanceMethod([self class], sel2);
        
        // 如果此类还没有对应的方法，先注册该方法
        BOOL methodAdded = class_addMethod([self class], sel1, method_getImplementation(m2), method_getTypeEncoding(m2));
        
        if (methodAdded) {
            NSLog(@"method add and add");
            class_replaceMethod([self class], sel2, method_getImplementation(m1), method_getTypeEncoding(m1));
        } else {
            // 否则，直接交换
            NSLog(@"methods exchange");
            method_exchangeImplementations(m1, m2);
        }
    });
}

- (void)swizzlingMethod1{
    NSLog(@"swizzling method: %s", __FUNCTION__);
}

- (void)swizzlingMethod2{
    NSLog(@"swizzing method: %s", __FUNCTION__);
}
```

经过实践发现，确实可以轻松的交换两个方法的实现。不过，这种做法会增加程序调试难度，应该尽可能减少使用。另外，也有一些注意事项：
- Method Swizzling的合适时机是`+load`或者`+initialize`，前者表示第一次加载时，后者表示第一次使用时的初始化工作。
- Method Swizzling应该总是在`dispatch_once`中执行，保证有且仅有一次运行机会。

对于Method Swizzling最常见的使用场景大概就是替换某些系统方法的默认实现，以便自动化处理一些工作，比如实现一个可自动记录日志和埋点数据的`viewWillAppear:`，通过替换UIViewController的原有`viewWillAppear:`，就可以实现一个通用的日志收集方案。

# 参考
- [Apple官方文档](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008048-CH1-SW1)
- [Apple开源代码](https://opensource.apple.com/source/objc4/objc4-646/runtime/)
- [玉令天下的博文](http://yulingtianxia.com/blog/2014/11/05/objective-c-runtime/)
- [戴铭的博文](https://github.com/ming1016/study/wiki/Objc-Runtime)
- [Tuski's Blog](https://perphet.com/2019/08/OC-Runtime/)
- [veryitman的博文](http://www.veryitman.com/2018/04/05/OC-RunTime-%E6%80%BB%E7%BB%93%E6%B6%88%E6%81%AF%E8%BD%AC%E5%8F%91%E4%B8%AD%E7%94%A8%E5%88%B0%E7%9A%84%E7%9F%A5%E8%AF%86%E7%82%B9/)