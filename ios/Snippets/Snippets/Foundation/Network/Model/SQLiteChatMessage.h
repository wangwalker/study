//
//  PersistentChatMessage.h
//  Snippets
//
//  Created by Walker Wang on 2021/11/8.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageQueue.h"

NS_ASSUME_NONNULL_BEGIN

@class ChatMessage;

@interface SQLiteChatMessage : NSObject <ChatMessagePersistentDelegate>

@end

NS_ASSUME_NONNULL_END
