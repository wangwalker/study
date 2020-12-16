//
//  QuartzManagerViewController.m
//  Snippets
//
//  Created by Walker on 2020/12/9.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "QuartzManagerViewController.h"
#import "WRQuartzSnippetItem.h"
#import "WRSnippetGroup.h"

@interface QuartzManagerViewController ()

@end

@implementation QuartzManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CIDetector *dict; CIImage *im;
    [self setSnippetGroups:@[
        [self basic],
    ]];
}

- (WRSnippetGroup *)basic {
    WRSnippetGroup *basic = [WRSnippetGroup groupWithName:@"Basic"];
    
    WRQuartzSnippetItem *path, *transform, *pattern, *gradient, *shading, *transLayer;
    
    path = [WRQuartzSnippetItem itemWithName:@"正弦曲线" viewControllerClassName:@"QuartzBaseViewController" detail:@"绘制Path"];
    path.relatedViewClassName = @"QuartzPathViewExample";
    
    transform = [WRQuartzSnippetItem itemWithName:@"变换椭圆" viewControllerClassName:@"QuartzBaseViewController" detail:@"以放射变换实现旋转"];
    transform.relatedViewClassName = @"QuartzTransformViewExample";
    
    pattern = [WRQuartzSnippetItem itemWithName:@"模式" viewControllerClassName:@"QuartzBaseViewController" detail:@"CGPattern"];
    pattern.relatedViewClassName = @"QuartzPatternViewExample";
    
    gradient = [WRQuartzSnippetItem itemWithName:@"普通渐变" viewControllerClassName:@"QuartzBaseViewController" detail:@"CGGradient"];
    gradient.relatedViewClassName = @"QuartzGradientViewExample";
    
    shading = [WRQuartzSnippetItem itemWithName:@"自定义渐变" viewControllerClassName:@"QuartzBaseViewController" detail:@"CGShaing"];
    shading.relatedViewClassName = @"QuartzShadingViewExample";
    
    transLayer = [WRQuartzSnippetItem itemWithName:@"透明图层" viewControllerClassName:@"QuartzBaseViewController" detail:@"合成图形"];
    transLayer.relatedViewClassName = @"QuartzTransparentLayer";
    
    [basic addSnippetItem:path];
    [basic addSnippetItem:transform];
    [basic addSnippetItem:pattern];
    [basic addSnippetItem:gradient];
    [basic addSnippetItem:shading];
    [basic addSnippetItem:transLayer];
    
    return basic;
}
@end
