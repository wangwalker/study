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
    dispatch_source_t processSource, dirSource, timerSource;
}

- (void)monitorProcess{
    processSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC, getpid(), DISPATCH_PROC_FORK, DISPATCH_TARGET_QUEUE_DEFAULT);
    if (!processSource)
        return;
    
    NSLog(@"start monitor process...");
    
    dispatch_source_set_event_handler(processSource, ^{
        NSLog(@"process forked, please check!");
        dispatch_source_cancel(self->processSource);
    });
    
    dispatch_activate(processSource);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        fork();
    });
}

- (void)monitorAppDirectory{
    // monitor
    @try {
        [self monitorFileDirectoryWithPath:[self docPath]];
    } @catch (NSException *exception) {
        NSLog(@"catch exception when monitor file system, exception:%@", exception.debugDescription);
        [self cancelMonitorAppDirectory];
    }
    
    // write file to doc path
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self writeDataToDocPath];
    });
}

- (void)monitorFileDirectoryWithPath:(NSString *)path{
    int const fd = open([path fileSystemRepresentation], O_EVTONLY);
    if (fd < 0) {
         char buffer[80];
         strerror_r(errno, buffer, sizeof(buffer));
         NSLog(@"Unable to open \"%@\": %s (%d)", path, buffer, errno);
         return;
    }
    
    dirSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fd,
    DISPATCH_VNODE_WRITE | DISPATCH_VNODE_DELETE | DISPATCH_VNODE_EXTEND, DISPATCH_TARGET_QUEUE_DEFAULT);
    dispatch_source_set_event_handler(dirSource, ^(){
        NSLog(@"The directory changed.");
    });
    
    dispatch_source_set_cancel_handler(dirSource, ^(){
         close(fd);
    });
        
    dispatch_activate(dirSource);
    
    NSLog(@"start monitor file system at: %@", path);
}

- (void)cancelMonitorAppDirectory{
    if (!dirSource) {
        return;
    }
    
    dispatch_source_cancel(dirSource);
}

- (void)writeDataToDocPath{
    NSString *message = [NSString stringWithFormat:@"write something at %.g", [NSDate.now timeIntervalSince1970]];
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSString *filePath = [[self docPath] stringByAppendingPathComponent:@"monitor.txt"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        if ([[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil]) {
            NSLog(@"Has created file at %@", filePath);
        } else {
            NSLog(@"Create file failed");
        }
    } else {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"Error occurs when delete file at %@", filePath);
        }
    }
}

- (void)monitorTimer{
    timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, DISPATCH_TARGET_QUEUE_DEFAULT);
    dispatch_source_set_timer(timerSource, DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC, DISPATCH_TIMER_STRICT);
    dispatch_source_set_event_handler(timerSource, ^{
        NSLog(@"time elapses");
    });
    dispatch_activate(timerSource);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_source_cancel(self->timerSource);
    });
}

- (NSString *)docPath{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

@end
