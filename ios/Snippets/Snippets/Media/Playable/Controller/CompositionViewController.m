//
//  CompositionViewController.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/30.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "CompositionViewController.h"
#import "VideoPickerProxy.h"
#import "VideoCollection.h"
#import "VideoAssetInfo.h"

@interface CompositionViewController ()
@property (nonatomic) AVMutableComposition *composition;
@property (nonatomic) AVMutableCompositionTrack *videoTrack;
@property (nonatomic) AVMutableCompositionTrack *audioTrack;
@property (nonatomic) VideoCollection *collection;
@end

@implementation CompositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self.videoProxy addObserver:self forKeyPath:@"videoUrl" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.collection setFrame:CGRectMake(8, 49, UIScreen.mainScreen.bounds.size.width-16, UIScreen.mainScreen.bounds.size.width/3+8)];
}
#pragma mark - Delegate

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self observeVideoPickerProxy:object];
}
- (void)video:(NSString *)path didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"video exported");
}
#pragma mark - Method

- (void)setupUI{
    UIBarButtonItem *add, *export;
    add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pickVideo:)];
    export = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(exportVideo:)];
    self.navigationItem.rightBarButtonItems = @[add, export];
    
    [self.view addSubview:self.collection];
}
- (void)pickVideo:(UIBarButtonItem *)sender{
    [self pickVideoWithCompletionHandler:^{
        
    }];
}
- (void)exportVideo:(UIBarButtonItem *)sender{
    if (_collection.infos.count < 2) {
        return;
    }
    [self exportVideoComposition:[self videoCompositionByApplyLayerInstructions]];
}
- (void)observeVideoPickerProxy:(id)object{
    if (object != self.videoProxy) {
        return;
    }
    AVAsset *asset = [AVAsset assetWithURL:self.videoProxy.videoUrl];
    [self insertAsset:asset];
    [self appendAssetInfo:[VideoAssetInfo infoWithAVAsset:asset]];
}
- (void)insertAsset:(AVAsset *)asset{
    AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    AVAssetTrack *audioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    
    [self.videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoTrack.timeRange.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    [self.audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioTrack.timeRange.duration) ofTrack:audioTrack atTime:kCMTimeZero error:nil];
    CMTimeShow(self.videoTrack.timeRange.start);
    CMTimeShow(self.videoTrack.timeRange.duration);
    CMTimeShow(self.audioTrack.timeRange.start);
    CMTimeShow(self.audioTrack.timeRange.duration);
}
- (void)appendAssetInfo:(VideoAssetInfo *)info{
    [info generateThumbnailWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collection appendAssetInfo:info];
        });
    }];
}
- (void)addAudioRamp{
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.audioTrack];
    [audioInputParams setVolumeRampFromStartVolume:0 toEndVolume:1.f timeRange:self.audioTrack.timeRange];
    audioMix.inputParameters = @[audioInputParams];
}
- (AVMutableVideoComposition *)videoCompositionByApplyLayerInstructions{
    CGAffineTransform firstTransform, secondTransform;
    AVAssetTrack *firstVideoAssetTrack, *secondVideoAssetTrack;
    firstVideoAssetTrack = [_collection.infos[0].asset tracksWithMediaType:AVMediaTypeVideo][0];
    secondVideoAssetTrack = [_collection.infos[1].asset tracksWithMediaType:AVMediaTypeVideo][1];
    firstTransform = CGAffineTransformMakeScale(2, 3);
    secondTransform = CGAffineTransformMakeScale(0.5, 0.5);
    
    AVMutableVideoCompositionInstruction *firstVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    // Set the time range of the first instruction to span the duration of the first video track.
    firstVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstVideoAssetTrack.timeRange.duration);
    AVMutableVideoCompositionInstruction * secondVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    // Set the time range of the second instruction to span the duration of the second video track.
    secondVideoCompositionInstruction.timeRange = CMTimeRangeMake(firstVideoAssetTrack.timeRange.duration, CMTimeAdd(firstVideoAssetTrack.timeRange.duration, secondVideoAssetTrack.timeRange.duration));
    AVMutableVideoCompositionLayerInstruction *firstVideoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:self.videoTrack];
    // Set the transform of the first layer instruction to the preferred transform of the first video track.
    [firstVideoLayerInstruction setTransform:firstTransform atTime:kCMTimeZero];
    AVMutableVideoCompositionLayerInstruction *secondVideoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:self.videoTrack];
    // Set the transform of the second layer instruction to the preferred transform of the second video track.
//    [secondVideoLayerInstruction setTransform:secondTransform atTime:firstVideoAssetTrack.timeRange.duration];
    firstVideoCompositionInstruction.layerInstructions = @[firstVideoLayerInstruction];
    secondVideoCompositionInstruction.layerInstructions = @[secondVideoLayerInstruction];
    
    AVMutableVideoComposition *mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    mutableVideoComposition.instructions = @[firstVideoCompositionInstruction, secondVideoCompositionInstruction];
    mutableVideoComposition.renderSize = UIScreen.mainScreen.bounds.size;
    mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
    return mutableVideoComposition;
}
- (void)exportVideoComposition:(AVMutableVideoComposition *)videoComposition{
    NSDateFormatter *kDateFormatter;
    if (!kDateFormatter) {
        kDateFormatter = [[NSDateFormatter alloc] init];
        kDateFormatter.dateStyle = NSDateFormatterMediumStyle;
        kDateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    // Create the export session with the composition and set the preset to the highest quality.
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:self.composition presetName:AVAssetExportPresetPassthrough];
    // Set the desired output URL for the file created by the export process.
    exporter.outputURL = [[[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create: YES error:nil] URLByAppendingPathComponent:[kDateFormatter stringFromDate:[NSDate date]]] URLByAppendingPathExtension:CFBridgingRelease(UTTypeCopyPreferredTagWithClass((CFStringRef)AVFileTypeQuickTimeMovie, kUTTagClassFilenameExtension))];
    // Set the output file type to be a QuickTime movie.
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = videoComposition;
    // Asynchronously export the composition to a video file and save this file to the camera roll once export completes.
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:exporter.outputURL.path]) {
                    UISaveVideoAtPathToSavedPhotosAlbum(exporter.outputURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
            }
        });
    }];
}

#pragma mark - Getter

- (AVMutableComposition *)composition{
    if (!_composition) {
        _composition = [AVMutableComposition composition];
    }
    return _composition;
}
- (AVMutableCompositionTrack *)videoTrack{
    if (!_videoTrack) {
        _videoTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    }
    return _videoTrack;
}
- (AVMutableCompositionTrack *)audioTrack{
    if (!_audioTrack) {
        _audioTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    }
    return _audioTrack;
}
- (VideoCollection *)collection{
    if (!_collection) {
        _collection = [[VideoCollection alloc] init];
    }
    return _collection;
}
@end
