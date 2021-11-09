//
//  ChatMessageQueue.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/9.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "ChatMessageQueue.h"
#import "ChatMessage.h"

@interface ChatMessageQueue ()
@property (nonatomic) NSMutableArray<ChatMessage*>* messages;
@end

@implementation ChatMessageQueue

- (instancetype)initWithName:(NSString *)name{
    if (self = [super init]) {
        _name = name;
        _messages = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name messages:(NSArray<ChatMessage *> *)messages{
    if (self = [super init]) {
        _name = name;
        _messages = [messages mutableCopy];
    }
    return self;
}

- (BOOL)addMessage:(ChatMessage *)message{
    if (message.content.length <= 0) {
        return NO;
    }
    
    if ([self.persistenceDelegate respondsToSelector:@selector(chatMessageQueue:willInsertChatMessage:)]) {
        [self.persistenceDelegate chatMessageQueue:self willInsertChatMessage:message];
    }
    [_messages addObject:message];
    if ([self.persistenceDelegate respondsToSelector:@selector(chatMessageQueue:didInsertChatMessage:)]) {
        [self.persistenceDelegate chatMessageQueue:self didInsertChatMessage:message];
    }
    
    return YES;
}

- (ChatMessage *)messageAtIndex:(NSInteger)index{
    return _messages[index];
}

- (NSUInteger)count{
    return _messages.count;
}

@end

