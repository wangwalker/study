//
//  AudioRecorder.m
//  Snippets
//
//  Created by Walker Wang on 2021/12/4.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIDevice.h>
#import "AudioRecorder.h"

@interface AudioRecorder ()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
@property (nonatomic) AVAudioRecorder *recorder;
@property (nonatomic) AVAudioPlayer *player;
@end
@implementation AudioRecorder {
    NSURL *_url;
    dispatch_queue_t queue;
}

+ (instancetype)recorderWithUrl:(NSURL *)url{
    return [[AudioRecorder alloc] initWithUrl:url];
}
- (instancetype)initWithUrl:(NSURL *)url{
    if ((self = [super init])) {
        _url = url;
        queue = dispatch_queue_create("audio-queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - Main

- (BOOL)startRecording:(AudioRecordingHandler)completionHandler{
    if (![self canRecord]) {
        return NO;
    }
    NSError *error;
    if (!_recorder) {
        NSDictionary*setting =@{
            AVFormatIDKey:@(kAudioFormatMPEG4AAC),  //音频格式
            AVSampleRateKey:@44100.0f,              //录音采样率(Hz)
            AVNumberOfChannelsKey:@1,               //音频通道数1或2
            AVEncoderBitDepthHintKey:@16,           //线性音频的位深度
            AVEncoderAudioQualityKey:@(AVAudioQualityHigh)
            };
        _recorder = [[AVAudioRecorder alloc] initWithURL:_url settings:setting error:&error];
    }
    if (error) {
        NSLog(@"error occured when recording audio: %@", error.debugDescription);
        return NO;
    }
    
    AVAudioSession  *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    [_recorder setDelegate:self];
    [_recorder setMeteringEnabled:YES];
    if (_maxDuration) {
        [_recorder recordForDuration:_maxDuration];
    }
    [_recorder prepareToRecord];
    dispatch_async(queue, ^{
        [self->_recorder record];
    });
    if (completionHandler) {
        completionHandler();
    }
    return YES;
}
- (BOOL)stopRecording:(AudioRecordingHandler)completionHandler{
    dispatch_async(queue, ^{
        [self->_recorder stop];
    });
    if (completionHandler) {
        completionHandler();
    }
    return YES;
}
- (BOOL)startPlaying:(AudioRecordingHandler)completionHandler{
    return [self startPlaying:_url completion:completionHandler];
}
- (BOOL)startPlaying:(NSURL *)url completion:(AudioRecordingHandler)handler{
    if ([NSData dataWithContentsOfURL:url].length == 0) {
        return NO;
    }
    if (_recorder.isRecording) {
        [_recorder stop];
    }
    
    NSError *error;
    if (!_player) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_url error:&error];
    }
    if (error) {
        NSLog(@"error when playing audio: %@", error.localizedDescription);
        return NO;
    }
    [_player setNumberOfLoops:0];
    [_player setVolume:1];
    [_player setDelegate:self];
    [_player prepareToPlay];
    
    if (!_player.isPlaying) {
        dispatch_async(queue, ^{
            [self->_player play];
        });
    }
    if (handler) {
        handler();
    }
    return YES;
}
- (void)finish{
    _recorder = nil;
    _player = nil;
}

#pragma mark - Private

- (BOOL)canRecord{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    return bCanRecord;
}

@end
