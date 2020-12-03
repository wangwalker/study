//
//  NSArrayOperation.h
//  Snippets
//
//  Created by Walker on 2020/12/3.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArrayOperation : NSObject

+ (void)startSort;
+ (void)startSortProduct;

+ (void)startEnumerate;

+ (void)startSearch;
+ (void)startBinarySearch;
+ (void)startSearchProduct;

@end

NS_ASSUME_NONNULL_END
