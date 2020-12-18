//
//  CIFilterProcessView.h
//  Snippets
//
//  Created by Walker on 2020/12/16.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CIFilterInputModel;

@interface CIFilterAttributePanel : UIView

+ (instancetype)panelWithName:(NSString *)name;

@property (nonatomic, readonly) CIFilterInputModel *inputModel;

@end

NS_ASSUME_NONNULL_END
