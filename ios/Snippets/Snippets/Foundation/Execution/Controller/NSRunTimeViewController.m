//
//  NSRunTimeViewController.m
//  Snippets
//
//  Created by Walker on 2020/11/20.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "NSRunTimeViewController.h"
#import "RuntimeExample.h"
#import "WRSnippetItem.h"
#import "WRSnippetGroup.h"

@interface NSRunTimeViewController ()

@end

@implementation NSRunTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupGroups];
}

- (void)setupGroups{
    WRSnippetGroup *runtime = [WRSnippetGroup groupWithName:@"RunTime"];
    
    [runtime addSnippetItem:[WRSnippetItem itemWithName:@"NSTimer" detail:@"default mode" selector:@selector(showInheritanceHierarchy) target:[RuntimeExample new] object:@0]];
    
    [runtime addSnippetItem:[WRSnippetItem itemWithName:@"NSTimer" detail:@"common mode" selector:@selector(showInheritanceHierarchy) target:[RuntimeExample new] object:@0]];
    
    
    [self setSnippetGroups:@[runtime, runtime, runtime, runtime, runtime]];
    
}

@end
