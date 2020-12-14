//
//  QuartzPathViewExample.m
//  Snippets
//
//  Created by Walker on 2020/12/9.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "QuartzPathViewExample.h"

@implementation QuartzPathViewExample

- (void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    [self drawPathWithContext:ctx baseline:self.center.y-100 height:160];
}

- (void)drawPathWithContext:(CGContextRef)ctx baseline:(CGFloat)baseline height:(CGFloat)height {

    // 外部矩形
    CGContextSaveGState(ctx);
    
    CGContextMoveToPoint(ctx, 0, baseline);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, .5);
    CGContextSetLineWidth(ctx, 2);
    CGContextStrokeRect(ctx, CGRectMake(0, baseline, CGRectGetWidth(self.bounds), height));
    
    CGContextRestoreGState(ctx);

    /// 正弦曲线
    CGFloat radius = 50;
    CGFloat tickThickNess = 2;
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, baseline+height/2);
    CGMutablePathRef cgpath = CGPathCreateMutable();
    
    // 坐标轴
    CGPathMoveToPoint(cgpath, NULL, 10, center.y);
    CGPathAddLineToPoint(cgpath, NULL, CGRectGetWidth(self.bounds)-20, center.y);
    CGPathMoveToPoint(cgpath, NULL, center.x, baseline+5);
    CGPathAddLineToPoint(cgpath, NULL, center.x, baseline+height-10);
    CGContextAddPath(ctx, cgpath);
    
    CGContextSaveGState(ctx); {
        CGContextSetLineWidth(ctx,tickThickNess);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextSetFlatness(ctx, 1);
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
        CGContextStrokePath(ctx);
    }
    CGContextRestoreGState(ctx);
    
    // 刻度
    CGPathMoveToPoint(cgpath, NULL, 10, center.y-tickThickNess);
    CGPathAddLineToPoint(cgpath, NULL, CGRectGetWidth(self.bounds)-20, center.y-tickThickNess);
    CGPathMoveToPoint(cgpath, NULL, center.x+tickThickNess, baseline+5);
    CGPathAddLineToPoint(cgpath, NULL, center.x+tickThickNess, baseline+height-10);
    CGContextAddPath(ctx, cgpath);
    
    CGContextSaveGState(ctx); {
        const CGFloat lengths[] = {2,5};
        CGContextSetLineWidth(ctx, tickThickNess);
        CGContextSetLineDash(ctx, 0, lengths, 2);
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
        CGContextStrokePath(ctx);
    }
    CGContextRestoreGState(ctx);
    
    // 右半部分圆弧
    CGPathMoveToPoint(cgpath, NULL, center.x+radius*2, center.y);
    CGPathAddArc(cgpath, NULL, center.x+radius, center.y, radius, 0, M_PI, YES);
    
    // 左半部分
    CGPathMoveToPoint(cgpath, NULL, center.x, center.y);
    CGPathAddArc(cgpath, NULL, center.x-radius, center.y, radius, 0, M_PI, NO);
    
    CGContextAddPath(ctx, cgpath);
    
    // 状态
    CGContextSaveGState(ctx); {
        CGContextSetLineWidth(ctx, 1);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextSetFlatness(ctx, 1);
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
        CGContextStrokePath(ctx);
    }
    
    CGContextRestoreGState(ctx);
    CGPathRelease(cgpath);
}

@end
