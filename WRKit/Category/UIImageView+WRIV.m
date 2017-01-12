//
//  UIImageView+WRIV.m
//  WRKit
//
//  Created by jfy on 16/10/26.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import "UIImageView+WRIV.h"
#import "UIImage+WRImage.h"

@implementation UIImageView (WRIV)

+(UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [image imageScaleToSize:frame.size];
    
    return imageView;
}

@end
