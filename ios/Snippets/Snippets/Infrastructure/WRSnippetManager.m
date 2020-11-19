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
    
    [cocoa addSnippetItem:[WRSnippetItem itemWithName:@"Concurrent" viewControllerClassName:@"ConcurrViewController" detail:@"并发实践"]];
    
    [cocoa addSnippetItem:[WRSnippetItem itemWithName:@"RunLoop-Time" viewControllerClassName:@"NSRunLoopViewController" detail:@"执行机制相关"]];
    
    groups = @[cocoa, cocoa, cocoa, cocoa, cocoa];
    
    return groups;
}

@end
