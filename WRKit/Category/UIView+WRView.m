//
//  UIView+WRView.m
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import "UIView+WRView.h"

@implementation UIView (WRView)

#pragma mark - property
-(void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(CGFloat)x{
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}

-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setImage:(UIImage *)image
{
    self.layer.contents = (id)image.CGImage;
}

- (UIImage *)image
{
    return [UIImage imageWithCGImage:(__bridge CGImageRef)(self.layer.contents)];
}

// 只有get
- (CGFloat)totalWidth{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setTotalWidth:(CGFloat)totalWidth{
    
}

- (CGFloat)totalHeight{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setTotalHeight:(CGFloat)totalHeight{
}

- (CGFloat)halfWidth{
    return self.width / 2.0;
}

- (void)setHalfWidth:(CGFloat)width{
    
}

- (CGFloat)halfHeight{
    return self.height / 2.0;
}

- (void)setHalfHeight:(CGFloat)height{
    
}


#pragma mark - about UI
- (void)addRectCorner:(UIRectCorner)rectCorner withSize:(CGSize)size
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:rectCorner
                                                         cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addCornerRadius:(CGFloat)radius color:(UIColor *)color lineWidth:(CGFloat)width{
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    UIColor *currentColor = color ? color : self.backgroundColor;
    self.layer.borderColor = currentColor.CGColor;
    self.layer.borderWidth = width;
    
}

- (void)addCorner:(UIColor *)color withWidth:(CGFloat)width
{
    [self addCornerRadius:MIN(self.width, self.height) / 2 color:color lineWidth:width];
}

-(void)addBorderWithColor:(UIColor *)color withWidth:(CGFloat)width{
    
    self.layer.masksToBounds = YES;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

-(void)addGradientLayerFromColor:(UIColor *)fColor toColor:(UIColor *)tColor
{
    UIView *gradentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:gradentView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = gradentView.bounds;
    
    [gradentView.layer addSublayer:gradientLayer];
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    gradientLayer.colors = @[(__bridge id)tColor.CGColor,
                             (__bridge id)fColor.CGColor];
}


#pragma mark - animation
-(void)startRotate
{
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.toValue = [NSNumber numberWithFloat:M_PI * 2];
    rotate.duration = 1.0f;
    rotate.repeatCount = 60;
    rotate.cumulative = YES;
    
    [self.layer addAnimation:rotate forKey:@"rotationAnimation"];
}
@end
