//
//  CIFilterInputViewModel.m
//  Snippets
//
//  Created by Walker on 2020/12/17.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "CIFilterInputViewModel.h"
#import "CIFilterInputModel.h"
#import "CIFilterInputView.h"

@interface CIFilterInputViewModel ()
@end
@implementation CIFilterInputViewModel {
    CIFilterInputItem *_model;
    CIFilterInputView *_view;
}

+ (instancetype)vmWithModel:(CIFilterInputItem *)model{
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(CIFilterInputItem *)model{
    if ((self = [super init])) {
        _model = model;
        [self initViewWithModel:model];
    }
    return self;
}

- (void)initViewWithModel:(CIFilterInputItem *)model{
    switch (model.type) {
        case CIFilterInputItemNumber:
            [self configSilderForModel:model];
            break;
            
        case CIFilterInputItemVector:
            [self configVectorViewWithModel:model];
            break;
            
        case CIFilterInputItemColor:
            [self configColorPickerWithModel:model];
            break;
            
        case CIFilterInputItemImage:
            [self configImagePickerWithModel:model];
            break;
            
        default:
            break;
    }
}

- (void)configSilderForModel:(CIFilterInputItem *)model{
    _view = [CIFilterInputSlider sliderWithValueRange:model.sliderRange];
    _view.name = model.name;
    
    [((CIFilterInputSlider*)_view).slider addTarget:self action:@selector(sliderDidChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)configVectorViewWithModel:(CIFilterInputItem *)model{
    _view = [[CIFilterInputView alloc] init];
    _view.name = model.name;
}

- (void)configColorPickerWithModel:(CIFilterInputItem *)model{
    _view = [[CIFilterInputView alloc] init];
    _view.name = model.name;
}

- (void)configImagePickerWithModel:(CIFilterInputItem *)model{
    _view = [[CIFilterInputView alloc] init];
    _view.name = model.name;
}

- (void)configDefaultViewWithModel:(CIFilterInputItem *)model{
    _view = [[CIFilterInputView alloc] init];
    _view.name = model.name;
}

#pragma mark - Selectors

- (void)sliderDidChanged:(UISlider *)slider{
    if (_model.type == CIFilterInputItemNumber) {
        _model.sliderValue = [NSNumber numberWithFloat:slider.value];
    }
}

#pragma mark - Getter

- (CIFilterInputView *)view{
    return _view;
}

- (CIFilterInputItem *)model{
    return _model;
}

@end
