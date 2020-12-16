//
//  QuartzTransformViewExample.m
//  Snippets
//
//  Created by Walker on 2020/12/10.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "QuartzTransformViewExample.h"

@implementation QuartzTransformViewExample

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    
    NSUInteger count = 100;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (int i=0; i<count; i++) {
        CGFloat angle = i * M_PI*2 / count;
        [self drawCicleToPath:path angle:angle];
    }
    
    CGContextAddPath(context, path);
    CGContextSaveGState(context); {
        CGContextSetLineWidth(context, 1);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
        CGContextStrokePath(context);
    }
    
    CGContextRestoreGState(context);
}

- (void)drawCicleToPath:(CGMutablePathRef)path angle:(CGFloat)angle {
    const CGPoint center = self.center;
    const CGFloat radius = 100.0;
          CGFloat ratio  = 4.0;
    
    CGFloat width, height, scale;
    
    width = CGRectGetWidth(self.bounds)*.5;
    height = width/ratio;
    scale = [self cicleScaleAtAngle:angle];
    
    // 注意，旋转中心是anchorPoint，而不是center
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform = CGAffineTransformMakeRotation(angle/100);
    transform = CGAffineTransformTranslate(transform, -cos(angle), -sin(angle));
    transform = CGAffineTransformScale(transform, 1-scale*.5, .5*(1+scale));
    
    CGPathAddArc(path,
                 &transform,
                 center.x,
                 center.y,
                 radius,
                 0,
                 2*M_PI-1e-5, NO);
}

- (CGFloat)cicleScaleAtAngle:(CGFloat)angle{
    const CGFloat baseAngle = M_PI_2;
    
    NSInteger scalerToPi_2 = angle / baseAngle;
    CGFloat midOfPi_2 = angle - scalerToPi_2*baseAngle;
    
    return midOfPi_2/baseAngle;
}

@end
