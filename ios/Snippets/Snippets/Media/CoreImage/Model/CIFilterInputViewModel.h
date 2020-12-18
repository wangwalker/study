//
//  CIFilterInputViewModel.h
//  Snippets
//
//  Created by Walker on 2020/12/17.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CIFilterInputItem;
@class CIFilterInputView;

@interface CIFilterInputViewModel : NSObject

+ (instancetype)vmWithModel:(CIFilterInputItem *)model;

@property (nonatomic, readonly) CIFilterInputItem* model;
@property (nonatomic, readonly) CIFilterInputView *view;

@end

NS_ASSUME_NONNULL_END
