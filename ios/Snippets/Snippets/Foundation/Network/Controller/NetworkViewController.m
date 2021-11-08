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
#import "TCPServer.h"

@interface NetworkViewController ()

@end

@implementation NetworkViewController

- (instancetype)init{
    if (self = [super init]) {
        [self initTcpServer];
    }
    return self;
}

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

- (void)initTcpServer{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [TCPServer startWithHost:@"127.0.0.1" port:8888];
    });
}

@end
