在iOS开发中，多线程编程实践有多重途径，它们各有侧重。
- NSThread
- NSOperation
- GCD
- pthread

# NSThread
NSThread是Apple官方推荐的多线程操作途径，它的抽象程度最高，确定是需要自己管理线程的生命周期，线程周期等核心问题。

核心属性有：
- `executing`：是否正在执行，调用`start`方法之后为`TRUE`。
- `finished`：是否执行完成。
- `cancelled`：是否已取消，调用`cancel`方法之后为`TRUE`。

核心方法：
- `start`：开始执行任务，实际调用下面的main方法；
- `main`：任务最终在此执行；
- `cancel`：取消任务。

## 初始化
### 直接创建
通过直接使用Apple封装好的接口，就可以多线程执行，简单高效。常用的接口有：
- `detachNewThreadWithBlock:`
- `detachNewThreadSelector:toTarget:withObject:`
- `initWithBlock:`
- `initWithTarget:selector:object:`

```objc
// 1. 直接开启一个新线程执行任务
[NSThread detachNewThreadSelector:@selector(doSomething:) toTarget:self withObject:nil];

// 2. 先创建线程对象，再运行线程操作，运行前可以设置线程优先级等线程信息
NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selecto (doSomething: object:nil];
[myThread start];

//3. 不显式创建线程的方法，使用NSObject的类方法创建一个线程
[self performSelectorInBackground:@selector(doSomething) withObject:nil];
```

完整示例见: [直接通过创建NSThread加载用户头像列表](https://github.com/Walkerant/Study/blob/master/ios/Snippets/Snippets/Concurrent/Controller/NSThreadViewController1.m)

### 继承

通过继承NSThread，将耗时任务封装在类内，可以起到“高内聚，低耦合”的作用。

具体而言，重写NSThread的`main`方法执行相关逻辑，然后调用`start`方法即可开始执行。

```objc
+ (instancetype)threadWithUser:(WRGithubUser *)user{
    return [[self alloc] initWithUser:user];
}

- (instancetype)initWithUser:(WRGithubUser*)user{
    if ((self = [super init])) {
        self.user = user;
    }
    return self;
}

- (void)setHandler:(WRGithubUserAvatarHandler)handler{
    _handler = handler;
    // 开始调用下面的main方法
    [self start];
}

- (void)main{
    if (!_user || !_user.avatarUrlString) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:_user.avatarUrlString];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    [self.user setAvatar:[UIImage imageWithData:imageData]];
    
    if (_handler) {
        _handler();
    }
}
```

完整示例见: [通过继承NSThread加载用户头像列表](https://github.com/Walkerant/Study/blob/master/ios/Snippets/Snippets/Concurrent/Controller/NSThreadViewController2.m)

# NSOperation
NSOperation是一个抽象类，不可直接调用，要么使用系统定义好的两个子类NSInvocationOperation和NSBlockOperation，要么继承自定义实现。

实现逻辑和NSThread大体相同，`main`函数是最终执行单任务逻辑的地方，`start`用来控制何时以及在哪里开始执行任务，`cancel`用来取消任务。不同点在于NSOperation可以:
- 设置任务之间的依赖关系，`addDependency:` `removeDependency:` ；
- 不用管任务执行状态，当一个任务执行完成或被取消，则直接`return` ；
- 配合NSOperationQueue，加入队列之后自动执行，使用起来会更方便。

## NSOperationQueue
NSOperationQueue用来维护一组NSOperation对象的执行顺序和流程。执行次序不但和加入的顺序相关，而且还和任务的优先级Priority有关，很明显高优先级的任务要先执行，低优先级的任务后执行。

一旦加入进去，就不可移除，直到执行完成为止。执行完成之后，自动释放任务对象。

重要的属性：
- `maxConcurrentOperationCount`：设置最大并发数量；
- `suspended`：控制该队列是否要挂起；
- `currentQueue`：当前队列，属于类对象的静态属性；
- `mainQueue`：和主线程相关的任务队列，处理事件循环相关任务。

重要方法：
- `addOperation:`：添加任务；
- `addBarrierBlock:`：添加barrier任务，也就是说已**入队的所有任务完成之后，才能执行新入队的任务**；
- `cancelAllOperations`：取消所有任务，但并没有移除，包括正在执行的任务；
- `waitUntilAllOperationsAreFinished`：阻塞当前线程，等待所有任务执行完成，此时不可再添加任务。

简单示例：
```objc
- (void)start{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    for (NSString *str in [self urlStrs]) {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImageWithUrlString:) object:str];
        [queue addOperation:operation];
    }
    
    [queue addBarrierBlock:^{
        NSLog(@"all operations finished");
    }];
}

- (void)downloadImageWithUrlString:(NSString*)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSLog(@"response data length:%zd from \nurl:%@", data.length, urlStr);
    // ...
}

- (NSArray<NSString*>*)urlStrs{
    return @[
        @"https://avatar.csdnimg.cn/B/A/A/3_qq_25537177.jpg",
        @"https://profile.csdnimg.cn/B/4/2/3_qq_41185868",
        @"https://profile.csdnimg.cn/8/0/6/3_qq_35190492",
        @"https://profile.csdnimg.cn/5/2/2/3_dataiyangu",
    ];
}
```

完整代码见：[NSOperation实践](https://github.com/Walkerant/Study/blob/master/ios/Snippets/Snippets/Concurrent/Model/NSOperationExample.m)

# GCD
Grand Central Dispatch简称GCD，是Apple为多核设备并发编程提供的一套综合性的解决方案，因为是在系统级别上实现的，所以更高效。

## 概况
### 队列Queue
在GCD中，一共有三种队列，分别是：
- Serial：对应`DISPATCH_QUEUE_SERIAL`，同一时间只能执行一个任务。常用于访问一些特殊资源，尤其临界资源。
- Concurrent：对应`DISPATCH_QUEUE_CONCURRENT`，实际上是global queue，具有真正的并发能力，任务执行的次序是随机的。
- Main：是一个Serial队列，用来维护在主线程上执行的所有任务。

### 优先级Priority
GCD中，所有任务都可以指定优先级，共分为四种：
- `DISPATCH_QUEUE_PRIORITY_HIGH`：最高优先级；
- `DISPATCH_QUEUE_PRIORITY_DEFAULT`：默认优先级；
- `DISPATCH_QUEUE_PRIORITY_LOW`：较低优先级；
- `DISPATCH_QUEUE_PRIORITY_BACKGROUND`：最低，常用于处理IO任务。

不过，任务优先级现在被另一个特性**服务质量QOS**所取代，QOS即Quality of Service。它有五个值，和优先级有一定的对应关系。

- `QOS_CLASS_USER_INTERACTIVE`：表示主线程事件循环相关事件，往往需要更新UI，比如绘制、动画事件。这个级别的任务要保持小规模。
- `QOS_CLASS_USER_INITIATED`：表示由用户发起的，需要等待结果的异步任务，比如创建一个任务，并用进度条显示进度。
- `QOS_CLASS_DEFAULT`：表示来自系统的任务，在这种场景中，任务没有额外说明信息。
- `QOS_CLASS_UTILITY`：表示不需要立即等待执行结果的任务，这类任务往往更加注重性能考量，显示进度与否并不重要。经常用来进行计算、I/O、网络请求等任务。
- `QOS_CLASS_BACKGROUND`：表示不由用户主动发起的任务，用户也不需要知道它的存在，唯一要考量的就是性能。比如预加载任务。

对于global queue，也就是系统级的并发队列，任务优先级和QOS之间的对应关系如下：
|Priority|Quality of Service|
|-|-|
|DISPATCH_QUEUE_PRIORITY_HIGH|QOS_CLASS_USER_INITIATED|
|DISPATCH_QUEUE_PRIORITY_DEFAULT|QOS_CLASS_DEFAULT|
|DISPATCH_QUEUE_PRIORITY_LOW|QOS_CLASS_UTILITY|
|DISPATCH_QUEUE_PRIORITY_BACKGROUND|QOS_CLASS_BACKGROUND|

```objc
dispatch_queue_t main, serial, concur1, concur2, concur3;

// 主线程队列，用来维护在主线程执行的任务执行次序
main = dispatch_get_main_queue();

// 串行队列
serial = dispatch_queue_create("COM.WALKER.S", DISPATCH_QUEUE_SERIAL);

// 并发队列
concur1 = dispatch_queue_create("COM.WALKER.C", DISPATCH_QUEUE_CONCURRENT);
// 下面两种是同一回事，但是推荐后面的写法
concur2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
concur3 = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
```

## 实践
### 创建任务
任务表示一段逻辑上完整且具有意义的代码块，可分为同步任务和异步任务。
- 同步任务。使用`dispatch_sync`创建，只有当提交的任务完成时，才会返回。使用的不多，因为容易造成死锁。
- 异步任务。使用`dispatch_async`创建，提交任务之后立即返回，队列属性决定是串行还是并发执行。相互独立的串行队列可并行处理。推荐使用，在需要大量时间才能完成的任务，尤其与UI无关的任务。比如，网络请求，IO，数据库读写时，必须使用它来创建。

```objc
// 在串行队列serial中执行同步任务
dispatch_sync(serial, ^{
    [self do...]
});

// 在并行队列concur1中执行异步任务
dispatch_async(concur1, ^{
    [self do...]
});

// 下载图片
dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
     NSURL * url = [NSURL URLWithString:@"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg"];
     NSData * data = [[NSData alloc]initWithContentsOfURL:url];
     UIImage *image = [[UIImage alloc]initWithData:data];
     if (data != nil) {
            // 在主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
     }
});
```

### 单次任务dispatch_once
在一些场景中，某个任务只被允许执行一次，比如创建单例。

```objc
// 单次任务
- (void)doOnceTask{
    static NSData *data;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"some-url"]];
    });
}

// 单例
+ (instancetype)sharedManager{
    static WRSnippetManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [WRSnippetManager new];
    });
    return manager;
}
```

### 延迟执行dispatch_after
延迟执行的使用场景很多，比如显示一些反馈信息给用户，但需要过一小段时间之后隐藏，如登录成功、失败，上传任务完成等。

```objc
/**
时间单位：
    秒：NSEC_PER_SEC
    毫秒：NSEC_PER_MSEC
    纳秒：NSEC_PER_USEC
*/
// 延迟2秒后执行
dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
dispatch_after(delayTime, dispatch_get_main_queue(), ^{
    [self do...]
});

```

### dispatch_barrier
GCD的`dispatch_barrier`相关API和NSOperationQueue的`addBarrierBlock:`类似，都可以保证在当前加入队列的任务执行时，前面已经加入的所有任务都执行完成，但dispatch_barrier更加强大灵活。用它可以高效地实现读写问题，即单一资源的线程安全问题。

注意：**使用Dispatch Barrier API时，Dispatch Queue必须是`DISPATCH_QUEUE_CONCURRENT`类型的。**

下面是一个**多读单写**实现。

```objc
@implementation GCDQueueExample{
    dispatch_queue_t wrQueue;
    NSMutableDictionary *userInfo;
}

- (instancetype)init{
    if ((self = [super init])) {
        wrQueue = dispatch_queue_create("COM.WALKER.WRQ", DISPATCH_QUEUE_CONCURRENT);
        userInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    // 如果调用者传入的是一个NSMutableString，在返回之后如果修改key值，则可能出错
    // 所以，为了避免这些问题，对key进行copy
    key = [key copy];
    dispatch_barrier_async(wrQueue, ^{
        if (key && value) {
            [self->userInfo setValue:value forKey:key];
        }
    });
}

- (id)valueForKey:(NSString *)key{
    __block id value = nil;
    dispatch_barrier_sync(wrQueue, ^{
        value = [userInfo objectForKey:key];
    });
    return value;
}
```

在这个例子中，写操作是异步执行，读操作是同步执行。因为对于很多场景，只要能够按照调用者的意图写入数据就可以了，至于要不要等待并不重要；而对于读，能够立即获得数据是值得的。

### dispatch_apply
利用dispatch_apply可以快速迭代，因为可以并行执行任务。

```objc
for (int i=0; i<1e6; i++) {
    // ...
}

dispatch_apply(1e6, DISPATCH_APPLY_AUTO, ^(size_t x) {
    // ...
});
```

但是呢🤔，经过测试发现：*在一般任务上dispatch_apply比for循环还慢。*

