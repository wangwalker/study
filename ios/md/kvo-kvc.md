# KVO
## 简介
Key-Value Observing是Objective-C的一个消息机制，它让特定对象的**属性的变化**可以被其他对象观测。这种消息机制，特别适合用在模型层和控制器层之间，作为**实现解耦**的有效方式。利用KVO实现观察者模式将变得非常容易。

通过KVO，既可以观测简单属性，比如标量、对象，也可以观测集合类对象，比如NSMutableArray、NSMutableSet等。

## 使用

首先请注意：KVO是同步发生的，并且注册行为和接收行为必须在同一个线程上进行。因此，应该避免在多线程使用KVO。

一般而言，使用KVO需要三步：
1. 要确保有一个被观测对象；
2. 通过 `addObserver:forKeyPath:options:context:` 注册观察者，并且让观察者实现`observeValueForKeyPath:ofObject:change:context: `，在接收到通知消息后实现相应的处理；
3. 当不再需要观测时，通过 `removeObserver:forKeyPath:` 移除观察者。

下面通过一个颜色空间转换——从LAB到RGB之间的例子说明。

在KVO中，提供了一种表示属性之间依赖关系的机制，可以用来实现比较复杂的观察行为。比如在将某种颜色从LAB颜色空间向RGB颜色空间转换时，并不是简单的一对一的依赖关系，而是Red依赖于LAB的L值，green依赖于L和A，blue依赖于L和B。

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

通过上面的依赖关系，系统就会在L改变时更新R，在L、A之一或同时改变时更新B，在L、B之一或同时改变时修改B，而在R、G、B其中之一或多个改变时更新color的值。

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
    id oldValue = change[NSKeyValueChangeOldKey];
    id newValue = change[NSKeyValueChangeNewKey];
    NSLog(@"update bgcolor, old: %@, new: %@", oldValue, newValue);
    self.view.backgroundColor = self.labColorConverter.color;
}
```

在这里面，有一个比较特殊的参数`Context`，在大多数情况下传入`NULL`就可以了，但如果想针对消息发送者做一些特殊处理，在这里传入特定参数，就可以在处理消息时轻松的做相应的处理了。

```objc
- (void)setConvertorObserverWithContext{
    [self.labColorConverter addObserver:self
                             forKeyPath:@"color"
                                options:(NSKeyValueObservingOptionInitial|
                                         NSKeyValueObservingOptionOld|
                                         NSKeyValueObservingOptionNew)
                                context:kColorConvertorKVOContextSomeOne];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context == kColorConvertorKVOContextSomeOne) {
        // 做相应的处理
    }
    // ...
}
```

另外，对于参数Options而言，除过新值和就值之分之外，`NSKeyValueObservingOptionInitial`表示在注册时也会触发消息，而`NSKeyValueObservingOptionPrior`表示在修改之前也发送消息，可通过`NSKeyValueChangeNotificationIsPriorKey`区分是修改之前，还是修改之后的消息。

```objc
if ([change[NSKeyValueChangeNotificationIsPriorKey] boolValue]) {
    // 改变之前
} else {
    // 改变之后
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

详细例子见：[通过KVO实现颜色空间LAB到RGB之间的转换](https://github.com/Walkerant/Study/blob/master/ios/Snippets/Snippets/Message/Controller/ColorConvertorViewController.m)

在这里，一定要注意：
- 在合适的时机，移除观察者，否则容易发生内存泄漏；
- 不要多次移除同一个观察者，否则应用将Crash掉。

至于KVO的实现原理，是根据Runtime提供的动态能力Method Swizzling
。先在运行期动态创建一个继承自被观察类的新类，其名为`NSKVONotifying_OriginalClassName`，里面会添加`willChangeValueForKey:`和`didChangeValueForKey:`。然后在注册KVO时，会将被观察者对象的isa指针指向新创建的类。最后在被观察者的属性被修改时，调用相关方法执行。

## 手动发送

基于NSObject的一些基本实现，Objective-C默认会自动发送**关于对象属性变化的一切消息**。具体而言，编译器会在对象的访问器方法中修改属性的前后分别调用两个方法：
- `- (void)willChangeValueForKey:(NSString *)key` 
- `- (void)didChangeValueForKey:(NSString *)key`

如果想手动发送这些消息，那就手动调用上面这两个方法。但前提是通过重写类的 `automaticallyNotifiesObserversForKey:` ，关闭自动发送机制。

```objc
+ (BOOL)automaticallyNotifiesObserversOfName{
    return NO;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
    if ([[NSArray arrayWithObjects:@"name", nil] containsObject:key]) {
        return NO;
    }
    return YES;
}

- (void)setName:(NSString *)name{
    [self willChangeValueForKey:@"name"];
    _name = name;
    [self didChangeValueForKey:@"name"];
}
```

但注意在大多数情况下，我们都不需要手动发送这些消息，因为这样做并不会带来可观的性能提升，而且还容易出现难以调试的Bug。

# KVC

Key-Value-Coding同样是一种非常有用的机制，它允许Objective-C中的对象可以像字典NSDictionary一样，通过一个键Key就可以访问值或设置值，这个键就是对象属性的字符串名称。对于对象的标量属性，KVC将自动包装为对应的NSNumber类。

## 使用
不要小看这一机制，在某些场景中，利用KVC可明显提高代码质量。

下面通过一个类似通讯录的例子说明KVC的强大之处。

```objc
// Contact类
@interface ClassmateContact : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *city;

@end

// 视图控制器
@interface ClassmateContactViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) ClassmateContact *contact;
@end

@implementation ClassmateContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contact = [ClassmateContact new];
    self.contact.name = @"Yapeng Wang";
    self.contact.nickname = @"Walker";
    self.contact.email = @"wwalkerrr@gmail.com";
    self.contact.city = @"Xi'an Shannxi";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateTextFields];
}

- (NSArray *)contactStringKeys;{
    return @[@"name", @"nickname", @"email", @"city"];
}

- (UITextField *)textFieldForModelKey:(NSString *)key{
    return [self valueForKey:[key stringByAppendingString:@"Field"]];
}

// 更新UI
- (void)updateTextFields{
    for (NSString *key in [self contactStringKeys]) {
        [[self textFieldForModelKey:key] setText:[self.contact valueForKey:key]];
    }
}

// 更新Model
- (void)textFieldDidEndEditing:(UITextField *)textField{
    for (NSString *key in [self contactStringKeys]) {
        UITextField *tf = [self textFieldForModelKey:key];
        if (tf == textField) {
            [self.contact setValue:textField.text forKey:key];
            break;
        }
    }
    NSLog(@"contact:%@", self.contact);
}

@end
```

通过这几十行代码就可以实现Model和View之间的绑定，非常高效。详细见：[使用KVC快速绑定Model和View](https://github.com/Walkerant/Study/blob/master/ios/Snippets/Snippets/Message/Controller/ClassmateContactViewController.m)。

## 键路径KeyPath
KVC 同样允许我们通过关系来访问对象。假设 `person` 对象有属性 `address`，`address` 有属性 `city`，我们可以这样通过 `person` 来访问 `city`：

```objc
[person valueForKeyPath:@"address.city"]
```

### 集合操作

KVC另一个更强大的功能是对于集合类的操作。比如，可以获取数组中最大的值。

```objc
SArray *a = @[@4, @84, @2];
NSLog(@"max = %@", [a valueForKeyPath:@"@max.self"]);
```

请注意，这里用的是 `valueForKeyPath:` ，而不是 `valueForKey:` 。

这种操作的语法结构是这样的：

![基于KVC的集合聚合操作](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/art/keypath.jpg)

其中，中间的操作符可分为三类，包括：
- 聚合操作符，根据特定键Key做聚合计算，最后得到一个单值对象。
    - @avg
    - @count
    - @min
    - @max
    - @sum
- 数组操作符，根据特定键Key取出相应的值，最后得到一个数组对象。
    - @distinctUnionOfObjects
    - @unionOfObjects
- 嵌套操作符，操作对象为数组的数组，最后得到的结果也是一个数组对象。
    - @distinctUnionOfArrays
    - @unionOfArrays
    - @distinctUnionOfSets

详细例子可见：[Key-Value Coding Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/CollectionOperators.html#//apple_ref/doc/uid/20002176-SW9)。

## KVV

KVV即Key-Value Validating，用来验证属性的API。一般情况下，我们都需要在控制器中对某些输入值进行验证，之后才能进行后续的操作。

结合KVV根据键验证值时，一个强大的能力在于可以对值进行操作，比如对字符串进行去空白处理等。

```objc
- (BOOL)validateName:(NSString * _Nullable __autoreleasing *)name error:(NSError *__autoreleasing  _Nullable *)error{
    if (*name == nil) {
        *name = @"";
        return YES;
    }
    *name = [*name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return YES;
}
```

# 参考
- [Apple官方文档1](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html#//apple_ref/doc/uid/10000177-BCICJDHA)
- [Apple官方文档2](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/index.html#//apple_ref/doc/uid/10000107-SW1)
- [Objc.io中国期刊7-3](https://objccn.io/issue-7-3/)