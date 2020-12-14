//
//  QuartzBaseViewController.m
//  Snippets
//
//  Created by Walker on 2020/12/9.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "QuartzBaseViewController.h"

@interface QuartzBaseViewController ()
@property (nonatomic) UIView *childView;
@end

@implementation QuartzBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupChildView];
}

- (void)setupChildView{
    if (!_childViewClassName) return;
    
    if (![self.view.subviews containsObject:_childView]) {
        [self.view addSubview:self.childView];
    }
}

- (UIView *)childView{
    if (!_childView) {
        const CGSize s = [UIScreen mainScreen].bounds.size;

        Class childViewClass = NSClassFromString(_childViewClassName);
        
        _childView = [[childViewClass alloc] init];
        _childView.frame = CGRectMake(0, 0, s.width, s.height);
        _childView.center = self.view.center;
    }
    return _childView;
}

@end
