//
//  BasicVideoViewController.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/29.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "BasicVideoViewController.h"
#import "PlayerView.h"
#import "VideoAssetInfo.h"
#import "VideoPickerProxy.h"

API_AVAILABLE(ios(14))
@interface BasicVideoViewController ()
@property (nonatomic) NSURL *videoUrl;
@property (nonatomic) AVAsset *videoAsset;
#pragma mark - Player
@property (nonatomic) AVPlayer *player;
@property (nonatomic) AVPlayerItem *playerItem;
@property (nonatomic) UISlider *playerSlider;
@property (nonatomic) PlayerView *playerView;
@property (nonatomic) VideoAssetInfo *assetInfo;
@end

@implementation BasicVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.videoProxy addObserver:self forKeyPath:@"videoUrl" options:NSKeyValueObservingOptionNew context:nil ];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addBarButton];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_player pause];
}

#pragma mark - Method

- (void)addBarButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pickVideo:)];
}
- (void)setupPlayer{
    if (_playerItem) {
        _playerItem = nil;
    }
    _playerItem = [AVPlayerItem playerItemWithAsset:_videoAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    [_player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerView setPlayer:_player];
    
    if ([self.view.subviews containsObject:self.playerView]) {
        return;
    }
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.playerSlider];
}
- (void)pickVideo:(UIBarButtonItem *)sender{
    [self pickVideoWithCompletionHandler:^{
        [self picked];
    }];
}
- (void)playVideo:(UIBarButtonItem *)sender{
    if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [self.player pause];
        [self generateThumbnail];
    } else {
        [self.player play];
    }
}
- (void)picked{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playVideo:)];
}
- (void)observeVideoProxy:(id)object{
    if (object != self.videoProxy) {
        return;
    }
    self.videoUrl = self.videoProxy.videoUrl;
}
- (void)observePlayerControll:(id)object{
    if (object != _player) {
        return;
    }
    UIBarButtonSystemItem item = self.player.timeControlStatus == AVPlayerTimeControlStatusPaused ? UIBarButtonSystemItemPlay : UIBarButtonSystemItemPause;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(playVideo:)];
}
- (void)changePlayerTime:(UISlider *)slider{
    [_player pause];
    [_player seekToTime:CMTimeMultiplyByFloat64(_videoAsset.duration, slider.value) completionHandler:^(BOOL finished) {
        if (finished) {
            [self->_player play];
        }
    }];
}
- (void)generateThumbnail{
    CMTime requireTime = CMTimeMultiplyByFloat64(_videoAsset.duration, _playerSlider.value);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error;
        CGImageRef image = [[[AVAssetImageGenerator alloc] initWithAsset:self->_videoAsset] copyCGImageAtTime:requireTime actualTime:nil error:&error];
        if (image && !error) {
            UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:image], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        CGImageRelease(image);
    });
}

#pragma mark - Delegate

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self observeVideoProxy:object];
    [self observePlayerControll:object];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        NSLog(@"generated image write to album");
    }
}

#pragma mark - Setter

- (void)setVideoUrl:(NSURL *)videoUrl{
    if (_videoUrl) {
        _videoUrl = nil;
        _videoAsset = nil;
        _assetInfo = nil;
    }
    _videoUrl = videoUrl;
    _videoAsset = [AVAsset assetWithURL:videoUrl];
    _assetInfo = [VideoAssetInfo infoWithAVAsset:_videoAsset];
    
    [_assetInfo showInfoWithLoadedCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupPlayer];
        });
    }];
}

#pragma mark - Getter

- (PlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[PlayerView alloc] initWithFrame:[UIScreen.mainScreen bounds]];
    }
    return _playerView;
}
- (UISlider *)playerSlider{
    if (!_playerSlider) {
        _playerSlider = [[UISlider alloc] initWithFrame:CGRectMake(60, UIScreen.mainScreen.bounds.size.height-200, UIScreen.mainScreen.bounds.size.width-120, 32)];
        [_playerSlider addTarget:self action:@selector(changePlayerTime:) forControlEvents:UIControlEventValueChanged];
    }
    return _playerSlider;
}
@end
