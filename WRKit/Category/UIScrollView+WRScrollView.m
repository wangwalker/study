//
//  UIScrollView+WRScrollView.m
//  WRKit
//
//  Created by jfy on 16/10/26.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import "UIScrollView+WRScrollView.h"
#import "UIImage+WRImage.h"

@implementation UIScrollView (WRScrollView)

+(UIScrollView *)scrollViewWithFrame:(CGRect)frame
                      imageNameArray:(NSArray<NSString *> *)imageNames
                              bounce:(BOOL)isBounce
                          svDelegate:(id)svDelegate
                        pagingEnable:(BOOL)pageingEnable

{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.contentSize = CGSizeMake(frame.size.width * imageNames.count, frame.size.height);
    scrollView.delegate = svDelegate;
    scrollView.bounces = isBounce;
    scrollView.pagingEnabled = pageingEnable;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < imageNames.count; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x + i * frame.size.width, 0, frame.size.width, frame.size.height)];
        iv.image = [UIImage image:imageNames[i]];
        [scrollView addSubview:iv];
    }
    
    
    
    return scrollView;
}

@end


@implementation UITableView (WRTableView)

+(UITableView *)tableViewWithFrame:(CGRect)frame delegate:(id)delegate dataSource:(id)dataSource tableViewStyle:(UITableViewStyle *)tvStyle
{
    UITableView *tv = [[UITableView alloc] initWithFrame:frame style:*tvStyle];
    tv.delegate = delegate;
    tv.dataSource = dataSource;
    
    return tv;
}

@end
