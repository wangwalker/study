//
//  KeyValueObserver.h
//  Snippets
//
//  Created by Walker on 2020/11/30.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyValueObserver : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;

/// Create a Key-Value Observing helper object.
///
/// As long as the returned token object is retained, the KVO notifications of the @c object
/// and @c keyPath will cause the given @c selector to be called on @c target.
/// @a object and @a target are weak references.
/// Once the token object gets dealloc'ed, the observer gets removed.
///
/// The @c selector should conform to
/// @code
/// - (void)nameDidChange:(NSDictionary *)change;
/// @endcode
/// The passed in dictionary is the KVO change dictionary (c.f. @c NSKeyValueChangeKindKey, @c NSKeyValueChangeNewKey etc.)
///
/// @returns the opaque token object to be stored in a property
///
/// Example:
///
/// @code
///   self.nameObserveToken = [KeyValueObserver observeObject:user
///                                                   keyPath:@"name"
///                                                    target:self
///                                                  selector:@selector(nameDidChange:)];
/// @endcode
+ (NSObject *)observeObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector __attribute__((warn_unused_result));

/// Create a key-value-observer with the given KVO options
+ (NSObject *)observeObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector options:(NSKeyValueObservingOptions)options __attribute__((warn_unused_result));


@end

NS_ASSUME_NONNULL_END
