//
//  NSDictionaryOperation.m
//  Snippets
//
//  Created by Walker on 2020/12/3.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "NSDictionaryOperation.h"

@implementation NSDictionaryOperation

+ (void)startSort{
    NSDictionary *dict = @{
        @"key31": @"value232",
        @"key2d": @"valuedsf232",
        @"key3": @"value23fds2",
        @"key4": @"value23fds2",
        @"key23": @"value2da32",
        @"key10": @"value23da2",
    };
    NSLog(@"sort dictionary: %@", dict);
    
    NSArray *sortedKeys = [dict keysSortedByValueUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSLog(@"sorted keys(keysSortedByValueUsingSelector:): %@", sortedKeys);
    
    sortedKeys = [dict keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 localizedCompare:obj2];
    }];
    NSLog(@"sorted keys(keysSortedByValueUsingComparator:): %@", sortedKeys);
    
    sortedKeys = [dict keysSortedByValueWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSLog(@"sorted keys(keysSortedByValueWithOptions:usingComparator:): %@", sortedKeys);
    
    NSArray *correspindingValues = [dict objectsForKeys:sortedKeys notFoundMarker:NSNull.null];
    NSLog(@"corresponding values: %@", correspindingValues);
    
    
}

+ (void)startEnumerate{
    NSDictionary *dict = @{
        @"key31": @"value232",
        @"key2d": @"valuedsf232",
        @"key3": @"value23fds2",
        @"key4": @"value23fds2",
        @"key23": @"value2da32",
        @"key10": @"value23da2",
    };
    NSLog(@"enumerate dictionary: %@", dict);
    
    // 1. Fast Enumeration
    for (NSString *key in dict) {
        id value = [dict objectForKey:key];
        NSLog(@"key: %@, value: %@", key, value);
    }
    
    // 2. Block
    [dict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"key: %@, value: %@", key, obj);
    }];
    
    [dict keysOfEntriesWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"key: %@, value: %@", key, obj);
        return YES;
    }];
    
    
    // 3. Test filter
    
    NSSet *matchedKeys = [dict keysOfEntriesWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        return [key length] == 5;
    }];
    NSLog(@"keys set(key.length==5): %@", matchedKeys);
    
    
}
@end
