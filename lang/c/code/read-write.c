#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BUFFERSIZE 4096

int main(int argc, char * argv[]) {
    int n;
    char buf[BUFFERSIZE];
    
    while((n = read(0, buf, BUFFERSIZE)) > 0) {
         if (write(1, buf, n) != n) {
             printf("write error\n");
	}
    if (n < 0) printf("read error\n");
    }

   exit(0);
}
