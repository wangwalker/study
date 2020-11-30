//
//  KeyValueViewController.m
//  Snippets
//
//  Created by Walker on 2020/11/30.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "KeyValueViewController.h"
#import "WRSnippetItem.h"
#import "WRSnippetGroup.h"

@interface KeyValueViewController ()

@end

@implementation KeyValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSnippetGroups:@[
        [self kvoc],
    ]];
}

- (WRSnippetGroup*)kvoc{
    WRSnippetGroup *kv = [WRSnippetGroup groupWithName:@"Key-Value Observing"];
    
    [kv addSnippetItem:[WRSnippetItem itemWithName:@"指定依赖关系" viewControllerClassName:@"ColorConvertorViewController" detail:@"Lab到RGB颜色空间的转换"]];
    
    return kv;
}

@end
