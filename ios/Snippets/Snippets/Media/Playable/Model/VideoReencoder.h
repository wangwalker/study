//
//  VideoReencoder.h
//  Snippets
//
//  Created by Walker Wang on 2021/12/2.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VideoReencodedHandler)(NSURL *outputUrl);

@interface VideoReencoder : NSObject
+ (instancetype)reencoderWithAsset:(AVAsset *)asset;
- (void)encodeWithCompletionHandler:(VideoReencodedHandler)completion;
@property (nonatomic, readonly) AVAsset *asset;

@end

NS_ASSUME_NONNULL_END
