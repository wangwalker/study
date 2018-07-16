//
//  WRDefine.h
//  tCCSC
//
//  Created by IMAC on 2018/4/19.
//  Copyright © 2018年 IMAC. All rights reserved.
//

#ifndef WRDefine_h
#define WRDefine_h

#import "WRConstants.h"
#import "NSString+WRString.h"
#import "NSData+WRData.h"
#import "NSDate+WRDate.h"
#import "UIImage+WRImage.h"
#import "NSObject+WRObject.h"
#import "UIView+WRView.h"
#import "UILabel+WRLabel.h"
#import "UIColor+WRColor.h"
#import "UIViewController+WRViewController.h"

// dimensions
#define SWIDTH [[UIScreen mainScreen] bounds].size.width
#define SHEIGHT [[UIScreen mainScreen] bounds].size.height

// iPhone X
#define Device_is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 导航栏 + 状态栏 的高度
#define NavigationBarHeight (Device_is_iPhoneX ? 88 : 64)
#define TopMargin (Device_is_iPhoneX ? 44 : 0)
#define BottomMargin (Device_is_iPhoneX ? 34 : 0)

// singleton
#undef    AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;
//+ (void) purgeSharedInstance;

#undef    DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
return __singleton__; \
}


#define UDF [NSUserDefaults standardUserDefaults]
#define DEF_WEAKSELF __weak __typeof(self) weakSelf = self;


#define SECOND    (1)
#define MINUTE    (60 * SECOND)
#define HOUR    (60 * MINUTE)
#define DAY        (24 * HOUR)
#define MONTH    (30 * DAY)
#define NOW [NSDate new]


// color
#define UIColorHEX(hexValue) ([UIColor colorFromHex:hexValue])
#define UIColorHEXA(hexValue, a) ([UIColor colorFromHex:hexValue withAlpha:a])
#define UIColorRGB(r, g, b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0])
#define UIColorRGBA(r, g, b, a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define TINTCOLOR [UIColor colorWithRed:78/255.f green:141/255.f blue:241/255.f alpha:1]
#define BGLIGHTGRAY [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define SEPCOLOR [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:.3]

// debug
#define CLASSNAME(object)  [NSString stringWithUTF8String:object_getClassName(object)]
#define WRDebug(__key,__msg) \
NSLog(@"\n==========================================================\nDebugAt :line%d\nfunction:%s\n%@:%@\n==========================================================",__LINE__,__FUNCTION__,__key,__msg)

// server
#define HOST @"https://data.ccsc.work/api/system/"
#define HTTPURLSTRING(method) [NSString stringWithFormat:@"%@%@", HOST, method]
#define HTTPURL(method) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST, method]]

#pragma mark Blocks
typedef void (^voidBlock)(void) ;
typedef void (^wr_getImageFromAssetBlock) (NSData *originalImageData, UIImage *originalImage);

#endif /* WRDefine_h */
