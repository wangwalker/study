//
//  BlockExample.m
//  Snippets
//
//  Created by Walker on 2020/11/24.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "BlockExample.h"

@interface BlockExample ()
@property (nonatomic, copy) NSString *name;
@end

@implementation BlockExample

// global block
void (^myGlobalBlock)(int) = ^(int value) {
    printf("double value %d is %d with global block", value, 2*value);
};

void sortMyStrings(char ** strs) {
    
}

- (instancetype)init{
    if ((self = [super init])) {
        self.name = @"Example...";
        self.someCallback = ^{
            NSLog(@"some callback");
        };
    }
    return self;
}

- (int)doubleInt:(NSNumber *)base{
    int exp = 2;
    
    // malloc block
    int (^doubleInt)(int) = ^(int base) {
        return (int)exp*base;
    };
    
    NSLog(@"double 11 is %d with stack block", doubleInt(11));
    myGlobalBlock(11);
    
    return doubleInt([base intValue]);
}

- (id)defineSomeVoidBlock{
    NSString *name = @"Walker";
    void (^myVoidBlock)(void) = ^(void) {
        NSLog(@"Hello, %@", name);
    };
    
    return myVoidBlock;
}

- (void)simulateRetainCycle{
    __weak typeof(self) weakSelf = self;
    self.someCallback = ^(void) {
        NSString *name = [NSString stringWithFormat:@"%@%u",
                          weakSelf.name, arc4random()%10];
        weakSelf.name = name;
    };
}


@end
