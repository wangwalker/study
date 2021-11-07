#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <assert.h>

int done = 0;
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t c = PTHREAD_COND_INITIALIZER;

 void thr_exit() {
     int rc;
     rc = pthread_mutex_lock(&m); assert(rc == 0);     
     done = 1;
     rc = pthread_cond_signal(&c); assert(rc == 0);
     rc = pthread_mutex_unlock(&m); assert(rc == 0);
 }

 void *child(void *arg) {
     printf("child\n");
     thr_exit();
     return NULL;
 }

 void thr_join() {
     int rc;
     rc = pthread_mutex_lock(&m); assert(rc == 0);
     while (done == 0)
     {
         rc = pthread_cond_wait(&c, &m); assert(rc == 0);
     }
     rc = pthread_mutex_unlock(&m);
     
 }

 int
 main(int argc, char *argv[]) {
     printf("parent begin\n");
     pthread_t p;
     int rc;
     rc = pthread_create(&p, NULL, child, NULL); assert(rc == 0);
     thr_join();
     printf("parent end\n");
     return 0;
 }