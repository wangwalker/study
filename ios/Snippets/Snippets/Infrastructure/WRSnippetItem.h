//
//  WRSnippetItem.h
//  Snippets
//
//  Created by Walker on 2020/11/10.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <libkern/OSAtomic.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WRGCDHandler)(void);

@interface WRSnippetItem : NSObject<NSCopying>

// 需要push新页面
+ (instancetype)itemWithName:(NSString*)name viewControllerClassName:(NSString*)className detail:(NSString*)detailDesc;

// 只在当前页执行任务
+ (instancetype)itemWithName:(NSString*)name detail:(NSString*)detailDesc selector:(SEL)aSelector target:(id)target object:(id)obj;

+ (instancetype)itemWithName:(NSString*)name detail:(NSString*)detailDesc block:(WRGCDHandler)handler;

// 如果不同push新页面，则执行相关任务，Selector或者Block
- (void)start;

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* viewControllerClassName;
@property (nonatomic, copy) NSString* detailedDescription;
@property (nonatomic) SEL aSelector;
@property (nonatomic) id selectorTarget;
@property (nonatomic) id selectorObject;

@property (nonatomic) WRGCDHandler handler;

@property (nonatomic) id parameters;

@property (nonatomic, readonly) id relatedViewController;

@end

NS_ASSUME_NONNULL_END
