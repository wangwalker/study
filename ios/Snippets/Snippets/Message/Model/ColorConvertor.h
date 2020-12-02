//
//  ColorConverter.h
//  Snippets
//
//  Created by Walker on 2020/11/30.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>

NS_ASSUME_NONNULL_BEGIN

static int const kColorConvertorKVOContextSomeOne;

@interface ColorConvertor : NSObject

@property (nonatomic) double lComponent;
@property (nonatomic) double aComponent;
@property (nonatomic) double bComponent;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, readonly) double redComponent;
@property (nonatomic, readonly) double greenComponent;
@property (nonatomic, readonly) double blueComponent;

@property (nonatomic, strong, readonly) UIColor *color;

@end

NS_ASSUME_NONNULL_END
