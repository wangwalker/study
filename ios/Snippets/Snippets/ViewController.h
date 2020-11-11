//
//  ViewController.h
//  Snippets
//
//  Created by Walker on 2020/6/9.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WRSnippetGroup;

@interface ViewController : UIViewController

@property (nonatomic, strong) NSArray<WRSnippetGroup*>* snippetGroups;

@end

