//
//  WRSnippetGroup.m
//  Snippets
//
//  Created by Walker on 2020/11/10.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <UIKit/UILabel.h>
#import "WRSnippetGroup.h"
#import "WRSnippetItem.h"

@implementation WRSnippetGroup{
    NSMutableArray<WRSnippetItem*>* items;
}

+ (instancetype)groupWithName:(NSString *)name{
    return [[self alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString*)name{
    if ([self init]) {
        self.name = name;
    }
    return self;
}

- (instancetype)init{
    if ((self = [super init])) {
        items = [NSMutableArray array];
    }
    return self;
}

- (void)addSnippetItem:(WRSnippetItem *)item{
    [items addObject:item];
}

- (NSArray<WRSnippetItem *> *)snippets{
    return [items copy];
}

@end


@implementation WRSnippetGroupTableViewDataSource{
    __weak NSArray<WRSnippetGroup*>* _groups;
}

+ (instancetype)dataSourceWithGroups:(NSArray<WRSnippetGroup*>*)groups{
    return [[self alloc] initWithGroups:groups];
}

- (instancetype)initWithGroups:(NSArray<WRSnippetGroup*>*)groups{
    if ((self = [super init])) {
        _groups = groups;
    }
    return self;
}

- (NSArray<WRSnippetGroup *> *)groups{
    return _groups;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _groups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _groups[section].snippets.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WRSnippetItem *item = [_groups[indexPath.section].snippets objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.detailedDescription;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%ld-%@", section+1, _groups[section].name];
}


@end
