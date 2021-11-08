//
//  TCPServer.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/8.
//  Copyright © 2021 Walker. All rights reserved.
//

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#import "TCPServer.h"

@implementation TCPServer

+ (BOOL)startWithHost:(NSString *)host port:(NSInteger)port{
    const char *s_addr = (const char *)host.UTF8String;
    int sock, new_sock;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    char read_buffer[1024] = {0};
    char write_buffer[1024] = "Hi, ";
    
    if (0 == (sock = socket(AF_INET, SOCK_STREAM, 0))) {
        NSLog(@"create server socket failed.");
        return NO;
    }
    
    if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt))) {
        NSLog(@"set socket option failed.");
        return NO;
    }
    
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = inet_addr(s_addr);
    address.sin_port = (in_port_t)port;
    
    if (0 > bind(sock, (struct sockaddr *)&address, sizeof(address))) {
        NSLog(@"error occured when bind to address.");
        return NO;
    }
    
    if (0 > listen(sock, 3)) {
        NSLog(@"error occured when listen to socket.");
        return NO;
    }
    
    new_sock = accept(sock, (struct sockaddr *)&address, (socklen_t *)&addrlen);
    if (0 > new_sock) {
        NSLog(@"error occured when accpet new socket.");
        return NO;
    }
    
    while (true) {
        read(new_sock, read_buffer, 1024);
        strcat(write_buffer, read_buffer);
        send(new_sock, write_buffer, strlen(write_buffer), 0);
        memset(read_buffer, 0, strlen(read_buffer));
        memset(write_buffer, 0, strlen(write_buffer));
        strcpy(write_buffer, "Hi, ");
    }
    
    return YES;
}
@end
