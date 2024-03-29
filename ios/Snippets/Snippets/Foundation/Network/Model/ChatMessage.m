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
