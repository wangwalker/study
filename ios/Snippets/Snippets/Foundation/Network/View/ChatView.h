//
//  ChatView.h
//  Snippets
//
//  Created by Walker Wang on 2021/11/7.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ChatMessage;
@class ChatMessageQueue;
@protocol ChatMessageViewDelegate;


@interface ChatView : UIView

- (void)update;

@property (nonatomic, weak) id<ChatMessageViewDelegate> delegate;

@end

@protocol ChatMessageViewDelegate <NSObject>

- (NSInteger)numberOfMessagesInChatView:(ChatView *)chatView;
- (UIView *)chatView:(ChatView *)chatView chatViewCellAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
