//
//  GCDSemaphoreExample.m
//  Snippets
//
//  Created by Walker on 2020/11/13.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "GCDSemaphoreExample.h"

@implementation GCDSemaphoreExample
{
    dispatch_semaphore_t chairs; // 表示海底捞的椅子数量
}

- (instancetype)init{
    if ((self = [super init])) {
        chairs = dispatch_semaphore_create(10);
    }
    return self;
}

- (void)startOperation{
    NSLog(@"HiHotPot start operation");
        
    __block NSTimer *timer = [NSTimer timerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self consumeHiHotPot];
    }];
    
    [NSRunLoop.mainRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [timer invalidate];
        NSLog(@"HiHotPot end operation");
    });
}

- (void)consumeHiHotPot{
    NSLog(@"start waiting for chair...");
    dispatch_semaphore_wait(chairs, DISPATCH_TIME_FOREVER);
    NSLog(@"starting eating... ");
    
    NSUInteger duration = arc4random()%5;
    // 每个人在一定时间之后吃完，时间随机
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"finish eating...");
        dispatch_semaphore_signal(self->chairs);
    });
}

@end
