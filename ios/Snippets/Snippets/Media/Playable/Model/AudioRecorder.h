//
//  AudioRecorder.h
//  Snippets
//
//  Created by Walker Wang on 2021/12/4.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^AudioRecordingHandler)(void);

@interface AudioRecorder : NSObject

+ (instancetype)recorderWithUrl:(NSURL * _Nonnull )url;

- (BOOL)startRecording:(AudioRecordingHandler)completionHandler;
- (BOOL)stopRecording:(AudioRecordingHandler)completionHandler;

- (BOOL)startPlaying:(AudioRecordingHandler)completionHandler;
- (BOOL)startPlaying:(NSURL *)url completion:(AudioRecordingHandler)handler;

- (void)finish;

@property (nonatomic) CGFloat maxDuration;

@property (nonatomic, readonly) NSURL *fileUrl;

@end

NS_ASSUME_NONNULL_END
