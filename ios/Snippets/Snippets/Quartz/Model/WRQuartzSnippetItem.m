//
//  WRQuartzSnippetItem.m
//  Snippets
//
//  Created by Walker on 2020/12/9.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "WRQuartzSnippetItem.h"
#import "QuartzBaseViewController.h"

@implementation WRQuartzSnippetItem{
    QuartzBaseViewController *quartzViewController;
}

- (id)relatedViewController{
    if (!quartzViewController) {
        if ([super relatedViewController]) {
            quartzViewController = (QuartzBaseViewController *)[super relatedViewController];
            if (self.relatedViewClassName) {
                [quartzViewController setChildViewClassName:self.relatedViewClassName];
            }
        }
    }
    return quartzViewController;
}
@end
