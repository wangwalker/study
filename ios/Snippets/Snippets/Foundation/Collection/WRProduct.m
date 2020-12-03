//
//  WRProduct.m
//  collections
//
//  Created by Walker on 2020/11/9.
//

#import "WRProduct.h"

@implementation WRProduct

+ (instancetype)productWithName:(NSString *)name sales:(NSUInteger)sales{
    return [[self alloc] initWithName:name sales:sales];
}

- (instancetype)initWithName:(NSString *)name sales:(NSUInteger)sales{
    if ((self = [super init])) {
        self.name = name;
        self.sales = sales;
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    WRProduct *other = (WRProduct *)object;
    return [self.name isEqualToString:other.name] && self.sales == other.sales;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"product name: %@, sales: %lu", self.name, (unsigned long)self.sales];
}

@end

@implementation WRProductLab

+ (NSArray<WRProduct *> *)testProducts{
    NSMutableArray *m = [@[] mutableCopy];
    
    for (int i=0; i<10; i++) {
        NSUInteger sales = arc4random()%10000;
        [m addObject:[WRProduct productWithName:[self randomName] sales:sales]];
    }
    
    return [m copy];
}

+ (WRProduct *)randomProductFromTest{
    NSArray *rp = [self testProducts];
    return [rp objectAtIndex:(arc4random()%rp.count)];
}

+ (NSString *)randomName{
    static NSString *alphb = @"abcdefghijklmnopqrstuvwxyz";
    NSUInteger length = arc4random()%10;
    NSMutableString *name = [@"" mutableCopy];
    
    for (int i=0; i<length; i++) {
        NSString *randomLetter = [alphb substringWithRange:NSMakeRange(arc4random()%25, 1)];
        [name appendString:randomLetter];
    }
    
    return [[name copy] capitalizedString];
}

@end
