# NSArray
## 排序sort
### Selector
通过Selector排序是最常用的方法，而且也是速度最快的。`sortedArrayUsingSelector:`:

```objc
NSArray *array = @[@"John Appleseed", @"Tim Cook", @"Hair Force One", @"Michael Jurewitz"];

// 字符串通常使用`localizedCaseInsensitiveCompare:`、`localizedCompare:`，或者最普通的`compare:`
NSArray *sortedArray = [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

// 数字排序通常使用`compare:`即可
NSArray *numbers = @[@9, @5, @11, @3, @1];
NSArray *sortedNumbers = [numbers sortedArrayUsingSelector:@selector(compare:)];
```

### Block
使用Block进行排序更加方便，使用地更多。`sortedArrayUsingComparator:`

```objc
NSArray *strs = @[@"John Appleseed", @"Tim Cook", @"Hair Force One", @"Michael Jurewitz"];

// NSComparator是一个预定义的Block：typedef NSComparisonResult (^NSComparator)(id obj1, id obj2);
sortedStrs = [strs sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    return [obj1 caseInsensitiveCompare:obj2];
}];

// 还可以设置option，用`NSSortConcurrent`提高排序速度
sortedStrs = [strs sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 caseInsensitiveCompare:obj2];
    }];
```

### 函数指针
也可以通过更加原始的函数指针来排序。`sortedArrayUsingFunction:context:`

```objc
// 先定义函数
NSInteger sort(id obj1, id obj2, void* context) {
    if ([obj1 valueForKey:@"length"]) {
        if ([obj1 length] > [obj2 length]) {
            return NSOrderedDescending;
        }
    } else {
        if ([obj1 intValue] > [obj2 intValue]) {
            return NSOrderedDescending;
        }
    }
    
    return NSOrderedAscending;
}

NSArray *strs = @[@"John Appleseed", @"Tim Cook", @"Hair Force One", @"Michael Jurewitz"];

sortedStrs = [strs sortedArrayUsingFunction:sort context:nil];

// 还可以通过`sortedArrayHint`提高排序速度
sortedStrs = [strs sortedArrayUsingFunction:sort context:nil hint:[strs sortedArrayHint]];
```

### NSSortDescriptor
用官方话语来说，`NSSortDescriptor`就是为了对一系列对象进行排序操作，具体而言就是要指定一个`key`，也就是对象的`property`作为基准，进行排序。

```objc
NSArray *strs = @[@"John Appleseed", @"Tim Cook", @"Hair Force One", @"Michael Jurewitz"];

// 通过NSString的length属性进行排序
sortedStrs = [strs sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"length" ascending:YES]]];
```

用一个比较真实的例子测试一下`NSSortDescriptor`的用法。下面定义了一个Product类：

```objc
// 📃 WRProduct.h
@interface WRProduct : NSObject

@property (nonatomic, assign) NSUInteger sales;

@property (nonatomic, copy) NSString *name;

+ (instancetype)productWithName:(NSString *)name sales:(NSUInteger)sales;

@end

@interface WRProductLab : NSObject

+ (NSArray<WRProduct *>*)testProducts;

+ (WRProduct *)randomProductFromTest;

@end

// 📃 WRProduct.m
@implementation WRProduct

+ (instancetype)productWithName:(NSString *)name sales:(NSUInteger)sales{
    return [[self alloc] initWithName:name sales:sales];
}

- (instancetype)initWithName:(NSString *)name sales:(NSUInteger)sales{
    if ((self = [super init])) {
        self.name = name;
        self.sales = sales;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"product name: %@, sales: %lu", self.name, (unsigned long)self.sales];
}

@end

@implementation WRProductLab

+ (NSArray<WRProduct *> *)testProducts{
    NSMutableArray *m = [@[] mutableCopy];
    
    for (int i=0; i<10; i++) {
        NSUInteger sales = arc4random()%10000;
        [m addObject:[WRProduct productWithName:[self randomName] sales:sales]];
    }
    
    return [m copy];
}

+ (WRProduct *)randomProductFromTest{
    NSArray *rp = [self testProducts];
    return [rp objectAtIndex:(arc4random()%rp.count)];
}

+ (NSString *)randomName{
    static NSString *alphb = @"abcdefghijklmnopqrstuvwxyz";
    NSUInteger length = arc4random()%10;
    NSMutableString *name = [@"" mutableCopy];
    
    for (int i=0; i<length; i++) {
        NSString *randomLetter = [alphb substringWithRange:NSMakeRange(arc4random()%25, 1)];
        [name appendString:randomLetter];
    }
    
    return [[name copy] capitalizedString];
}

@end
```

排序:
```objc
NSArray *products = [WRProductLab testProducts];
NSLog(@"row products: %@", products);

NSArray *sortedProducts = [products sortedArrayUsingDescriptors:@[
    [NSSortDescriptor sortDescriptorWithKey:@"name"
                                    ascending:YES
                                    selector:@selector(localizedCaseInsensitiveCompare:)],
    [NSSortDescriptor sortDescriptorWithKey:@"sales"
                                    ascending:NO]]];
NSLog(@"sorted products: %@", sortedProducts);

// 结果：
/**
row products: (
    "product name: Bk, sales: 5290",
    "product name: Wid, sales: 1284",
    "product name: Waqb, sales: 9422",
    "product name: Cxwcj, sales: 441",
    "product name: Llt, sales: 2378",
    "product name: Kmgfo, sales: 683",
    "product name: Dqmloqen, sales: 8969",
    "product name: Glxpnqh, sales: 206",
    "product name: Arw, sales: 5866",
    "product name: Kgorl, sales: 7557"
)
sorted products: (
    "product name: Arw, sales: 5866",
    "product name: Bk, sales: 5290",
    "product name: Cxwcj, sales: 441",
    "product name: Dqmloqen, sales: 8969",
    "product name: Glxpnqh, sales: 206",
    "product name: Kgorl, sales: 7557",
    "product name: Kmgfo, sales: 683",
    "product name: Llt, sales: 2378",
    "product name: Waqb, sales: 9422",
    "product name: Wid, sales: 1284"
)
*/
```
## 查找search
查找是信息处理中最常用的操作之一，小到对单个值的查找，大到企业级搜索和搜索引擎，其原理是相通的。

### 顺序查找
顺序查找表示从序列的第一个值开始，直到找到某个特定值，或者直到最后一个值为止。在OC中，有下面这些方法可用于查找：
- `indexOfObject:`: 根据给定的值进行查找，通过`isEqual:`判断是否满足等值关系。
- `indexOfObjectIdenticalTo:`: 根据**内存地址**进行判断是否等值。
- `indexOfObjectPassingTest:`: 根据特定条件筛选多个对象，而非单个。
- `indexOfObjectWithOptions:passingTest:`： 同上，只是多了一个参数，用来控制遍历行为，可并行或者逆序。
- `filteredArrayUsingPredicate:`：条件过滤。

```objc
NSArray *strs = @[@"John Appleseed", @"Tim Cook", @"Hair Force One", @"Michael Jurewitz"];

// 1. 搜索单个元素, 根据`isEqual:`判断
NSInteger index = [strs indexOfObject:@"Tim"];
if (index == NSNotFound) {
    NSLog(@"Have not found 'Tim' in strs");
} else {
    NSLog(@"find `Tim` at index: %zd", index);
}

// 根据内存地址判断
index = [strs indexOfObjectIdenticalTo:@"Tim Cook"];
NSLog(@"find `Tim Cook` at index: %zd", index);

// 根据条件查找，还可以设置`Range`等条件
index = [strs indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    return [obj length] < 10;
}];
NSLog(@"find the first string(length<10) at index: %zd", index);

// 2. 根据条件查找多个元素
NSIndexSet *is = [strs indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj length] > 10) {
        return YES;
    }
    return NO;
}];
NSLog(@"find all strings(length>10) at indexset: %@", is);

// 使用NSPredicate
NSArray *lengthGt10 = [strs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
    return [evaluatedObject length] > 10;
}]];
NSLog(@"all strings(length>10): %@", lengthGt10);

// results:
/**
collections[1885:69544] Have not found 'Tim' in strs
collections[1885:69544] find `Tim Cook` at index: 1
ollections[1885:69544] find the first string(length<10) at index: 1
collections[1885:69544] find all strings(length>10) at indexset: <NSIndexSet: 0x100653b90>[number of indexes: 3 (in 2 ranges), indexes: (0 2-3)]
collections[1885:69544] all strings(length>10): (
    "John Appleseed",
    "Hair Force One",
    "Michael Jurewitz"
)
*/
```

对于上面的Product，先定义`isEqual:`方法：

```objc
- (BOOL)isEqual:(id)object{
    WRProduct *other = (WRProduct *)object;
    return [self.name isEqualToString:other.name] && self.sales == other.sales;
}
```

查找特定product

```objc
NSArray *testProducts = [WRProductLab testProducts];
WRProduct *randomProduct = [testProducts objectAtIndex:arc4random()%testProducts.count];
WRProduct *fakeRandomProduct = [WRProduct productWithName:randomProduct.name sales:randomProduct.sales];

// raw random product
NSLog(@"The index of random product in test products: %zd", [testProducts indexOfObject:randomProduct]);
NSLog(@"The index of identical random product in test products: %zd", [testProducts indexOfObjectIdenticalTo:randomProduct]);

// the fake random product
NSLog(@"The index of random product in test products: %zd", [testProducts indexOfObject:fakeRandomProduct]);
NSLog(@"The index of identical random product in test products: %zd", [testProducts indexOfObjectIdenticalTo:fakeRandomProduct]);

// 结果是前三个为相同的index，最后一个为NSNotFound
```

### 二分查找
二分查找有更快的查找速度`indexOfObject:inSortedRange:options:usingComparator:`，但是有一个条件：序列必须是经过排序的，否则结果是undefined。

```objc
NSArray *strs = @[@"John Appleseed", @"Tim Cook", @"Hair Force One", @"Michael Jurewitz"];
NSLog(@"start search at array: %@", strs);

NSInteger indexBeforeSort = [strs indexOfObject:@"Tim Cook" inSortedRange:NSMakeRange(0, strs.count) options:NSBinarySearchingFirstEqual usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    return [obj1 compare:obj2];
}];

strs = [strs sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
NSInteger indexAfterSort = [strs indexOfObject:@"Tim Cook" inSortedRange:NSMakeRange(0, strs.count) options:NSBinarySearchingFirstEqual usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    return [obj1 compare:obj2];
}];

NSLog(@"The index of 'Tim Cook' before sort is %zd, after sort is %zd", indexBeforeSort, indexAfterSort);
// NSNotFound, 3
```

## 枚举enumerate
### 快速枚举
使用`for ... in`就是快速枚举。

```objc
NSArray *strs = @[@"John Appleseed", @"Tim Cook", @"Hair Force One", @"Michael Jurewitz"];
    
for (NSString *str in strs) {
    NSLog(@"Fast Enumeration, string: %@", str);
}
```

### 下标取值
即传统的for循环。
```objc
NSArray *strs = @[@"John Appleseed", @"Tim Cook", @"Hair Force One", @"Michael Jurewitz"];

for (int idx = 0; idx < strs.count; idx++) {
    id object = strs[idx];
    NSLog(@"For Loop, string: %@", object);
}
```

### Block

```objc
NSArray *strs = @[@"John Appleseed", @"Tim Cook", @"Hair Force One", @"Michael Jurewitz"];

[strs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSLog(@"Block, string: %@, stop:%s", obj, stop);
}];
```

### NSEnumerator

```objc
NSArray *strs = @[@"John Appleseed", @"Tim Cook", @"Hair Force One", @"Michael Jurewitz"];

NSEnumerator *enumerator = [strs objectEnumerator];
id object = nil;
while ((object = enumerator.nextObject) != nil) {
    NSLog(@"NSENumerator, string: %@", object);
}
```

# NSDictionary
## 排序sort

使用细节上和NSArray类似，只不过对于Dictionary的排序，是通过**value**的值进行比较，而非**key**。具体方法有：
- `keysSortedByValueUsingSelector:`
- `keysSortedByValueUsingComparator:`
- `keysSortedByValueWithOptions:usingComparator:`

## 枚举
除过前面NSArray中提及的枚举方法，这里再说一种方法。实际上，它主要用于查找，当不设置任何条件时，就成了枚举。更重要的是，它也可以控制枚举行为是否为并行或者逆序。

```objc
// 广义的查找
[dict keysOfEntriesWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    NSLog(@"key: %@, value: %@", key, obj);
    return YES;
}];

// 用Block枚举
[dict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    NSLog(@"key: %@, value: %@", key, obj);
}];
```

# NSSet
除过逻辑含义的不同，set和array与dictionary的使用方法类似，对照理解即可。