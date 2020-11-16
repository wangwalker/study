//
//  WRGCDViewController.m
//  Snippets
//
//  Created by Walker on 2020/11/10.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "WRGCDViewController.h"
#import "GCDGroupExample.h"
#import "WRSnippetGroup.h"
#import "WRSnippetItem.h"
#import "GCDQueueExample.h"
#import "GCDSemaphoreExample.h"
#import "GCDSourceExample.h"

@interface WRGCDViewController ()

@end

@implementation WRGCDViewController
{
    dispatch_queue_t queue1, queue2;
    NSArray<GCDTaskItem*> *tasks1, *tasks2;
    GDCGroupTaskScheduler *scheduler1, *scheduler2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGroups];
    [self initGroupTasks];
}

- (void)initGroupTasks{
    queue1 = dispatch_get_global_queue(0, 0);
    queue2 = dispatch_get_global_queue(0, 0);
    
    tasks1 = @[
        [[GCDTaskItem alloc] initWithSleepSeconds:2 name:@"T11" queue:queue1],
        [[GCDTaskItem alloc] initWithSleepSeconds:5 name:@"T12" queue:queue2]
    ];
    tasks2 = @[
        [[GCDTaskItem alloc] initWithSleepSeconds:1 name:@"T21" queue:queue1],
        [[GCDTaskItem alloc] initWithSleepSeconds:3 name:@"T22" queue:queue2]
    ];
    
    scheduler1 = [[GDCGroupTaskScheduler alloc] initWithTasks:tasks1 name:@"S1"];
    scheduler2 = [[GDCGroupTaskScheduler alloc] initWithTasks:tasks2 name:@"S2"];
}

- (void)initGroups{
    WRSnippetGroup *common = [WRSnippetGroup groupWithName:@"线程同步"];
    WRSnippetGroup *source = [WRSnippetGroup groupWithName:@"监控Source"];

    // dispatch_group_wait
    [common addSnippetItem:[WRSnippetItem itemWithName:@"wait" detail:@"用dispatch_group_wait同步队列" selector:@selector(performTasksWithWait) target:self object:@0]];
    
    // dispatch_group_notify
    [common addSnippetItem:[WRSnippetItem itemWithName:@"notify" detail:@"用dispatch_group_notify同步队列" selector:@selector(performTasksWithNofity) target:self object:@0]];
    
    // 比较dispatch apply 和 for loop
    [common addSnippetItem:[WRSnippetItem itemWithName:@"apply" detail:@"比较dispatch_apply和for循环快慢" selector:@selector(doDispatchApply) target:[GCDQueueExample new] object:@0]];
    
    // 信号量
    [common addSnippetItem:[WRSnippetItem itemWithName:@"semaphore" detail:@"使用信号量模拟在海底捞🍲" selector:@selector(startOperation) target:[GCDSemaphoreExample new] object:@0]];
    
    // 使用Dispatch Source API监控
    [source addSnippetItem:[WRSnippetItem itemWithName:@"监控进程" detail:@"dispatch_source监控进程" selector:@selector(monitorProcess) target:[GCDSourceExample new] object:@0]];

    [source addSnippetItem:[WRSnippetItem itemWithName:@"监控文件" detail:@"dispatch_source监控文件系统变化" selector:@selector(monitorAppDirectory) target:[GCDSourceExample new] object:@0]];
    
    [source addSnippetItem:[WRSnippetItem itemWithName:@"Timer" detail:@"dispatch_source版定时器" selector:@selector(monitorTimer) target:[GCDSourceExample new] object:@0]];
    
    [self setSnippetGroups:@[common, source]];
    
}

- (void)performTasksWithWait{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        [self->scheduler1 dispatchTasksWaitUntilDone];
        [self->scheduler2 dispatchTasksWaitUntilDone];
    });
}

- (void)performTasksWithNofity{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        [self->scheduler1 dispatchTasksUntilDoneAndNofity];
        [self->scheduler2 dispatchTasksUntilDoneAndNofity];
    });
}


@end
