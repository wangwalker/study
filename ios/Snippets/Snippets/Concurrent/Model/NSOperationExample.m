//
//  NSOperationExample.m
//  Snippets
//
//  Created by Walker on 2020/11/11.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "NSOperationExample.h"

@implementation NSOperationExample

- (void)start{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    for (NSString *str in [self urlStrs]) {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImageWithUrlString:) object:str];
        [queue addOperation:operation];
    }
    NSInputStream *inputs;
    [queue addBarrierBlock:^{
        NSLog(@"all operations finished");
    }];
}

- (void)downloadImageWithUrlString:(NSString*)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSLog(@"response data length:%zd from \nurl:%@", data.length, urlStr);
    // ...
}

- (NSArray<NSString*>*)urlStrs{
    return @[
        @"https://avatar.csdnimg.cn/B/A/A/3_qq_25537177.jpg",
        @"https://profile.csdnimg.cn/B/4/2/3_qq_41185868",
        @"https://profile.csdnimg.cn/8/0/6/3_qq_35190492",
        @"https://profile.csdnimg.cn/5/2/2/3_dataiyangu",
    ];
}

@end
