//
//  UIScrollView+WRScrollView.h
//  WRKit
//
//  Created by jfy on 16/10/26.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (WRScrollView)

/**
 *
 *
 *  @param frame         .
 *  @param imageNames    图片名称数字
 *  @param isBounce      拉伸
 *  @param svDelegate    scrollViewDelegate
 *  @param pageingEnable 整页翻动
 *  @param pcDelegate    pageControllDelegate
 *  @param tintColor     tintColor description
 *  @param currentColor  currentColor description
 *
 *  @return
 */
+(UIScrollView *)scrollViewWithFrame:(CGRect)frame
                      imageNameArray:(NSArray<NSString *>*)imageNames
                              bounce:(BOOL)isBounce
                          svDelegate:(id)svDelegate
                        pagingEnable:(BOOL)pageingEnable;


@end


@interface UITableView (WRTableView)

+(UITableView *)tableViewWithFrame:(CGRect)frame
                          delegate:(id)delegate
                        dataSource:(id)dataSource
                    tableViewStyle:(UITableViewStyle *)tvStyle;

@end
