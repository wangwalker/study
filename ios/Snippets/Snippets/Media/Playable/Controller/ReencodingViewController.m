//
//  ReencodingViewController.m
//  Snippets
//
//  Created by Walker Wang on 2021/12/2.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "ReencodingViewController.h"
#import "VideoReencoder.h"
#import "VideoPickerProxy.h"

@interface ReencodingViewController ()

@end

@implementation ReencodingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pickVideo:)];
    [self.videoProxy addObserver:self forKeyPath:@"videoUrl" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self observePickerProxy:object];
}

#pragma mark - Private

- (void)observePickerProxy:(id)object{
    if (object != self.videoProxy) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(reencode:)];
    });
}
- (void)pickVideo:(UIBarButtonItem *)sender{
    [self pickVideoWithCompletionHandler:^{
        self.navigationItem.rightBarButtonItem = nil;
    }];
}
- (void)reencode:(UIBarButtonItem *)sender{
    AVAsset *asset = [AVAsset assetWithURL:self.videoProxy.videoUrl];
    VideoReencoder *reencoder = [VideoReencoder reencoderWithAsset:asset];
    [reencoder encodeWithCompletionHandler:^(NSURL * _Nonnull outputUrl) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:outputUrl.path]) {
            NSLog(@"reencoded video \n%@\nto\n%@", self.videoProxy.videoUrl, outputUrl.path);
        } else {
            NSLog(@"reencoding failed");
        }
    }];
}
@end
