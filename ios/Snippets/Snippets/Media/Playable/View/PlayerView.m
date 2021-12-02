//
//  PlayerView.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/30.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

+ (Class)layerClass{
    return [AVPlayerLayer class];
}

- (AVPlayer *)player{
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end
