//
//  UIViewController+WRViewController.m
//  tCCSC
//
//  Created by IMAC on 2018/4/19.
//  Copyright © 2018年 IMAC. All rights reserved.
//

#import "UIViewController+WRViewController.h"
#import "NSString+WRString.h"
#import "Reachability.h"
#include <net/if.h>
#include <arpa/inet.h>
#include <ifaddrs.h>

NSNotificationName  WRNetworkTrafficSpeedNotificationName = @"network-traffic-speed-nn";
NSNotificationName  WRNetworkTotalTrafficKey = @"network-total-traffic-key";
NSNotificationName  WRNetworkSpeedKey = @"network-speed-key";

@implementation UIViewController (WRViewController)

-(void)pushToSettingOfSystem:(NSString *)setting
{
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@",setting]] options:@{} completionHandler:nil];
    } else {
        [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=//%@", setting]]];
    }
}

-(void)pushToSafariWithURLString:(NSString *)url
{
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",url.length>0?url:nil]] options:@{} completionHandler:nil];
    } else {
        [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", url]]];
    }
}


-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message action:(UIAlertAction *)action
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:1];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action1];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message actionArray:(NSArray<UIAlertAction *> *)actionArray
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (UIAlertAction *action in actionArray) {
        [actionSheet addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:cancel];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}


-(void)callPhoneWithNumber:(NSString *)phoneNumber
{
    if (!([phoneNumber isPhoneNumber] || [phoneNumber isFixPhoneNo])) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"电话号码有误" message:nil preferredStyle:1];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]] options:@{} completionHandler:^(BOOL success) {
            }];
        } else {
            [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]]];
        }
    }
}


-(void)takeAPhotoWithCameraDelegate:(id)delegate isAllowEdit:(BOOL)allowEditing
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate                 = delegate;
        picker.sourceType               = sourceType;
        picker.allowsEditing            = allowEditing;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"模拟器中不能打开相机");
    }
}


-(void)pickImageFromAlbumDelegate:(id)delegate isAllowEdit:(BOOL)allowEditing
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate                 = delegate;
    picker.allowsEditing            = allowEditing;
    [self presentViewController:picker animated:YES completion:nil];
}


-(BOOL)isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    switch ([reach currentReachabilityStatus])
    {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    
    return isExistenceNetwork;
}

-(NSString *)getIDFA{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

-(void)showAlertIMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *de = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:de];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)postNetworkNotification{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSTimer *netTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(postTrafficSpeed) userInfo:nil repeats:YES];
        [netTimer fire];
    });
}

-(void)postTrafficSpeed{
    static long long totalTraffic = 0;
    long long perSecondTraffic = ([self getNetInterfaceTraffic] - totalTraffic)*2;
    totalTraffic = [self getNetInterfaceTraffic] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:WRNetworkTrafficSpeedNotificationName object:nil userInfo:@{WRNetworkTotalTrafficKey: [self formatTrafficSpeed:totalTraffic], WRNetworkSpeedKey: [self formatTrafficSpeed:perSecondTraffic]}];
}

- (long long) getNetInterfaceTraffic {
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) return 0;
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next){
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        /* Not a loopback device. */
        
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }
    freeifaddrs(ifa_list);
    return oBytes;
}

-(NSString*)formatTrafficSpeed:(float)size{
    float t = size;
    NSArray<NSString*>* units = @[@"Byte", @"KB", @"MB", @"GB", @"TB", @"PB", @"EB"];
    int level = 0;
    while (t >= 1024) {
        t /= 1024.0;
        level ++;
    }
    return [NSString stringWithFormat:@"%.1f%@/s", t, units[level]];
}

@end
