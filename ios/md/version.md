# SceneDelegate
## 概要

在iOS13中，增加了SceneDelegate，用来处理应用程序多场景的问题。在之前的版本中，大多数应用都选择了Single View Application，也就是单页应用，这对于iPhone上的应用来说基本足够了。但是随着程序的业务场景越来越复杂，尤其对于iPad应用来说，多场景应用是一个非常合理的需求。

并且，在Xcode11中，新建的项目已经默认支持多场景，也因此，工程目录结果相对于之前，有了一些变化，这一变化主要体现在多了两个文件：

```Objc
SceneDelegate.h
SceneDelegate.m
```
SceneDelegate就是用来负责应用程序的各种场景管理工作的。在之前的版本中，AppDelegate全权负责程序Application和界面Window的生命周期。
 
<img src="https://user-gold-cdn.xitu.io/2019/9/25/16d67ed556696568?imageView2/0/w/1280/h/960/format/webp/ignore-error/1" width = "660" alt="之前"/>

```Objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
```

而现在，AppDelegate只负责程序的生命周期，界面场景相关的工作全部交给了SceneDelegate。

<img src="https://user-gold-cdn.xitu.io/2019/9/25/16d67ed556c14392?imageView2/0/w/1280/h/960/format/webp/ignore-error/1" width = "660" alt="之后"/>

<img src="https://user-gold-cdn.xitu.io/2019/9/25/16d67ed558f16c62?imageView2/0/w/1280/h/960/format/webp/ignore-error/1" width = "660" alt="SceneDelegate"/>

在AppDelegate.m中，

```Objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}
- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}
```

在SceneDelegate中，

```Objc
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
}
- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}
...
```

另外，原先AppDelegate中的window属性被移除了，放到了SceneDelegate中。

所以，设置`key window`和`root viewcontroller`也需要做一些修改。具体如下：

在AppDelegate.m中，

```Objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (@available(iOS 13.0, *)) {
        // application will go to scene delegate automatically to get proper scene
    } else {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        ViewController *vc = [[ViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.window setRootViewController:nav];
        [self.window makeKeyAndVisible];
    }
    return YES;
}
```

在SceneDelegate.m中，

```Objc
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.windowScene = windowScene;
        
        ViewController *vc = [[ViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.window setRootViewController:nav];
        [self.window makeKeyAndVisible];
    }
}
```

## Scene Session

每一个Scene中，都有一个scene session对象，用来指定具体的使用场景，还可以保存自定义的用户数据，这有助于场景的状态还原。在AppDelegate中，有两个代理函数可用来管理，一个用于初始化配置，另一个用于关闭场景时要进行的处理：

```Objc
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}
- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}
```

在info.plist文件中，有一项Application Scene Manifest用于进行场景声明。

<img src="https://user-gold-cdn.xitu.io/2019/11/13/16e635c2f072f8f4?imageView2/0/w/1280/h/960/format/webp/ignore-error/1" width = "660" alt="plist" />
