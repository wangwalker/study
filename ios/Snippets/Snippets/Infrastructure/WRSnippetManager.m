//
//  WRSnippetManager.m
//  Snippets
//
//  Created by Walker on 2020/11/10.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "WRSnippetManager.h"
#import "WRSnippetGroup.h"
#import "WRSnippetItem.h"

@implementation WRSnippetManager

+ (instancetype)sharedManager {
    static WRSnippetManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [WRSnippetManager new];
    });
    return manager;
}

- (NSArray<WRSnippetGroup *> *)allSnippetGroups {
    return [NSArray arrayWithObjects:
            [self foundation],
            [self media],
             nil];
}

- (WRSnippetGroup *)foundation {
    WRSnippetGroup *foundation = [WRSnippetGroup groupWithName:@"Foundation"];
    
    [foundation addSnippetItem:[WRSnippetItem itemWithName:@"集合类" viewControllerClassName:@"CollectionViewController" detail:@"排序、遍历、查找等操作"]];
    
    [foundation addSnippetItem:[WRSnippetItem itemWithName:@"并发编程" viewControllerClassName:@"ConcurrViewController" detail:@"线程、GCD相关"]];
    
    [foundation addSnippetItem:[WRSnippetItem itemWithName:@"运行时特性" viewControllerClassName:@"NSRunLoopViewController" detail:@"执行机制相关"]];
    
    [foundation addSnippetItem:[WRSnippetItem itemWithName:@"消息机制" viewControllerClassName:@"MessageViewController" detail:@"KVO&C、通知机制等"]];
    
    return foundation;
}

- (WRSnippetGroup *)media {
    WRSnippetGroup *media = [WRSnippetGroup groupWithName:@"Media"];
    
    [media addSnippetItem:[WRSnippetItem itemWithName:@"Quartz 2D" viewControllerClassName:@"QuartzManagerViewController" detail:@"二维绘图引擎"]];
    
    [media addSnippetItem:[WRSnippetItem itemWithName:@"CoreImage" viewControllerClassName:@"CoreImageManageViewController" detail:@"图片处理相关"]];

    return media;
}

@end
