//
//  NSObject+WRObject.h
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NSObjectBlock)(NSDictionary *object);

@interface NSObject (WRObject)

// 获取系统时制信息.
+ (BOOL)isHasAM_PMTime;



@end
