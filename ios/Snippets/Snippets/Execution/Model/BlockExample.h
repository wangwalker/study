//
//  BlockExample.h
//  Snippets
//
//  Created by Walker on 2020/11/24.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^MyVoidVoidBlock) (void);
typedef void (^MyVoidIntBlock) (int);
typedef int (^MyIntStringBlock) (char *);

@interface BlockExample : NSObject

- (int)doubleInt:(NSNumber*)base;

- (id)defineSomeVoidBlock;

@property (nonatomic, assign) MyVoidVoidBlock someCallback;

@end

NS_ASSUME_NONNULL_END
