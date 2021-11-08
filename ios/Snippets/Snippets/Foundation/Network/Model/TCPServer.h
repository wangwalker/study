//
//  TCPServer.h
//  Snippets
//
//  Created by Walker Wang on 2021/11/8.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCPServer : NSObject

+ (BOOL)startWithHost:(NSString * _Nonnull)host port:(NSInteger)port;

@end

NS_ASSUME_NONNULL_END
