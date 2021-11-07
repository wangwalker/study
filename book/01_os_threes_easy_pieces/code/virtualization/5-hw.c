#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <assert.h>

// 5.1
// int
// main(int argc, char *argv[]) {
//     int t = 10;
//     printf("before fork (variable = %d)\n", t);
//     int rc = fork();
//     if (rc < 0) // fork failed
//     {
//         fprintf(stderr, "fork failed\n");
//         exit(1);
//     }
//     else if (rc == 0) // child process
//     {
//         // t = 11;
//         printf("child process (variable = %d)\n", t);
//     }
//     else
//     {
//         // t = 12;
//         printf("parent process (variable = %d)\n", t);
//     }
//     return 0;
// }

// 5.2
int
main(int argc, char *argv[]) {
    int fd = open("/tmp/file", O_WRONLY | O_CREAT | O_TRUNC, S_IRWXU);
    assert(fd > -1);
    int rc = fork();
    if (rc < 0) // fork failed
    {
        fprintf(stderr, "fork failed\n");
        exit(1);
    }
    else if (rc == 0) // child process
    {
        int rc = write(fd, "child process", 20);
        printf("child process (rc = %d)\n", rc);
    }
    else
    {
        int rc = write(fd, "parent process", 30);
        printf("parent process (rc = %d)\n", rc);
    }
    return 0;
}