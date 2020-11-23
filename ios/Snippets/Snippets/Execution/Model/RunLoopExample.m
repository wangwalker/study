//
//  RunLoopExample.m
//  Snippets
//
//  Created by Walker on 2020/11/17.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "RunLoopExample.h"
#import <QuartzCore/CADisplayLink.h>

@implementation RunLoopExample

void timerDefaultModeCallback() {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    NSArray *allModes = CFBridgingRelease(CFRunLoopCopyAllModes(runLoop));
    printf("timer on default mode\n");
}

void timerCommonModeCallback() {
    printf("timer on common mode\n");
}

void dislayLinkDefaultModeCallback() {
    printf("display link on default mode\n");
}

/**
 注意这里的顺序：
    1. 先开始观察；
    2. 然后加入对应Source，比如Timer、Selector；
    3. 最后开始运行RunLoop。
 */
- (void)addObserverFor:(NSRunLoop *)runloop mode:(CFRunLoopMode)mode callback:(CFRunLoopObserverCallBack)callback{
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, callback, &context);
    
    if (observer) {
        CFRunLoopRef rl = [runLoop getCFRunLoop];
        CFRunLoopAddObserver(rl, observer, mode);
    }
}

- (void)addTimerForDefaultMode{
    // NSTimer默认加入到NSDefaultRunLoopMode
    [self addObserverFor:[NSRunLoop currentRunLoop] mode:kCFRunLoopDefaultMode callback:timerDefaultModeCallback];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"default mode, time elapse 0.2 second");
    }];
    [NSRunLoop.currentRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
}

- (void)addTimerForCommonMode{
    [self addObserverFor:[NSRunLoop currentRunLoop] mode:kCFRunLoopCommonModes callback:timerCommonModeCallback];

    __block NSTimer *timer = [NSTimer timerWithTimeInterval:.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"common mode, time elapse 0.2 second");
    }];
    [NSRunLoop.currentRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
    [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [timer invalidate];
    });
}

- (void)addDislayLinkForDefaultMode{
    [self addObserverFor:[NSRunLoop currentRunLoop] mode:kCFRunLoopDefaultMode callback:dislayLinkDefaultModeCallback];

    CADisplayLink *dl = [CADisplayLink displayLinkWithTarget:self selector:@selector(doDispaly)];
    dl.preferredFramesPerSecond = 5;
    [dl addToRunLoop:NSRunLoop.currentRunLoop forMode:NSDefaultRunLoopMode];
    [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
}

- (void)doDispaly{
    NSLog(@"default mode, time elapse 0.2 second");
}

@end
