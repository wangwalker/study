### Architecture

- [iOS系统架构层次结构](https://github.com/Walkerant/Study/tree/master/ios/md/architecture.md) 从上到下四层结构：交互层Cocoa Touch、媒体层Media、核心服务层Core Services、操作系统层Core OS。

### Fundation

- [集合类使用指南](https://github.com/Walkerant/Study/tree/master/ios/md/collection.md) NSArray、NSDictionary和NSSet的排序、查找、枚举操作等。

- [并发编程实践](https://github.com/Walkerant/Study/tree/master/ios/md/concurrent.md) NSThread、NSOperation、GCD的使用方法和代码片段，以及线程同步机制，尤其强大的GCD，比如分组任务、信号量等。

- [Block：OC的闭包](https://github.com/Walkerant/Study/tree/master/ios/md/block.md) Block的数据结构、三种类型，常见的声明、使用方式，以及`__block`和循环引用问题。

- [RunLoop：任务调度机制](https://github.com/Walkerant/Study/tree/master/ios/md/runloop.md) 也可称为事件循环EventLoop，是很多服务得以被调度的基础，比如GCD、线程、NSTimer、UIEvent等。

- [Runtime：强大的运行时系统](https://github.com/Walkerant/Study/tree/master/ios/md/runtime.md) Runtime的原理、数据结构、公开接口，消息发送、动态解析和转发，以及Method Swizzling和使用场景。

- [KVO和KVC：灵活的键值特性](https://github.com/Walkerant/Study/tree/master/ios/md/kvo-kvc.md) KVO可有效实现解耦，三个步骤：注册、处理、移除；KVC让对象扁平化，集合类的聚合操作很方便。

### Media

- [Quartz 2D绘图引擎](https://github.com/Walkerant/Study/tree/master/ios/md/quartz.md) 也叫Core Graphics，绘图上下文，颜色空间，路径：直线、曲线、子路径，放射变换，渐变，模式，透明图层等。
- [Core Image：图片处理](https://github.com/Walkerant/Study/tree/master/ios/md/core-image.md) 滤镜概念、创建滤镜、处理流程，内置滤镜分类，滤镜链，人脸检测，提高性能的注意点等。
- [Core Animation：动画](https://github.com/Walkerant/Study/tree/master/ios/md/core-animation.md) UIView VS CALayer，CALayer可动画属性、图层结构模型，CABasicAnimation、CAKeyFrameAnimation、CAAnimationGroup等。
- [FFmpeg基本介绍](https://github.com/Walkerant/Study/tree/master/ios/md/avf-ffmpeg.md) 项目介绍、基本结构、命令行使用方法，核心模块、核心数据结构定义和基本使用方式。
- [视频编码基本知识](https://github.com/Walkerant/Study/tree/master/ios/md/video-basic.md) 基本概念：码率、帧率；颜色空间：RGB，YUV的多种形式以及存储方式；编码原理：帧内预测、帧间预测、DCT；四种冗余：空间、时间、视觉、信息熵；H264码流结构：I、P、B帧，NALU等。

### Application

- [APP启动流程及优化](https://github.com/Walkerant/Study/tree/master/ios/md/launch.md) 三个启动流程，以及相应的优化方法。

- [APP版本升级相关问题](https://github.com/Walkerant/Study/tree/master/ios/md/version.md) 高版本的新特性，以及相关兼容处理方法。

### Swift

- [版本迭代及基础知识](https://github.com/Walkerant/Study/tree/master/ios/md/swift-overview.md) 大版本之间的特性演变，和Objective-C之间的区别，编译，基本类型，运算符，遍历方法

- [一些高级特性](https://github.com/Walkerant/Study/tree/master/ios/md/swift-advanced.md) 函数的实参、形参、类型，闭包语法、类型、捕获值、逃逸闭包、自动闭包，面向对象，值类型和引用类型，属性、方法，初始化过程

### QA

- [问题集合-1](https://github.com/Walkerant/Study/tree/master/ios/md/qa-1.md) presentViewController相关问题等。