//
//  QuartzTransparentLayer.m
//  Snippets
//
//  Created by Walker on 2020/12/14.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "QuartzTransparentLayer.h"

@implementation QuartzTransparentLayer

- (void)drawRect:(CGRect)rect {
    
    NSUInteger   count      = 100;
    CGContextRef context    = UIGraphicsGetCurrentContext();
    CGFloat      angleSeg   = M_PI*2/count;
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.f);
    
    for (int i=0; i<count; i++) {
        CGContextBeginTransparencyLayer(context, NULL);
        [self drawCicleToContext:context angle:i*angleSeg];
        CGContextEndTransparencyLayer(context);
    }
}

- (void)drawCicleToContext:(CGContextRef)context angle:(CGFloat)angle {
    CGFloat width, height, radius;
    CGSize shadeOffset;
    
    width = CGRectGetWidth(self.bounds)*.6;
    height = width/8;
    radius = 100;
    shadeOffset = CGSizeMake(10, -10);
    
    CGContextSetShadow(context, shadeOffset, 10);
    
    CGContextAddArc(context,
                    self.center.x+cos(angle)*radius,
                    self.center.y+sin(angle)*radius,
                    [self radiusAtAngle:angle],
                    0,
                    M_PI*2-1e-5,
                    NO);
    
    CGContextSetRGBFillColor(context, 1.f, 1.f, 1.f, 1.f);
    CGContextSetRGBStrokeColor(context, 1.f, 1.f, 1.f, 1.f);
    CGContextStrokePath(context);
    
}

- (CGFloat)radiusAtAngle:(CGFloat)angle{
    const CGFloat baseAngle = M_PI_2;
    const CGFloat baseRadius = 50;
    
    NSInteger scalerToPi_2 = angle / baseAngle;
    CGFloat midOfPi_2 = angle - scalerToPi_2*baseAngle;
    CGFloat scaleFactor = (0.5 + midOfPi_2/baseAngle);
    
    return scaleFactor * baseRadius;
}

@end
