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

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, assign) BOOL hasImmersed;
@property (nonatomic, assign) BOOL hasScrollUpTendency;
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableview];
}

- (void)hideNavBar:(BOOL)hidden{
    [UIView animateWithDuration:0.6 animations:^{
        self.navigationController.navigationBar.hidden = hidden;
    }];
    CADisplayLink *ca;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.snippetGroups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.snippetGroups[section].snippets.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WRSnippetItem *item = [self.snippetGroups[indexPath.section].snippets objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.detailedDescription;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%ld-%@", section+1, self.snippetGroups[section].name];
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


#pragma mark - Getter

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

@end
