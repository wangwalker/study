//
//  KVCTransation.m
//  Snippets
//
//  Created by Walker on 2020/12/2.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "KVCTransaction.h"

@implementation KVCTransaction

+ (instancetype)transactionWithPayee:(NSString *)payee amount:(NSNumber *)amount data:(NSDate *)date{
    return [[self alloc] initWithPayee:payee amount:amount date:date];
}

- (instancetype)initWithPayee:(NSString *)payee amount:(NSNumber *)amount date:(NSDate *)date{
    if ((self = [super init])) {
        self.payee = payee;
        self.amount = amount;
        self.date = date;
    }
    return self;
}

@end


@implementation KVCTransationLab

- (void)filterWithCollectionOperator:(NSString *)collectionOperator{
    NSLog(@"the %@ of transactions", [collectionOperator substringFromIndex:1]);
    NSNumber *aggValue = [[self transactions] valueForKeyPath:collectionOperator];
    NSLog(@"is %@", aggValue);
}

- (NSArray<KVCTransaction*> *)transactions{
    NSMutableArray *transactions = [NSMutableArray array];
    
    [transactions addObject:[KVCTransaction transactionWithPayee:@"Green Power" amount:@(150.00) data:[self randomDate]]];
    [transactions addObject:[KVCTransaction transactionWithPayee:@"Green Power" amount:@(170.00) data:[self randomDate]]];
    [transactions addObject:[KVCTransaction transactionWithPayee:@"Green Power" amount:@(120.00) data:[self randomDate]]];
    [transactions addObject:[KVCTransaction transactionWithPayee:@"Car Loan" amount:@(132.00) data:[self randomDate]]];
    [transactions addObject:[KVCTransaction transactionWithPayee:@"Car Loan" amount:@(232.00) data:[self randomDate]]];
    [transactions addObject:[KVCTransaction transactionWithPayee:@"Car Loan" amount:@(893.00) data:[self randomDate]]];
    [transactions addObject:[KVCTransaction transactionWithPayee:@"General Cable" amount:@(420.00) data:[self randomDate]]];
    [transactions addObject:[KVCTransaction transactionWithPayee:@"General Cable" amount:@(323.00) data:[self randomDate]]];
    [transactions addObject:[KVCTransaction transactionWithPayee:@"Mortgage" amount:@(2120.40) data:[self randomDate]]];
    [transactions addObject:[KVCTransaction transactionWithPayee:@"Mortgage" amount:@(320.05) data:[self randomDate]]];
    [transactions addObject:[KVCTransaction transactionWithPayee:@"Animal Hospital" amount:@(500.00) data:[self randomDate]]];
    
    return [transactions copy];
}

- (NSDate *)randomDate{
    NSTimeInterval rand = arc4random()%10000000;
    return [NSDate dateWithTimeIntervalSinceNow:rand-5000000];
}
@end
