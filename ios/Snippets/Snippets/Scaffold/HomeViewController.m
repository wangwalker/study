//
//  HomeViewController.m
//  Snippets
//
//  Created by Walker on 2020/11/11.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "HomeViewController.h"
#import "WRSnippetManager.h"
#import "WRSnippetGroup.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Snippets"];
    
    [self setSnippetGroups:[WRSnippetManager sharedManager].allSnippetGroups];

}

@end
