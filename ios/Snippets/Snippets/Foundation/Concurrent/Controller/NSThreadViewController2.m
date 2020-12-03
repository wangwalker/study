//
//  WRNSThreadViewController2.m
//  Snippets
//
//  Created by Walker on 2020/11/11.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "NSThreadViewController2.h"
#import "WRGithubUser.h"
#import "WRGithubUserThread.h"

@interface NSThreadViewController2 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray<WRGithubUserThread*>* users;
@end

@implementation NSThreadViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupProps];
    
    [self.view addSubview:self.tableview];
}

- (void)setupProps{
    NSMutableArray *users = [NSMutableArray array];
    for (WRGithubUser *user in [WRGithubUserGroup testUsers]) {
        [users addObject:[WRGithubUserThread threadWithUser:user]];
    }
    self.users = [users copy];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self downloadAvatars];
}

- (void)downloadAvatars{
    [_users enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(WRGithubUserThread * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isFinished || obj.isExecuting) {
            return;
        }
        __weak WRGithubUser* weakUser = obj.user;
        [weakUser setIndex:@(idx)];
        [obj setHandler:^(void) {
            [self performSelectorOnMainThread:@selector(updateUI:)
                                   withObject:weakUser
                                waitUntilDone:NO
                                        modes:@[NSRunLoopCommonModes]];
        }];
    }];
}

- (void)updateUI:(WRGithubUser *)user{
    for (int i=0; i<_tableview.numberOfSections; i++) {
        UITableViewCell *cell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:user.index.integerValue inSection:i]];
        cell.imageView.image = user.avatar;
    }
    [_tableview reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _users.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"github-user-cell-2"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"github-user-cell-2"];
    }
    cell.textLabel.text = [_users objectAtIndex:indexPath.row].user.name;
    if (_users[indexPath.row].user.avatar) {
        cell.imageView.image = _users[indexPath.row].user.avatar;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

