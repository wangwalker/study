//
//  UIViewController+WRVC.m
//  WRKit
//
//  Created by jfy on 16/10/26.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import "UIViewController+WRVC.h"
#import "Header.h"
#import "Reachability.h"


@implementation UIViewController (WRVC)

-(void)pushToSettingOfSystem:(NSString *)setting
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@",setting]]];
}

-(void)pushToSafariWithURLString:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",url.length>0?url:nil]]];
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
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]];
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
@end
