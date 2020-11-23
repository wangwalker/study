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
    
    // 动态方法解析
    [runtime addSnippetItem:[WRSnippetItem itemWithName:@"消息转发①" detail:@"动态方法解析" selector:NSSelectorFromString(@"someDynamicMethod") target:[RuntimeExample new] object:@0]];
    // 重定向接收者
    [runtime addSnippetItem:[WRSnippetItem itemWithName:@"消息转发②" detail:@"重定向接收者" selector:@selector(addTimerForCommonMode) target:[RuntimeExample new] object:@0]];
    // 最后的转发
    [runtime addSnippetItem:[WRSnippetItem itemWithName:@"消息转发③" detail:@"最后的消息转发步骤" selector:@selector(processUnrecognizedMessage) target:[RuntimeExample new] object:@0]];
    
    [runtime addSnippetItem:[WRSnippetItem itemWithName:@"Swizzling" detail:@"替换方法实现" selector:@selector(swizzlingMethod1) target:[RuntimeExample new] object:@0]];
    
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
