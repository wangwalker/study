//
//  WRSynchronizeExample.m
//  Snippets
//
//  Created by Walker on 2020/11/16.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "WRSynchronizeExample.h"

@implementation WRSynchronizeExample
{
    id syncObject;
}

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
    
    NSOperation *op;
    NSConditionLock *lock;
}
@end
