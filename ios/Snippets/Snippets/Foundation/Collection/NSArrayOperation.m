//
//  NSArrayOperation.m
//  Snippets
//
//  Created by Walker on 2020/12/3.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "NSArrayOperation.h"
#import "WRProduct.h"

@implementation NSArrayOperation

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

+ (void)startSort{
    // 字符串排序
    NSArray *strs = @[@"John Appleseed", @"Tim Cook", @"Hair Force One", @"Michael Jurewitz"];
    
    NSLog(@"string array: %@", strs);
    
    NSArray *reversedStr = strs.reverseObjectEnumerator.allObjects;
    NSLog(@"revsered array: %@", reversedStr);
    
    [strs sortedArrayUsingFunction:sort context:nil hint:[strs sortedArrayHint]];
    
    NSArray *sortedStrs = [strs sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSLog(@"sorted(selector) array: %@", sortedStrs);
    
    sortedStrs = [strs sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 caseInsensitiveCompare:obj2];
    }];
    sortedStrs = [strs sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 caseInsensitiveCompare:obj2];
    }];
    NSLog(@"sorted(comparator) array: %@", sortedStrs);
    
    sortedStrs = [strs sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"length" ascending:YES]]];
    NSLog(@"sorted(descriptors) array: %@", sortedStrs);
    
    sortedStrs = [strs sortedArrayUsingFunction:sort context:nil];
    sortedStrs = [strs sortedArrayUsingFunction:sort context:nil hint:[strs sortedArrayHint]];
    NSLog(@"sorted(function pointer) array: %@", sortedStrs);
    
    // 数字排序
    NSArray *numbers = @[@3, @9, @10, @90, @32];
    NSArray *sortedNumbers = [numbers sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"numbers: %@, sorted: %@", numbers, sortedNumbers);
    
}

+ (void)startSortProduct{
    NSArray *products = [WRProductLab testProducts];
    NSLog(@"row products: %@", products);
    
    NSArray *sortedProducts = [products sortedArrayUsingDescriptors:@[
        [NSSortDescriptor sortDescriptorWithKey:@"name"
                                      ascending:YES
                                       selector:@selector(localizedCaseInsensitiveCompare:)],
        [NSSortDescriptor sortDescriptorWithKey:@"sales"
                                      ascending:NO]]];
    NSLog(@"sorted products: %@", sortedProducts);
    
}

+ (void)startEnumerate{
    NSArray *strs = @[@"John Appleseed", @"Tim Cook", @"Hair Force One", @"Michael Jurewitz"];
    
    // 1. for ... in Fast Enumeration
    for (NSString *str in strs) {
        NSLog(@"Fast Enumeration, string: %@", str);
    }
    
    // 2. 传统 for循环
    for (int idx = 0; idx < strs.count; idx++) {
        id object = strs[idx];
        NSLog(@"For Loop, string: %@", object);
    }
    
    // 3. using block
    [strs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"Block, string: %@", obj);
    }];
    
    // 4. NSEnumerator
    NSEnumerator *enumerator = [strs objectEnumerator];
    id object = nil;
    while ((object = enumerator.nextObject) != nil) {
        NSLog(@"NSENumerator, string: %@", object);
    }
}

+ (void)startSearch{
    NSArray *strs = @[@"John Appleseed", @"Tim Cook", @"Hair Force One", @"Michael Jurewitz"];
    NSLog(@"start search at array: %@", strs);
    
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
    NSArray *lengthGt5 = [strs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject length] > 10;
    }]];
    NSLog(@"all strings(length>10): %@", lengthGt5);
}

+ (void)startBinarySearch{
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
}

+ (void)startSearchProduct{
    NSArray *testProducts = [WRProductLab testProducts];
    WRProduct *randomProduct = [testProducts objectAtIndex:arc4random()%testProducts.count];
    WRProduct *fakeRandomProduct = [WRProduct productWithName:randomProduct.name sales:randomProduct.sales];
    
    // raw random product
    NSLog(@"The index of random product in test products: %zd", [testProducts indexOfObject:randomProduct]);
    NSLog(@"The index of identical random product in test products: %zd", [testProducts indexOfObjectIdenticalTo:randomProduct]);
    
    // the fake random product
    NSLog(@"The index of random product in test products: %zd", [testProducts indexOfObject:fakeRandomProduct]);
    NSLog(@"The index of identical random product in test products: %zd", [testProducts indexOfObjectIdenticalTo:fakeRandomProduct]);
}

@end
