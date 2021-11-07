//
//  TCPClient.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/7.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "TCPClient.h"
#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>

@implementation TCPClient {
    NSString *_host;
    NSUInteger _port;
    BOOL _connented;
}

@synthesize host = _host;
@synthesize port = _port;

int sock;

int connectToServer(const char * host, int port) {
    struct sockaddr_in server_addr;
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        NSLog(@"socket creation failed.");
        return -1;
    }
    
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = (in_port_t)port;
    
    // Convert IPv4 or IPv6 addresses from strings to binary form
    if (inet_pton(AF_INET, host, &server_addr.sin_addr) <= 0) {
        NSLog(@"Invalid IP address, or not supported.");
        return -1;
    }
    
    if (connect(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        NSLog(@"can't connect to host: %s port: %d", host, port);
        return -1;
    }
    
    return 0;
}

- (instancetype)initWithHost:(NSString *)host port:(NSUInteger)port{
    self = [super init];
    if (!self) {
        return nil;
    }
    _host = host;
    _port = port;
    
    _connected = connectToServer([host UTF8String], (int)port) == 0;
    
    if (_connected) {
        NSLog(@"connect to server %@:%lu", host, port);
    }
    
    return self;
}

- (BOOL)writeContent:(NSString *)content{
    if (!_connected) {
        return NO;
    }
    return send(sock, [content UTF8String], content.length, 0) > 0;
}

- (NSString *)readFromServer{
    if (!_connected) {
        return @"";
    }
    char buffer[1024] = {0};
    if (read(sock, buffer, 1024) > 0) {
        return [NSString stringWithUTF8String:buffer];
    }
    return @"";
}

@end
