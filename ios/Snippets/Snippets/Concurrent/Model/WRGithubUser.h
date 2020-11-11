//
//  WRGithubUser.h
//  Snippets
//
//  Created by Walker on 2020/11/10.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRGithubUser : NSObject

+ (instancetype)userWithName:(NSString*)name avatarUrlString:(NSString*)string;

@property (nonatomic, copy) NSString* avatarUrlString;

@property (nonatomic, copy) NSString* name;

@property (nonatomic, strong) UIImage *avatar;

@property (nonatomic, strong) NSNumber *index;

@end


@interface WRGithubUserGroup : NSObject

+ (NSArray<WRGithubUser*>* )testUsers;

@end

NS_ASSUME_NONNULL_END
