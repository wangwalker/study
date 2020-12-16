//
//  QuartzPatternViewExample.m
//  Snippets
//
//  Created by Walker on 2020/12/14.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "QuartzPatternViewExample.h"

@implementation QuartzPatternViewExample

#define H_PATTERN_SIZE 16
#define V_PATTERN_SIZE 18
 
void MySquaredPattern (void *info, CGContextRef myContext) {
    CGFloat subunit = 5; // the pattern cell itself is 16 by 18
 
    CGRect  rect1 = {{0,0}, {subunit, subunit}},
            rect2 = {{subunit, subunit}, {subunit, subunit}},
            rect3 = {{0,subunit}, {subunit, subunit}},
            rect4 = {{subunit,0}, {subunit, subunit}};
 
    CGContextSetRGBFillColor (myContext, 1, 1, 1, 0.5);
    CGContextFillRect (myContext, rect1);
    CGContextSetRGBFillColor (myContext, 1, 0, 0, 0.5);
    CGContextFillRect (myContext, rect2);
    CGContextSetRGBFillColor (myContext, 0, 1, 0, 0.5);
    CGContextFillRect (myContext, rect3);
    CGContextSetRGBFillColor (myContext, .5, 0, .5, 0.5);
    CGContextFillRect (myContext, rect4);
}

void MyPatternPaint(CGContextRef context, CGRect rect) {
    CGPatternRef    pattern;
    CGColorSpaceRef patternSpace;
    CGFloat         alpha = 1;
    static const    CGPatternCallbacks callbacks = {
                        0,
                        &MySquaredPattern,
                        NULL
                    };
    patternSpace =  CGColorSpaceCreatePattern(NULL);

    CGContextSaveGState(context);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    
    pattern = CGPatternCreate(NULL,
                              CGRectMake(0, 0, H_PATTERN_SIZE, V_PATTERN_SIZE),
                              CGAffineTransformMake(1, 0, 0, 1, 0, 0),
                              H_PATTERN_SIZE,
                              V_PATTERN_SIZE,
                              kCGPatternTilingConstantSpacing,
                              true,
                              &callbacks);
    
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    
}

- (void)drawRect:(CGRect)rect {
    CGRect square = CGRectMake(0, (CGRectGetHeight(self.bounds)-CGRectGetWidth(self.bounds))/2, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds));
    
    MyPatternPaint(UIGraphicsGetCurrentContext(), square);
}


@end
