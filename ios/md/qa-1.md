# Catalog

# 1. `presentingViewController`是`nil`
## Q:
在iOS8之后，当前视图控制器被其他视图控制器通过 `presentViewController:animated:completion:` present之后，后面的视图控制器在 `viewDidLoad` 中获取 `presentingController`、`presentedController` 可能得到`nil`。

## A:
在 `viewDidLoad` 中，并不能保证完整的视图控制器层级结构已加载到它的导航控制器中，如果将这里的逻辑移动到后面的生命周期函数中，比如 `viewWillAppear`、`viewDidAppear `中，将能够成功拿到这些属性。

```objc
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 在此保存在私有属性中
    [self setPresentingController:self.presentingViewController];
}
```

# 2. NSTimer VS CADisplayLink

## Q:
既然NSTimer和CADisplayLink都是定时器，那它们有什么区别呢？

## A:
CADisplayLink是一个根据屏幕刷新频率进行调用的定时器。对硬件设备而言，绘制屏幕内容是一项及其高频的操作，主要是为了获得更好的交互性能。虽然在CPU繁忙时可能有所减少，但总体而言它的精度更高，同时这也隐含的给出了一个使用条件：和UI相关。否则，必要性会大大降低，NSTimer将是更加合适的选择。

NSTimer是一个更加普通，使用范围更加广的定时器，它几乎可以使用在所有场景中，还可以进行单次或多次的区分。不过，这也造成了一个后果——性能欠佳，有时候甚至不能正常工作。
