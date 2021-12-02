//
//  VideoAssetInfo.h
//  Snippets
//
//  Created by Walker Wang on 2021/11/29.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AVAsset;

typedef void(^VideoAssetLoadedCompletionHandler)(void);

@interface VideoAssetInfo : NSObject

+ (instancetype)infoWithAVAsset:(AVAsset *)asset;

- (void)showInfoWithLoadedCompletionHandler:(VideoAssetLoadedCompletionHandler)completion;

- (void)generateThumbnailWithCompletionHandler:(VideoAssetLoadedCompletionHandler)completion;

@property (nonatomic, readonly) AVAsset *asset;

@property (nonatomic, readonly) UIImage *thumbnail;

@end

NS_ASSUME_NONNULL_END
