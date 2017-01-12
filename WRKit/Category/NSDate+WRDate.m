//
//  NSDate+WRDate.m
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import "NSDate+WRDate.h"



@implementation NSDate (WRDate)

@dynamic year;
@dynamic month;
@dynamic day;
@dynamic hour;
@dynamic minute;
@dynamic second;
@dynamic weekday;

#pragma mark - private
+(NSCalendar *)WR_currentCalender{
    
    NSMutableDictionary *dict = [[NSThread currentThread] threadDictionary];
    NSCalendar *calender = [dict objectForKey:@"WR_Calender"];
    if (calender == nil) {
        calender = [NSCalendar currentCalendar];
        [dict setObject:calender forKey:@"WR_Calender"];
    }
    return calender;
}

- (NSInteger)year
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self].year;
}

- (NSInteger)month
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self].month;
}

- (NSInteger)day
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self].day;
}

- (NSInteger)hour
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self].hour;
}

- (NSInteger)minute
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self].minute;
}

- (NSInteger)second
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self].second;
}

- (NSInteger)weekday
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self].weekday;
}


// @"yyyy-MM-dd HH:mm:ss"
- (NSString *)dateToStringFormat:(NSString *)format
{
#if 0
    
    NSTimeInterval time = [self timeIntervalSince1970];
    NSUInteger timeUint = (NSUInteger)time;
    return [[NSNumber numberWithUnsignedInteger:timeUint] stringWithDateFormat:format];
    
#else
    
    // thansk @lancy, changed: "NSDate depend on NSNumber" to "NSNumber depend on NSDate"
    
    NSDateFormatter * dateFormatter = [NSDate dateFormatterTemp];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
    
#endif
}

// 日期转为字符串
- (NSString *)dateToString
{
    NSDateFormatter* dateFormatter = [NSDate dateFormatterTemp];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 所有得时间都按格林的时间，无需转换。结果一样
    // 如果本身需要具体的时间。可以转换成GMT
    // NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    // [dateFormatter setTimeZone:timeZone];
    
    NSString *dateString = [dateFormatter stringFromDate:self];
    
    return dateString;
}

// 日期转为字符串 @"yyyy-MM-dd"
- (NSString *)dateToDayString
{
    NSString *dateString = [self dateToString];
    NSArray *array = [dateString componentsSeparatedByString:@" "];
    
    return array[0];
}

+ (NSDateFormatter *)dateFormatterTemp
{
    static NSDateFormatter* format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    
    return format;
}

- (NSString *)showTimeAgo
{
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
    
    if (delta < 1 * MINUTE)
    {
        return @"刚刚";
    }
    else if (delta < 2 * MINUTE)
    {
        return @"1分钟前";
    }
    else if (delta < 45 * MINUTE)
    {
        int minutes = floor((double)delta/MINUTE);
        return [NSString stringWithFormat:@"%d分钟前", minutes];
    }
    else if (delta < 90 * MINUTE)
    {
        return @"1小时前";
    }
    else if (delta < 24 * HOUR)
    {
        int hours = floor((double)delta/HOUR);
        return [NSString stringWithFormat:@"%d小时前", hours];
    }
    else if (delta < 48 * HOUR)
    {
        return @"昨天";
    }
    else if (delta < 30 * DAY)
    {
        int days = floor((double)delta/DAY);
        return [NSString stringWithFormat:@"%d天前", days];
    }
    else if (delta < 12 * MONTH)
    {
        int months = floor((double)delta/MONTH);
        return months <= 1 ? @"1个月前" : [NSString stringWithFormat:@"%d个月前", months];
    }
    
    int years = floor((double)delta/MONTH/12.0);
    return years <= 1 ? @"1年前" : [NSString stringWithFormat:@"%d年前", years];
}


-(NSString *)weekDay{
    long week = [NSDate date].weekday;
    NSString *weekStr = nil;
    if(week==1)
    {
        weekStr=@"星期天";
    }else if(week==2){
        weekStr=@"星期一";
        
    }else if(week==3){
        weekStr=@"星期二";
        
    }else if(week==4){
        weekStr=@"星期三";
        
    }else if(week==5){
        weekStr=@"星期四";
        
    }else if(week==6){
        weekStr=@"星期五";
        
    }else if(week==7){
        weekStr=@"星期六";
        
    }
    return weekStr;
}


// 返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    // NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    
    return dateAfterDay;
}

// 字符串转日期.
+ (NSDate *)dateByString:(NSString *)timeString
{
    NSArray *array = [timeString componentsSeparatedByString:@" "];
    
    if (array)
    {
        if (array.count == 1)
        {
            NSString *dateString = [NSString stringWithFormat:@"%@ 00:00:00", timeString];
            NSDate *date = [NSDate dateByStringFormat:dateString];
            // 加上当前时区
            date = [date dateByAddingTimeInterval:[NSDate DateByTimeZone] * 3600];
            
            return date;
        }
        else if (array.count == 2)
        {
            return [NSDate dateByStringFormat:timeString];
        }
        else
        {
            return [NSDate date];
        }
    }
    
    return [NSDate date];
}

// 传入已经具备格式化的字符串.
+ (NSDate *)dateByStringFormat:(NSString *)timeString
{
    NSDateFormatter *formatter = [NSDate dateFormatterTemp];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:timeString];
    
    return date;
}

// 返回距离aDate有多少天
- (NSInteger)dateByDistanceDaysWithDate:(NSDate *)aDate
{
    NSCalendar *calendar = [NSDate WR_currentCalender];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay fromDate:self toDate:aDate options:0];
    
    return [dateComponents day];
}

// 获得当前的时区
+ (CGFloat)DateByTimeZone
{
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    
    return tz.secondsFromGMT * 1.0 / 3600;
}

// 日期比较 同一天返回yes
-(BOOL)isTheSameDate:(NSDate *)date
{
    return [NSDate twoDateIsSameDay:self second:date];
}


+ (BOOL)twoDateIsSameDay:(NSDate *)fistDate_
                  second:(NSDate *)secondDate_
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay;
    NSDateComponents *fistComponets = [calendar components:unit
                                                  fromDate:fistDate_];
    NSDateComponents *secondComponets = [calendar components:unit
                                                    fromDate:secondDate_];
    
    if ([fistComponets day] == [secondComponets day]
        && [fistComponets month] == [secondComponets month]
        && [fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    
    return NO;
}

// 判断当前日期是否是本周.
+ (BOOL)dateIsThisWeek:(NSDate *)date
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal =[NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    BOOL success= [cal rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&start
                          interval: &extends forDate:today];
    
    if(!success)
    {
        return NO;
    }
    
    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 判断当前日期是否是本月.
+ (BOOL)dateIsThisMonth:(NSDate *)date
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitMonth
                         startDate: &start
                          interval: &extends forDate:today];
    
    if(!success)
    {
        return NO;
    }
    
    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



@end
