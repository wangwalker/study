# KVO
## 简介
Key-Value Observing是Objective-C的一个重要机制，它让特定对象**属性的变化**可以被其他对象观测。它是非常有用的消息机制，尤其在模型层和控制器层之间，可以作为**实现解耦**的有效方式。

通过KVO，可以观测的属性既可以是简单的属性，比如标量、对象，也可以是比较复杂的集合类对象，比如NSArray、NSSet等。

## 使用

一般而言，使用KVO需要三步：
1. 要保证有一个被观测对象；
2. 为被观测对象注册一个观察者，需要通过 `addObserver:forKeyPath:options:context:` 完成注册，并且让观察者实现`observeValueForKeyPath:ofObject:change:context: `，在接收到通知消息后实现相应的处理；
3. 当不再需要观测时，通过 `removeObserver:forKeyPath:` 移除观察者。

下面通过一个颜色空间转换——从LAB到RGB之间的例子说明。

在Foundation中，提供了表示属性依赖的机制，可以用来实现比较复杂的依赖关系。比如在将颜色从LAB颜色空间向RGB颜色空间转换时，并不是简单的一对一的依赖关系，而是Red依赖于LAB的L值，green依赖于L和A，blue依赖于L和B。

```objc
// 根据Key分别指定依赖关系
+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key{
    
}
// 分开指定
+ (NSSet *)keyPathsForValuesAffecting<键名>
```

对于这个例子，具体的依赖关系如下：

```objc
+ (NSSet<NSString *> *)keyPathsForValuesAffectingRedComponent{
    return [NSSet setWithObject:@"lComponent"];
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingGreenComponent{
    return [NSSet setWithObjects:@"lComponent", @"aComponent", nil];
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingBlueComponent{
    return [NSSet setWithObjects:@"lComponent", @"bComponent", nil];
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingColor{
    return [NSSet setWithObjects:@"redComponent", @"greenComponent", @"blueComponent", nil];
}
```

下面，我们在控制器中注册观察者并实现对应的处理逻辑。

```objc
@interface ColorConvertorViewController ()
@property (nonatomic, strong) ColorConvertor* labColorConverter;
@end

@implementation ColorConvertorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLabColorConverter:[ColorConvertor new]];
    [self setConvertorObserver];
    [self.view setBackgroundColor:[UIColor lightTextColor]];
}

- (void)setConvertorObserver {
    [self.labColorConverter addObserver:self
                             forKeyPath:@"color"
                                options:NSKeyValueObservingOptionInitial
                                context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"color"]) {
        [self performSelector:@selector(updateColor:) withObject:change];
    }
}

- (void)updateColor:(NSDictionary*)change {
    NSLog(@"update bgcolor: %@", change);
    self.view.backgroundColor = self.labColorConverter.color;
}
```

还可以通过一个[辅助类](https://github.com/objcio/issue-7-lab-color-space-explorer/blob/master/Lab%20Color%20Space%20Explorer/KeyValueObserver.m)，将 -addObserver:forKeyPath:options:context:，-observeValueForKeyPath:ofObject:change:context:和-removeObserverForKeyPath: 封装在一起，可有效减少控制器中的代码量，增加可读性。

```objc
- (void)setLabColorConverter:(ColorConvertor *)labColorConverter{
    _labColorConverter = labColorConverter;
    
    _colorObserveToken = [KeyValueObserver observeObject:labColorConverter
                                                 keyPath:@"color"
                                                  target:self
                                                selector:@selector(updateColor:)
                                                 options:NSKeyValueObservingOptionInitial];
}

- (void)updateColor:(NSDictionary*)change {
    self.view.backgroundColor = self.labColorConverter.color;
}
```

详细例子见：[通过KVO实现颜色空间LAB到RGB之间的转换](https://github.com/Walkerant/Study/blob/master/ios/Snippets/Snippets/KeyValue/Controller/ColorConvertorViewController.m)

# KVC

# 参考
- [Apple官方文档1](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html#//apple_ref/doc/uid/10000177-BCICJDHA)
- [Apple官方文档2](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/index.html#//apple_ref/doc/uid/10000107-SW1)
- [Objc.io中国期刊7-3](https://objccn.io/issue-7-3/)