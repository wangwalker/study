//
//  WRGithubUserThread.m
//  Snippets
//
//  Created by Walker on 2020/11/11.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "WRGithubUserThread.h"
#import "WRGithubUser.h"

@implementation WRGithubUserThread

+ (instancetype)threadWithUser:(WRGithubUser *)user{
    return [[self alloc] initWithUser:user];
}

- (instancetype)initWithUser:(WRGithubUser*)user{
    if ((self = [super init])) {
        self.user = user;
    }
    return self;
}

- (void)setHandler:(WRGithubUserAvatarHandler)handler{
    _handler = handler;
    [self start];
}

- (void)main{
    if (!_user || !_user.avatarUrlString) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:_user.avatarUrlString];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    [self.user setAvatar:[UIImage imageWithData:imageData]];
    
    if (_handler) {
        _handler();
    }
}

@end
