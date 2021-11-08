//
//  SQLiteManager.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/7.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "SQLiteManager.h"

NSMutableArray *existedDatabaseNames;

@implementation SQLiteManager {
    NSString *_name;
    sqlite3 *sqlite;
    BOOL connected;
}

@synthesize name = _name;

+ (void)initialize{
    existedDatabaseNames = [NSMutableArray array];
}

+ (instancetype)databaseWithName:(NSString *)name{
    return [[self alloc] initWithDatabaseWithName:name];
}

- (instancetype)initWithDatabaseWithName:(NSString *)name{
    NSAssert(![existedDatabaseNames containsObject:name], @"your database name already existed.");
    if (self = [super init]) {
        _name = name;
        [existedDatabaseNames addObject: name];
    }
    return self;
}

- (BOOL)createTableWithStatement:(NSString *)stmt{
    return [self executeSql:stmt];
}

- (BOOL)insertRowWithStatement:(NSString *)stmt{
    return [self executeSql:stmt];
}

- (BOOL)updateRowWithStatement:(NSString *)stmt{
    return [self executeSql:stmt];
}

- (NSArray *)selectRowsWithStatement:(NSString *)stmt{
    if (![self openDatabase]) {
        return nil;
    }
    sqlite3_stmt *sStmt;
    if (sqlite3_prepare_v2(sqlite, stmt.UTF8String, -1, &sStmt, nil) != SQLITE_OK) {
        return nil;
    }
    
    NSMutableArray *rows = [NSMutableArray array];
    while (sqlite3_step(sStmt) == SQLITE_ROW) {
        int column = sqlite3_column_count(sStmt);
        NSMutableDictionary *row = [NSMutableDictionary dictionary];
        for (int col = 0; col < column; col++) {
            id value;
            NSString *key = [NSString stringWithUTF8String:sqlite3_column_name(sStmt, col)];
            const char *charValue = (const char *)sqlite3_column_text(sStmt, col);
            if (NULL != charValue) {
                value = [NSString stringWithUTF8String:charValue];
            } else {
                value = nil;
            }
            [row setValue:value forKey:key];
        }
        [rows addObject:row];
    }
    return [rows copy];
}

#pragma mark - Private

- (BOOL)executeSql:(NSString *)stmt{
    if (!connected && ![self openDatabase]) {
        return NO;
    }
    return SQLITE_OK == sqlite3_exec(sqlite, stmt.UTF8String, nil, nil, nil);
}

- (BOOL)openDatabase{
    NSString *dbPath = [self databasePath];
    if (nil == dbPath) {
        return NO;
    }
    connected = SQLITE_OK == sqlite3_open(dbPath.UTF8String, &sqlite);
    return connected;
}

- (NSString *)databasePath{
    if (nil == _name || 0 >= _name.length) {
        return nil;
    }
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [doc stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.sqlite", _name]];
}

@end
