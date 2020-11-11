//
//  WRGithubUsersViewController.m
//  Snippets
//
//  Created by Walker on 2020/11/10.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "WRNSThreadViewController.h"
#import "WRGithubUser.h"

@interface WRNSThreadViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray<WRGithubUser*>* users;
@end

@implementation WRNSThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUsers:[WRGithubUserGroup testUsers]];
    
    [self.view addSubview:self.tableview];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self downloadAvatars];
}

- (void)downloadAvatars{
    [_users enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(WRGithubUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setIndex:@(idx)];
        [NSThread detachNewThreadSelector:@selector(downloadWithUser:) toTarget:self withObject:obj];
    }];
}

- (void)downloadWithUser:(WRGithubUser*)user{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:user.avatarUrlString]];
    UIImage *image = [[UIImage alloc]initWithData:data];
    if(image) {
          //更新主线程外的数据使用performSelector:onThread:withObject:waitUntilDone:
        NSDictionary *obj = @{
            @"image": image,
            @"index": user.index
        };
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:obj waitUntilDone:YES];
        [_users[user.index.intValue] setAvatar:image];
    } else {
        NSLog(@"avatar is null at index:%@", user.index);
    }
}

- (void)updateUI:(NSDictionary *)obj{
    NSInteger index = [[obj valueForKey:@"index"] integerValue];
    
    for (int i=0; i<_tableview.numberOfSections; i++) {
        UITableViewCell *cell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:i]];
        cell.imageView.image = [obj objectForKey:@"image"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = [_users objectAtIndex:indexPath.row].name;
    }
    cell.textLabel.text = [_users objectAtIndex:indexPath.row].name;
    if (_users[indexPath.row].avatar) {
        cell.imageView.image = _users[indexPath.row].avatar;
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
