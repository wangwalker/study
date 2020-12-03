//
//  ClassMateContact.m
//  Snippets
//
//  Created by Walker on 2020/12/2.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "ClassmateContact.h"

@implementation ClassmateContact

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (BOOL)validateName:(NSString * _Nullable __autoreleasing *)name error:(NSError *__autoreleasing  _Nullable *)error{
    if (*name == nil) {
        *name = @"";
        return YES;
    }
    *name = [*name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return YES;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"contact name: %@, nickname: %@, email: %@, city: %@",
            _name, _nickname, _email, _city];
}

@end
