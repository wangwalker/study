//
//  WRGCDViewController.m
//  Snippets
//
//  Created by Walker on 2020/11/10.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "WRGCDViewController.h"
#import "GCDGroupExample.h"
#import "WRSnippetGroup.h"
#import "WRSnippetItem.h"
#import "GCDQueueExample.h"

@interface WRGCDViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray<WRSnippetGroup*>* groups;
@end

@implementation WRGCDViewController
{
    dispatch_queue_t queue1, queue2;
    NSArray<GCDTaskItem*> *tasks1, *tasks2;
    GDCGroupTaskScheduler *scheduler1, *scheduler2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGroupTasks];
    [self.view addSubview:self.tableview];
}

- (void)initGroupTasks{
    queue1 = dispatch_get_global_queue(0, 0);
    queue2 = dispatch_get_global_queue(0, 0);
    
    tasks1 = @[
        [[GCDTaskItem alloc] initWithSleepSeconds:2 name:@"T11" queue:queue1],
        [[GCDTaskItem alloc] initWithSleepSeconds:5 name:@"T12" queue:queue1]
    ];
    tasks2 = @[
        [[GCDTaskItem alloc] initWithSleepSeconds:1 name:@"T21" queue:queue2],
        [[GCDTaskItem alloc] initWithSleepSeconds:3 name:@"T22" queue:queue2]
    ];
    
    scheduler1 = [[GDCGroupTaskScheduler alloc] initWithTasks:tasks1 name:@"S1"];
    scheduler2 = [[GDCGroupTaskScheduler alloc] initWithTasks:tasks2 name:@"S2"];
}

- (void)performTasksWithWait{
    [scheduler1 dispatchTasksWaitUntilDone];
    [scheduler2 dispatchTasksWaitUntilDone];
}

- (void)performTasksWithNofity{
    [scheduler1 dispatchTasksUntilDoneNofityQueue:queue2 nextTask:^{
        [self->scheduler2 dispatchTasksWaitUntilDone];
    }];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups[section].snippets.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WRSnippetItem *item = self.groups[indexPath.section].snippets[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dispatch_group_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"dispatch_group_cell"];
    }
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.detailedDescription;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WRSnippetItem *item = self.groups[indexPath.section].snippets[indexPath.row];
    if (item.relatedViewController) {
        [self.navigationController pushViewController:item.relatedViewController animated:YES];
    } else {
        [item start];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getter

- (NSArray<WRSnippetGroup *> *)groups{
    if (!_groups) {
        WRSnippetGroup *GCDGroup = [WRSnippetGroup groupWithName:@"dispatch_group"];
        
        // dispatch_group_wait
        [GCDGroup addSnippetItem:[WRSnippetItem itemWithName:@"wait" detail:@"用dispatch_group_wait同步队列" selector:@selector(performTasksWithWait) target:self object:@0]];
        
        // dispatch_group_notify
        [GCDGroup addSnippetItem:[WRSnippetItem itemWithName:@"notify" detail:@"用dispatch_group_notify同步队列" selector:@selector(performTasksWithNofity) target:self object:@0]];
        
        // 比较dispatch apply 和 for loop
        [GCDGroup addSnippetItem:[WRSnippetItem itemWithName:@"apply" detail:@"比较dispatch_apply和for循环快慢" selector:@selector(doDispatchApply) target:[GCDQueueExample new] object:@0]];
        
        _groups = @[GCDGroup, GCDGroup];
    }
    return _groups;
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

@end
