//
//  ColorConvertorViewController.m
//  Snippets
//
//  Created by Walker on 2020/11/30.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "ColorConvertorViewController.h"
#import "ColorConvertor.h"
#import "KeyValueObserver.h"

@interface ColorConvertorViewController ()
@property (nonatomic, strong) ColorConvertor* labColorConverter;
@property (nonatomic, strong) id colorObserveToken;
@end

@implementation ColorConvertorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

//    [self setConvertorNatively];
    
    [self setConvertorByHelper];
}

- (void)setConvertorByHelper {
    // 通过KeyValueObserver辅助类，将注册和处理回调以及移除整合在一起
    // 间接将所有工作加载labColorConverter的初始化setter中
    [self setLabColorConverter:[ColorConvertor new]];
}

- (void)setLabColorConverter:(ColorConvertor *)labColorConverter{
    _labColorConverter = labColorConverter;
    
    _colorObserveToken = [KeyValueObserver observeObject:labColorConverter
                                                 keyPath:@"color"
                                                  target:self
                                                selector:@selector(updateColor:)
                                                 options:NSKeyValueObservingOptionInitial];
}

- (void)setConvertorNatively{
    [self setLabColorConverter:[ColorConvertor new]];
    [self setConvertorObserver];
}

- (void)setConvertorObserver {
    [self.labColorConverter addObserver:self
                             forKeyPath:@"color"
                                options:NSKeyValueObservingOptionInitial
                                context:NULL];
}

- (void)setConvertorObserverWithContext{
    [self.labColorConverter addObserver:self
                             forKeyPath:@"color"
                                options:(NSKeyValueObservingOptionInitial|
                                         NSKeyValueObservingOptionOld|
                                         NSKeyValueObservingOptionNew)
                                context:&kColorConvertorKVOContextSomeOne];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context == &kColorConvertorKVOContextSomeOne) {
        // 做相应的处理
    }
    if ([keyPath isEqualToString:@"color"]) {
        [self performSelector:@selector(updateColor:) withObject:change];
    }
}

- (void)updateColor:(NSDictionary*)change {
    id oldValue = change[NSKeyValueChangeOldKey];
    id newValue = change[NSKeyValueChangeNewKey];
    NSLog(@"update bgcolor, old: %@, new: %@", oldValue, newValue);
    self.view.backgroundColor = self.labColorConverter.color;
}

- (IBAction)updateLComponent:(UISlider *)sender {
    self.labColorConverter.lComponent = sender.value;
}

- (IBAction)updateAComponent:(UISlider *)sender {
    self.labColorConverter.aComponent = sender.value;
}

- (IBAction)updateBComponent:(UISlider *)sender {
    self.labColorConverter.bComponent = sender.value;
}

- (void)dealloc{
    [self.labColorConverter removeObserver:self forKeyPath:@"color"];
}

@end
