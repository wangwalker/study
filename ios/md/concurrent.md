在iOS开发中，多线程编程实践有多重途径，它们各有侧重。
- NSThread
- GCD
- NSOperation
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

但是呢🤔，经过测试发现：*在一般任务上dispatch_apply比for循环要慢。*

### 任务组`dispatch_group`
任务组`dispatch_group`和任务队列`dispatch_queue`的道理一样，都用来对任务进行约束，但任务组除过约束单个任务之后，还可以约束队列。也就是说，任务组dispatch_group的约束维度更高。

在复杂问题中，任务组dispatch_group是非常必要的，比如监视一组由不同队列组成的任务，在适当时机进行适当处理。

常用的方法有：
- `dispatch_group_create`，创建任务组；
- `dispatch_group_async`，提交任务到特定队列和组；
- `dispatch_group_notify`，在组内任务执行完成之后，通知调用者，以便执行特定任务；
- `dispatch_group_wait`，同步等待已加入组内的所有任务直到完成或者超时，会阻塞当前线程；
- `dispatch_group_enter`，进入任务组，相当于添加任务到特定任务组，一直到`dispatch_group_leave`为止；
- `dispatch_group_leave`，离开任务组，和`dispatch_group_enter`配合使用，表示任务结束。

下面这个例子，通过两个类GCDTaskItem、GCDTaskScheduler来模拟任务组的使用方法。

```objc
@implementation GCDTaskItem

- (instancetype)initWithSleepSeconds:(NSInteger)seconds name:(nonnull NSString *)name queue:(nonnull dispatch_queue_t)queue{
    if (self = [super init]) {
        self.sleepSeconds = seconds;
        self.name = name;
        self.queue = queue;
    }
    return self;
}

- (void)start{
    NSDate *start = [NSDate date];
    NSLog(@"task-%@ start do task.", _name);
    
    [NSThread sleepForTimeInterval:_sleepSeconds];
    NSLog(@"---task-%@ using %.3f seconds finishing task ---", _name, [[NSDate date] timeIntervalSinceDate:start]);
}

- (void)asyncStart{
    NSDate *start = [NSDate date];
    NSLog(@"task-%@ start do task.", _name);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_sleepSeconds * NSEC_PER_SEC)), _queue, ^{
        NSLog(@"---task-%@ using %.3f seconds finishing task ---", self.name, [[NSDate date] timeIntervalSinceDate:start]);
    });
}

@end


@implementation GDCGroupTaskScheduler

- (instancetype)initWithTasks:(NSArray<GCDTaskItem *> *)tasks name:(nonnull NSString *)name{
    if (self = [super init]) {
        self.tasks = tasks;
        self.name = name;
        self.group = dispatch_group_create();
    }
    return self;
}

- (void)dispatchTasksWaitUntilDone{
    NSDate *start = [NSDate date];
    
    NSLog(@"group-%@ start dispatch tasks",_name);
    
    for (GCDTaskItem *task in _tasks) {
        dispatch_group_async(_group, task.queue, ^{
            [task start];
        });
    }
    // 同步【synchronously】等待当前组中的所有队列中的任务完成，会阻塞当前线程
    dispatch_group_wait(_group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group-task-%@ using %.3f seconds finishing task", _name, [[NSDate date] timeIntervalSinceDate:start]);
    NSLog(@"=========================");
}

- (void)dispatchTasksUntilDoneNofityQueue:(dispatch_queue_t)queue nextTask:(GDCGroupTasksCompletionHandler)next{
    NSDate *start = [NSDate date];
    
    NSLog(@"group-%@ start dispatch tasks",_name);
    
    for (GCDTaskItem *task in _tasks) {
        dispatch_group_async(_group, task.queue, ^{
            [task start];
        });
    }
    
    dispatch_group_notify(_group, queue, ^{
        NSLog(@"group-task-%@ using %.3f seconds finishing task", self.name, [[NSDate date] timeIntervalSinceDate:start]);
        NSLog(@"=========================");
        
        if (next) {
            next();
        }
    });
}

@end
```

初始化任务：

```objc
- (void)initGroupTasks{
    queue1 = dispatch_get_global_queue(0, 0);
    queue2 = dispatch_get_global_queue(0, 0);
    
    tasks1 = @[
        [[GCDTaskItem alloc] initWithSleepSeconds:2 name:@"T11" queue:queue1],
        [[GCDTaskItem alloc] initWithSleepSeconds:5 name:@"T12" queue:queue2]
    ];
    tasks2 = @[
        [[GCDTaskItem alloc] initWithSleepSeconds:1 name:@"T21" queue:queue1],
        [[GCDTaskItem alloc] initWithSleepSeconds:3 name:@"T22" queue:queue2]
    ];
    
    scheduler1 = [[GDCGroupTaskScheduler alloc] initWithTasks:tasks1 name:@"S1"];
    scheduler2 = [[GDCGroupTaskScheduler alloc] initWithTasks:tasks2 name:@"S2"];
}
```

使用dispatch_group_wait同步等待任务完成：

```objc
- (void)performTasksWithWait{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        [self->scheduler1 dispatchTasksWaitUntilDone];
        [self->scheduler2 dispatchTasksWaitUntilDone];
    });
}

// 结果：
/**
2020-11-13 09:27:18.443424+0800 Snippets[16360:1149514] group-S1 start dispatch tasks
2020-11-13 09:27:18.445682+0800 Snippets[16360:1149517] task-T11 start do task.
2020-11-13 09:27:18.447914+0800 Snippets[16360:1149516] task-T12 start do task.
2020-11-13 09:27:20.452293+0800 Snippets[16360:1149517] ---task-T11 using 2.007 seconds finishing task ---
2020-11-13 09:27:23.452638+0800 Snippets[16360:1149516] ---task-T12 using 5.005 seconds finishing task ---
2020-11-13 09:27:23.453117+0800 Snippets[16360:1149514] group-task-S1 using 5.010 seconds finishing task
2020-11-13 09:27:23.453377+0800 Snippets[16360:1149514] =========================
2020-11-13 09:27:23.454756+0800 Snippets[16360:1149514] group-S2 start dispatch tasks
2020-11-13 09:27:23.454999+0800 Snippets[16360:1149516] task-T21 start do task.
2020-11-13 09:27:23.455093+0800 Snippets[16360:1149517] task-T22 start do task.
2020-11-13 09:27:24.457332+0800 Snippets[16360:1149516] ---task-T21 using 1.002 seconds finishing task ---
2020-11-13 09:27:26.457219+0800 Snippets[16360:1149517] ---task-T22 using 3.002 seconds finishing task ---
2020-11-13 09:27:26.457524+0800 Snippets[16360:1149514] group-task-S2 using 3.003 seconds finishing task
2020-11-13 09:27:26.457746+0800 Snippets[16360:1149514] =========================
*/
```

使用dispatch_group_notify异步等待完成通知：

```objc
- (void)performTasksWithNofity{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        [self->scheduler1 dispatchTasksUntilDoneAndNofity];
        [self->scheduler2 dispatchTasksUntilDoneAndNofity];
    });
}

// 结果：
/**
2020-11-13 09:41:58.804265+0800 Snippets[16462:1157254] group-S1 start dispatch tasks
2020-11-13 09:41:58.805894+0800 Snippets[16462:1157254] group-S2 start dispatch tasks
2020-11-13 09:41:58.806184+0800 Snippets[16462:1157255] task-T11 start do task.
2020-11-13 09:41:58.806658+0800 Snippets[16462:1157532] task-T12 start do task.
2020-11-13 09:41:58.807275+0800 Snippets[16462:1157254] task-T21 start do task.
2020-11-13 09:41:58.808840+0800 Snippets[16462:1157533] task-T22 start do task.
2020-11-13 09:41:59.815052+0800 Snippets[16462:1157254] ---task-T21 using 1.008 seconds finishing task ---
2020-11-13 09:42:00.812159+0800 Snippets[16462:1157255] ---task-T11 using 2.006 seconds finishing task ---
2020-11-13 09:42:01.816091+0800 Snippets[16462:1157533] ---task-T22 using 3.007 seconds finishing task ---
2020-11-13 09:42:01.816527+0800 Snippets[16462:1157182] group-task-S2 using 3.011 seconds finishing task
2020-11-13 09:42:01.816773+0800 Snippets[16462:1157182] =========================
2020-11-13 09:42:03.813934+0800 Snippets[16462:1157532] ---task-T12 using 5.007 seconds finishing task ---
2020-11-13 09:42:03.814274+0800 Snippets[16462:1157182] group-task-S1 using 5.010 seconds finishing task
2020-11-13 09:42:03.814508+0800 Snippets[16462:1157182] =========================
*/
```

可以看见，用任务组`dispatch_group`约束来自不同队列的任务之后，程序依然可按照预期的流程执行。

详细示例见：[使用dispatch_group约束任务的执行流程](https://github.com/Walkerant/Study/blob/master/ios/Snippets/Snippets/Concurrent/Controller/WRGCDViewController.m)

### 信号量`dispatch_semaphore`
信号量适合控制一个（组）仅限于有限个用户访问的共享资源，信号量的初始值表示可同时访问的数量，或者共享资源的数量。

信号量只有两种操作方式，`wait`和`signal`，前者表示信号量减一，后者表示信号量加一。如果信号量为0，则需要等待，直至信号量为正方可进行后续操作。

在GCD中，信号量`dispatch_semaphore`的使用方法包括：
- `dispatch_semaphore_create`，创建信号量，需要一个>=0的数初始化；
- `dispatch_semaphore_wait`，信号量减一；
- `dispatch_semaphore_signal`，信号量加一。

下面这个例子演示了海底捞火锅店的营业活动。

```objc
@implementation GCDSemaphoreExample
{
    dispatch_semaphore_t chairs; // 表示海底捞的椅子数量
}

- (instancetype)init{
    if ((self = [super init])) {
        chairs = dispatch_semaphore_create(10);
    }
    return self;
}

- (void)startOperation{
    NSLog(@"HiHotPot start operation");
        
    __block NSTimer *timer = [NSTimer timerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self consumeHiHotPot];
    }];
    
    [NSRunLoop.mainRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [timer invalidate];
        NSLog(@"HiHotPot end operation");
    });
}

- (void)consumeHiHotPot{
    NSLog(@"start waiting for chair...");
    dispatch_semaphore_wait(chairs, DISPATCH_TIME_FOREVER);
    NSLog(@"starting eating... ");
    
    NSUInteger duration = arc4random()%5;
    // 一定时间之后吃完，时间随机
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"finish eating...");
        dispatch_semaphore_signal(self->chairs);
    });
}

@end
```

完整示例见：[用信号量模拟海底捞的营业活动](https://github.com/Walkerant/Study/blob/master/ios/Snippets/Snippets/Concurrent/Model/GCDSemaphoreExample.m)

### 调度块dispatch_block
调度块是根据现有的block对象，根据特定信息在堆上创建一个新的调度块对象。

我们都知道，直接用GCD创建的任务一旦完成创建，就不能取消，只能等待执行。这在有些场景中就会出现问题，而调度块就能实现**取消**，但也有个条件：**此任务还没有被执行**。

而且，它也可以结合任务组一起使用。

常用方法有：
- `dispatch_block_create`，创建，需要制定flag；
- `dispatch_block_perform`，同步执行，完成之后释放资源；
- `dispatch_block_wait`，等待直到block完成，或者超时；如果已完成则直接返回；
- `dispatch_block_notify`，提交一个完成通知；
- `dispatch_block_cancel`，取消一个调度块对象，只能在未执行之前被调用。

### dispatch_source
Dispatch Source API是一组对低层次系统对象进行监控的接口，比如监视进程变化、内存压力、文件系统等。

需要注意的是，创建好特定类型的Dispatch Source之后，**要通过`dispatch_resume`或者`dispatch_activate`（更推荐）进行激活**，因为它们是以非活动状态创建的。

#### 进程PROC
用Dispatch Source监控进程状态的变化，比如退出、fork子进程等。

```objc
processSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC, getpid(), DISPATCH_PROC_FORK, DISPATCH_TARGET_QUEUE_DEFAULT);
if (!processSource)
    return;

NSLog(@"start monitor process...");

dispatch_source_set_event_handler(processSource, ^{
    NSLog(@"process forked, please check!");
    dispatch_source_cancel(self->processSource);
});

dispatch_activate(processSource);

dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    fork();
});
```

#### 文件系统

监控文件系统的变化，比如读写文件，删除文件。

```objc
- (void)monitorFileDirectoryWithPath:(NSString *)path{
    int const fd = open([path fileSystemRepresentation], O_EVTONLY);
    if (fd < 0) {
         char buffer[80];
         strerror_r(errno, buffer, sizeof(buffer));
         NSLog(@"Unable to open \"%@\": %s (%d)", path, buffer, errno);
         return;
    }
    
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fd,
    DISPATCH_VNODE_WRITE | DISPATCH_VNODE_DELETE | DISPATCH_VNODE_EXTEND, DISPATCH_TARGET_QUEUE_DEFAULT);
    dispatch_source_set_event_handler(source, ^(){
        NSLog(@"The directory changed.");
    });
    
    dispatch_source_set_cancel_handler(source, ^(){
         close(fd);
    });
    
    dirSource = source;
    
    dispatch_activate(dirSource);
    
    NSLog(@"start monitor file system at: %@", path);
}
```

完整示例见：[用Dispatch Source监控文件系统](https://github.com/Walkerant/Study/blob/master/ios/Snippets/Snippets/Concurrent/Model/GCDSourceExample.m)

#### 定时器

在OC中，延迟任务的方法有：
- `performSelector: withObject: afterDelay:`
- `NSTimer timerWithTimeInterval: repeats: block:`
- `NSTimer scheduledTimerWithTimeInterval: repeats: block:`

但这些方法的执行严重依赖于RunLoop。也就是说，它们只有在RunLoop开启的情况下，才能起作用。而如果在非主线程中执行，RunLoop默认是关闭的，这就导致在这些线程中调用会失效的后果。另外，对于NSTimer的创建和销毁，必须在同一个线程内，并且还有内存泄漏的危险。

对于这些问题，稍不注意就会出现。

利用Dispatch Source API创建定时器的做法，可以解决这些问题，而且更加准确灵活。

```objc
timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, DISPATCH_TARGET_QUEUE_DEFAULT);
dispatch_source_set_timer(timerSource, DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC,100ull * NSEC_PER_MSEC);
dispatch_source_set_event_handler(timerSource, ^{
    NSLog(@"time elapses");
});
dispatch_activate(timerSource);

dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    dispatch_source_cancel(self->timerSource);
});
```

注意，`dispatch_source_set_timer(source, start, interval, leeway)`API的最后一个参数`leeway`用来控制延时误差，值越小，对系统性能要求越高，如果对性能要非常高，那么可以设置为`DISPATCH_TIMER_STRICT`。另外，interval设置为`DISPATCH_TIME_FOREVER`表示一次性任务。

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

# pthread

pthread是POSIX线程（POSIX Threads，常被缩写为Pthreads）是POSIX的线程标准，定义了创建和操纵线程的一套基于C语言的API。

所以，pthread几乎在所有计算平台都可使用，是跨平台编程的首选。不过比起上面这些方案，它涉及众多底层知识，这是很多开发者不具备的，而且使用起来也比较麻烦。

具体可参考：[POSIX Threads Programming](https://computing.llnl.gov/tutorials/pthreads/)

# 同步

虽然多线程编程能够有效提高程序性能，但同时也带来了一些问题，比如程序运行逻辑不可控，结果不可预测，对特殊资源的争夺，严重时还有可能让程序奔溃退出。

而同步就是用于解决这些问题的。具体而言，同步是指对一个系统中所发生的事进行协调，在时间上达到一致性与统一性的现象。简单来说，就是让程序按照一定顺序执行，从而产生可控、可预期的结果。

## 原子操作atomic

原子操作是最简单，粒度最小的同步单元。它经常用于在对象属性层面进行控制，不过为了性能考虑，通常使用非原子操作nonatomic。

```objc
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* viewControllerClassName;
@property (nonatomic, copy) NSString* detailedDescription;
```

## @synchronized

@synchronized是使用最简便、最多的同步机制，只需要在其后跟上同步对象即可实现同步。

```objc
- (void)synchronizeWithAtSync{
    syncObject = [NSObject new];
    
    // 这里只是为了测试使用，真实代码中没人会这么用
    [@[@1, @2, @3] enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @synchronized (syncObject) {
            syncObject = obj;
            sleep((int)idx);
            NSLog(@"synchronize object is %@", syncObject);
        }
    }];
}
```

实际上，`@synchronized`是用互斥锁实现的，传入的对象作为唯一标识符来区分代码块是否获得了锁。显然，这个对象粒度越大，代码性能受到的影响越大，比如`@synchronized(self)`这种写法，性能差是在所难免的。

## Lock🔐

锁是最基本的同步机制，比如上面的`@synchronized`就是基于锁实现的。而它的种类也比较多，像互斥锁、递归锁、条件锁等。

### NSLock

NSLock是一中互斥锁，两种基本操作`lock`和`unlock`。

```objc
BOOL moreToDo = YES;
NSLock *theLock = [[NSLock alloc] init];
...
while (moreToDo) {
    /* Do another increment of calculation */
    /* until there’s no more to do. */
    if ([theLock tryLock]) {
        /* Update display used by all threads. */
        [theLock unlock];
    }
}

```

### NSRecursiveLock

可以被一个线程多次获得，而不会引起死锁。NSRecursiveLock会记录上锁和解锁的次数，当二者平衡的时候，才会在此释放锁、上锁。

```objc
NSRecursiveLock *theLock = [[NSRecursiveLock alloc] init];
[theLock lock];
if (value != 0) {
    --value;
    MyRecursiveFunction(value);
}
[theLock unlock];
```

### NSConditionLock

顾名思义，只有满足某个条件时才能获得锁，之后执行代码并释放所后，又可以重新设置条件，这一切都在于使用者。

详细文档见：[Apple开发者文档](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/ThreadSafety/ThreadSafety.html#//apple_ref/doc/uid/10000057i-CH8-SW16).

## 信号量

信号量也是一个常用的同步机制，而且它的性能更高。信号量是一个整型变量，可以对其执行 down 和 up 操作，也就是常见的 P 和 V 操作。
- **down** : 如果信号量大于 0 ，执行 -1 操作；如果信号量等于 0，进程睡眠，等待信号量大于 0；
- **up** ：对信号量执行 +1 操作，唤醒睡眠的进程让其完成 down 操作。

down 和 up 操作需要被设计成原语，不可分割，通常的做法是在执行这些操作的时候屏蔽中断。如果信号量的取值只能为 0 或者 1，那么就成为了 互斥量（Mutex） ，0 表示临界区已经加锁，1 表示临界区解锁。

```c
typedef int semaphore;
semaphore mutex = 1;
void P1() {
    down(&mutex);
    // 临界区
    up(&mutex);
}

void P2() {
    down(&mutex);
    // 临界区
    up(&mutex);
}
```

在OC中，可以借助GCD的`dispatch_semaphore`使用信号量。使用案例见上面GCD部分。

# 总结

下面对上面提及的四种多线程编程进行比较，分析各自的优缺点。

- NSThread
    - 优点：支持面向对象，简单轻量；
    - 缺点：需要自己管理线程的生命周期；
- GCD
    - 优点：高效灵活，功能最强大，自动管理生命周期；
    - 缺点：比较复杂，深入理解不易；
- NSOperation
    - 优点：基于GCD，简单，可设置任务之间的依赖关系和并发数量；
    - 缺点：一旦加入队列，就不能单独取消；
- pthread
    - 优点：轻量，跨平台；
    - 缺点：不好使用。