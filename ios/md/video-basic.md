### 基本概念

##### 像素

视频是有一连串静态图像按照时间先后顺序显示而得来的。像素是图像的基本单元（最小单元），是一个个颜色块。

<img src="https://static001.geekbang.org/resource/image/5a/ce/5aa82584e3c3ba42e40f7265a53c91ce.jpeg?wh=2472x1034" alt="像素" style="zoom:60%;" />

##### 分辨率

分辨率是指图像的大小尺寸，即长x宽，以像素`px`为单位。

视频行业常见的分辨率有 QCIF（176x144）、CIF（352x288）、 360P（640x360）、720P（1280x720）、1080P（1920x1080）、4K（3840x2160）、8K（7680x4320）等。

一般来说，分辨率越高图像越清晰，但这对于原始图像来说是正确的，而对于经过后期优化处理之后的图像，并不是这样，可能随着分辨率的增大，反而会变得更加模糊。

##### 位深

这是针对颜色的一个属性，表示颜色空间的大小。比如对于RGB颜色空间，每一个通道占8位，即一个字节，三个通道一共能表示2^8^3=1677万种颜色。当然，如果每个通道占的位越多，那么对应的颜色值就越多，占用的空间也就越大。

##### Stride

Stride并不是图像本身的属性，而是图像存储中一个特别重要的概念，指的是**图像存储时内存中每行像素所占有的空间**。其实，这个概念是为了CPU能够快速处理数据，将每一行像素按照CPU的位数进行对齐之后得出的概念，比如按照16位补齐。

有了这个概念之后，在处理视频时要特别注意，处理不好会出现**花屏**现象。

##### 帧率

视频中显示的每一张图像称为一帧，在**1秒内显示的图像数量称之为帧率**。据研究表明，一般帧率达到 10～12 帧每秒，人眼就会认为是流畅的了。通常，电影的帧率为24fps，监控行业为25fps，现在常用的帧率还有30fps、60fps。

##### 码率

码率是指，**视频在单位时间内包含的数据量的多少**。一般是 1 秒钟内的数据量，其单位一般是 Kb/s 或者 Mb/s。通常，我们用压缩工具压缩同一个原始视频的时候，码率越高，图像的失真就会越小，视频画面就会越清晰，反之视频画面就会越模糊。当然，这还与使用的压缩算法有关，算法越高效，在同等规模的压缩效果下，视频会越清晰。

### 颜色空间

在数字世界中，常用的颜色空间包括RGB、YUV、CYMK、HSI等，其中RGB使用的最多，YUV使用在视频领域，CYMK应用在印刷行业。

##### RGB

RGB 相对比较简单。顾名思义，它指图像的每一个像素都有 R、G、B 三个值。一般来说，每个RGB颜色按照顺序以此存储，但也有可能按照别的顺序存储，比如在OpenCV中是以BGR的顺序排列的。

##### YUV

Y是Luminance的首字母，表示亮度，U和V共同表示色度。将亮度和色度分开表示的好处是，能够很好的兼容黑白图像系统，比如早期的电视机；另外，还能节省存储空间。

YUV的存储方式主要分为 YUV 4:4:4、YUV 4:2:2、YUV 4:2:0 这几种常用的类型。其中最常用的又是 YUV 4:2:0。这里的数字指的是Y、U、V值之间的比重。

- **YUV 4:4:4** 表示每一个Y对应一个U和一个V；
- **YUV 4:2:2** 表示每两个Y对应一个U和一个V；
- **YUV 4:2:0** 表示每四个Y对应一个U和一个V；

|   模式    |                             图示                             |
| :-------: | :----------------------------------------------------------: |
| YUV 4:4:4 | Y U V  \|  Y U V  \|  Y U V  <br />Y U V  \|  Y U V  \|  Y U V  <br />Y U V  \|  Y U V  \|  Y U V  <br /> |
| YUV 4:2:2 | U      \|     U      \|     U    <br />Y      Y   \|  Y      Y  \| Y     Y  <br />    V      \|      V      \|     V    <br /> |
| YUV 4:2:0 | Y      Y  \|  Y      Y  \|  Y       Y <br />   U V    \|    U V    \|     U V    <br /> Y     Y  \|  Y      Y  \|  Y       Y <br /> |

对于YUV4:4:4这种模式，存储和RGB一样，按照顺序存储就可以了，但对于其他两种，如何存储呢？这里一共有两种方式。

- **Planar**，先顺序存储所有的Y，接着是U，最后是所有的V；
- **Packed**，先顺序存储所有像素的Y，再U和V连续交替存储；

|               模式                |                             图示                             |
| :-------------------------------: | :----------------------------------------------------------: |
|         YUV 4:4:4 (I444)          | Y0 Y1 Y2 Y3 <br />Y4 Y5 Y6 Y7 <br />U0 U1 U2 U3 <br />U4 U5 U6 U7 <br />V0 V1 V2 V3 <br />V4 V5 V6 V7 <br /> |
|         YUV 4:4:4 (YV24)          | Y0 Y1 Y2 Y3 <br />Y4 Y5 Y6 Y7 <br />V0 V1 V2 V3 <br />V4 V5 V6 V7 <br />U0 U1 U2 U3 <br />U4 U5 U6 U7 <br /> |
| YUV 4:2:2 (YU16)<br />Planer格式  | Y0 Y1 Y2 Y3 <br />Y4 Y5 Y6 Y7 <br />U0 U1 U2 U3 <br />V0 V1 V2 V3 <br /> |
| YUV 4:2:2 (YV16)<br /> Planer格式 | Y0 Y1 Y2 Y3 <br />Y4 Y5 Y6 Y7 <br />V0 V1 V2 V3 <br />U0 U1 U2 U3<br /> |
| YUV 4:2:2 (NV16)<br />Packed格式  | Y0 Y1 Y2 Y3 <br />Y4 Y5 Y6 Y7 <br />U0 V0 U1 V1 <br />U2 V2 U3 V3 <br /> |
| YUV 4:2:2 (NV61)<br />Packed格式  | Y0 Y1 Y2 Y3 <br />Y4 Y5 Y6 Y7 <br />V0 U0 V1 U1 <br />V2 U2 V3 U3 <br /> |
| YUV 4:2:0 (YU12)<br />Planer格式  | Y00 Y01 Y02 Y03 <br />Y04 Y05 Y06 Y07 <br />Y08 Y09 Y10 Y11 <br />Y12 Y13 Y14 Y15 <br />U00 U01 U02 U03 <br />V00 V01 V02 V03 <br /> |
| YUV 4:2:0 (YV12)<br />Planer格式  | Y00 Y01 Y02 Y03 <br />Y04 Y05 Y06 Y07 <br />Y08 Y09 Y10 Y11 <br />Y12 Y13 Y14 Y15 <br />V00 V01 V02 V03 <br />U00 U01 U02 U03 <br /> |
| YUV 4:2:0 (NV12)<br />Packed格式  | Y00 Y01 Y02 Y03 <br />Y04 Y05 Y06 Y07 <br />Y08 Y09 Y10 Y11 <br />Y12 Y13 Y14 Y15 <br />U00 V00 U01 V01 <br />U02 V02 U03 V03 <br /> |
| YUV 4:2:0 (NV21)<br />Packed格式  | Y00 Y01 Y02 Y03 <br />Y04 Y05 Y06 Y07 <br />Y08 Y09 Y10 Y11 <br />Y12 Y13 Y14 Y15 <br />V00 U00 V01 U01 <br />V02 U02 V03 U03 <br /> |

##### RGB和YUV之间的转换

一般来说，由视频采集设备采集到的颜色都是RGB格式，要编码为视频就必须进行颜色转换。具体的转换按照相应的标准进行就可以，但标准颜色范围Color Range有关系。虽然RGB颜色空间中每个通道都有8位，2^8=256个值，但并不是所有的颜色都能取到0~255之间的任意值，有两种Color Range：

- Full Range，每个通道都可以取到0~255之间的值；
- Limited Range，每个通道只能取到16~235之间的值；

BT709 和 BT601 定义了一个 RGB 和 YUV 互转的标准规范。

![convert](https://static001.geekbang.org/resource/image/19/72/19da3510c564b590f92cf969be01d872.jpeg?wh=1920x1080)

### 编码原理

之所以要对视频进行编码，是因为视频太占空间了，以帧率为25fps、分辨率为1080P的YUV4:4:4为例，1分钟要占用1080x1920x3x25x60 = 8.7G空间，一个小时就需要大概500G。

##### 冗余

实际上，我们完全不用将所有数据都存储下来，因为视频中有很多冗余信息，例如在一段时间内，背景基本不会改变。除此之外，每张图片中的局部细节也会有很多冗余信息，比如图片中的纯色背景，大部分色值都是相同的，这也是一种冗余。图像数据中一共有四种冗余：

- **空间冗余**：空间上（相邻像素）有很多相似的部分；
- **时间冗余**：时间维度上（前后相连的帧之间）也有大量相似的部分；
- **视觉冗余**：人眼对高频信息的敏感度是小于低频信息的，高频信息就是视觉上的冗余；
- **信息熵冗余**：熵表示信息的随机程度，越随机，熵越大。上面这三种都是信息熵冗余。

在实际图像的存储中，是按照一个个块进行编码的，这个块在 H264 中叫做宏块，而在 VP9、AV1 中称之为超级块。宏块大小一般是 16x16（H264、VP8），32x32（H265、VP9），64x64（H265、VP9、AV1），128x128（AV1）这几种。

##### 编码技术

一般会通过帧内预测、帧间预测和DCT变换减少冗余，实现高效编码。

- **帧内预测**：通过算法，根据已经编码的块计算出相邻的、还未编码的块；
- **帧间预测**：和帧内预测相似，以已经编码的帧为基准（参考帧），通过遍历和搜索，找出和后面还未编码的块最相似的块，再在原始帧和预测帧之间的做差值得到**运动矢量**，这样就通过**参考帧**和**运动矢量**就可计算出后续帧。
- **DCT（离散余弦变换）**：**从空域到时域的变换**，将视觉上敏感的低频信息放在左上角，不敏感的高频信息经过处理（尽可能置零）放在其他位置。

##### 编码器比较

常见的编码标准有 H264、H265、VP8、VP9 和 AV1。目前 H264 和 VP8 是最常用的编码标准，且两者的标准非常相似。H265 和 VP9 分别是他们的下一代编码标准。AV1 是 VP9 的下一代编码标准。

H264 和 H265 是需要专利费的，而 VP8 和 VP9 是完全免费的。由于 H265 需要付高额的版权费，以谷歌为首的互联网和芯片巨头公司组织了 AOM 联盟，开发了新一代压缩编码算法 AV1，并宣布完全免费，以此来对抗高额专利费的 H265。

目前使用 H264 最多，而 H265 因为专利费使用得比较少。VP8 是 WebRTC 默认的编码标准，因此 WebRTC 使用 VP8 最多。同时，WebRTC 也支持 VP9 和 AV1，YouTube 使用了 VP9 和 AV1，Netflix 也使用了 AV1。

| 编码标准 | 块大小                                                    | 帧内编码                                             | 帧间编码                                 | 变换                                               | 熵编码         | 滤波后处理               |
| :------: | --------------------------------------------------------- | ---------------------------------------------------- | ---------------------------------------- | -------------------------------------------------- | -------------- | ------------------------ |
|   H264   | 最大16x16<br />可划分为8x16、16x6<br />8x8、4x8、8x4、4x4 | 8个方向<br />Planer、DC                              | 中值MVP                                  | DCT4x4/8x8                                         | CAVLC、CABAC   | 去块滤波                 |
|   H265   | 最大支持64x64<br />四叉树划分                             | 33个方向<br />Planer、DC                             | Merge模式<br />AMVP模式                  | DCT4x4/8/16/32x32<br />DST4x4                      | CABAC          | 去块滤波                 |
|   AV1    | 最大支持128x128<br />四叉树划分                           | 56个方向<br />3个平滑模式<br />递归FilterIntra模式等 | OBMC<br />扭曲运动补偿<br />复合帧内预测 | 4x4~64x64、1:2/2:1<br />1:4/4:1矩形DCT/ADST/IDTX等 | 多符号算数编码 | 去块滤波、CDEF、LR滤波等 |

### 帧内预测

帧内预测会根据块的大小分为不同的预测模式，另外，亮度块和色度块会分开进行。

##### 4x4子块

4x4 亮度块的帧内预测模式总共有9种。其中有8种方向模式和一种 DC 模式，且方向模式指预测是有方向角度的。

- **Vertical模**：当前编码亮度块的每一列的像素值，都是复制上边已经编码块的最下面那一行的对应位置的像素值。
- **Horizontal**：当前编码亮度块的每一行的像素值，都是复制左边已经编码块的最右边那一列的对应位置的像素值。
- **DC模式**：当前编码亮度块的每一个像素值，是上边已经编码块的最下面那一行和左边已编码块右边最后一列的所有像素值的平均值。
- **Diagonal Down-Left**：是上边块和右上块（上边块和右上块有可能是一个块，因为可能是一个 16 x 16 的亮度块）的像素通过插值得到。如果上边块和右上块不存在则该模式无效。
- **Vertical-Right**：通过上边块、左边块以及左上角对角的像素插值得到的。
- **Horizontal-Down**：通过上边块、左边块以及左上角对角的像素插值得到。必须要这三个都有效才能使用，否则该模式无效。
- **Vertical-Left**：通过上边块和右上块（上边块和右上块有可能是一个块，因为可能是一个 16 x 16 的亮度块）最下面一行的像素通过插值得到。
- **Horizontal-Up**：通过左边块的像素通过插值得到的。

##### 8x8/16x16子块

16 x 16 亮度块总共有4种预测模式，分别是Vertical模式，Horizontal模式、DC 模式和Plane 模式，前面三种模式跟 4 x 4 的原理是一样的，Plane 预测块的每一个像素值，都是将上边已编码块的最下面那一行，和左边已编码块右边最后一列的像素值经过复杂计算得来的。

![816](https://static001.geekbang.org/resource/image/e3/e6/e303d85a11dced7978cedea604f001e6.png?wh=1920x872)

![816](https://static001.geekbang.org/resource/image/b0/24/b09910c6bc61b97924a52dcd89c04824.png?wh=1920x885)

##### 模式选择

既然有这么多的预测方法，那么到底该选择哪一个呢？

其实，选择的标准就一条：**先通过所有方法预测，得到结果之后和真实值比较得出残差值，然后用某种标准得出当前块残差值最小的哪一个**。主要有三种方案：

- 第一种方案，先对每一种预测模式的残差块的像素值求绝对值再求和，称之为 cost，然后取其中残差块绝对值之和也就是 cost 最小的预测模式。
- 第二种方案，对残差块先进行 Hadamard 变换，变换到频域之后再求绝对值求和，同样称为 cost，然后取 cost 最小的预测模式。
- 第三种方案，对残差块直接进行 DCT 变换量化熵编码，计算得到失真大小和编码后的码流大小，然后通过率失真优化的方法来选择最优预测模式。

### 帧间预测

##### 参考帧

在帧间预测中，**会在已经编码的帧里面找到一个块来作为预测块**，这个已经编码的帧称之为参考帧。在 H264 标准中，P 帧最多支持从 16 个参考帧中选出一个作为编码块的参考帧，但是同一个帧中的不同块可以选择不同的参考帧，这就是多参考。

通常在 RTC 场景中，比如 WebRTC 中，P 帧中的所有块都参考同一个参考帧。并且一般会选择当前编码帧的前一帧来作为参考帧。

参考帧内的块和待预测块之间的差值，称之为**运动矢量**，解码器解析出运动矢量，通过参考帧和残差值就可以得到真实图像。

##### 运动搜索

简单来说，运动搜索算法就是通过**在参考帧中遍历一定范围内的块，找出和实际图像差异（残差值）最小的块的方法**。为了更快的找出最理想的子块，扫描的范围只在一个特点区域内，主要是两种：

- **钻石**搜索算法：以一个菱形的模式去寻找最优预测块。
- **六边形**搜索算法：六边形搜索跟钻石搜索差不多，只是搜索模式是六边形的。

##### 亚像素插值

实际上，很少有运动矢量正好是整数个像素的，很多都带有小数。为了解决这种问题，需要通过亚像素插值来解决。

简单来说，亚像素插值就是通过对已有的像素进行加权计算得到粒度更小的像素值，1/4像素又可以通过亚像素和整像素之间插值来得到。

##### 运动矢量预测

其实，运动矢量跟编码块一样不是直接编码进去的，而是先用周围相邻块的运动矢量预测一个预测运动矢量，称为 MVP。将当前运动矢量与 MVP 的残差称之为 MVD，然后编码到码流中去的。解码端使用同样的运动矢量预测算法得到 MVP，并从码流中解码出运动矢量残差 MVD，**MVP+MVD 就是运动矢量了**。

##### SKIP模式

如果运动矢量就是 MVP，也就是说 MVD 为 (0，0)，同时，残差块经过变换量化后系数也都是等于 0，那么当前编码块的模式就是 SKIP。

其实SKIP模式只是一种特例，但这种模式压缩率非常高，非常节省码率，很高效。

##### 预测模式选择

编码块帧间模式的选择其实就是**参考帧的选择、运动矢量的确定，以及块大小**（也就是块划分的方式）的选择，如果 SKIP 单独拿出来算的话就再加上一个判断是不是 SKIP 模式。

如果涉及多参考的话，编码块在选择参考帧的时候只需要遍历每一个参考帧进行块划分，然后再对每一个块进行运动搜索得到运动矢量就可以了。

### H264码流结构

在所有的编码标准中，H264是使用最多，也最经典的一种，通过分析它的二进制数据流来理解视频数据的组织方式。

##### 帧类型

在 H264 中，帧类型主要分为 3 大类，分别是**I 帧、P 帧和 B 帧**。

简单来说，I帧是一张完整的图片，它不需要任何参考，这里I是Intra-coded picture的意思；P需要参考前面紧接着的第一个I帧，P是Predicted的意识；B帧需要参考紧接着的前一个I帧和后一个P帧，B是Bi-directional Predicted的意思。

| 类型 | 预测方式          | 参考帧             | 描述                                       |
| ---- | ----------------- | ------------------ | ------------------------------------------ |
| I帧  | 帧内预测          | 无                 | 可独立编解码，压缩率小                     |
| P帧  | 帧内预测+帧间预测 | 参考前面的I帧和P帧 | 压缩率高，要参考其他帧才能完成编解码       |
| B帧  | 帧内预测+帧间预测 | 参考前面的I帧和P帧 | 压缩率最高，需要缓存帧，延时高，实时性不好 |

![Frame type](https://static001.geekbang.org/resource/image/ab/4c/ab75b04921d925f567a92796c992e54c.jpeg?wh=1920x376)

很明显，P帧和B帧由于要参考其他帧，如果被参考的帧出现错误，这些错误就会不断传递，为了解决这种问题，还有一种特殊的**IDR（Instantanous Decoder Refresh）帧**，也叫立即刷新帧。

H264 编码标准中规定，IDR 帧之后的帧不能再参考 IDR 帧之前的帧，这样就解决了错误不断传递的问题。所以，在对实时性要求高的场景，比如直播中，很少使用这种普通的I帧，反而使用IDR帧较多。

##### GOP

GOP是Group of Pictures的简称，即图片组。表示从一个 IDR 帧开始到下一个 IDR 帧的前一帧为止，这里面包含的 IDR 帧、普通 I 帧、P 帧和 B 帧。

 GOP 的大小是由 IDR 帧之间的间隔来确定的，而这个间隔有一个重要的概念来表示，叫做**关键帧间隔**。关键帧间隔越大，两个 IDR 相隔就会越远，GOP 也就越大；关键帧间隔越小，IDR 相隔也就越近，GOP 就越小。

GOP 越大，编码的 I 帧就会越少。相比而言，P 帧、B 帧的压缩率更高，因此整个视频的编码效率就会越高。但是 GOP 太大，也会导致 IDR 帧距离太大，点播场景时进行视频的 seek 操作就会不方便。所以，GOP应该合理选择，以适应实际使用场景。

##### Slice

Slice 其实是为了并行编码而设计的。为了高效编解码，可以将一帧图像划分成几个 Slice，这样当Slice之间相互独立、互不依赖时，独立编码就称为可能。

在 H264 中编码的基本单元是宏块，所以一个 Slice 又包含整数个宏块。宏块MB（Macro Block）一般为16x16，在做帧内和帧间预测时，又可以将宏块继续划分成不同大小的子块，用来给复杂区域做精细化编码。

总结来说，**图像内的层次结构就是一帧图像可以划分成一个或多个 Slice，而一个 Slice 包含多个宏块，且一个宏块又可以划分成多个不同尺寸的子块。**

![structure](https://static001.geekbang.org/resource/image/63/16/63f316bf5d1410cdb38334ba7bc9f316.jpg?wh=1280x720)

##### 码流格式

**H264 码流有两种格式：一种是 Annex B格式；一种是 MP4 格式**，它们之间的区别在于前者会使用一个起始码表示数据的开始，而后者会在起始处使用一个4字节的长度字段表示数据的长度。

- Annex B格式：起始码有两种，一种是 4 字节的“00 00 00 01”，一种是 3 字节的“00 00 01”。为了区分原本就是“00 00 00 01”和“00 00 01”的数据，做如下修改：
  - 1）“00 00 00”修改为“00 00 03 00”；
  - 2）“00 00 01”修改为“00 00 03 01”；
  - 3）“00 00 02”修改为“00 00 03 02”；
  - 4）“00 00 03”修改为“00 00 03 03”。
- MP4格式：在图像编码数据的开始使用了 4 个字节作为长度标识，用来表示编码数据的长度，读完这些长度的字节之后，即为下一个数据单元。

##### NALU

**NALU（Network Abstract Layer Unit）网络抽象层单元**，是对码流结构中所有单元的统一定义。

在视频码流中，除了前面介绍的三种帧类型I帧、P帧、B帧，Slice之外，还有两个基本单元SPS（Sequence Parameter Set）和PPS（Picture Parameter Set），前者用来定义图像的宽高、YUV格式、位深等基本信息，后者用于存储熵编码类型、基础 QP 和最大参考帧数量等基本编码信息，这些基本数据是实现编解码的重要支撑。

所以，H264 的码流主要是由 SPS、PPS、I Slice、P Slice和B Slice 组成的。而NALU就是用来区分不同类型数据的数据结构。每一个 NALU 又都是由一个 1 字节的 NALU Header 和若干字节的 NALU Data 组成的。而对于每一个  NALU Data， 又是由 Slice Header 和 Slice Data 组成，并且 Slice Data 又是由一个个 MB Data 组成。

![NALU](https://static001.geekbang.org/resource/image/df/c0/df6fdacccd55c66d8495cc7c113489c0.jpg?wh=1280x720)

NALU按照是否含有视觉信息，可分为两类VCL（Video Coding Layer）和non-VCL。

- VCL（Video Coding Layer）含有实际的视觉信息
  - 1 Coded slice of a non-IDR picture
  - 2 Coded slice data partition A
  - 3 Coded slice data partition B
  - 4 Coded slice data partition C
  - 5 Coded slice of an IDR picture
- non-VCL 只含有元数据
  - 0 Unspecified non-VCL
  - 6 Supplemental enhancement information (SEI)
  - 7 Sequence parameter set
  - 8 Picture parameter set
  - 9 Access unit delimiter
  - 10 End of sequence
  - 11 End of stream
  - 12 Filler data
  - 13 Sequence parameter set extension
  - 14 Prefix NAL unit
  - 15 Subset sequence parameter set
  - 16 Depth parameter set
  - 17..18 Reserved
  - 19 Coded slice of an auxiliary coded picture without partitioning
  - 20 Coded slice extension
  - 21 Coded slice extension for depth view components
  - 22..23 Reserved non-VCL 24..31 Unspecified