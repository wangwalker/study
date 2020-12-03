//
//  ClassMateContact.h
//  Snippets
//
//  Created by Walker on 2020/12/2.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassmateContact : NSObject

- (BOOL)validateName:(NSString *_Nullable*_Nullable)name error:(NSError * __autoreleasing *)error;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *city;

@end

NS_ASSUME_NONNULL_END
