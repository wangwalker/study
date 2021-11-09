//
//  AppDelegate.h
//  Snippets
//
//  Created by Walker on 2020/6/9.
//  Copyright © 2020 Walker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

