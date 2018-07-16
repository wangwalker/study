//
//  UIImage+WRImage.h
//  tCCSC
//
//  Created by IMAC on 2018/4/20.
//  Copyright © 2018年 IMAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WRImage)

// 直接加载工程的图片 适配不同的系统因渲染问题导致有时看不到图片 同时也是缓存的方式.
+ (UIImage *)image:(NSString *)resourceName;

// 将图片进行缩放
- (UIImage *)imageScaleToSize:(CGSize)size;

-(UIImage *)uniformScaleToWidth:(CGFloat)width;

-(UIImage *)uniformScaleWithRatio:(CGFloat)ratio;

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

//生成一个二维码
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;

//生成条形码
+(UIImage *)generateBarCode:(NSString *)barString withWidth:(CGFloat)width height:(CGFloat)height;

//根据view转换image
+ (UIImage*) imageWithUIView:(UIView*) view;

/**
 * get the image data size with a formated(KB, MB, GB ...) string,
 */
-(NSString *)getSizeWithCompressRatio:(CGFloat)ratio;


/**
 * return if a image is landscape and portraits
 */
-(Boolean)isLandscape;


/**
 * 获取图片的Exif信息
 */
+(NSDictionary *)getImageExifWithMediaURL:(NSURL *)mediaURL;


@end
