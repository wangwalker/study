//
//  UIColor+WRColor.m
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import "UIColor+WRColor.h"

@implementation UIColor (WRColor)

+ (UIColor *)colorFromHex:(int)hex{
    
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *)colorFromHex:(int)hex withAlpha:(CGFloat)alpha{
    
    return [[UIColor colorFromHex:hex] colorWithAlphaComponent:alpha];
}

-(NSString *)name
{
    NSString *name;
    
    if (self == [UIColor grayColor]) {
        name = @"gragColor";
    }
    else if (self == [UIColor whiteColor]) {
        name = @"whiteColor";
    }
    else if (self == [UIColor redColor]) {
        name = @"redColor";
    }
    
    return name;
}
@end
