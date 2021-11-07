//
//  ChatMessage.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/7.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage {
    ChatMessageMembership _membership;
    ChatMessageType _type;
}

@synthesize membership = _membership;
@synthesize type = _type;

+ (void)load{
    
}

+ (void)initialize{
    
}
+ (instancetype)messageWithMessageShip:(ChatMessageMembership)membership type:(ChatMessageType)type{
    return [[self alloc] initWithMembership:membership type:type];
}

- (instancetype)initWithMembership:(ChatMessageMembership)membership type:(ChatMessageType)type{
    if (self = [super init]) {
        _membership = membership;
        _type = type;
    }
    return self;
}

@end


@implementation ChatTextMessage {
    NSString *_content;
}

@synthesize content = _content;

+ (instancetype)text:(NSString *)text membership:(ChatMessageMembership)membership{
    return [[self alloc] initWithText:text membership:membership];
}

- (instancetype)initWithText:(NSString *)text membership:(ChatMessageMembership)membership{
    if (self = [super initWithMembership:membership type:ChatMessageTypeText]) {
        _content = text;
    }
    return self;
}

@end


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

- (BOOL)addMessage:(ChatMessage *)message{
    if (message.content.length <= 0) {
        return NO;
    }
    [_messages addObject:message];
    return YES;
}

- (ChatMessage *)messageAtIndex:(NSInteger)index{
    return _messages[index];
}

- (NSArray<ChatMessage *> *)messages{
    return [_messages copy];
}

- (NSUInteger)count{
    return _messages.count;
}

@end