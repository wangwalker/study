//
//  ChatMessageQueue.h
//  Snippets
//
//  Created by Walker Wang on 2021/11/9.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ChatMessage;
@protocol ChatMessagePersistentDelegate;

@interface ChatMessageQueue : NSObject

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name messages:(NSArray<ChatMessage*>*)messages;

- (BOOL)addMessage:(ChatMessage *)message;

- (ChatMessage *)messageAtIndex:(NSInteger)index;

@property (nonatomic, weak) id<ChatMessagePersistentDelegate> persistenceDelegate;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSUInteger count;

@end


/**
 * Separate data persistence from regular CURD operations. When adding new chat message to queue, do corresponding persistence jobs.
 */
@protocol ChatMessagePersistentDelegate <NSObject>

@required

- (BOOL)insertChatMessage:(ChatMessage *)chatMessage;

- (NSArray *)retrieveAllChatMessages;

- (BOOL)chatMessageQueue:(ChatMessageQueue *)messageQueue willInsertChatMessage:(ChatMessage *)chatMessage;
- (BOOL)chatMessageQueue:(ChatMessageQueue *)messageQueue didInsertChatMessage:(ChatMessage *)chatMessage;

@optional

- (BOOL)chatMessageQueue:(ChatMessageQueue *)messageQueue willUpdateChatMessage:(ChatMessage *)chatMessage;
- (BOOL)chatMessageQueue:(ChatMessageQueue *)messageQueue didUpdateChatMessage:(ChatMessage *)chatMessage;

- (BOOL)chatMessageQueue:(ChatMessageQueue *)messageQueue willDeleteChatMessage:(ChatMessage *)chatMessage;
- (BOOL)chatMessageQueue:(ChatMessageQueue *)messageQueue didDeleteChatMessage:(ChatMessage *)chatMessage;
@end


NS_ASSUME_NONNULL_END
