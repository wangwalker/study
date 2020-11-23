//
//  RuntimeExample.h
//  Snippets
//
//  Created by Walker on 2020/11/19.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RuntimeExample : NSObject

- (void)showInheritanceHierarchy;

- (void)setAndGetDynamicObject;

// 模拟Method Swizzling
- (void)swizzlingMethod1;
- (void)swizzlingMethod2;

@end


@interface RuntimeHelper : NSObject

- (void)processUnrecognizedMessage;

@end

NS_ASSUME_NONNULL_END
