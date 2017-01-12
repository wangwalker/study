//
//  NSString+WRString.m
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import "NSString+WRString.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (WRString)

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isValid
{
    if (self && ![self isEqualToString:@""])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isUserNameWithMin:(NSUInteger)min andMax:(NSUInteger)max
{
    NSString *regex = [NSString stringWithFormat:@"(^[A-Za-z0-9]{%ld,%ld}$)",min,max];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isNickName
{
    NSString *regex = @"(^[A-Za-z0-9-_]{1,10}$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isPassword
{
    NSString *		regex = @"(^[A-Za-z0-9-_]{6,20}$)";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}+[\\.[A-Za-z]{2,4}]?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isPhoneNumber
{
    NSString *regex = @"^1[3-8][0-9]{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isBankCard
{
    NSString *regex = @"^([0-9]{16}||[0-9]{19})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isPostCode
{
    NSString *regex = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isFixPhoneNo
{
    NSString *regex = @"^([\\d{3,4}-)\\d{7,8}$]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isURL
{
    NSString *regex = @"^http://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isAddress
{
    NSString *regex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isIPAddress
{
    NSString *regex = @"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isIDCardNo
{
    NSString *regex = @"\\d{14}[[0-9],0-9xX]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isQQNumber
{
    NSString *regex = @"[1-9][0-9]\{4,\\}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pred evaluateWithObject:self];
}


-(NSString *)byteStringBySystem:(NSString*)system
{
    NSMutableString *mstr = [@"" mutableCopy];
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    Byte *byte = (Byte *)[data bytes];
    
    for (int i = 0; i < [data length]; i ++) {
        [mstr appendString:[NSString stringWithFormat:
                            [NSString stringWithFormat:@"%%%s",
                            [system cStringUsingEncoding:NSUTF8StringEncoding]],byte[i]]];
    }
    
    return mstr;
}


-(NSString *)hexByte
{
    return [self byteStringBySystem:@"x"];
}

-(NSString *)base64
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}


-(NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (uint32_t) strlen(cStr), result );
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]] lowercaseString];
}


-(NSString *)sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}


-(NSString *)reverseString
{
    NSMutableString *reverseString = [@"" mutableCopy];
    
    for (int i = (int)self.length; i >0; i--) {
        [reverseString appendString:[self substringWithRange:NSMakeRange(i - 1, 1)]];
    }
    return reverseString;
}

- (BOOL)isPureNumber
{
    NSString *regex = @"[0-9]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pred evaluateWithObject:self];
}

@end
