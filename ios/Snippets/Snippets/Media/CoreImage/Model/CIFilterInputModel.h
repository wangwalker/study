//
//  CIFilterModel.h
//  Snippets
//
//  Created by Walker on 2020/12/16.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CIFilter.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CIFilterInputItemType) {
    CIFilterInputItemNumber,
    CIFilterInputItemVector,
    CIFilterInputItemColor,
    CIFilterInputItemImage,
    CIFilterInputItemUnknown
};

@interface CIFilterInputItem : NSObject

+ (instancetype)itemWithParams:(NSDictionary *)params name:(NSString *)name;

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, readonly) CIFilterInputItemType type;

// For slider, first object is min value, the second object is default value, and the last is max value
@property (nonatomic, readonly) NSArray *sliderRange;

@property (nonatomic) NSNumber *sliderValue;

// The initial values are default vector values
@property (nonatomic) NSArray *vectorValues;

// The components in rgb color
@property (nonatomic) NSArray *colorComponents;

@end


@interface CIFilterInputModel : NSObject

+ (instancetype)modelWithFilterName:(NSString *)name;

@property (nonatomic, copy, readonly) NSString *name;

// The recent filter that is updated recently
@property (nonatomic, readonly) CIFilter *recentFilter;

@property (nonatomic, readonly) NSArray<CIFilterInputItem *>*inputItems;

@end

NS_ASSUME_NONNULL_END
