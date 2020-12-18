//
//  CIFilterInputView.h
//  Snippets
//
//  Created by Walker on 2020/12/17.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIFilterInputView : UIView
@property (nonatomic, copy) NSString* name;
@property (nonatomic, readonly) UILabel *nameLabel;
@end


@interface CIFilterInputSlider : CIFilterInputView

+ (instancetype)sliderWithValueRange:(NSArray *)valueRange;

@property (nonatomic, readonly) UISlider *slider;

@end


@interface CIFilterInputVector : CIFilterInputView

@end


@interface CIFilterInputColor : CIFilterInputView

@end


@interface CIFilterInputImage : CIFilterInputView

@end

NS_ASSUME_NONNULL_END
