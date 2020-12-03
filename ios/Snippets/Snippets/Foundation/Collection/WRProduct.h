//
//  WRProduct.h
//  collections
//
//  Created by Walker on 2020/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRProduct : NSObject

@property (nonatomic, assign) NSUInteger sales;

@property (nonatomic, copy) NSString *name;

+ (instancetype)productWithName:(NSString *)name sales:(NSUInteger)sales;

@end

@interface WRProductLab : NSObject

+ (NSArray<WRProduct *>*)testProducts;

+ (WRProduct *)randomProductFromTest;

@end

NS_ASSUME_NONNULL_END
