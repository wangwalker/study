//
//  CIFilterProcessView.m
//  Snippets
//
//  Created by Walker on 2020/12/16.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "CIFilterAttributePanel.h"
#import "CIFilterInputModel.h"
#import "CIFilterInputView.h"
#import "CIFilterInputViewModel.h"

@interface CIFilterAttributePanel ()
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSArray<CIFilterInputViewModel*> *vms;
@end

@implementation CIFilterAttributePanel {
    CIFilterInputModel *_inputModel;
}

+ (instancetype)panelWithName:(NSString *)name {
    return [[self alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString *)name {
    if ((self = [super init])) {
        _inputModel = [CIFilterInputModel modelWithFilterName:name];
        [self configViewModels];
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)configViewModels{
    NSMutableArray *vms = [NSMutableArray array];
    for (CIFilterInputItem *item in _inputModel.inputItems) {
        CIFilterInputViewModel *vm = [CIFilterInputViewModel vmWithModel:item];
        [vms addObject:vm];
        [self.scrollView addSubview:vm.view];
    }
    
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.bounds)*vms.count, CGRectGetHeight(self.bounds))];
    
    _vms = [vms copy];
}

- (void)updateName:(NSString *)name{
    if ([name isEqualToString:_inputModel.name])
        return;
    
    for (id view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    for (CIFilterInputViewModel *vm in _vms) {
        [vm.view removeFromSuperview];
    }
    
    _inputModel = [CIFilterInputModel modelWithFilterName:name];
    [self configViewModels];
}


#pragma mark - Getter

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
- (CIFilterInputModel *)inputModel{
    return _inputModel;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.scrollView setFrame:self.bounds];
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.bounds)*self.vms.count, CGRectGetHeight(self.bounds))];
    
    for (int i=0; i<self.vms.count; i++) {
        CIFilterInputView *view = self.vms[i].view;
        view.frame = CGRectMake(i*CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }
}

@end
