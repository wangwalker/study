//
//  NSString+WRString.h
//  tCCSC
//
//  Created by IMAC on 2018/4/19.
//  Copyright © 2018年 IMAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (WRString)

// 删除字符串开头与结尾的空白符与换行
- (NSString *)trim;

/**
 *  判断字符串是否为真并且不为@""
 */
- (BOOL)isValid;

/**
 *  是否为合法的用户名，长度范围为[min,max]
 *
 *  @param min 最小长度限制
 *  @param max 最大长度限制
 */
- (BOOL)lengthBetween:(NSUInteger)min andMax:(NSUInteger)max;

/**
 *  是否为正确的密码
 */
- (BOOL)isPassword;

/**
 *  是否为Email
 */
- (BOOL)isEmail;

/**
 *  是否为手机号码
 */
- (BOOL)isPhoneNumber;

/**
 *  是否为银行卡号
 */
- (BOOL)isBankCard;

/**
 *  是否为邮政编码
 */
- (BOOL)isPostCode;

/**
 *  是否为地址信息
 */
- (BOOL)isAddress;

/**
 *  是否为省份证号
 */
- (BOOL)isIDCardNo;

/**
 *  是否为IP地址
 */
- (BOOL)isIPAddress;

/**
 *  是否为固定电话号码
 */
- (BOOL)isFixPhoneNo;

/**
 *  是否为QQ号码
 */
- (BOOL)isQQNumber;

/**
 *  是否为URL
 */
- (BOOL)isURL;

/**
 *  转换成不同进制的bytes数组字符串
 *  @param system 进制数  八进制：o;十六进制：x，十进制：d
 *  @return 对应字符串
 */
-(NSString *)byteStringBySystem:(NSString*)system;

//16进制的Byte字符串
-(NSString *)hexByte;

//base64加密
-(NSString *)base64;

//MD5加密
-(instancetype)md5;
-(instancetype)md5Lower16;
-(instancetype)md5Upper16;
-(instancetype)md5Lower32;
-(instancetype)md5Upper32;
//SHA1加密
-(NSString *)sha1;

/**
 *  翻转字符串
 *  @return 翻转字符串
 */
-(NSString *)reverseString;


/**
 *  检测是否为纯数字
 */
-(BOOL)isPureNumber;

@end
