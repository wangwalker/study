//
//  WRStoryItem.h
//  Snippets
//
//  Created by Walker on 2020/8/14.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GDCGroupTasksCompletionHandler) (void);

NS_ASSUME_NONNULL_BEGIN

@interface GCDGroupExample : NSObject

@end


@interface GCDTaskItem : NSObject

- (instancetype)initWithSleepSeconds:(NSInteger)seconds name:(NSString *)name queue:(dispatch_queue_t)queue;

@property (nonatomic, assign) NSInteger sleepSeconds;
@property (nonatomic, copy) NSString *name;

@property (nonatomic) dispatch_queue_t queue;

- (void)start;

@end


@interface GDCGroupTaskScheduler : NSObject

- (instancetype)initWithTasks:(NSArray <GCDTaskItem*>*)tasks name:(NSString *)name;

- (void)dispatchTasksWaitUntilDone;

- (void)dispatchTasksUntilDoneNofityQueue:(dispatch_queue_t)queue nextTask:(GDCGroupTasksCompletionHandler)next;

@property (nonatomic, strong) NSArray<GCDTaskItem*>* tasks;
@property (nonatomic, copy) NSString *name;

@property (nonatomic) dispatch_group_t group;

@end

NS_ASSUME_NONNULL_END

