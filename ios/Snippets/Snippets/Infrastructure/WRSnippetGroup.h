//
//  WRSnippetGroup.h
//  Snippets
//
//  Created by Walker on 2020/11/10.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WRSnippetItem;

@interface WRSnippetGroup : NSObject

+ (instancetype)groupWithName:(NSString*)name;

- (void)addSnippetItem:(WRSnippetItem*)item;

@property (nonatomic, strong, readonly) NSArray<WRSnippetItem*>* snippets;

@property (nonatomic, copy) NSString* name;

@end

NS_ASSUME_NONNULL_END
