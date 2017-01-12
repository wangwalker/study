//
//  UIColor+WRColor.h
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WRColor)

// 返回一个十六进制表示的颜色: 0xFF0000
+ (UIColor *)colorFromHex:(int)hex;
+ (UIColor *)colorFromHex:(int)hex withAlpha:(CGFloat)alpha;

-(NSString *)name;

@end
