//
//  KeyValueViewController.m
//  Snippets
//
//  Created by Walker on 2020/11/30.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "MessageViewController.h"
#import "WRSnippetItem.h"
#import "WRSnippetGroup.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSnippetGroups:@[
        [self kvo],
        [self kvc],
    ]];
}

- (WRSnippetGroup*)kvo{
    WRSnippetGroup *kvo = [WRSnippetGroup groupWithName:@"Key-Value Observing"];
    
    [kvo addSnippetItem:[WRSnippetItem itemWithName:@"指定依赖关系" viewControllerClassName:@"ColorConvertorViewController" detail:@"Lab到RGB颜色空间的转换"]];
    
    return kvo;
}

- (WRSnippetGroup*)kvc{
    WRSnippetGroup *kvc = [WRSnippetGroup groupWithName:@"Key-Value Coding"];
    
    [kvc addSnippetItem:[WRSnippetItem itemWithName:@"KVC一般使用" viewControllerClassName:@"ClassmateContactViewController" detail:@"快速绑定Model层和View层"]];
    
    return kvc;
}

@end
