//
//  RuntimeExample.m
//  Snippets
//
//  Created by Walker on 2020/11/19.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "RuntimeExample.h"
#import <objc/runtime.h>

static char dynamicKey;

@implementation RuntimeExample

- (instancetype)init{
    if ((self = [super init])) {
        
    }
    return self;
}

- (void)showInheritanceHierarchy{
    Class selfClass = [self class];
    Class superClass = [self superclass];
    Class metaClass = objc_getClass((__bridge void *)[NSObject class]);
    
    NSLog(@"[RuntimeExample new]\nself class: %@, super class %@, meta class: %@",
          NSStringFromClass(selfClass),
          NSStringFromClass(superClass),
          NSStringFromClass(metaClass));
        
    Class cls = selfClass;
    while ([cls superclass]){
        NSLog(@"current class: %@, super class: %@, meta class:%@",
              NSStringFromClass(cls),
              NSStringFromClass([cls superclass]),
              objc_getClass((__bridge  void *)[cls class]));
        
        cls = [cls superclass];
    }
}

- (void)setAndGetDynamicObject{
    if (objc_getAssociatedObject(self, &dynamicKey)) {
        objc_removeAssociatedObjects(objc_getAssociatedObject(self, &dynamicKey));
    }
    
    id objcSet = [self generateDynamicObject];
    objc_setAssociatedObject(self, &dynamicKey, objcSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    id objcGet = objc_getAssociatedObject(self, &dynamicKey);
    
    NSLog(@"my dynamic object is %@", objcGet);
}

- (id)generateDynamicObject{
    NSArray *objecs = @[@1, @3, @"Wang", @YES];
    NSUInteger idx = arc4random()%4;
    return [objecs objectAtIndex:idx];
}
@end
