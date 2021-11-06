//
//  QuartzGradientViewExample.m
//  Snippets
//
//  Created by Walker on 2020/12/14.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "QuartzGradientViewExample.h"

@implementation QuartzGradientViewExample

CGGradientRef CreateGradient(void) {
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    size_t num_locations    = 2;
    CGFloat locations[2]    = { 0.0, 1.0};
    CGFloat components[8]   = { 0.95, 0.3, 0.4, 1.0,
                                0.10, 0.20, 0.30, 1.0 };
    
    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericGray);
    gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                   components,
                                                   locations,
                                                   num_locations);
    
    return gradient;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(),
                                CreateGradient(),
                                CGPointMake(0, 0),
                                CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)),
                                kCGGradientDrawsAfterEndLocation);
    
    CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(),
                                CreateGradient(),
                                self.center, 10,
                                self.center, 200,
                                kCGGradientDrawsAfterEndLocation);
    
}

@end
