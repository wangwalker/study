//
//  UIButton+WRButton.h
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WRButton)

/**
 *  工厂方法创建普通按钮
 *
 *  @param frame            frame
 *  @param normalTitle      title on normal state
 *  @param normalTitleColor title color on normal state
 *  @param highLightedColor highl ighted color
 *  @param titleSize        tile font size
 *  @param action           代理方法
 *
 *  @return uibutton
 */
+(UIButton *)buttonWithFrame:(CGRect )frame
                 NormalTitle:(NSString *)normalTitle
            NormalTitleColor:(UIColor *)normalTitleColor
       HighlightedTitleColor:(UIColor *)highLightedColor
                   TitleSize:(CGFloat )titleSize ;


//圆角按钮
+(UIButton *)roundButtonWithFrame:(CGRect )frame
                RoundCornerRadius:(CGFloat )cornerRadius
                      NormalTitle:(NSString *)normalTitle
                 NormalTitleColor:(UIColor *)normalTitleColor
            HighlightedTitleColor:(UIColor *)highLightedColor
                        TitleSize:(CGFloat )titleSize;


//添加背景图片
-(void)addBackgroundImage:(NSString *)normalImageName
         highLightedImage:(NSString *)highLightedImageName;



@end
