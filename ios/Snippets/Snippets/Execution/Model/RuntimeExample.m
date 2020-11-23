//
//  RuntimeExample.m
//  Snippets
//
//  Created by Walker on 2020/11/19.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "RuntimeExample.h"
#import <objc/runtime.h>
#import "RunLoopExample.h"

static char dynamicKey;

@implementation RuntimeExample{
    RunLoopExample *runloop;
    RuntimeHelper *anotherObject;
}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel1 = @selector(swizzlingMethod1);
        SEL sel2 = @selector(swizzlingMethod2);
        
        Method m1 = class_getInstanceMethod([self class], sel1);
        Method m2 = class_getInstanceMethod([self class], sel2);
        
        BOOL methodAdded = class_addMethod([self class], sel1, method_getImplementation(m2), method_getTypeEncoding(m2));
        
        if (methodAdded) {
            NSLog(@"method add and add");
            class_replaceMethod([self class], sel2, method_getImplementation(m1), method_getTypeEncoding(m1));
        } else {
            NSLog(@"methods exchange");
            method_exchangeImplementations(m1, m2);
        }
    });
}

- (instancetype)init{
    if ((self = [super init])) {
        runloop = [[RunLoopExample alloc] init];
        anotherObject = [[RuntimeHelper alloc] init];
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

void dynamicMethodIMP(id self, SEL _cmd) {
    NSLog(@"dynamic method implementation: %@", NSStringFromSelector(_cmd));
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    SEL aSel = NSSelectorFromString(@"someDynamicMethod");
    if (sel == aSel) {
        class_addMethod([self class], aSel, (IMP)dynamicMethodIMP, "v@:");
    }
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel{
    SEL aSel = NSSelectorFromString(@"someDynamicMethod");
    if (sel == aSel) {
        class_addMethod([self class], aSel, (IMP)dynamicMethodIMP, "v@:");
    }
    return [super resolveClassMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"forwarding target");
    if ([NSStringFromSelector(aSelector) isEqualToString:NSStringFromSelector(@selector(addTimerForCommonMode))]) {
        NSLog(@"forwarding to 'runloop'");
        return runloop;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    SEL sel = [anInvocation selector];
    if ([anotherObject respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:anotherObject];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature && [anotherObject respondsToSelector:aSelector]) {
        signature = [anotherObject methodSignatureForSelector:aSelector];
    }
    return signature;
}

- (void)swizzlingMethod1{
    NSLog(@"swizzling method: %s", __FUNCTION__);
}

- (void)swizzlingMethod2{
    NSLog(@"swizzing method: %s", __FUNCTION__);
}

@end


@implementation RuntimeHelper

- (void)processUnrecognizedMessage{
    NSLog(@"process messages that NSRuntimeExample does not recognize");
}

@end
