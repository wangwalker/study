//
//  NetworkViewController.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/7.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "NetworkViewController.h"
#import "WRSnippetGroup.h"
#import "WRSnippetItem.h"

@interface NetworkViewController ()

@end

@implementation NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSnippetGroups:@[
        [self tcp],
    ]];
}

- (WRSnippetGroup *)tcp{
    WRSnippetGroup *tcp = [WRSnippetGroup groupWithName:@"TCP连接"];
    
    [tcp addSnippetItem:[WRSnippetItem itemWithName: @"Socket" viewControllerClassName:@"CommunicatorViewController" detail:@"chat"]];
    
    return tcp;
}

@end
