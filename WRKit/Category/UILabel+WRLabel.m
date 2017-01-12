//
//  UILabel+WRLabel.m
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import "UILabel+WRLabel.h"
#import "UIView+WRView.h"

@implementation UILabel (WRLabel)

+(UILabel *)labelWithRect:(CGRect)rect textAlignment:(NSTextAlignment)alignment fontSize:(CGFloat)size withText:(NSString *)text textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.textAlignment = alignment;
    label.font = [UIFont systemFontOfSize:size];
    label.text = text;
    label.textColor = textColor;
    
    return label;
}

+(UILabel *)roundLabelWithRect:(CGRect)rect radius:(NSInteger)radius textAlignment:(NSTextAlignment)alignment fontSize:(CGFloat)size withText:(NSString *)text textColor:(UIColor *)textColor
{
    UILabel *label = [self labelWithRect:rect textAlignment:alignment fontSize:size withText:text textColor:textColor];
    [label addCornerRadius:radius color:[UIColor whiteColor] lineWidth:0];
    
    return label;
}

- (CGSize)estimateUISizeByHeight:(CGFloat)height
{
    if ( nil == self.text || 0 == self.text.length )
        return CGSizeMake( 0.0f, height );
    
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(10000, 0)
                                          options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    
    return size;
}

@end
