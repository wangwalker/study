//
//  CoreDataChatMessage.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/9.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CoreDataChatMessage.h"
#import "ChatMessage.h"
#import "ChatMessageQueue.h"

@implementation CoreDataChatMessage

- (NSArray *)retrieveAllChatMessages{
    
    return @[];
}

- (BOOL)insertChatMessage:(ChatMessage *)chatMessage{
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSManagedObjectContext *context = app.persistentContainer.viewContext;
//    ChatMessage *cdChatMessage = (ChatMessage *)[NSEntityDescription insertNewObjectForEntityForName:@"ChatMessage" inManagedObjectContext:context];
    
    return YES;
}

- (BOOL)chatMessageQueue:(ChatMessageQueue *)messageQueue willInsertChatMessage:(ChatMessage *)chatMessage{
    NSLog(@"core data will insert chat message: %@", chatMessage.content);
    
    return YES;
}

- (BOOL)chatMessageQueue:(ChatMessageQueue *)messageQueue didInsertChatMessage:(ChatMessage *)chatMessage{
    
    return YES;
}

@end
