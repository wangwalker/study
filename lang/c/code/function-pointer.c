#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

// pointer function
int *func1(int a, int b);
int f_func2(void);

// function pointers
int (*func2)(void);


int main(int argc, char *argv[]) {
    printf("function pointer vs pointer function\n");
    int *c;
    int d;

    c = func1(1, 2);
    func2 = &f_func2;
    d = (*func2)();
    printf("pointer function func1's answer is (*c = %d at %p)\n", *c, c);
    printf("function pointer func2's answer is (d = %d)\n", d);
    return 0;
}


int *func1(int a, int b) {
    printf("this is inside a pointer function\n");
    int *c;
    c = malloc(sizeof(int));
    *c = a + b;
    return c;
}

int f_func2() {
    printf("this is inside a function pointer\n");
    return 8;
}
