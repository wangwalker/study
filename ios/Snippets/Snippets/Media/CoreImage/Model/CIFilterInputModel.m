//
//  CIFilterModel.m
//  Snippets
//
//  Created by Walker on 2020/12/16.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "CIFilterInputModel.h"
#import <CoreImage/CoreImage.h>

@implementation CIFilterInputItem {
    NSString * _name;
    NSArray * _sliderRange;
    CIFilterInputItemType _type;
}

@dynamic name;
@dynamic type;
@dynamic sliderRange;

+ (instancetype)itemWithParams:(NSDictionary *)params name:(nonnull NSString *)name{
    return [[self alloc] initWithParams:params name:name];
}

- (instancetype)initWithParams:(NSDictionary *)params name:(NSString *)name{
    if ((self = [super init])) {
        _name = name;
        _sliderRange = [NSArray arrayWithObjects:
                            [params valueForKey:kCIAttributeSliderMin],
                            [params valueForKey:kCIAttributeDefault],
                            [params valueForKey:kCIAttributeSliderMax], nil];
        [self configTypeWithName:[params valueForKey:kCIAttributeClass]];
    }
    return self;
}

- (void)configTypeWithName:(NSString *)typeName {
    if ([typeName isEqualToString:@"NSNumber"]) {
        _type = CIFilterInputItemNumber;
    } else if ([typeName isEqualToString:@"CIVector"]) {
        _type = CIFilterInputItemVector;
    } else if ([typeName isEqualToString:@"CIColor"]) {
        _type = CIFilterInputItemColor;
    } else if ([typeName isEqualToString:@"CIImage"]) {
        _type = CIFilterInputItemImage;
    } else {
        _type = CIFilterInputItemUnknown;
    }
}

- (NSString *)name {
    return _name;
}

- (NSArray *)sliderRange{
    return _sliderRange;
}

- (CIFilterInputItemType)type {
    return _type;
}

@end


@implementation CIFilterInputModel {
    NSString *_name;
    CIFilter *_filter;
    NSArray<CIFilterInputItem *>*_inputItems;
}

+ (instancetype)modelWithFilterName:(NSString *)name{
    return [[self alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString *)name {
    if ((self = [super init])) {
        _name = name;
        [self configItemsWithName:name];
    }
    return self;
}

- (void)configItemsWithName:(NSString *)name {
    _filter = [CIFilter filterWithName:name];
    
    NSMutableArray *inputItems = [NSMutableArray array];
    for (NSString *inputKey in _filter.attributes) {
        // Input key starts with 'input', except for 'inputImage'
        if ([inputKey hasPrefix:@"input"] &&
            ![inputKey isEqualToString:@"inputImage"]) {
            CIFilterInputItem *item = [CIFilterInputItem itemWithParams:_filter.attributes[inputKey] name:inputKey];
            [inputItems addObject:item];
        }
    }
    
    _inputItems = [inputItems copy];
}

- (CIFilter *)recentFilter{
    for (CIFilterInputItem *item in _inputItems) {
        if (item.type == CIFilterInputItemNumber) {
            [_filter setValue:item.sliderValue?:item.sliderRange[1] forKey:item.name];
            NSLog(@"%@ is %@", item.name, item.sliderValue?:item.sliderRange[1]);
        }
    }
    
    return _filter;
}

- (NSString *)name{
    return _name;
}

@end
