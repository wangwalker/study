//
//  ChatMessage.h
//  Snippets
//
//  Created by Walker Wang on 2021/11/7.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ChatMessageMembershipSelf,
    ChatMessageMembershipOther,
} ChatMessageMembership;

typedef enum : NSUInteger {
    ChatMessageTypeText,
    ChatMessageTypeImage,
    ChatMessageTypeAudio,
    ChatMessageTypeVideo,
} ChatMessageType;


@interface ChatMessage : NSObject

+ (instancetype)messageWithMessageShip:(ChatMessageMembership)membership type:(ChatMessageType)type;

@property (nonatomic, readonly) ChatMessageMembership membership;
@property (nonatomic, readonly) ChatMessageType type;
@property (nonatomic, readonly, copy) NSString *content;

@end


@interface ChatTextMessage : ChatMessage

+ (instancetype)text:(NSString *)text membership:(ChatMessageMembership)membership;

- (instancetype)initWithText:(NSString *)text membership:(ChatMessageMembership)membership;

@end


@interface ChatMessageQueue : NSObject

- (instancetype)initWithName:(NSString *)name;

- (BOOL)addMessage:(ChatMessage *)message;

- (ChatMessage *)messageAtIndex:(NSInteger)index;

@property (nonatomic, readonly) NSArray<ChatMessage*>* messages;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSUInteger count;

@end

NS_ASSUME_NONNULL_END
