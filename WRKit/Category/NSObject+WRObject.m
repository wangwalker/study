//
//  NSObject+WRObject.m
//  tCCSC
//
//  Created by IMAC on 2018/4/19.
//  Copyright © 2018年 IMAC. All rights reserved.
//

#import "NSObject+WRObject.h"
#import <UIKit/UIKit.h>

@implementation NSObject (WRObject)

-(NSString *)getIDFA{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

-(NSString*)formatDataSize:(float)size{
    float t = size;
    NSArray<NSString*>* units = @[@"Byte", @"KB", @"MB", @"GB", @"TB", @"PB", @"EB"];
    int level = 0;
    while (t >= 1024) {
        t /= 1024.0;
        level ++;
    }
    return [NSString stringWithFormat:@"%.1f%@", t, units[level]];
}

@end
