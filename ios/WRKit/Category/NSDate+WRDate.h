//
//  NSDate+WRDate.h
//  tCCSC
//
//  Created by IMAC on 2018/4/19.
//  Copyright © 2018年 IMAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WRDefine.h"

@interface NSDate (WRDate)
@property (nonatomic, readonly) NSInteger    year;
@property (nonatomic, readonly) NSInteger    month;
@property (nonatomic, readonly) NSInteger    day;
@property (nonatomic, readonly) NSInteger    hour;
@property (nonatomic, readonly) NSInteger    minute;
@property (nonatomic, readonly) NSInteger    second;
@property (nonatomic, readonly) NSInteger    weekday;
@property (nonatomic, readonly) NSString    *weekDay;
@property (nonatomic, readonly) NSString    *readableDateString;

// @"yyyy-MM-dd HH:mm:ss"
- (NSString *)dateToStringByFormat:(NSString *)format;

// 日期转为字符串 和上一个一样
- (NSString *)dateToString;

// 转为@"yyyy-MM-dd"
- (NSString *)dayString;

// 返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDays:(int)dayCount;

// 返回距离aDate有多少天
- (NSInteger)dayCountBetweenDate:(NSDate *)aDate;

// 日期比较 同一天返回yes
- (BOOL)isSameDay:(NSDate *)date;

// 获得当前的时区
+ (CGFloat)timeZone;

// 单例模式, 避免持续消耗内存.
+ (NSDateFormatter *)dateFormatter;

// 判断当前日期是否是本周.
+ (BOOL)isThisWeek:(NSDate *)date;

// 判断当前日期是否是本月.
+ (BOOL)isThisMonth:(NSDate *)date;

// 字符串转日期.
+ (NSDate *)dateByString:(NSString *)timeString;

+(NSString *)timeStampString;

+ (NSDate *)dateByStringFormat:(NSString *)timeString;

@end
