//
//  AVFoundationViewController.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/29.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "AVFoundationViewController.h"
#import "WRSnippetItem.h"
#import "WRSnippetGroup.h"

@interface AVFoundationViewController ()

@end

@implementation AVFoundationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSnippetGroups:@[
        [self basic],
    ]];
}

- (WRSnippetGroup *)basic {
    WRSnippetGroup *basic = [WRSnippetGroup groupWithName:@"Basic"];
    
    [basic addSnippetItem:[WRSnippetItem itemWithName:@"单视频处理" viewControllerClassName:@"BasicVideoViewController" detail:@"playing, thumbnails"]];
    [basic addSnippetItem:[WRSnippetItem itemWithName:@"组合" viewControllerClassName:@"CompositionViewController" detail:@"mutableComposition"]];
    [basic addSnippetItem:[WRSnippetItem itemWithName:@"重编码" viewControllerClassName:@"ReencodingViewController" detail:@"AVAssetReaderWriter"]];
    return basic;
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
