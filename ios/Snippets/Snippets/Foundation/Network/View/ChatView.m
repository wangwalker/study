//
//  ChatView.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/7.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "ChatView.h"

@interface ChatView ()<UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ChatView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.tableView setFrame:self.frame];
}

- (void)update{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(numberOfMessagesInChatView:)]) {
        return [self.delegate numberOfMessagesInChatView:self];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![self.delegate respondsToSelector:@selector(chatView:chatViewCellAtIndex:)]) {
        return nil;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"];
    }
    if (cell.contentView.subviews.count > 0) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    UIView *customView = [self.delegate chatView:self chatViewCellAtIndex:indexPath.row];
    [cell.contentView addSubview:customView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
