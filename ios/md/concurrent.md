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

完整示例见: [直接通过创建NSThread加载用户头像列表]()

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

完整示例见: [通过继承NSThread加载用户头像列表]()

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

完整代码见：[NSOperation实践]()

