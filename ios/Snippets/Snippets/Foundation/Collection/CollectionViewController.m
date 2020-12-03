//
//  CollectionViewController.m
//  Snippets
//
//  Created by Walker on 2020/12/3.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "CollectionViewController.h"
#import "WRSnippetItem.h"
#import "WRSnippetGroup.h"
#import "NSArrayOperation.h"
#import "NSDictionaryOperation.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSnippetGroups:@[
        [self arrayOps],
        [self dictOps],
    ]];
}

- (WRSnippetGroup *)arrayOps{
    WRSnippetGroup *array = [WRSnippetGroup groupWithName:@"NSArray Ops"];
    
    [array addSnippetItem:[WRSnippetItem itemWithName:@"Sort" detail:@"基本类型的排序操作" selector:@selector(startSort) target:[NSArrayOperation class] object:@0]];
    
    [array addSnippetItem:[WRSnippetItem itemWithName:@"Sort" detail:@"根据属性的对象排序" selector:@selector(startSortProduct) target:[NSArrayOperation class] object:@0]];
    
    [array addSnippetItem:[WRSnippetItem itemWithName:@"Enumerate" detail:@"几种常用操作演示" selector:@selector(startEnumerate) target:[NSArrayOperation class] object:@0]];
    
    [array addSnippetItem:[WRSnippetItem itemWithName:@"Search" detail:@"一般查找方法" selector:@selector(startSearch) target:[NSArrayOperation class] object:@0]];
    
    [array addSnippetItem:[WRSnippetItem itemWithName:@"Search" detail:@"有序数组的二分查找" selector:@selector(startBinarySearch) target:[NSArrayOperation class] object:@0]];
    
    [array addSnippetItem:[WRSnippetItem itemWithName:@"Search" detail:@"对象的查找" selector:@selector(startSearchProduct) target:[NSArrayOperation class] object:@0]];
    
    return array;
}

- (WRSnippetGroup *)dictOps {
    WRSnippetGroup *dict = [WRSnippetGroup  groupWithName:@"NSDictionay Ops"];
    
    [dict addSnippetItem:[WRSnippetItem itemWithName:@"Sort" detail:@"根据Key排序" selector:@selector(startSort) target:[NSDictionaryOperation class] object:@0]];
    
    [dict addSnippetItem:[WRSnippetItem itemWithName:@"Enumerate" detail:@"几种常用操作演示" selector:@selector(startEnumerate) target:[NSDictionaryOperation class] object:@0]];
    
    return dict;
}

@end
