//
//  GCDQueueExample.m
//  Snippets
//
//  Created by Walker on 2020/11/12.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "GCDQueueExample.h"

@implementation GCDQueueExample{
    dispatch_queue_t wrQueue;
    NSMutableDictionary *userInfo;
}

- (instancetype)init{
    if ((self = [super init])) {
        wrQueue = dispatch_queue_create("COM.WALKER.WRQ", DISPATCH_QUEUE_CONCURRENT);
        userInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    // 如果调用者传入的是一个NSMutableString，在返回之后如果修改key值，则可能出错
    // 所以，为了避免这些问题，对key进行copy
    key = [key copy];
    dispatch_barrier_async(wrQueue, ^{
        if (key && value) {
            [self->userInfo setValue:value forKey:key];
        }
    });
}

- (id)valueForKey:(NSString *)key{
    __block id value = nil;
    dispatch_barrier_sync(wrQueue, ^{
        value = [userInfo objectForKey:key];
    });
    return value;
}

- (void)createQueues{
    
    dispatch_queue_t main, serial, concur1, concur2, concur3;
    
    // 主线程队列，用来维护在主线程执行的任务执行次序
    main = dispatch_get_main_queue();
    
    // 串行队列
    serial = dispatch_queue_create("COM.WALKER.S", DISPATCH_QUEUE_SERIAL);
    
    // 并发队列
    concur1 = dispatch_queue_create("COM.WALKER.C", DISPATCH_QUEUE_CONCURRENT);
    // 下面两种是同一回事，但是推荐后面的写法
    concur2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    concur3 = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
    
    dispatch_sync(serial, ^{
        
    });
    
    dispatch_async(concur1, ^{
        
    });
}

- (void)doOnceTask{
    static NSData *data;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"some-url"]];
    });
}

- (void)doDelayTask{
    /**
     时间单位：
        秒：NSEC_PER_SEC
        毫秒：NSEC_PER_MSEC
        纳秒：NSEC_PER_USEC
     */
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
    });
    
    dispatch_barrier_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)doDispatchApply{
    NSInteger iterateTimes = 1e4;
    NSDate *now;
    
    now = [NSDate date];
    
    dispatch_apply(iterateTimes*iterateTimes, DISPATCH_APPLY_AUTO, ^(size_t x) {
        
    });
    
    NSLog(@"dispatch apply iterate 1e8 times used times: %.g", [[NSDate date] timeIntervalSinceDate:now]);
    
    now = [NSDate date];
    
    for (int i=0; i<iterateTimes*iterateTimes; i++) {
//        for (int k=0; k<iterateTimes; k++) {
//
//        }
    }
    
    NSLog(@"for loop iterate 1e8 times used times: %.g", [[NSDate date] timeIntervalSinceDate:now]);
}

@end
