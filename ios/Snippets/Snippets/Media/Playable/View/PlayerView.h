//
//  PlayerView.h
//  Snippets
//
//  Created by Walker Wang on 2021/11/30.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerView : UIView
@property (nonatomic) AVPlayer *player;
@end

NS_ASSUME_NONNULL_END
