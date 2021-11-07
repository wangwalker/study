#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int
main(int argc, char *argv[]) {
    printf("Hello world (pid:%d)\n", (int) getpid());
    // fork()是OS提供的创建（新）子进程的方法，新创建的进程几乎和当前调用进程一样，除了有自己的地址空间、寄存器、PC等。
    // 子进程会执行创建它的代码之后的代码，它和父进程都会从fork()系统调用中返回。
    int rc = fork();
    if (rc < 0) // fork failed
    {
        fprintf(stderr, "fork failed\n");
        exit(1);
    }
    else if (rc == 0) // child process
    {
        printf("hello, I am child (pid:%d)\n", (int) getpid());
    }
    else
    {
        printf("Hello, I am parent of %d (pid:%d)\n", rc, (int) getpid());
    }
    return 0;
}