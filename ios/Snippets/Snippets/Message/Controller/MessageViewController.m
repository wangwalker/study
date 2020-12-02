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
#import "KVCTransaction.h"

@interface MessageViewController ()
@property (nonatomic) UIAlertController *collectionAggAlert;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
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
    
    [kvc addSnippetItem:[WRSnippetItem itemWithName:@"一般使用" viewControllerClassName:@"ClassmateContactViewController" detail:@"快速绑定Model层和View层"]];
    
    [kvc addSnippetItem:[WRSnippetItem itemWithName:@"聚合操作" detail:@"[arr valueForKeyPath:@agg.key]" block:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:self.collectionAggAlert animated:YES completion:^{}];
        });
    }]];
    
    return kvc;
}

#pragma mark - Getter

- (UIAlertController *)collectionAggAlert{
    if (!_collectionAggAlert) {
        _collectionAggAlert = [UIAlertController alertControllerWithTitle:@"选择聚合类型" message:@"基于KVC对数组进行聚合操作" preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (NSString *key in @[@"amount", @"payee", @"date"]) {
            for (NSString *kind in @[@"min", @"max", @"sum", @"avg", @"count"]) {
                NSString *agg = [NSString stringWithFormat:@"@%@.%@", kind, key];
                [_collectionAggAlert addAction:[self actionWithTitle:agg]];
            }
        }
        
        [_collectionAggAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _collectionAggAlert;
}

- (UIAlertAction *)actionWithTitle:(NSString *)title{
    static KVCTransationLab *transactionLab;
    transactionLab = [KVCTransationLab new];
    return [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @try {
            [transactionLab performSelector:@selector(filterWithCollectionOperator:) withObject:title];
        } @catch (NSException *exception) {
            NSLog(@"filter collection exception: %@", exception);
        }
    }];
}

@end
