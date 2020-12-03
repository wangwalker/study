//
//  WRGithubUserThread.h
//  Snippets
//
//  Created by Walker on 2020/11/11.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WRGithubUser;

typedef void (^WRGithubUserAvatarHandler) (void);

@interface WRGithubUserThread : NSThread

+ (instancetype)threadWithUser:(WRGithubUser*)user;

@property (nonatomic, strong) WRGithubUser* user;

// Invoke `start` when set handler
@property (nonatomic) WRGithubUserAvatarHandler handler;

@end

NS_ASSUME_NONNULL_END
