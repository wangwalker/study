//
//  WRSnippetManager.h
//  Snippets
//
//  Created by Walker on 2020/11/10.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WRSnippetGroup;

@interface WRSnippetManager : NSObject

+ (instancetype)sharedManager;

- (NSArray<WRSnippetGroup*>* )allSnippetGroups;

@end

NS_ASSUME_NONNULL_END
