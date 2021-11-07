//
//  Communicator.h
//  Snippets
//
//  Created by Walker Wang on 2021/11/7.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Communicator : NSObject<NSStreamDelegate>

- (instancetype)initWithHost:(NSString *)host port:(NSUInteger)port;

- (void)setup;
- (void)open;
- (void)close;
- (void)readIn:(NSString *)content;
- (void)writeOut:(NSString *)content;

@property (nonatomic, readonly, copy) NSString *host;
@property (nonatomic, readonly, assign) NSUInteger port;

@end

NS_ASSUME_NONNULL_END
