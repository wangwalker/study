//
//  NSObject+WRObject.h
//  tCCSC
//
//  Created by IMAC on 2018/4/19.
//  Copyright © 2018年 IMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WRObject)

// get unique identifier for Verdor of phone and applications
-(NSString *)getIDFA;

-(NSString*)formatDataSize:(float)size;

@end
