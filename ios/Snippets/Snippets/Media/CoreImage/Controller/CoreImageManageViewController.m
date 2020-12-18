//
//  CoreImageManageViewController.m
//  Snippets
//
//  Created by Walker on 2020/12/16.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "CoreImageManageViewController.h"
#import "WRSnippetItem.h"
#import "WRSnippetGroup.h"

@interface CoreImageManageViewController ()

@end

@implementation CoreImageManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSnippetGroups:@[
        [self filters],
    ]];
}

- (WRSnippetGroup *)filters {
    WRSnippetGroup *group = [WRSnippetGroup groupWithName:@"Filter"];
    
    [group addSnippetItem:[WRSnippetItem itemWithName:@"处理图片" viewControllerClassName:@"SingleCIFilterViewController" detail:@"单个滤镜&滤镜链"]];
    
    [group addSnippetItem:[WRSnippetItem itemWithName:@"滤镜综合应用" viewControllerClassName:@"MultiCIFiltersViewController" detail:@"自定义选择"]];
    
    return group;
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
