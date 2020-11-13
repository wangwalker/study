//
//  GCDSourceExample.m
//  Snippets
//
//  Created by Walker on 2020/11/13.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "GCDSourceExample.h"

@implementation GCDSourceExample
{
    dispatch_source_t dirSource;
}

- (void)monitorProcessWithIdentifier:(NSString *)appIdentifier{
    
}

- (void)monitorFileDirectoryWithUrl:(NSURL *)dirUrl{
    int const fd = open([[dirUrl path] fileSystemRepresentation], O_EVTONLY);
    if (fd < 0) {
         char buffer[80];
         strerror_r(errno, buffer, sizeof(buffer));
         NSLog(@"Unable to open \"%@\": %s (%d)", [dirUrl path], buffer, errno);
         return;
    }
    
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fd,
    DISPATCH_VNODE_WRITE | DISPATCH_VNODE_DELETE, DISPATCH_TARGET_QUEUE_DEFAULT);
    dispatch_source_set_event_handler(source, ^(){
         unsigned long const data = dispatch_source_get_data(source);
         if (data & DISPATCH_VNODE_WRITE) {
              NSLog(@"The directory changed.");
         }
         if (data & DISPATCH_VNODE_DELETE) {
              NSLog(@"The directory has been deleted.");
         }
    });
    
    dispatch_source_set_cancel_handler(source, ^(){
         close(fd);
    });
    
    dirSource = source;
    
    dispatch_activate(dirSource);
}

- (void)cancelMonitorFileDirectory{
    if (!dirSource) {
        return;
    }
    
    dispatch_source_cancel(dirSource);
}

- (void)writeDataToFileDir:(NSURL *)dirUrl{
    NSString *message = @"Start monitor ";
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[dirUrl path]]) {
        if ([[NSFileManager defaultManager] createFileAtPath:[dirUrl path] contents:data attributes:nil]) {
            NSLog(@"Has created file at %@", dirUrl.path);
        } else {
            NSLog(@"Create file failed");
        }
    } else {
        [data writeToFile:[dirUrl path] atomically:NO];
    }
}

- (NSURL *)fileUrlToWrite{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docPath = paths.firstObject;
    return [NSURL URLWithString:[docPath stringByAppendingPathComponent:@"string.txt"]];
}

@end
