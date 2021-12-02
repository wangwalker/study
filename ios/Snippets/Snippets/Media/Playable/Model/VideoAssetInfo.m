//
//  VideoAssetInfo.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/29.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Photos/Photos.h>
#import "VideoAssetInfo.h"

@implementation VideoAssetInfo {
    __weak AVAsset *_asset;
}

@synthesize asset = _asset;

+ (instancetype)infoWithAVAsset:(AVAsset *)asset{
    return [[VideoAssetInfo alloc] initWithAsset:asset];
}
- (instancetype)initWithAsset:(AVAsset *)asset{
    if ((self = [super init])) {
        _asset = asset;
    }
    return self;
}

- (void)showInfoWithLoadedCompletionHandler:(void (^)(void))completion{
    NSArray *keys = @[@"duration", @"tracks"];
    
    [_asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        NSError *error = nil;
        AVKeyValueStatus tracksStatus = [self->_asset statusOfValueForKey:@"duration" error:&error];
            switch (tracksStatus) {
                case AVKeyValueStatusUnknown:
                    
                    break;
                case AVKeyValueStatusLoading:
                    
                    break;
                case AVKeyValueStatusLoaded:
                    if (completion) {
                        completion();
                        [self showTracks];
                    }
                    break;
                case AVKeyValueStatusFailed:
                    
                    break;
                case AVKeyValueStatusCancelled:
                    // Do whatever is appropriate for cancelation.
                    break;
            }
    }];
}
- (void)generateThumbnailWithCompletionHandler:(VideoAssetLoadedCompletionHandler)completion{
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:_asset];
    [generator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:kCMTimeZero]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        self->_thumbnail = [[UIImage alloc] initWithCGImage:image];
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Private

- (void)showTracks{
    for (AVAssetTrack *track in _asset.tracks) {
        NSLog(@"track media type is %@", track.mediaType);
        NSLog(@"    time range start:");
        CMTimeShow(track.timeRange.start);
        NSLog(@"    time range duration:");
        CMTimeShow(track.timeRange.duration);
        NSLog(@"    language code is %@, extend language tags is %@", track.languageCode, track.extendedLanguageTag);
        NSLog(@"    natural size is %@", NSStringFromCGSize(track.naturalSize));
        NSLog(@"    preferred transform is %@", NSStringFromCGAffineTransform(track.preferredTransform));
        if ([NSJSONSerialization isValidJSONObject:track.formatDescriptions]) {
            NSArray<NSDictionary*> *descs = [NSJSONSerialization JSONObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:track.formatDescriptions requiringSecureCoding:NO error:nil] options:NSJSONReadingMutableContainers error:nil];
            [descs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dictobj, NSUInteger idx, BOOL * _Nonnull stop) {
                [dictobj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSLog(@"       %@ is %@", key, obj);
                }] ;
            }];
        } else {
            NSLog(@"    formatDescriptions is %@", track.formatDescriptions);
        }
        for (AVMetadataItem *item in track.metadata) {
            [self showMetadata:item];
        }
    }
}
- (void)showMetadata:(AVMetadataItem *)item{
    NSLog(@"      identifier is %@", item.identifier);
    NSLog(@"      value is %@", item.value);
}
- (void)showMediaSelectionOptions{
    NSArray<AVMediaCharacteristic>* chars = _asset.availableMediaCharacteristicsWithMediaSelectionOptions;
    [chars enumerateObjectsUsingBlock:^(AVMediaCharacteristic  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"media characteristic is %@", obj);
        AVMediaSelectionGroup *group = [_asset mediaSelectionGroupForMediaCharacteristic:obj];
        for (AVMediaSelectionOption *option in group.options) {
            NSLog(@"    media type is %@, subtypes is %@, propertylist is %@", option.mediaType, option.mediaSubTypes, option.propertyList);
        }
    }];
}

@end
