//
//  ConcurrViewController.m
//  Snippets
//
//  Created by Walker on 2020/11/11.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "ConcurrViewController.h"
#import "WRSnippetGroup.h"
#import "WRSnippetItem.h"
#import "NSOperationExample.h"

@interface ConcurrViewController ()

@end

@implementation ConcurrViewController

- (void)viewDidLoad {
    
    [self initSnippetGroups];
    
    [super viewDidLoad];
    
}

- (void)initSnippetGroups{
    static NSArray<WRSnippetGroup*>* groups;
    
    WRSnippetGroup *cocoa = [WRSnippetGroup groupWithName:@"并发实践"];
     
    [cocoa addSnippetItem:[WRSnippetItem itemWithName:@"GCD" viewControllerClassName:@"WRGCDViewController" detail:@"GCD用法集合"]];
    [cocoa addSnippetItem:[WRSnippetItem itemWithName:@"NSOperation" detail:@"一个简单示例" selector:@selector(start) target:[NSOperationExample new] object:@0]];
    [cocoa addSnippetItem:[WRSnippetItem itemWithName:@"NSThread-1" viewControllerClassName:@"NSThreadViewController1" detail:@"直接使用NSThread"]];
    [cocoa addSnippetItem:[WRSnippetItem itemWithName:@"NSThread-2" viewControllerClassName:@"NSThreadViewController2" detail:@"继承NSThread"]];
    
    groups = @[cocoa, cocoa, cocoa, cocoa, cocoa];
    
    [self setSnippetGroups:groups];

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
