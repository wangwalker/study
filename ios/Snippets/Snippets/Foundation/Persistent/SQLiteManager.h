//
//  SQLiteManager.h
//  Snippets
//
//  Created by Walker Wang on 2021/11/7.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>

/**
 * Note:
 * - sqlite can't work at multi-thread programming environment, you must invoke sql statements on one specific thread;
 * - when create tables, the data type of column with the primary key and auto increment clause must set to 'INTEGER';
 * - more details at https://www.sqlite.org/docs.html
 */

NS_ASSUME_NONNULL_BEGIN

@interface SQLiteManager : NSObject

+ (instancetype)databaseWithName:(NSString *)name;

- (BOOL)createTableWithStatement:(NSString *)stmt;
- (BOOL)insertRowWithStatement:(NSString *)stmt;
- (BOOL)updateRowWithStatement:(NSString *)stmt;
- (NSArray *)selectRowsWithStatement:(NSString *)stmt;

@property (nonatomic, readonly, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
