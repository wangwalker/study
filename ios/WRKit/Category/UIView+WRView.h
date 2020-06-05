//
//  UIView+WRView.h
//  tCCSC
//
//  Created by IMAC on 2018/4/23.
//  Copyright © 2018年 IMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UIViewSimpleBlock)(UIView *aView, id object);

@interface UIView (WRView)
/**
 *  长度和位置属性的便捷获取
 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, strong) UIImage *image;

/**
 *  这些属性只能获取
 */
@property (nonatomic, assign, readonly) CGFloat totalWidth;
@property (nonatomic, assign, readonly) CGFloat totalHeight;
@property (nonatomic, assign, readonly) CGFloat halfWidth;
@property (nonatomic, assign, readonly) CGFloat halfHeight;

/**
 *  添加圆角
 *
 *  @param rectCorner 圆角位置
 *  @param size       圆角大小
 */
- (void)addRectCorner:(UIRectCorner)rectCorner withSize:(CGSize)size;

/**
 *  添加圆角, 是四周的 color  width .
 *
 *  @param color 为边框颜色
 *  @param width 为边框的宽度
 */
- (void)addCorner:(UIColor *)color withWidth:(CGFloat)width;

/**
 *  只添加圆角
 *
 */
-(void)addCornerRadius:(CGFloat)radius;

// 指定角度
- (void)addCornerRadius:(CGFloat)radius color:(UIColor *)color lineWidth:(CGFloat)width;
/**
 *  添加边框
 *
 *  @param color 边框颜色
 *  @param width 边框宽度
 */
-(void)addBorderWithColor:(UIColor *)color withWidth:(CGFloat)width;

/**
 *  为视图切换添加动画效果
 *
 *  @param animationBlock 动作描述
 */
- (void)animationWithViewTransition:(UIViewSimpleBlock)animationBlock;

@end
