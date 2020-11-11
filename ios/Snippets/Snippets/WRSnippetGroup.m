//
//  WRSnippetGroup.m
//  Snippets
//
//  Created by Walker on 2020/11/10.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "WRSnippetGroup.h"
#import "WRSnippetItem.h"

@implementation WRSnippetGroup{
    NSMutableArray<WRSnippetItem*>* items;
}

+ (instancetype)groupWithName:(NSString *)name{
    return [[self alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString*)name{
    if ([self init]) {
        self.name = name;
    }
    return self;
}

- (instancetype)init{
    if ((self = [super init])) {
        items = [NSMutableArray array];
    }
    return self;
}

- (void)addSnippetItem:(WRSnippetItem *)item{
    [items addObject:item];
}

- (NSArray<WRSnippetItem *> *)snippets{
    return [items copy];
}

@end
