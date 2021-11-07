//
//  TCPClient.h
//  Snippets
//
//  Created by Walker Wang on 2021/11/7.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCPClient : NSObject

- (instancetype)initWithHost:(NSString *)host port:(NSUInteger)port;

- (BOOL)writeContent:(NSString *)content;
- (NSString *)readFromServer;

@property (nonatomic, readonly, copy) NSString *host;
@property (nonatomic, readonly) NSUInteger port;
@property (nonatomic, readonly) BOOL connected;

@end

NS_ASSUME_NONNULL_END
