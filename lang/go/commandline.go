package main

import (
	// 需在此处添加代码。[1]
	"flag"
	"fmt"
)

var name1 string

// flag.String，直接返回一个分配好的用于存储命令参数的地址，是一个pointer
var name2 = flag.String("name2", "Smith", "user name")

func init() {
	// 需在此处添加代码。[2]
	// flag.StringVar函数接收四个参数
	// 第一个是用来保存命令参数值得地址，第二个是命令参数的名称，第三个为默认值，第四个为简短说明
	flag.StringVar(&name1, "name1", "Walker", "get name from command line.")
}

func main() {
	// flag.Parse()，真正解析命令参数，并把他们的值赋给相应的变量
	flag.Parse()
	fmt.Printf("Hello, %s and %s!\n", name1, *name2)

	// flag.Args()返回所有的命令参数
	fmt.Printf("all flags are: %s", flag.Args())
}
