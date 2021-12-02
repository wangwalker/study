### FFmpeg简介

##### 项目

###### 简介

FFmpeg是一套免费、开源的综合性跨平台音视频解决方案，是用C语言开发的。它能实现的功能包括：音视频播放、剪辑、编解码、格式转换、特效处理等。业界很多项目或产品都用到了FFmpeg，比如：YouTube、KMPlayer、Mplayer、暴风影音、格式工厂等。

###### 组成

- 结构
  - ffmpeg：命令行工具，实现视频转换、查询等常见操作。
  - ffserver：http媒体流服务器。
  - ffplay：播放器，使用ffmpeg库解码，通过SDL显示。
  - ffprobe：查询视频元数据的工具。
- 组件
  - libavutil：公用工具函数，比如算数运算，字符操作。
  - libavcodec：音视频编解码核心库。
  - libavdevice：各种设备的输入输出，比如Video4Linux2, VfW, DShow以及 ALSA。
  - libavfilter：音视频滤镜特效处理。
  - libswscale：实现视频缩放、颜色转换。
  - libavswresample：音频重采样，格式转换和混音
  - libavformat：I/O操作和封装格式(muxer/demuxer)处理。

###### 相关信息

- FFmpeg 官网 : http://ffmpeg.org/download.html
- FFmpeg 源码 : https://github.com/FFmpeg/FFmpeg
- FFmpeg doc : http://www.ffmpeg.org/documentation.html
- FFmpeg wiki : https://trac.ffmpeg.org/wiki

##### 作者

法布里斯贝拉（FabriceBellard）有着“天才程序员”之称，因为FFmpeg、QEMU等项目而闻名于业界。同时，他凭着极其深厚的计算机底层功力编写出了多款编译器和虚拟机，并靠着出色的数学知识提出了最快圆周率算法贝拉公式。

##### 基本配置

通过GitHub上的开源项目[FFmpeg-iOS-build-script](https://github.com/kewlbear/FFmpeg-iOS-build-script)可通过源码编译出针对特定硬件平台的静态代码库，实现特定功能。

另外，要将上面编译好的静态代码库集成到iOS项目中，同时要在项目中导入这些依赖库文件：

- libz.tbd
- libbz2.tbd
- libiconv.tbd
- CoreMedia.framework
- VideoToolbox.framework
- AVFoundation.framework

然后，将编译好的头文件(include目录中)和静态库(lib目录中)，导入项目工作目录中，并设置 Header Search Paths 路径，指向 项目中include目录，即可完成基础工作。



