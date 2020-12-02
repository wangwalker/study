//
//  KVCTransation.h
//  Snippets
//
//  Created by Walker on 2020/12/2.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVCTransaction : NSObject

+ (instancetype)transactionWithPayee:(NSString *)payee amount:(NSNumber *)amount data:(NSDate *)date;

@property (nonatomic, copy) NSString* payee;   // To whom
@property (nonatomic, copy) NSNumber* amount;  // How much
@property (nonatomic) NSDate* date;      // When

@end


@interface KVCTransationLab : NSObject

- (void)filterWithCollectionOperator:(NSString *)collectionOperator;

@end

NS_ASSUME_NONNULL_END
