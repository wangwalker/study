//
//  ChatMessageTests.m
//  SnippetsTests
//
//  Created by Walker Wang on 2021/11/8.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ChatMessage.h"

@interface ChatMessageTests : XCTestCase
@property (nonatomic, strong) ChatMessage *chatMessage;
@end

@implementation ChatMessageTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _chatMessage = [ChatMessage messageWithMessageShip:ChatMessageMembershipSelf type:ChatMessageTypeText];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _chatMessage = nil;
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssertNotNil(_chatMessage);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
