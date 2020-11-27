//
//  ViewController.m
//  Snippets
//
//  Created by Walker on 2020/6/9.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "ViewController.h"
#import "WRSnippetManager.h"
#import "WRSnippetGroup.h"
#import "WRSnippetItem.h"

@interface ViewController ()<UITableViewDelegate, UIScrollViewDelegate>
@property BOOL hasImmersed;
@property BOOL hasScrollUpTendency;
@property (nonatomic) UITableView *tableview;
@property WRSnippetGroupTableViewDataSource *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableview];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WRSnippetItem *item = [self.snippetGroups[indexPath.section].snippets objectAtIndex:indexPath.row];
    
    if (item.relatedViewController) {
        [self.navigationController pushViewController:item.relatedViewController animated:YES];
    } else {
        [item start];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static CGFloat offsetY = 0;
    
    _hasScrollUpTendency = offsetY < scrollView.contentOffset.y;
    // recording last offset y
    offsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat immersedThreshold = CGRectGetWidth(self.view.bounds);
    if (!_hasImmersed && _hasScrollUpTendency && scrollView.contentOffset.y > immersedThreshold) {
        // immerse your view that should be immersed
        [self hideNavBar:YES];
        // update state
        _hasImmersed = YES;
    }
    
    if (_hasImmersed && !_hasScrollUpTendency && scrollView.contentOffset.y < immersedThreshold) {
        // restore your view
        [self hideNavBar:NO];
        // update state
        _hasImmersed = NO;
    }
}

#pragma mark - Setter

- (void)setSnippetGroups:(NSArray<WRSnippetGroup *> *)snippetGroups{
    _snippetGroups = snippetGroups;
    _dataSource = [WRSnippetGroupTableViewDataSource dataSourceWithGroups:_snippetGroups];
    _tableview.dataSource = _dataSource;
}

#pragma mark - Getter

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
    }
    return _tableview;
}

#pragma mark - Private

- (void)hideNavBar:(BOOL)hidden{
    [UIView animateWithDuration:0.6 animations:^{
        self.navigationController.navigationBar.hidden = hidden;
    }];
}

@end
