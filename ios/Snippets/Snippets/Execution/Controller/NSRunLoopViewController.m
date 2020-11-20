//
//  NSRunLoopViewController.m
//  Snippets
//
//  Created by Walker on 2020/11/18.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "NSRunLoopViewController.h"
#import "RunLoopExample.h"
#import "RuntimeExample.h"
#import "WRSnippetItem.h"
#import "WRSnippetGroup.h"

@interface NSRunLoopViewController ()

@end

@implementation NSRunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupGroups];
}

- (void)setupGroups{
    WRSnippetGroup *runLoop = [WRSnippetGroup groupWithName:@"RunLoop"];
    
    [runLoop addSnippetItem:[WRSnippetItem itemWithName:@"NSTimer" detail:@"default mode" selector:@selector(addTimerForDefaultMode) target:[RunLoopExample new] object:@0]];
    
    [runLoop addSnippetItem:[WRSnippetItem itemWithName:@"NSTimer" detail:@"common mode" selector:@selector(addTimerForCommonMode) target:[RunLoopExample new] object:@0]];
    
    [runLoop addSnippetItem:[WRSnippetItem itemWithName:@"CADisplayLink" detail:@"default mode" selector:@selector(addDislayLinkForDefaultMode) target:[RunLoopExample new] object:@0]];
    
    
    WRSnippetGroup *runtime = [WRSnippetGroup groupWithName:@"RunTime"];
    
    [runtime addSnippetItem:[WRSnippetItem itemWithName:@"Class" detail:@"Class的继承体系" selector:@selector(showInheritanceHierarchy) target:[RuntimeExample new] object:@0]];
    
    [runtime addSnippetItem:[WRSnippetItem itemWithName:@"关联对象" detail:@"objc_*AssociatedObject" selector:@selector(setAndGetDynamicObject) target:[RuntimeExample new] object:@0]];
    
    [self setSnippetGroups:@[runLoop, runtime]];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
