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

```obj
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

# 消息

Objective-C把一切操作称之为发送消息，比如`[someone doSth]`表示给`someone`发送了一条名为`doSth`的消息。这是Objective-C和其他语言差异比较大的一件事。

## 发送消息



## 动态解析


## 转发消息



# 参考
- [Apple官方文档](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008048-CH1-SW1)
- [Apple开源代码](https://opensource.apple.com/source/objc4/objc4-646/runtime/)
- [玉令天下的博文](http://yulingtianxia.com/blog/2014/11/05/objective-c-runtime/)
- [戴铭的博文](https://github.com/ming1016/study/wiki/Objc-Runtime)
- [Tushs's Blog](https://github.com/ming1016/study/wiki/Objc-Runtime)
- [veryitman的博文](http://www.veryitman.com/2018/04/05/OC-RunTime-%E6%80%BB%E7%BB%93%E6%B6%88%E6%81%AF%E8%BD%AC%E5%8F%91%E4%B8%AD%E7%94%A8%E5%88%B0%E7%9A%84%E7%9F%A5%E8%AF%86%E7%82%B9/)