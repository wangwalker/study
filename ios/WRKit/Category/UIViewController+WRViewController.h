//
//  UIViewController+WRViewController.h
//  tCCSC
//
//  Created by IMAC on 2018/4/19.
//  Copyright © 2018年 IMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
extern  NSNotificationName  WRNetworkSpeedKey;
extern  NSNotificationName  WRNetworkTotalTrafficKey;
extern  NSNotificationName  WRNetworkTrafficSpeedNotificationName;

//系统设置
#define GENERAL_SYSTEM_SETTING      @"General"
#define ABOUT_SYSTEM_SETTING        @"General&path = About"
#define AIRPLANEMODE_SYSTEM_SETTING @"AIRPLANE_MODE"
#define BRIGHTNESS_SYSTEM_SETTING   @"Brightness"
#define BLUETOOTH_SYSTEM_SETTING    @"General&path = Bluetooth"
#define DATE_TIME_SYSTEM_SETTING    @"General&path = DATE_AND_TIME"
#define FACETIME_SYSTEM_SETTING     @"FACETIME"
#define KEYBOARD_SYSTEM_SETTING     @"General&path = Keyboard"
#define MUSIC_SYSTEM_SETTING        @"MUSIC"
#define NETWORK_SYSTEM_SETTING      @"General&path = Network"
#define NOTIFICATION_SYSTEM_SETTING @"NOTIFICATIONS_ID"
#define PHONE_SYSTEM_SETTING        @"Phone"
#define PHOTO_SYSTEM_SETTING        @"Photos"
#define SAFARI_SYSTEM_SETTING       @"Safari"
#define WIFI_SYSTEM_SETTING         @"WIFI"
#define SETTING_SYSTEM_SETTING      @"INTERNET_TETHERING"

@interface UIViewController (WRViewController)
/**
 *  跳转到系统设置页面
 */
-(void)pushToSettingOfSystem:(NSString *)setting;

/**
 *  跳转到Safari
 *
 *  @param url 具体的域名，空时默认Safari
 */
-(void)pushToSafariWithURLString:(NSString *)url;

/**
 *  提示框，子按钮只有 【取消】 + 【确认】
 *
 *  @param title 标题
 *  @param message 详细信息
 *  @param action  【确认】按钮及其动作
 */
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message action:(UIAlertAction *)action;

/**
 *  ActionSheet 【actions】 + 【取消】
 *
 *  @param title 标题
 *  @param message 详细信息
 *  @param actionArray  actions
 */
-(void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message actionArray:(NSArray< UIAlertAction *>*)actionArray;

/**
 *  拨打电话
 *  @param phoneNumber phone number
 */
-(void)callPhoneWithNumber:(NSString *)phoneNumber;

/**
 *  打开相机
 */
-(void)takeAPhotoWithCameraDelegate:(id)delegate isAllowEdit:(BOOL)allowEditing;

/**
 *  在相册中选择照片
 */
-(void)pickImageFromAlbumDelegate:(id)delegate isAllowEdit:(BOOL)allowEditing;

/**
 *  检测网络状态
 */
-(BOOL)isConnectionAvailable;

-(void)showAlertIMessage:(NSString *)message;
-(void)postNetworkNotification;
@end
