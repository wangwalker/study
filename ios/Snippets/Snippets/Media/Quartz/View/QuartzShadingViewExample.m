//
//  QuartzShadingViewExample.m
//  Snippets
//
//  Created by Walker on 2020/12/14.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "QuartzShadingViewExample.h"

@implementation QuartzShadingViewExample

static void myCalculateShadingValues (void *info,
                            const CGFloat *in,
                            CGFloat *out) {
    CGFloat v;
    size_t k, components;
    static const CGFloat c[] = {1, 0, .5, 0 };
 
    components = (size_t)info;
 
    v = *in;
    for (k = 0; k < components -1; k++)
        *out++ = c[k] * v;
     *out++ = 1;
}


static CGFunctionRef myGetFunction (CGColorSpaceRef colorspace) {
    size_t numComponents;
    static const CGFloat input_value_range [2] = { 0, 1 };
    static const CGFloat output_value_ranges [8] = { 0, 1, 0, 1, 0, 1, 0, 1 };
    static const CGFunctionCallbacks callbacks = { 0,
                                &myCalculateShadingValues,
                                NULL };
 
    numComponents = 1 + CGColorSpaceGetNumberOfComponents (colorspace);
    return CGFunctionCreate ((void *) numComponents,
                                1,
                                input_value_range,
                                numComponents,
                                output_value_ranges,
                                &callbacks);
}

void myPaintRadialShading (CGContextRef myContext, CGRect bounds) {
    CGPoint startPoint, endPoint;
    CGFloat startRadius, endRadius;
    CGAffineTransform myTransform;
    CGColorSpaceRef colorspace;
    CGShadingRef shading;
    CGFunctionRef shadingFuction;
    
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
 
    startPoint = CGPointMake(0.25,0.3);
    startRadius = .1;
    endPoint = CGPointMake(.7,0.7);
    endRadius = .25;
 
    colorspace = CGColorSpaceCreateDeviceRGB();
    shadingFuction = myGetFunction (colorspace);
 
    shading = CGShadingCreateRadial (colorspace,
                            startPoint, startRadius,
                            endPoint, endRadius,
                            shadingFuction,
                            false, false);
 
    myTransform = CGAffineTransformMakeScale (width, height);
    CGContextConcatCTM (myContext, myTransform);
    CGContextSaveGState (myContext);
 
    CGContextClipToRect (myContext, CGRectMake(0, 0, 1, 1));
    CGContextSetRGBFillColor (myContext, 1, 1, 1, 1);
    CGContextFillRect (myContext, CGRectMake(0, 0, 1, 1));
 
    CGContextDrawShading (myContext, shading);
    CGColorSpaceRelease (colorspace);
    CGShadingRelease (shading);
    CGFunctionRelease (shadingFuction);
 
    CGContextRestoreGState (myContext);
}

- (void)drawRect:(CGRect)rect{
    myPaintRadialShading(UIGraphicsGetCurrentContext(), self.bounds);
}

@end
