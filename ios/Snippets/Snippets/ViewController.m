//
//  ViewController.m
//  Snippets
//
//  Created by Walker on 2020/6/9.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "ViewController.h"
#import "GDCGroupExample.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, assign) BOOL hasImmersed;
@property (nonatomic, assign) BOOL hasScrollUpTendency;
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation ViewController
{
    dispatch_queue_t queue1, queue2;
    NSArray<GDCTaskItem*> *tasks1, *tasks2;
    GDCGroupTaskScheduler *scheduler1, *scheduler2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Snippets"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableview];
    [self initGroupTasks];
}

- (void)initGroupTasks{
    queue1 = dispatch_get_global_queue(0, 0);
    queue2 = dispatch_get_global_queue(0, 0);
    
    tasks1 = @[
        [[GDCTaskItem alloc] initWithSleepSeconds:2 name:@"T11" queue:queue1],
        [[GDCTaskItem alloc] initWithSleepSeconds:5 name:@"T12" queue:queue1]
    ];
    tasks2 = @[
        [[GDCTaskItem alloc] initWithSleepSeconds:1 name:@"T21" queue:queue2],
        [[GDCTaskItem alloc] initWithSleepSeconds:3 name:@"T22" queue:queue2]
    ];
    
    scheduler1 = [[GDCGroupTaskScheduler alloc] initWithTasks:tasks1 name:@"S1"];
    scheduler2 = [[GDCGroupTaskScheduler alloc] initWithTasks:tasks2 name:@"S2"];
}

- (void)performTasksWithWait{
    [scheduler1 dispatchTasksWaitUntilDone];
    [scheduler2 dispatchTasksWaitUntilDone];
}

- (void)performTasksWithNofity{
    [scheduler1 dispatchTasksUntilDonwNofityQueue:queue2 nextTask:^{
        [self->scheduler2 dispatchTasksWaitUntilDone];
    }];
}

- (void)hideNavBar:(BOOL)hidden{
    [UIView animateWithDuration:0.6 animations:^{
        self.navigationController.navigationBar.hidden = hidden;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd-%zd", indexPath.section+1, indexPath.row+1];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performTasksWithNofity];
    
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
