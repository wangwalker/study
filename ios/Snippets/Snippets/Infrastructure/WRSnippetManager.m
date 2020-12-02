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

+ (instancetype)sharedManager{
    static WRSnippetManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [WRSnippetManager new];
    });
    return manager;
}

- (NSArray<WRSnippetGroup *> *)allSnippetGroups{
    static NSArray<WRSnippetGroup*>* groups;
    
    WRSnippetGroup *cocoa = [WRSnippetGroup groupWithName:@"Cocoa"];
    
    [cocoa addSnippetItem:[WRSnippetItem itemWithName:@"并发编程" viewControllerClassName:@"ConcurrViewController" detail:@"线程、GCD相关"]];
    
    [cocoa addSnippetItem:[WRSnippetItem itemWithName:@"运行时特性" viewControllerClassName:@"NSRunLoopViewController" detail:@"执行机制相关"]];
    
    [cocoa addSnippetItem:[WRSnippetItem itemWithName:@"消息机制" viewControllerClassName:@"MessageViewController" detail:@"KVO&C、通知机制等"]];
    
    groups = @[cocoa, cocoa, cocoa, cocoa, cocoa];
    
    return groups;
}

@end
