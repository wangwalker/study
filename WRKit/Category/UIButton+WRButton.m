//
//  UIButton+WRButton.m
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import "UIButton+WRButton.h"
#import "Header.h"


@implementation UIButton (WRButton)

+(UIButton *)buttonWithFrame:(CGRect)frame
                 NormalTitle:(NSString *)normalTitle
            NormalTitleColor:(UIColor *)normalTitleColor
       HighlightedTitleColor:(UIColor *)highLightedColor
                   TitleSize:(CGFloat)titleSize
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button setTitle:normalTitle forState:UIControlStateNormal];
    [button setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [button setTitleColor:highLightedColor forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:titleSize];
    
    return button;
}

+(UIButton *)roundButtonWithFrame:(CGRect)frame
                RoundCornerRadius:(CGFloat)cornerRadius
                      NormalTitle:(NSString *)normalTitle
                 NormalTitleColor:(UIColor *)normalTitleColor
            HighlightedTitleColor:(UIColor *)highLightedColor
                        TitleSize:(CGFloat)titleSize
{
    UIButton *button = [self buttonWithFrame:frame NormalTitle:normalTitle NormalTitleColor:normalTitleColor HighlightedTitleColor:highLightedColor TitleSize:titleSize];
    [button addCornerRadius:cornerRadius color:[UIColor whiteColor] lineWidth:0];
    
    return button;
}

-(void)addBackgroundImage:(NSString *)normalImageName
         highLightedImage:(NSString *)highLightedImageName
{
    //因为图片可能会显示的小一点，所以需设置按钮的bounds属性
    UIImage *nimage = [UIImage image:normalImageName];
    if (nimage.size.width < self.frame.size.width &&
        nimage.size.height < self.frame.size.height)
    {
        self.bounds = CGRectMake(self.frame.size.width/2.0 - nimage.size.width/2.0, self.frame.size.height/2.0 - nimage.size.height/2.0, nimage.size.width, nimage.size.height);
    }
    [self setBackgroundImage:[UIImage image:normalImageName] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage image:highLightedImageName] forState:UIControlStateHighlighted];
}



@end
