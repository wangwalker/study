//
//  WRGithubUser.m
//  Snippets
//
//  Created by Walker on 2020/11/10.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "WRGithubUser.h"
/**
 https://avatars2.githubusercontent.com/u/909674?s=64&v=4
 
 */
@implementation WRGithubUser

+ (instancetype)userWithName:(NSString *)name avatarUrlString:(NSString *)string{
    return [[self alloc] initWithName:name avatarUrlString:string];
}

- (instancetype)initWithName:(NSString*)name avatarUrlString:(NSString*)string{
    if ((self = [super init])) {
        self.name = name;
        self.avatarUrlString = string;
    }
    return self;
}
@end


@implementation WRGithubUserGroup

+ (NSArray<WRGithubUser *> *)testUsers{
    return @[
        [WRGithubUser userWithName:@"Walker Wang" avatarUrlString:@"https://avatars2.githubusercontent.com/u/16174018?s=64&u=25ff1a53cb09dccae0202ff56556a3fc9fdff945&v=4"],
        [WRGithubUser userWithName:@"IKeda Sho" avatarUrlString:@"https://avatars2.githubusercontent.com/u/909674?s=64&v=4"],
        [WRGithubUser userWithName:@"Justion Summer" avatarUrlString:@"https://avatars1.githubusercontent.com/u/432536?s=64&v=4"],
        [WRGithubUser userWithName:@"Matt Depihouse" avatarUrlString:@"https://avatars3.githubusercontent.com/u/1302?s=64&v=4"],
        [WRGithubUser userWithName:@"J.D.Healy" avatarUrlString:@"https://avatars3.githubusercontent.com/u/1302?s=64&v=4"],
        [WRGithubUser userWithName:@"Alen Roger" avatarUrlString:@"https://avatars1.githubusercontent.com/u/22635?s=64&v=4"],
        [WRGithubUser userWithName:@"Robert Bokei" avatarUrlString:@"https://avatars1.githubusercontent.com/u/22635?s=64&v=4"],
        [WRGithubUser userWithName:@"Tomason Hued" avatarUrlString:@"https://avatars3.githubusercontent.com/u/196761?s=64&v=4"],
        [WRGithubUser userWithName:@"Eric Hodda" avatarUrlString:@"https://avatars2.githubusercontent.com/u/438313?s=64&v=4"],
        [WRGithubUser userWithName:@"Rob Rox" avatarUrlString:@"https://avatars2.githubusercontent.com/u/59671?s=64&v=4"],
        [WRGithubUser userWithName:@"Matt Depihouse" avatarUrlString:@"https://avatars3.githubusercontent.com/u/1302?s=64&v=4"],
        [WRGithubUser userWithName:@"J.D.Healy" avatarUrlString:@"https://avatars3.githubusercontent.com/u/1302?s=64&v=4"],
        [WRGithubUser userWithName:@"Alen Roger" avatarUrlString:@"https://avatars1.githubusercontent.com/u/22635?s=64&v=4"],
        [WRGithubUser userWithName:@"Robert Bokei" avatarUrlString:@"https://avatars1.githubusercontent.com/u/22635?s=64&v=4"],
        [WRGithubUser userWithName:@"Tomason Hued" avatarUrlString:@"https://avatars3.githubusercontent.com/u/196761?s=64&v=4"],
        [WRGithubUser userWithName:@"Eric Hodda" avatarUrlString:@"https://avatars2.githubusercontent.com/u/438313?s=64&v=4"],
        [WRGithubUser userWithName:@"Rob Rox" avatarUrlString:@"https://avatars2.githubusercontent.com/u/59671?s=64&v=4"],
    ];
}

@end
