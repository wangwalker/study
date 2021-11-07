#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char const *argv[])
{
    in_port_t port = 8888;
    int sock = 0, valread;
    struct sockaddr_in serv_addr;
    char read_buffer[1024] = {0};
    char write_buffer[1024] = {0};

    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        printf("\n Socket creation error \n");
        return -1;
    }
   
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = port;
       
    // Convert IPv4 and IPv6 addresses from text to binary form
    if(inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr)<=0) 
    {
        printf("\nInvalid address/ Address not supported \n");
        return -1;
    }
   
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
        printf("\nConnection Failed \n");
        return -1;
    }
    
    while (printf("please write you message: ") ,scanf("%s", write_buffer) > 0)
    {
        send(sock, write_buffer, strlen(write_buffer), 0);
        valread = read(sock , read_buffer, 1024);
        printf("write: %s\nread: %s\n", write_buffer, read_buffer );
        memset(write_buffer, 0, strlen(write_buffer));
        memset(read_buffer, 0, strlen(read_buffer));
    }
    
    
    return 0;
}
