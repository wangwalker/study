//
//  UIImage+WRImage.h
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WRImage)

// 直接加载工程的图片 适配不同的系统因渲染问题导致有时看不到图片 同时也是缓存的方式.
+ (UIImage *)image:(NSString *)resourceName;

// 将图片进行缩放
- (UIImage *)imageScaleToSize:(CGSize)size;

// 将图片拉伸 imageName 将要拉伸的图片名字
+ (UIImage *)imageStretch:(NSString *)imageName;

// 根据工程文件的图片直接加载 非缓存的方式
+ (UIImage *)imageWithFile:(NSString *)fileString;

// 根据完整的路径加载图片 非缓存的方式
+ (UIImage *)imageWithPath:(NSString *)fileString;

// 高斯模糊 radius 模糊的范围
- (UIImage *)imageWithStackBlur:(NSUInteger)radius;

// 根据颜色绘制图片
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  条形码生成器
 *
 *  @param barString 字符
 *  @param width     条形码宽度
 *  @param height    条形码高度
 *
 *  @return
 */
+(UIImage *)generateBarCode:(NSString *)barString withWidth:(CGFloat)width height:(CGFloat)height;

/**
 *  二维码生成器
 *
 *  @param string         字符
 *  @param Imagesize      二维码宽度和高度【正方形】
 *  @param waterImagesize
 *
 *  @return 
 */
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;

//根据view转换image
+ (UIImage*)imageFromView:(UIView*)view;

//将图片转换成字符串，方便保存
-(NSString *)imageBase64String;

@end
