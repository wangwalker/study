//
//  UILabel+WRLabel.h
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (WRLabel)

/**
 *  @param rect      、
 *  @param alignment 、
 *  @param size      、
 *  @param text      、
 *  @param textColor 、
 */
+ (UILabel *)labelWithRect:(CGRect)rect
             textAlignment:(NSTextAlignment)alignment
                  fontSize:(CGFloat)size
                  withText:(NSString *)text
                 textColor:(UIColor *)textColor;

+ (UILabel *)roundLabelWithRect:(CGRect)rect
                         radius:(NSInteger)radius
                  textAlignment:(NSTextAlignment)alignment
                       fontSize:(CGFloat)size
                       withText:(NSString *)text
                      textColor:(UIColor *)textColor;

- (CGSize)estimateUISizeByHeight:(CGFloat)height;

/*
 * get width or height of label' size by given a fixed height or width and font size;
 */
- (CGFloat)getWidthReferToHeight:(CGFloat)height fontSize:(CGFloat)fontSize;
- (CGFloat)getHeightReferToWidth:(CGFloat)width fontSize:(CGFloat)fontSize;

@end
