//
//  PersistentChatMessage.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/8.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "SQLiteChatMessage.h"
#import "ChatMessage.h"
#import "SQLiteManager.h"

SQLiteManager *sqliteManager;

@implementation SQLiteChatMessage

+ (void)initialize{
    sqliteManager = [SQLiteManager databaseWithName:@"default"];
    NSAssert([sqliteManager createTableWithStatement:[self createTableStatement]], @"create ChatMessage table failed");
}

+ (NSString*)createTableStatement{
    char *stmt;
    stmt =  "CREATE TABLE IF NOT EXISTS 'CHAT_MESSAGE' (" \
            "'localID' INTEGER PRIMARY KEY AUTOINCREMENT," \
            "'serverID' INTEGER," \
            "'type' INT," \
            "'membership' INT," \
            "'content' TEXT NOT NULL);";
    return [NSString stringWithUTF8String:stmt];
}

- (BOOL)insertChatMessage:(ChatMessage *)chatMessage{
    NSString *stmtFormat = @"INSERT INTO 'CHAT_MESSAGE' (type, membership, content) VALUES (%ld, %ld, '%s');";
    NSString *stmt = [NSString stringWithFormat:stmtFormat, chatMessage.type, chatMessage.membership, chatMessage.content.UTF8String];
    return [sqliteManager insertRowWithStatement:stmt];
}

- (NSArray *)retrieveAllChatMessages{
    NSString *stmt = @"SELECT * FROM CHAT_MESSAGE;";
    NSArray *rows = [sqliteManager selectRowsWithStatement:stmt];
    if (nil == rows || 0 == rows.count) {
        return nil;
    }
    NSMutableArray *chats = [NSMutableArray array];
    for (NSDictionary* row in rows) {
        ChatMessage *chatMessage = [ChatTextMessage text:[row objectForKey:@"content"] membership:(ChatMessageMembership)[[row objectForKey:@"membership"] intValue]];
        [chats addObject:chatMessage];
    }
    return chats;
}

#pragma mark ChatMessagePersistentDelegate

- (BOOL)chatMessageQueue:(ChatMessageQueue *)messageQueue willInsertChatMessage:(ChatMessage *)chatMessage{
    NSLog(@"will insert chat message: %@", chatMessage.content);
    return YES;
}

- (BOOL)chatMessageQueue:(ChatMessageQueue *)messageQueue didInsertChatMessage:(ChatMessage *)chatMessage{
    NSLog(@"did insert chat message: %@", chatMessage.content);
    [self insertChatMessage:chatMessage];
    return YES;
}

@end
