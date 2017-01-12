//
//  NSObject+WRObject.m
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import "NSObject+WRObject.h"

@implementation NSObject (WRObject)

+ (BOOL)isHasAM_PMTime
{
    // 获取系统是24小时制或者12小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = (containsA.location != NSNotFound);
    
    // hasAMPM == TURE为12小时制，否则为24小时制
    
    return hasAMPM;
}

@end
