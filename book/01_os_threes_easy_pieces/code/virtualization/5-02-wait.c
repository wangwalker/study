#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int
main(int argc, char *argv[]) {
    printf("Hello world (pid:%d)\n", (int) getpid());
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
        // 在父进程中调用wait()，可以延迟自己的执行，直到子进程执行完毕。
        // 这样，不管CPU的调度策略如何，都能保证子进程先执行，父进程后执行。
        int wc = wait(NULL);
        printf("Hello, I am parent of %d (wc: %d) (pid:%d)\n", rc, wc, (int) getpid());
    }
    return 0;
}