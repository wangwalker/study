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