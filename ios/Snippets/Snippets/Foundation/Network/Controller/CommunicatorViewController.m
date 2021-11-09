//
//  CommunicatorViewController.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/7.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "CommunicatorViewController.h"
#import "ChatView.h"
#import "Communicator.h"
#import "TCPClient.h"
#import "ChatMessage.h"
#import "ChatMessageQueue.h"
#import "SQLiteChatMessage.h"

@interface CommunicatorViewController () <ChatMessageViewDelegate>
@property (nonatomic) ChatView *chatView;
@property (nonatomic) UITextField *inputFiled;
@property (nonatomic) TCPClient *client;
@property (nonatomic) ChatMessageQueue *messages;
@property (nonatomic) SQLiteChatMessage *sqlite;
@end

@implementation CommunicatorViewController

- (instancetype)init{
    if (self = [super init]) {
        [self initChat];
        [self initUI];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.chatView update];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.chatView.frame = self.view.frame;
    self.chatView.center = self.view.center;
    self.inputFiled.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-50, 44);
    self.inputFiled.center = self.view.center;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self chat:textField.text];
    return YES;
}

#pragma mark - ChatViewDelegate

- (NSInteger)numberOfMessagesInChatView:(ChatView *)chatView{
    return _messages.count;
}

- (UIView *)chatView:(ChatView *)chatView chatViewCellAtIndex:(NSInteger)index{
    ChatMessage *message = [_messages messageAtIndex:index];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    label.font = [UIFont systemFontOfSize:16.f];
    label.text = message.content;
    switch (message.membership) {
        case ChatMessageMembershipSelf:
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = [UIColor greenColor];
            break;
        case ChatMessageMembershipOther:
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor lightGrayColor];
            break;
        default:
            break;
    }
    return label;
}

#pragma mark - Private

- (void)chat:(NSString *)content{
    ChatMessage *message = [ChatTextMessage text:content membership:ChatMessageMembershipSelf];
    [_messages addMessage:message];
    [_chatView update];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.client writeContent:content];
        NSString *recievedContent = [self.client readFromServer];
        ChatTextMessage *other = [ChatTextMessage text:recievedContent membership:ChatMessageMembershipOther];
        [self.messages addMessage:other];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.chatView update];
        });
        NSLog(@"\nsend: %@\nrecieve: %@", content, recievedContent);
    });
}

- (void)initUI{
    [self.view addSubview:self.chatView];
    [self.view addSubview:self.inputFiled];
}

- (void)initChat{
    NSArray *chats;
    
    _messages = [[ChatMessageQueue alloc] initWithName:@"tcpChat"];
    _client = [[TCPClient alloc] initWithHost:@"127.0.0.1" port:8888];
    _sqlite = [[SQLiteChatMessage alloc] init];
    
    chats = [_sqlite retrieveAllChatMessages];
    if (chats && 0 < chats.count) {
        _messages = [[ChatMessageQueue alloc] initWithName:@"tcpChat" messages:chats];
    }
    
    // do data persistent when operate chat messages queue
    _messages.persistenceDelegate = _sqlite;
}

- (UITextField *)inputFiled{
    if (!_inputFiled) {
        _inputFiled = [[UITextField alloc] initWithFrame:CGRectZero];
        _inputFiled.delegate = self;
        _inputFiled.tintColor = [UIColor lightGrayColor];
        _inputFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputFiled.placeholder = @"please input";
        _inputFiled.backgroundColor = [UIColor lightGrayColor];
        _inputFiled.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _inputFiled;
}

- (ChatView *)chatView{
    if (!_chatView) {
        _chatView = [[ChatView alloc] initWithFrame:CGRectZero];
        _chatView.delegate = self;
    }
    return _chatView;
}

@end
