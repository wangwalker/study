//
//  WRSystemInfo.h
//  WRKit
//
//  Created by jfy on 16/10/27.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#define iOS11_OR_LATER     ( [[[UIDevice currentDevice] systemVersion] compare:@"11.0"] != NSOrderedAscending )
#define iOS10_OR_LATER     ( [[[UIDevice currentDevice] systemVersion] compare:@"10.0"] != NSOrderedAscending )
#define iOS9_OR_LATER       ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )
#define iOS8_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define iOS7_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define iOS6_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define iOS5_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define iOS4_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define iOS3_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )

#define iOS10_OR_EARLIER      ( !iOS11_OR_LATER )
#define iOS9_OR_EARLIER        ( !iOS10_OR_LATER )
#define iOS8_OR_EARLIER        ( !iOS9_OR_LATER )
#define iOS7_OR_EARLIER		( !iOS8_OR_LATER )
#define iOS6_OR_EARLIER		( !iOS7_OR_LATER )
#define iOS5_OR_EARLIER		( !iOS6_OR_LATER )
#define iOS4_OR_EARLIER		( !iOS5_OR_LATER )
#define iOS3_OR_EARLIER		( !iOS4_OR_LATER )

#define IS_SCREEN_4_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_35_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#define iOS11_OR_LATER     (NO)
#define iOS10_OR_LATER     (NO)
#define iOS9_OR_LATER       (NO)
#define iOS8_OR_LATER       (NO)
#define iOS7_OR_LATER		(NO)
#define iOS6_OR_LATER		(NO)
#define iOS5_OR_LATER		(NO)
#define iOS4_OR_LATER		(NO)
#define iOS3_OR_LATER		(NO)

#define IS_SCREEN_4_INCH	(NO)
#define IS_SCREEN_35_INCH	(NO)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import <UIKit/UIKit.h>

@interface WRSystemInfo : NSObject

+(NSString *) OSVersion;
+(NSString *) appVersion;
+(NSString *) appIdentifier;
+(NSString *) appSchema;
+(NSString *) appSchema:(NSString *)name;
+(NSString *) deviceModel;
+(NSString *) deviceUUID;

// 是否越狱
+(BOOL) isJailBroken		NS_AVAILABLE_IOS(4_0);
+(NSString *) jailBreaker	NS_AVAILABLE_IOS(4_0);

+(BOOL) isDevicePhone;
+(BOOL) isDevicePad;

+(BOOL) requiresPhoneOS;

+(BOOL) isPhone;
+(BOOL) isPhone35; // 4
+(BOOL) isPhoneRetina35; // 4s
+(BOOL) isPhoneRetina4; // 5, 5c ,5s
+(BOOL) isPhoneSix; // 6
+(BOOL) isPhoneSixPlus; // 6plus
+(BOOL) isPad;
+(BOOL) isPadRetina;
+(BOOL) isScreenSize:(CGSize)size;

//////////////////////////////
// 返回本机ip地址
+(NSString *) localHost;

+(BOOL) isFirstRun;
+(BOOL) isFirstRunCurrentVersion;
+(void) setFirstRun;
+(void) setNotFirstRun;

+(BOOL) isFirstRunWithUser:(NSString *)user;
+(BOOL) isFirstRunCurrentVersionWithUser:(NSString *)user;
+(void) setFirstRunWithUser:(NSString *)user;
+(void) setNotFirstRunWithUser:(NSString *)user;


@end
