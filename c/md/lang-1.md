关于C语言的一些疑难问题。

###### 1、函数指针（function pointer）和指针函数（pointer function）之间的区别

首先从语义上理解，函数指针是一个指针（指向函数内存的首地址），是一个变量variable，而指针函数是一个函数，函数的返回值是一个指针。
然后，在定义方式和使用方式上，它们之间有极大的差异。定义一个函数指针需要把指针符号`*`和函数名用括号括起来，在使用的时候要加上`()`，才能真正调用函数；指针函数则只需要在函数名之前加上指针符号`*`即可。
最后，通过代码演示如下。

```c
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

// 指针函数
int *func1(int a, int b);
// 正常函数
int f_func2(void);
// 函数指针
int (*func2)(void);


int main(int argc, char *argv[]) {
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
```

```bash
this is inside a pointer function
this is inside a function pointer
pointer function func1's answer is (*c = 3 at 0x127e06770)
function pointer func2's answer is (d = 8)
```

