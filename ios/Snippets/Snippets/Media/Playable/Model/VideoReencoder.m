//
//  VideoReencoder.m
//  Snippets
//
//  Created by Walker Wang on 2021/12/2.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "VideoReencoder.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface VideoReencoder ()
@property (nonatomic) dispatch_group_t dispatchGroup;
@property (nonatomic) dispatch_queue_t mainQueue;
@property (nonatomic) dispatch_queue_t audioQueue;
@property (nonatomic) dispatch_queue_t videoQueue;
@property (nonatomic) AVAssetReader *assetReader;
@property (nonatomic) AVAssetWriter *assetWriter;
@property (nonatomic) AVAssetReaderTrackOutput *assetReaderAudioOutput;
@property (nonatomic) AVAssetReaderTrackOutput *assetReaderVideoOutput;
@property (nonatomic) AVAssetWriterInput *assetWriterAudioInput;
@property (nonatomic) AVAssetWriterInput *assetWriterVideoInput;
@property (nonatomic) BOOL cancelled;
@property (nonatomic) BOOL audioFinished;
@property (nonatomic) BOOL videoFinished;
@property (nonatomic) NSURL *outputUrl;
@end

@implementation VideoReencoder{
    AVAsset *iAsset;
}

+ (instancetype)reencoderWithAsset:(AVAsset *)asset{
    return [[VideoReencoder alloc] initReencoderWithAsset:asset];;
}
- (instancetype)initReencoderWithAsset:(AVAsset *)asset{
    if ((self = [super init])) {
        iAsset = asset;
        [self setup];
    }
    return self;
}
-(void)encodeWithCompletionHandler:(VideoReencodedHandler)completion{
    [self loadTracksWithCompletionHandler:completion];
}

#pragma mark - Private

- (void)loadTracksWithCompletionHandler:(VideoReencodedHandler)completion{
    [iAsset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        dispatch_async(self.mainQueue, ^{
            if (self.cancelled) {
                return;
            }
            BOOL success = YES;
            NSError *localError = nil;
            success = ([self->iAsset statusOfValueForKey:@"tracks" error:&localError] == AVKeyValueStatusLoaded);
            if (success) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:self.outputUrl.path]) {
                    success = [[NSFileManager defaultManager] removeItemAtURL:self.outputUrl error:&localError];
                }
            } else {
                NSLog(@"error occured when load asset: %@", localError.debugDescription);
                return;
            }
            
            if (success) {
                success = [self setupAssetReaderAndAssetWrite:&localError];
            }
            if (success) {
                success = [self startAssetReaderAndWrite:&localError completion:completion];
            }
            if (!success) {
                [self readingAndWriteDidFinish:success error:localError completion:completion];
            }
        });
    }];
}
- (BOOL)setupAssetReaderAndAssetWrite:(NSError **)error{
    _assetReader = [[AVAssetReader alloc] initWithAsset:iAsset error:error];
    BOOL success = (_assetReader != nil);
    if (success) {
        _assetWriter = [[AVAssetWriter alloc] initWithURL:_outputUrl fileType:AVFileTypeQuickTimeMovie error:error];
        success = (_assetWriter != nil);
    }
    if (success) {
        AVAssetTrack *audioTrack, *videoTrack;
        NSArray *audioTracks = [iAsset tracksWithMediaType:AVMediaTypeAudio];
        NSArray *videoTracks = [iAsset tracksWithMediaType:AVMediaTypeVideo];
        if (audioTracks.count > 0) {
            audioTrack = audioTracks.firstObject;
        }
        if (videoTracks.count > 0) {
            videoTrack = videoTracks.firstObject;
        }
        if (audioTrack) {
            NSDictionary *decompressionAudioSettings = @{ AVFormatIDKey : [NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM] };
            _assetReaderAudioOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:audioTrack outputSettings:decompressionAudioSettings];
            [_assetReader addOutput:_assetReaderAudioOutput];
            AudioChannelLayout stereoChannelLayout = {
                .mChannelLayoutTag = kAudioChannelLayoutTag_Stereo,
                .mChannelBitmap = 0,
                .mNumberChannelDescriptions = 0
            };
            NSData *channelLayoutAsData = [NSData dataWithBytes:&stereoChannelLayout length:offsetof(AudioChannelLayout, mChannelDescriptions)];
            NSDictionary *compressionAudioSettings = @{
                AVFormatIDKey         : [NSNumber numberWithUnsignedInt:kAudioFormatMPEG4AAC],
                AVEncoderBitRateKey   : [NSNumber numberWithInteger:128000],
                AVSampleRateKey       : [NSNumber numberWithInteger:44100],
                AVChannelLayoutKey    : channelLayoutAsData,
                AVNumberOfChannelsKey : [NSNumber numberWithUnsignedInteger:2]
            };
            _assetWriterAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:audioTrack.mediaType outputSettings:compressionAudioSettings];
            [_assetWriter addInput:_assetWriterAudioInput];
        }
        if (videoTrack) {
            NSDictionary *decompressionVideoSettings = @{
                (id)kCVPixelBufferPixelFormatTypeKey     : [NSNumber numberWithUnsignedInt:kCVPixelFormatType_422YpCbCr8],
                (id)kCVPixelBufferIOSurfacePropertiesKey : [NSDictionary dictionary]
            };
            _assetReaderVideoOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:decompressionVideoSettings];
            [_assetReader addOutput:_assetReaderVideoOutput];
            CMFormatDescriptionRef formatDescription = NULL;
            NSArray *videoFormatDescriptions = [videoTrack formatDescriptions];
            if ([videoFormatDescriptions count] > 0) {
                formatDescription = (__bridge CMFormatDescriptionRef)[videoFormatDescriptions objectAtIndex:0];
            }
            CGSize trackDimensions = {
                .width = 0.0,
                .height = 0.0,
            };
            if (formatDescription) {
                trackDimensions = CMVideoFormatDescriptionGetPresentationDimensions(formatDescription, NO, NO);
            } else {
                trackDimensions = [videoTrack naturalSize];
            }
            NSDictionary *compressionSettings = nil;
            if (formatDescription) {
                NSDictionary *cleanAperture = nil;
                NSDictionary *pixelAspectRatio = nil;
                CFDictionaryRef cleanApertureFromCMFormatDescription = CMFormatDescriptionGetExtension(formatDescription, kCMFormatDescriptionExtension_CleanAperture);
                if (cleanApertureFromCMFormatDescription){
                    cleanAperture = @{
                        AVVideoCleanApertureWidthKey : (id)CFDictionaryGetValue(cleanApertureFromCMFormatDescription, kCMFormatDescriptionKey_CleanApertureWidth),
                        AVVideoCleanApertureHeightKey: (id)CFDictionaryGetValue(cleanApertureFromCMFormatDescription, kCMFormatDescriptionKey_CleanApertureHeight),
                        AVVideoCleanApertureHorizontalOffsetKey: (id)CFDictionaryGetValue(cleanApertureFromCMFormatDescription, kCMFormatDescriptionKey_CleanApertureHorizontalOffset),
                        AVVideoCleanApertureVerticalOffsetKey: (id)CFDictionaryGetValue(cleanApertureFromCMFormatDescription, kCMFormatDescriptionKey_CleanApertureVerticalOffset)
                    };
                }
                CFDictionaryRef pixelAspectRatioFromCMFormatDescription = CMFormatDescriptionGetExtension(formatDescription, kCMFormatDescriptionExtension_PixelAspectRatio);
                if (pixelAspectRatioFromCMFormatDescription){
                    pixelAspectRatio = @{
                        AVVideoPixelAspectRatioHorizontalSpacingKey : (id)CFDictionaryGetValue(pixelAspectRatioFromCMFormatDescription, kCMFormatDescriptionKey_PixelAspectRatioHorizontalSpacing),
                        AVVideoPixelAspectRatioVerticalSpacingKey   : (id)CFDictionaryGetValue(pixelAspectRatioFromCMFormatDescription, kCMFormatDescriptionKey_PixelAspectRatioVerticalSpacing)
                    };
                }
                // Add whichever settings we could grab from the format description to the compression settings dictionary.
                if (cleanAperture || pixelAspectRatio){
                    NSMutableDictionary *mutableCompressionSettings = [NSMutableDictionary dictionary];
                    if (cleanAperture)
                        [mutableCompressionSettings setObject:cleanAperture forKey:AVVideoCleanApertureKey];
                    if (pixelAspectRatio)
                        [mutableCompressionSettings setObject:pixelAspectRatio forKey:AVVideoPixelAspectRatioKey];
                    compressionSettings = mutableCompressionSettings;
                }
            }
            NSMutableDictionary *videoSettings = [NSMutableDictionary dictionaryWithDictionary:@{
                AVVideoCodecKey  : AVVideoCodecTypeH264,
                AVVideoWidthKey  : [NSNumber numberWithDouble:trackDimensions.width],
                AVVideoHeightKey : [NSNumber numberWithDouble:trackDimensions.height]
            }];
            if (compressionSettings) {
                [videoSettings setObject:compressionSettings forKey:AVVideoCompressionPropertiesKey];
            }
            _assetWriterVideoInput = [[AVAssetWriterInput alloc] initWithMediaType:videoTrack.mediaType outputSettings:videoSettings];
            [_assetWriter addInput:_assetWriterVideoInput];
        }
    }
    
    return YES;
}
- (BOOL)startAssetReaderAndWrite:(NSError **)outError completion:(VideoReencodedHandler)handler{
    BOOL success = YES;
    success = [_assetReader startReading];
    if (!success)
        *outError = [_assetReader error];
    if (success){
        // If the reader started successfully, attempt to start the asset writer.
        success = [_assetWriter startWriting];
        if (!success)
            *outError = [_assetWriter error];
    }
    if (success) {
        _dispatchGroup = dispatch_group_create();
        [_assetWriter startSessionAtSourceTime:kCMTimeZero];
        _audioFinished = NO;
        _videoFinished = NO;
        if (_assetWriterAudioInput) {
            dispatch_group_enter(_dispatchGroup);
            [_assetWriterAudioInput requestMediaDataWhenReadyOnQueue:_audioQueue usingBlock:^{
                if (self->_audioFinished) {
                    return;
                }
                BOOL completedOrFailed = NO;
                while ([self->_assetWriterAudioInput isReadyForMoreMediaData] && !completedOrFailed) {
                    CMSampleBufferRef sampeBuffer = [self->_assetReaderAudioOutput copyNextSampleBuffer];
                    if (sampeBuffer != NULL) {
                        BOOL success = [self->_assetWriterAudioInput appendSampleBuffer:sampeBuffer];
                        CFRelease(sampeBuffer);
                        sampeBuffer = NULL;
                        completedOrFailed = !success;
                    } else {
                        completedOrFailed = YES;
                    }
                }
                if (completedOrFailed) {
                    BOOL oldFinished = self.audioFinished;
                    self.audioFinished = YES;
                    if (oldFinished == NO){
                        [self.assetWriterAudioInput markAsFinished];
                    }
                    dispatch_group_leave(self.dispatchGroup);
                }
            }];
        }
        if (_assetWriterVideoInput) {
            dispatch_group_enter(_dispatchGroup);
            [_assetWriterVideoInput requestMediaDataWhenReadyOnQueue:_videoQueue usingBlock:^{
                if (self->_videoFinished) {
                    return;
                }
                BOOL completedOrFailed = NO;
                while ([self->_assetWriterVideoInput isReadyForMoreMediaData] && !completedOrFailed) {
                    CMSampleBufferRef sampleBuffer = [self->_assetReaderVideoOutput copyNextSampleBuffer];
                    if (sampleBuffer != NULL) {
                        [self->_assetWriterVideoInput appendSampleBuffer:sampleBuffer];
                        CFRelease(sampleBuffer);
                        sampleBuffer = NULL;
                        completedOrFailed = !success;
                    } else {
                        completedOrFailed = YES;
                    }
                }
                if (completedOrFailed) {
                    BOOL oldFinished = self->_videoFinished;
                    self.videoFinished = YES;
                    if (oldFinished == NO) {
                        [self->_assetWriterVideoInput markAsFinished];
                    }
                    dispatch_group_leave(self->_dispatchGroup);
                }
            }];
        }
        // notification when audio and video work both finished
        dispatch_group_notify(_dispatchGroup, _mainQueue, ^{
            BOOL finalSuccess = YES;
            NSError *finalError = nil;
            // Check to see if the work has finished due to cancellation.
            if (self.cancelled){
                // If so, cancel the reader and writer.
                [self.assetReader cancelReading];
                [self.assetWriter cancelWriting];
            } else {
                if (self->_assetReader.status == AVAssetReaderStatusFailed) {
                    finalSuccess = NO;
                    finalError = self->_assetReader.error;
                }
                if (finalSuccess) {
                    [self->_assetWriter finishWritingWithCompletionHandler:^{
                        
                    }];
                    finalError = self->_assetWriter.error;
                }
            }
            [self readingAndWriteDidFinish:finalSuccess error:finalError completion:handler];
        });
    }
    return success;
}
- (void)readingAndWriteDidFinish:(BOOL)success error:(NSError *)outError completion:(VideoReencodedHandler)handler{
    if (!success) {
        [_assetReader cancelReading];
        [_assetWriter cancelWriting];
    } else {
        _cancelled = NO;
        _videoFinished = NO;
        _audioFinished = NO;
        if (handler) {
            handler(_outputUrl);
        }
    }
}
- (void)setup{
    _mainQueue = dispatch_queue_create("video reencoder main", NULL);
    _audioQueue = dispatch_queue_create("video reencoder audio", NULL);
    _videoQueue = dispatch_queue_create("video reencoder video", NULL);
    
    NSDateFormatter *kDateFormatter;
    if (!kDateFormatter) {
        kDateFormatter = [[NSDateFormatter alloc] init];
        kDateFormatter.dateStyle = NSDateFormatterMediumStyle;
        kDateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    _outputUrl = [[[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create: YES error:nil] URLByAppendingPathComponent:[kDateFormatter stringFromDate:[NSDate date]]] URLByAppendingPathExtension:CFBridgingRelease(UTTypeCopyPreferredTagWithClass((CFStringRef)AVFileTypeQuickTimeMovie, kUTTagClassFilenameExtension))];
}
@end
