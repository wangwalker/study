//
//  CoreDataChatMessage.h
//  Snippets
//
//  Created by Walker Wang on 2021/11/9.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataChatMessage : NSObject <ChatMessagePersistentDelegate>

- (NSArray *)retrieveAllChatMessages;

@end

NS_ASSUME_NONNULL_END
