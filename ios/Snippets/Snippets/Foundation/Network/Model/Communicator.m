//
//  Communicator.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/7.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "Communicator.h"

CFReadStreamRef readStream;
CFWriteStreamRef writeStream;

NSInputStream *inputStream;
NSOutputStream *outputStream;

@implementation Communicator {
    NSString *_host;
    NSUInteger _port;
}

@synthesize host = _host;
@synthesize port = _port;

- (instancetype)initWithHost:(NSString *)host port:(NSUInteger)port{
    self = [super init];
    if (!self) {
        return nil;
    }
    _host = host;
    _port = port;
    return self;
}

- (void)setup{
    NSURL *url = [NSURL URLWithString:_host];
    NSLog(@"Setting up connection to %@ : %lu", [url absoluteString], _port);
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)[url host], (uint32_t)_port, &readStream, &writeStream);
    if (!CFWriteStreamOpen(writeStream)) {
        NSLog(@"Error, write stream not open!");
        return;
    }
    [self open];
}

- (void)open{
    NSLog(@"opening stream...");
    inputStream = (NSInputStream *)inputStream;
    outputStream = (NSOutputStream *)outputStream;
    
    inputStream.delegate = self;
    outputStream.delegate = self;
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
    NSLog(@"Status of inputStream: %lu", [inputStream streamStatus]);
    NSLog(@"Status of outputStream: %lu", [outputStream streamStatus]);
}

- (void)close{
    NSLog(@"Closing streams.");
        
    [inputStream close];
    [outputStream close];
        
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"stream triggered");
    
    switch (eventCode) {
        case NSStreamEventHasSpaceAvailable:
            if (stream == outputStream) {
                NSLog(@"outstream is ready");
            }
            break;
        case NSStreamEventHasBytesAvailable :
            if (stream == inputStream) {
                NSLog(@"input stream is ready");
                
                uint8_t buffer[1024];
                NSInteger len = 0;
                len = [inputStream read:buffer maxLength:1024];
                if (len <= 0) {
                    NSLog(@"input stream is empty");
                    return;
                }
                
                NSMutableData *data = [[NSMutableData alloc] initWithLength:0];
                [data appendBytes:(const void *)data length:len];
                NSString *content = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                [self readIn:content];
                
                data = nil;
            }
            break;
            
        default:
            NSLog(@"Stream is sending an event: %lu", eventCode);
            break;
    }
}

- (void)readIn:(NSString *)content{
    NSLog(@"Reading in the following:");
    NSLog(@"%@", content);
}

- (void)writeOut:(NSString *)content{
    uint8_t *buffer = (uint8_t *)[content UTF8String];
    [outputStream write:buffer maxLength:strlen((char *)buffer)];
    NSLog(@"write out the following:");
    NSLog(@"%@", content);
}

@end
