//
//  WRStoryItem.m
//  Snippets
//
//  Created by Walker on 2020/8/14.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "GCDGroupExample.h"

@implementation GCDGroupExample

@end


@implementation GCDTaskItem

- (instancetype)initWithSleepSeconds:(NSInteger)seconds name:(nonnull NSString *)name queue:(nonnull dispatch_queue_t)queue{
    if (self = [super init]) {
        self.sleepSeconds = seconds;
        self.name = name;
        self.queue = queue;
    }
    return self;
}

- (void)start{
    NSDate *start = [NSDate date];
    NSLog(@"task-%@ start do task.", _name);
    
    [NSThread sleepForTimeInterval:_sleepSeconds];
    NSLog(@"---task-%@ using %.3f seconds finishing task ---", _name, [[NSDate date] timeIntervalSinceDate:start]);
}

- (void)asyncStart{
    NSDate *start = [NSDate date];
    NSLog(@"task-%@ start do task.", _name);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_sleepSeconds * NSEC_PER_SEC)), _queue, ^{
        NSLog(@"---task-%@ using %.3f seconds finishing task ---", self.name, [[NSDate date] timeIntervalSinceDate:start]);
    });
}

@end


@implementation GDCGroupTaskScheduler

- (instancetype)initWithTasks:(NSArray<GCDTaskItem *> *)tasks name:(nonnull NSString *)name{
    if (self = [super init]) {
        self.tasks = tasks;
        self.name = name;
        self.group = dispatch_group_create();
    }
    return self;
}

- (void)dispatchTasksWaitUntilDone{
    NSDate *start = [NSDate date];
    
    NSLog(@"group-%@ start dispatch tasks",_name);
    
    for (GCDTaskItem *task in _tasks) {
        dispatch_group_async(_group, task.queue, ^{
            [task start];
        });
    }
    // 同步【synchronously】等待当前组中的所有队列中的任务完成，会阻塞当前线程
    dispatch_group_wait(_group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group-task-%@ using %.3f seconds finishing task", _name, [[NSDate date] timeIntervalSinceDate:start]);
    NSLog(@"=========================");
}

- (void)dispatchTasksUntilDoneNofityQueue:(dispatch_queue_t)queue nextTask:(GDCGroupTasksCompletionHandler)next{
    NSDate *start = [NSDate date];
    
    NSLog(@"group-%@ start dispatch tasks",_name);
    
    for (GCDTaskItem *task in _tasks) {
        dispatch_group_async(_group, task.queue, ^{
            [task start];
        });
    }
    
    dispatch_group_notify(_group, queue, ^{
        NSLog(@"group-task-%@ using %.3f seconds finishing task", self.name, [[NSDate date] timeIntervalSinceDate:start]);
        NSLog(@"=========================");
        
        if (next) {
            next();
        }
    });
}

- (void)dispatchTasksUntilDoneAndNofity{
    NSDate *start = [NSDate date];
    
    NSLog(@"group-%@ start dispatch tasks",_name);
    
    for (GCDTaskItem *task in _tasks) {
        dispatch_group_async(_group, task.queue, ^{
            [task start];
        });
    }
    
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        NSLog(@"group-task-%@ using %.3f seconds finishing task", self.name, [[NSDate date] timeIntervalSinceDate:start]);
        NSLog(@"=========================");
    });
}

@end
