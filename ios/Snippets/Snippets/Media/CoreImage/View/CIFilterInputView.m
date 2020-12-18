//
//  CIFilterInputView.m
//  Snippets
//
//  Created by Walker on 2020/12/17.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "CIFilterInputView.h"

const CGFloat kInputViewWidth = 200.f;
const CGFloat kInputViewHeight = 32.f;

@implementation CIFilterInputView{
    UILabel *nameLabel;
}

- (instancetype)init{
    if ((self = [super init])) {
        nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:16.f];
        nameLabel.textColor = [UIColor lightGrayColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nameLabel];
    }
    return self;
}

- (void)setName:(NSString *)name{
    nameLabel.text = name;
}

- (UILabel *)nameLabel{
    return nameLabel;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [nameLabel setFrame:CGRectMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds), 120, 32)];
    [nameLabel setCenter:self.center];
}

@end


@implementation CIFilterInputSlider {
    UILabel *valueLabel;
    UISlider *_slider;
}

+ (instancetype)sliderWithValueRange:(NSArray *)valueRange{
    return [[self alloc] initWithValueRange:valueRange];
}

- (instancetype)initWithValueRange:(NSArray *)valueRange {
    if ((self = [super init])) {
        [self initUI];
        [self configSliderRange:valueRange];
    }
    return self;
}

- (void)initUI{
    _slider = [[UISlider alloc] init];
    [_slider addTarget:self action:@selector(updateValueLabel:) forControlEvents:UIControlEventValueChanged];
    
    valueLabel = [[UILabel alloc] init];
    valueLabel.font = [UIFont systemFontOfSize:18.f];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.textColor = [UIColor blueColor];
    
    [self addSubview:_slider];
    [self addSubview:valueLabel];
}

- (void)configSliderRange:(NSArray *)range{
    [_slider setMinimumValue:[range.firstObject floatValue]];
    [_slider setMaximumValue:[range.lastObject floatValue]];
}

- (void)updateValueLabel:(UISlider *)slider{
    valueLabel.text = [NSString stringWithFormat:@"%.3f", slider.value];
}

- (UISlider *)slider{
    return _slider;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat nameLabelWidth;
    CGRect nameLabelFrame, sliderFrame;
    
    nameLabelWidth = CGRectGetWidth(self.bounds)-100;
    nameLabelFrame = CGRectMake(CGRectGetMidX(self.bounds)-nameLabelWidth/2,
                                CGRectGetMidY(self.bounds)-kInputViewHeight,
                                nameLabelWidth,
                                kInputViewHeight);
    
    sliderFrame = CGRectMake(CGRectGetMidX(self.bounds)-kInputViewWidth/2,
                             CGRectGetMidY(self.bounds)+kInputViewHeight,
                             kInputViewWidth,
                             kInputViewHeight);
    
    self.nameLabel.frame = nameLabelFrame;
    _slider.frame = sliderFrame;
    valueLabel.frame = CGRectMake(0, 0, nameLabelWidth, 24.f);
    valueLabel.center = CGPointMake(self.center.x, (CGRectGetMaxY(nameLabelFrame)+CGRectGetMinY(sliderFrame)/2));
}

@end


@implementation CIFilterInputVector



@end


@implementation CIFilterInputColor



@end


@implementation CIFilterInputImage



@end
