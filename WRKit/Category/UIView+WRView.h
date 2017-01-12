//
//  UIView+WRView.h
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import <UIKit/UIKit.h>

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

#pragma mark - about UI
/**
 *  添加圆角
 *
 *  @param rectCorner 圆角位置
 *  @param size       圆角大小
 */
- (void)addRectCorner:(UIRectCorner)rectCorner withSize:(CGSize)size;

/**
 *  添加圆角, 半径默认为边长的一半.
 *
 *  @param color 为边框颜色
 *  @param width 为边框的宽度
 */

- (void)addCorner:(UIColor *)color withWidth:(CGFloat)width;

/**
 *  添加圆角，可以设置半径大小，颜色和宽度
 */
- (void)addCornerRadius:(CGFloat)radius color:(UIColor *)color lineWidth:(CGFloat)width;

/**
 *  添加边框
 *
 *  @param color 边框颜色
 *  @param width 边框宽度
 */
-(void)addBorderWithColor:(UIColor *)color withWidth:(CGFloat)width;

/**
 *  为视图添加渐变色（对称渐变）
 *
 *  @param fcolor 渐变起始色
 *  @param tColor 渐变结束色
 */
-(void)addGradientLayerFromColor:(UIColor *)fColor toColor:(UIColor *)tColor;


#pragma mark - animation
-(void)startRotate;


@end
