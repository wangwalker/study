//
//  VideoCollection.h
//  Snippets
//
//  Created by Walker Wang on 2021/12/1.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoAssetInfo;

@interface VideoCollection : UIView
@property (nonatomic) NSArray<VideoAssetInfo*>* infos;
- (void)appendAssetInfo:(VideoAssetInfo *)asset;
@end

@interface VideoCollectionCell : UICollectionViewCell
- (void)config:(VideoAssetInfo *)info;
@end

NS_ASSUME_NONNULL_END
