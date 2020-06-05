//
//  UIView+WRView.m
//  tCCSC
//
//  Created by IMAC on 2018/4/23.
//  Copyright © 2018年 IMAC. All rights reserved.
//

#import "UIView+WRView.h"

@implementation UIView (WRView)

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

-(void)addCornerRadius:(CGFloat)radius
{
    [self addCornerRadius:radius color:nil lineWidth:0];
}

- (void)addCorner:(UIColor *)color withWidth:(CGFloat)width
{
    [self addCornerRadius:self.bounds.size.width / 2 color:color lineWidth:width];
}

-(void)addBorderWithColor:(UIColor *)color withWidth:(CGFloat)width{
    
    self.layer.masksToBounds = YES;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

- (void)animationWithViewTransition:(UIViewSimpleBlock)animationBlock
{
    [UIView transitionWithView:self
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
                    animations:^{
                        if (animationBlock)
                        {
                            animationBlock(self, nil);
                        }
                    } completion:nil];
}


+(UIView *)triangleIndicatorViewWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)backgroundColor{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint topMiddlePoint = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y);
    CGPoint bottomLeftPoint = CGPointMake(frame.origin.x, frame.origin.y + frame.size.height);
    CGPoint bottomRightPoint = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height);
    
    CGContextMoveToPoint(context, topMiddlePoint.x, topMiddlePoint.y);
    CGContextAddLineToPoint(context, bottomRightPoint.x, bottomRightPoint.y);
    CGContextAddLineToPoint(context, bottomLeftPoint.x, bottomLeftPoint.y);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillPath(context);
    
    return (__bridge UIView *)(context);
}


@end
