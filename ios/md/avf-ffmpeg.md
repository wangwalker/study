### FFmpeg简介

##### 项目

###### 简介

FFmpeg是一套免费、开源的综合性跨平台音视频解决方案，是用C语言开发的。它能实现的功能包括：音视频播放、剪辑、编解码、格式转换、特效处理等。业界很多项目或产品都用到了FFmpeg，比如：YouTube、KMPlayer、Mplayer、暴风影音、格式工厂等。

###### 作者

法布里斯贝拉（FabriceBellard）有着“天才程序员”之称，因为FFmpeg、QEMU等项目而闻名于业界。同时，他凭着极其深厚的计算机底层功力编写出了多款编译器和虚拟机，并靠着出色的数学知识提出了最快圆周率算法贝拉公式。

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

###### 相关

- FFmpeg 官网 : http://ffmpeg.org/download.html
- FFmpeg 源码 : https://github.com/FFmpeg/FFmpeg
- FFmpeg doc : http://www.ffmpeg.org/documentation.html
- FFmpeg wiki : https://trac.ffmpeg.org/wiki

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

##### 工作流程

用命令行工具ffmpeg能够实现音视频的转码，比如将MP4格式转换为AVI格式，通过下面的语法即可实现：

```bash
ffmpeg -i input.mp4 output.avi
```

执行这条命令之后，即可将input.mp4转换为output.avi。整个工作会经过下面这些流程：

```bash
 _______              ______________
|       |            |              |
| input |  demuxer   | encoded data |   decoder
| file  | ---------> | packets      | -----+
|_______|            |______________|      |
                                           v
                                       _________
                                      |         |
                                      | decoded |
                                      | frames  |
                                      |_________|
 ________             ______________       |
|        |           |              |      |
| output | <-------- | encoded data | <----+
| file   |   muxer   | packets      |   encoder
|________|           |______________|

```

### 常用命令

FFmpeg常用的命令包括这几类：

- 基本信息查询
- 分解、复用
- 处理原始数据
- 滤镜
- 切割与合并
- 图片-视频互转
- 直播相关

##### 基本信息查询

基本信息查询是通过`ffmpeg -some_commands`来获取FFmpeg都支持哪些能力，比如哪些编解码器、解复用器、网络协议、滤波器等。

| 参数         | 说明                             |
| :----------- | :------------------------------- |
| -version     | 显示版本                         |
| -demuxers    | 显示可用的demuxers               |
| -muxers      | 显示可用的muxers                 |
| -devices     | 显示可用的设备                   |
| -codecs      | 显示libavcodec已知的所有编解码器 |
| -decoders    | 显示可用的解码器                 |
| -encoders    | 显示所有可用的编码器             |
| -protocols   | 显示可用的协议                   |
| -filters     | 显示可用的libavfilter过滤器      |
| -pix_fmts    | 显示可用的像素格式               |
| -sample_fmts | 显示可用的采样格式               |
| -colors      | 显示识别的颜色名称               |

下面是一些示例。

```bash
# Mac上可用的设备
walkerwang@macbook ~ % ffmpeg -devices
Devices:
 D. = Demuxing supported
 .E = Muxing supported
 --
  E audiotoolbox    AudioToolbox output device
 D  avfoundation    AVFoundation input device
 D  lavfi           Libavfilter virtual input device
  E sdl,sdl2        SDL2 output device
 D  x11grab         X11 screen capture, using XCB
# 支持的编解码器
walkerwang@macbook ~ % ffmpeg -codecs
Codecs:
 D..... = Decoding supported
 .E.... = Encoding supported
 ..V... = Video codec
 ..A... = Audio codec
 ..S... = Subtitle codec
 ...I.. = Intra frame-only codec
 ....L. = Lossy compression
 .....S = Lossless compression
 -------
 D.VI.S 012v                 Uncompressed 4:2:2 10-bit
 D.V.L. 4xm                  4X Movie
 D.VI.S 8bps                 QuickTime 8BPS video
 .EVIL. a64_multi            Multicolor charset for Commodore 64 (encoders: a64multi )
 .EVIL. a64_multi5           Multicolor charset for Commodore 64, extended with 5th color (colram) (encoders: a64multi5 )
 D.V..S aasc                 Autodesk RLE
 D.V.L. agm                  Amuse Graphics Movie
 D.VIL. aic                  Apple Intermediate Codec
 DEVI.S alias_pix            Alias/Wavefront PIX image
 D.V.L. av1                  Alliance for Open Media AV1
 D.V... avrn                 Avid AVI Codec
 DEVI.S avrp                 Avid 1:1 10-bit RGB Packer
 D.V.L. avs                  AVS (Audio Video Standard) video
 ...
```

##### 命令基本格式

FFmpeg命令行操作的基本格式如下：

```bash
ffmpeg [global_options] {[input_file_options] -i input_url} ... {[output_file_options] output_url} ...
```

在FFmpeg命令行操作中，用`-i`指定输入媒体流，可以是本地文件、网络文件、管道，甚至可以为抓取设备。

**主要参数**

| 参数                         | 说明                                                         |
| :--------------------------- | :----------------------------------------------------------- |
| -f fmt                       | 输入或输出文件格式。 格式通常是自动检测，所以大多数情况下不需要指定 |
| -i url                       | 输入文件的URI，可以是本地文件、网络媒体流、管道等            |
| -c [:stream_specifier] codec | 为一个或多个流指定编解码器，codec 是编解码器的名称或 copy表示原始编解码器<br />比如：`ffmpeg -i INPUT.mp4 -map 0 -c:v h264 -c:a copy OUTPUT.h264` |
| -t duration                  | 当用在`-i`之前时，表示从输入文件读取的数据时长<br />当用作输出选项时（在输出url之前），表示持续多长时间之后停止输出 |
| -ss hh:mm:ss                 | 当用在`-i`之前时，表示在这个输入文件中寻找位置。<br />当用在输出选项（在输出url之前）时，解码但丢弃输入，直到时间戳到达此位置 |
| -b[:a/v]                     | 比特率，音频用a，视频用v                                     |

**视频参数**

| 参数                        | 说明                                                         |
| :-------------------------- | :----------------------------------------------------------- |
| -vframes num                | 指定要输出的视频帧的数量                                     |
| -r [:stream_specifier] fps  | 指定帧率                                                     |
| -s [:stream_specifier]      | 指定视频窗口大小                                             |
| -aspect [:stream_specifier] | 指定视频显示宽高比。可以是浮点数字符串，也可以是num：den形式的字符串<br />例如：“4：3”，“16：9”，“1.3333”和“1.7777”都是有效的参数值 |
| -vn                         | 禁用视频录制 = video no                                      |
| -vcodec                     | 指定视频编解码器，是`-codec：v`的别名                        |
| -vf filtergraph             | 创建由filtergraph指定的过滤器图，并使用它来过滤流            |

**音频参数**

| 参数                                        | 说明                                                         |
| :------------------------------------------ | :----------------------------------------------------------- |
| -aframes                                    | 指定要输出的音频帧的数量                                     |
| -ar [：stream_specifier] freq               | 指定音频采样频率，输出流默认设置为相应输入流的频率，输入流仅适用于音频捕获设备和原始分路器，并映射到相应的分路器选件 |
| -ac [：stream_specifier]                    | 指定音频通道的数量。输出流默认设置为输入音频通道的数量，输入流此选项仅适用于音频捕获设备和原始分路器，并映射到相应的分路器选件 |
| -an                                         | 禁用录音 = audio no                                          |
| -acodec                                     | 指定音频编解码器。这是`-codec:a`的别名。                     |
| -sample_fmt [：stream_specifier] sample_fmt | 指定音频采样格式，可先使用-sample_fmts获取支持的样本格式列表 |
| -af filtergraph                             | 创建由filtergraph指定的过滤器图，并使用它来过滤流            |

##### 分解和复用

**分解**是指将媒体文件中不同类型的流Stream抽取出来，比如取出MP4文件中的音频流或者视频流；**复用**正好相反，是指把不同类型的流组装为一个媒体文件，比如MP4。

```bash
# 从MP4文件中抽取音频流
ffmpeg -i input.mp4 -acodec copy -vn out.aac
# 抽取视频流
ffmpeg -i input.mp4 -vcodec copy -an out.h264
# 格式转化，比如从MP4到flv，FFmpeg会根据文件后缀判断要转化的类型
ffmpeg -i out.mp4 -vcodec copy -acodec copy out.flv
# 将一路音频流和一路视频流组装为MP4
ffmpeg -i out.h264 -i out.aac -vcodec copy -acodec copy out.mp4
```

##### 处理原始数据

视频的原始数据类型通常为YUV格式，音频的原始数据类型通常为PCM格式。

```bash
# 提取视频的YUV数据
ffmpeg -i input.mp4 -an -c:v rawvideo -pix_fmt yuv420p out.yuv
ffplay -s wxh out.yuv
# YUV转H264
ffmpeg -f rawvideo -pix_fmt yuv420p -s 320x240 -r 30 -i out.yuv -c:v libx264 -f rawvideo out.h264
# 提取音频的PCM数据
ffmpeg -i out.mp4 -vn -ar 44100 -ac 2 -f s16le out.pcm
ffplay -ar 44100 -ac 2 -f s16le -i out.pcm
```

- -c:v rawvideo 指定将视频转成原始数据
- -pix_fmt yuv420p 指定转换格式为yuv420p

##### 滤镜

在音视频编码之前，可以对原始数据进行某种变换操作，从而得到新的数据，通常这种变换操作就是滤镜，比如最简单的缩放、剪裁、倍速等等。FFmpeg中的`avfilter`模块专门用来处理滤镜相关操作，不管是音频还是视频，FFmpeg都内置了大量可直接使用的滤镜。

这是FFmpeg中所有的内置滤镜：

- **音频**
  abench, acompressor, acontrast, acopy, acue, acrossfade, acrossover, acrusher, adeclick, adeclip, adecorrelate, adelay, adenorm, aderivative, aecho, aemphasis, aeval, aexciter, afade, afftdn, afftfilt, afir, aformat, afreqshift, afwtdn, agate, aiir, aintegral, ainterleave, alatency, alimiter, allpass, aloop, amerge, ametadata, amix, amultiply, anequalizer, anlmdn, anlms, anull, apad, aperms, aphaser, aphaseshift, apsyclip, apulsator, arealtime, aresample, areverse, arnndn, asdr, asegment, aselect, asendcmd, asetnsamples, asetpts, asetrate, asettb, ashowinfo, asidedata, asoftclip, asplit, astats, astreamselect, asubboost, asubcut, asupercut, asuperpass, asuperstop, atempo, atilt, atrim, axcorrelate, bandpass, bandreject, bass, biquad, channelmap, channelsplit, chorus, compand, compensationdelay, crossfeed, crystalizer, dcshift, deesser, drmeter, dynaudnorm, earwax, ebur128, equalizer, extrastereo, firequalizer, flanger, haas, hdcd, headphone, highpass, highshelf, join, loudnorm, lowpass, lowshelf, mcompand, pan, replaygain, sidechaincompress, sidechaingate, silencedetect, silenceremove, speechnorm, stereotools, stereowiden, superequalizer, surround, treble, tremolo, vibrato, volume, volumedetect, aevalsrc, afirsrc, anoisesrc, anullsrc, hilbert, sinc, sine, anullsink
- **视频**
  addroi, alphaextract, alphamerge, amplify, atadenoise, avgblur, bbox, bench, bilateral, bitplanenoise, blackdetect, blend, bm3d, bwdif, cas, chromahold, chromakey, chromanr, chromashift, ciescope, codecview, colorbalance, colorchannelmixer, colorcontrast, colorcorrect, colorize, colorkey, colorhold, colorlevels, colorspace, colortemperature, convolution, convolve, copy, coreimage, crop, cue, curves, datascope, dblur, dctdnoiz, deband, deblock, decimate, deconvolve, dedot, deflate, deflicker, dejudder, derain, deshake, despill, detelecine, dilation, displace, dnn_classify, dnn_detect, dnn_processing, doubleweave, drawbox, drawgraph, drawgrid, edgedetect, elbg, entropy, epx, erosion, estdif, exposure, extractplanes, fade, fftdnoiz, fftfilt, field, fieldhint, fieldmatch, fieldorder, fillborders, floodfill, format, fps, framepack, framerate, framestep, freezedetect, freezeframes, gblur, geq, gradfun, graphmonitor, grayworld, greyedge, guided, haldclut, hflip, histogram, hqx, hstack, hsvhold, hsvkey, hue, huesaturation, hwdownload, hwmap, hwupload, hysteresis, identity, idet, il, inflate, interleave, kirsch, lagfun, latency, lenscorrection, limitdiff, limiter, loop, lumakey, lut, lut1d, lut2, lut3d, lutrgb, lutyuv, maskedclamp, maskedmax, maskedmerge, maskedmin, maskedthreshold, maskfun, median, mergeplanes, mestimate, metadata, midequalizer, minterpolate, mix, monochrome, morpho, msad, negate, nlmeans, noformat, noise, normalize, null, oscilloscope, overlay, pad, palettegen, paletteuse, perms, photosensitivity, pixdesctest, pixscope, premultiply, prewitt, pseudocolor, psnr, qp, random, readeia608, readvitc, realtime, remap, removegrain, removelogo, reverse, rgbashift, roberts, rotate, scale, scale2ref, scdet, scharr, scroll, segment, select, selectivecolor, sendcmd, separatefields, setdar, setfield, setparams, setpts, setrange, setsar, settb, shear, showinfo, showpalette, shuffleframes, shufflepixels, shuffleplanes, sidedata, signalstats, sobel, split, sr, ssim, streamselect, swaprect, swapuv, tblend, telecine, thistogram, threshold, thumbnail, tile, tlut2, tmedian, tmidequalizer, tmix, tonemap, tpad, transpose, trim, unpremultiply, unsharp, untile, v360, varblur, vectorscope, vflip, vfrdet, vibrance, vif, vignette, vmafmotion, vstack, w3fdif, waveform, weave, xbr, xcorrelate, xfade, xmedian, xstack, yadif, yaepblur, zoompan, allrgb, allyuv, cellauto, color, colorspectrum, coreimagesrc, gradients, haldclutsrc, life, mandelbrot, nullsrc, pal75bars, pal100bars, rgbtestsrc, sierpinski, smptebars, smptehdbars, testsrc, testsrc2, yuvtestsrc, nullsink, abitscope, adrawgraph, agraphmonitor, ahistogram, aphasemeter, avectorscope, concat, showcqt, showfreqs, showspatial, showspectrum, showspectrumpic, showvolume, showwaves, showwavespic, spectrumsynth, amovie, movie, afifo, fifo, abuffer, buffer, abuffersink, buffersink

给音视频应用滤镜的过程如下：

```bash
 _________                        ______________
|         |                      |              |
| decoded |                      | encoded data |
| frames  |\                   _ | packets      |
|_________| \                  /||______________|
             \   __________   /
  simple     _\||          | /  encoder
  filtergraph   | filtered |/
                | frames   |
                |__________|
```

添加水印

```bash
ffmpeg -i vid1.mp4  -vf "movie=logo.png,scale=64:48[watermask];[in][watermask] overlay=30:10 [out]" water.mp4
```

- -vf中的 movie 指定logo位置。
- scale 指定 logo 大小
- overlay 指定 logo 摆放的坐标位置

缩放，缩小一倍

```bash
ffmpeg -i out.mp4 -vf scale=iw/2:-1 scale.mp4
```

- -vf scale 指定使用简单过滤器 
- scale=iw/2:-1 中的 iw 指定按整型取视频的宽度， -1 表示高度随宽度一起变化

剪裁

```bash
ffmpeg -i vid1.mov  -vf crop=in_w-200:in_h-200 -c:v h264 -c:a copy -video_size 1280x720 vr_new.mp4
```

格式为`crop=out_w:out_hx:x:y`

- out_w: 输出的宽度，in_w 表式输入视频的宽度
- out_h: 输出的高度， in_h 表式输入视频的高度
- x : X坐标
- y : Y坐标

**其他有意思的滤镜**

- 镜像：`crop=iw/2:ih:0:0,split[left][tmp];[tmp]hflip[right]`
- 复古：`curves=vintage;`
- 光晕：`vignette=PI/4`
- 降噪：`hqdn3d=luma_spatial=15.0`
- 锐化：`fftfilt=dc_Y=0:weight_Y='1+squish(1-(Y+X)/100)'`
- 高通滤波：`fftfilt=dc_Y=128:weight_Y='squish(1-(Y+X)/100)'`
- 边缘检测：`edgedetect`

更多更详细内容见：[音视频专家李超老师的博文](https://avdancedu.com/92d94a35/)

### 模块

##### 核心数据结构

###### 定义

- `AVFrame` 经解码器解码之后得到（未压缩）的原始音视频数据，音频为PCM，视频为YUV/RGB格式。主要字段包括：
  - 音视频共用信息
    - `data` 压缩数据，音频为channel，视频为picture
    - `extended_data` 扩展数据
    - `linesize` 一行数据的大小，为了高效要和CPU位数对齐，比如16、32
    - `format` 格式，视频为`AVPixelFormat`的一种，音频为`AVSampleFormat`的一种
    - `key_frame` 是否为关键帧，1是0非
    - `pts` 显示时间戳
    - `pkt_dts` 解码时间戳
    - `quality` 质量，1为最好，`FF_LAMBDA_MAX`最差
    - `buf` 缓冲
    - `metadata` 元数据
    - `pkt_size` packet大小
  - 视频特有
    - `width/height` 帧宽和高
    - `colorspace` 颜色空间
  - 音频特有
    - `nb_samples` 每一个channel的采样数量
    - `sample_rate` 采样率
    - `channel_layout` channel布局
    - `channels` 音频频道数
- `AVPacket` 和`AVFrame`对应，存储的是经编码之后（被压缩的）数据，音频为AAC/MP3，视频为H.264等。
  一般经过解复用器处理之后得到`AVPacket`，并交给解码器进行解码；或者通过编码器Encoder编码之后的输出也是`AVPacket`，并交给复用器组装给特定类型。
  - `buf` 缓冲
  - `pts` 显示时间戳，以AVStream->time_base为基准
  - `dts` 解码时间戳，仍然以AVStream->time_base为基准
  - `data/size` 数据及大小
- `AVFormatContext` 格式相关的基本结构体，主要用于封装格式、解封格式等。主要字段包括：
  - 基本信息
    - `iformat/oformat` 用于解复用和复用的输入输出格式
      - `AVInputFormat` 输入容器文件格式
      - `AVOutputFormat` 输出容器文件格式
    - `nb_streams` 音视频媒体流的数量，是`streams`的数量
    - `streams` 音视频媒体流列表
    - `bit_rate` 比特率
    - `packet_size` 数据包大小
    - `metadata` 元数据
  - 时间信息
    - `start_time` 开始时间
    - `duration` 持续时长
  - 编解码
    - `video_codec` 视频编解码器
    - `audio_codec` 音频编解码器
    - `subtitle_codec` 副标题编解码器
  - 行为信息
    - `io_open` 用于打开某个stream的函数指针
    - `io_close` 关闭某个stream
- `AVIOContext` 输入输出字节流相关的结构体，主要用于读写数据。主要字段包括：
  - 缓冲相关
    - `buffer` 缓冲区
    - `buffer_size` 缓冲区大小
    - `buf_ptr` 缓冲指针，主要用在写操作中
    - `buf_end` 缓冲区结束位置
  - 行为类
    - `read_packet` 读取编码之后的数据包
    - `write_packet` 写入编码之后的数据包
    - `read_pause` 在基于网络协议的流中，暂停或者恢复播放
    - `read_seek` 将当前时间设置到特定时间戳
- `AVStream` 音视频媒体流对应的结构体，处理音视频编解码。主要字段包括：
  - 基本信息
    - `index` 该stream在AVFormatContext->streams中的索引
    - `nb_frames` 流的总帧数
    - `metadata` 元数据
    - `codecpar` 编解码参数
    - `info` 内部使用的状态信息
  - 时间相关
    - `time_base` 以秒为单位的，当前在显示的时间基线
    - `start_time` 第一帧的显示时间
    - `duration` 持续时长
- `AVCodecContext` 编解码上下文，外部使用的主要API，主要字段包含：
  - 主要信息
    - `codec_type` 媒体类型
    - `codec` 具体的编解码器
    - `bit_rate` 平均比特率
    - `time_base` 基本时间单位
    - `gop_size` 图片组大小
    - `pix_fmt` 像素格式
    - `slice_count` 切片数量
    - `me_cmp` 运动估计比较函数
    - `me_sub_cmp` 亚像素运动估计函数
    - `frame_size` 帧大小
    - `hwaccel` 硬件加速器
    - `execute` 函数指针，执行一系列独立任务

`AVIOContext`中与缓冲相关的字段区别（来自官方）：

```bash
**********************************************************************************
*                                   READING
**********************************************************************************
*                            |              buffer_size              |
*                            |---------------------------------------|
*                            |                                       |
*                         buffer          buf_ptr       buf_end
*                            +---------------+-----------------------+
*                            |/ / / / / / / /|/ / / / / / /|         |
*  read buffer:              |/ / consumed / | to be read /|         |
*                            |/ / / / / / / /|/ / / / / / /|         |
*                            +---------------+-----------------------+
*                                                         pos
*              +-------------------------------------------+-----------------+
*  input file: |                                           |                 |
*              +-------------------------------------------+-----------------+
*
**********************************************************************************
*                                   WRITING
**********************************************************************************
*                             |          buffer_size                 |
*                             |--------------------------------------|
*                             |                                      |
*                                                buf_ptr_max
*                          buffer                 (buf_ptr)       buf_end
*                             +-----------------------+--------------+
*                             |/ / / / / / / / / / / /|              |
*  write buffer:              | / / to be flushed / / |              |
*                             |/ / / / / / / / / / / /|              |
*                             +-----------------------+--------------+
*                               buf_ptr can be in this
*                               due to a backward seek
*                            pos
*               +-------------+----------------------------------------------+
*  output file: |             |                                              |
*               +-------------+----------------------------------------------+
```

###### 使用方法

上面这些重要的数据结构的初始化和销毁操作如下。

| 数据结构          | 初始化                                                       | 销毁                                                         | 位置              |
| ----------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ----------------- |
| `AVFormatContext` | `avformat_alloc_context()`                                   | `avformat_free_context()`                                    | avformat.h        |
|                   | 先调用`av_malloc()`分配内存，同时为internal字段分配内存。此外，还调用了`avformat_get_context_defaults()`为字段设置默认值 | 调用了各式各样的销毁函数，比如：`av_opt_free()`、`av_freep()`、`av_dict_free()`等 |                   |
| `AVIOContext`     | `avio_alloc_context()`                                       | `avio_context_free()`                                        | avformat/avio.h   |
|                   | 先调用`av_mallocz`分配内存，然后调用`ffio_init_context()`做真正的初始化工作：为字段赋值 |                                                              |                   |
| `AVStream`        | `avformat_new_stream()`                                      |                                                              | avformat.h        |
|                   | 先调用`av_mallocz`分配内存，接着给各个字段赋默认值，然后调用`avcode_alloc_context3()`初始化`codec`字段 |                                                              |                   |
| `AVCodecContext`  | `avcodec_alloc_context3()`                                   |                                                              | avcodec.h         |
|                   | 先调用`av_mallocz`分配内存，然后调用`avcode_get_context_defaults()`为字段设置默认值 |                                                              |                   |
| `AVFrame`         | `av_frame_alloc()`<br />`av_image_fill_arrays()`             | `av_frame_free()`                                            | libavutil/frame.h |
|                   | 先调用`av_mallocz`分配内存，然后调用`get_frame_defaults()`设置默认值 | 在释放结构体之前，先调用了`av_frame_unref()`释放引用的缓存，当然还要释放其他数据 |                   |
| `AVPacket`        | `av_init_packet()`<br />`av_new_packet()`                    | `av_free_packet()`                                           | avcodec.h         |
|                   | 前者只是简单的初始化一些必要信息，后者在调用前者之后，还会进行一些内部数据的分配 | 先调用`av_buffer_unref()`释放缓存数据，还调用了`av_packet_free_side_data()`释放某些特定数据 |                   |

