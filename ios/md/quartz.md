# 简介
Core Graphics也叫Quartz 2D，是为Apple为不同设备提供的统一性、轻量级的二维绘图引擎，包括iOS、iPadOS、macOS和tvOS。Quartz 2D虽然是用C语言写的，但用起来并不麻烦，而且功能强大，包含的功能有：

- 绘图上下文
- 颜色及颜色空间管理
- 绘制路径，比如贝塞尔曲线
- 图形变换
- 阴影和渐变
- 离屏渲染
- PDF相关

除此之外，Quartz 2D还可以与其他图像处理框架一起工作，比如Core Image、Core Video、OpenGL（目前为Metal）等。

## 绘画上下文

绘图上下文drawing context是所有绘图操作发生的地方，比如位图、PDF、视图、窗口、图层等。对于每一种绘图上下文，里面都会封装进去所有相关信息，比如颜色、分辨率、字体、颜色空间，以及设备相关信息等。

在iOS中，如果要将某个绘图对象通过屏幕显示出来，一般需要定义一个UIView对象，并实现它的 `drawRect:` 方法，以进行具体的绘制操作。在程序运行起来之后，当这个视图对象变得可见时或者其上的内容需要更新时，`drawRect:` 会被自动调用。而在此期间，视图对象会自动创建并配置相关的环境上下文信息，以让绘图过程立即执行。在 `drawRect: `方法中，可以通过UIGraphicsGetCurrentContext得到当前绘图上下文对象。

创建不同的上下文对象可以参考：[不同绘图对象的上下文对象的创建方式](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_context/dq_context.html#//apple_ref/doc/uid/TP30001066-CH203-TPXREF101)。

## 图形状态

针对不同的绘图对象和操作，有与之对应的参数决定不同的绘图行为，这些参数也就是图形的状态，比如当画一条线时，需要设置颜色color、线宽width、连接类型join style、端点样式cap style、虚线类型dash等参数。

对于上下文信息来说，一般会持有多个图形状态信息，它们会以栈的形式被保存，通过`CGContextSaveGState`可以将当前状态信息入栈，而通过`CGContextRestoreGState`会弹出栈顶的状态作为当前的绘图状态。

# 路径

路径Path是由几何方式定义的不同形状或子路径构成的组合，比如直线、曲线、以及圆、矩形等，即可开放，也可闭合。也就是说，Path由以下这些部分组合而成：

- **直线Line**
    - 实线
    - 虚线
- **曲线Curve**
    - 弧线Arc
    - 贝塞尔曲线
- **子路径**
    - 圆Circle
    - 矩形Rectangle
    - 椭圆Ellipse
    - ...

当然对于所有Path，创建之后还要对其进行装饰，也就是真正的绘制过程，比如设置线宽、颜色，以及描边或填充。

## 创建

创建Path有两种方式，其一是直接将路径的细节填入上下文对象CGContextRef中，每操作一次都需要调用一次 GContextMove* 或 CGContextAdd* 函数；其二是将所有细节放入一个CGPathRef对象中，等构建完成之后再加入上下文中。

相比较而言，前一种方法适用于一次性操作，简单快速，后一种则更适用于需要重复使用的场景，复用性强。同时，它们的API是对应的。

|说明|CGContext|CGPath|
|-|-|-|
|初始化|CGContextBeginPath|CGPathCreateMutable|
|设置开始点|CGContextMoveToPoint|CGPathMoveToPoint|
|添加直线|CGContextAddLineToPoint|CGPathAddLineToPoint|
|添加曲线|CGContextAddCurveToPoint|CGPathAddCurveToPoint|
|添加椭圆|CGContextAddEllipseToPoint|CGPathAddEllipseToPoint|
|添加弧线|CGContextAddArc|CGPathAddARc|
|添加矩形|CGContextAddRect|CGPathAddRect|
|闭合路径|CGContextClosePath|CGPathCloseSubpath|

对于可复用的Path，在绘制完成之后可通过CGContextAddPath加入到当前的上下文中。

## 绘制

当创建好Path之后，就进行真正的绘制过程，这一步可分为**描边Stroke**或填充**Fill**两种类型。

描边需要考虑的参数包括：
- 线宽，CGContextSetLineWidth
- 颜色，CGContextSetStrokeColorWithColor
- 模式，CGContextSetStrokePattern
- 连接类型，CGContextSetLineJoin
- 端头形式，CGContextSetLineCap
- 虚线样式，CGContextSetLineDash
- ...

如果填充，自然只需要设置一个参数——颜色，通过CGContextSetFillColorWithColor即可完成。

## 其他

当绘制视图存在背景色，或者已经有其他对象时，就涉及到另一个概念：混合，表示如何处理上层对象对于下层对象的覆盖行为。默认会根据下面这个公式计算上层对象的可见度：

result = (alpha * foreground) + (1 - alpha) * background

当然还有其他混合样式，具体可以通过CGContextSetBlendMode按需进行设置，可选值包括如下，效果见：[混合模式效果](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_paths/dq_paths.html#//apple_ref/doc/uid/TP30001066-CH211-TPXREF101)。

```objc
typedef CF_ENUM (int32_t, CGBlendMode) {
    /* Available in Mac OS X 10.4 & later. */
    kCGBlendModeNormal,
    kCGBlendModeMultiply,
    kCGBlendModeScreen,
    kCGBlendModeOverlay,
    kCGBlendModeDarken,
    kCGBlendModeLighten,
    kCGBlendModeColorDodge,
    kCGBlendModeColorBurn,
    kCGBlendModeSoftLight,
    kCGBlendModeHardLight,
    kCGBlendModeDifference,
    kCGBlendModeExclusion,
    kCGBlendModeHue,
    kCGBlendModeSaturation,
    kCGBlendModeColor,
    kCGBlendModeLuminosity,

    /* Available in Mac OS X 10.5 & later. R, S, and D are, respectively,
       premultiplied result, source, and destination colors with alpha; Ra,
       Sa, and Da are the alpha components of these colors.

       The Porter-Duff "source over" mode is called `kCGBlendModeNormal':
         R = S + D*(1 - Sa)

       Note that the Porter-Duff "XOR" mode is only titularly related to the
       classical bitmap XOR operation (which is unsupported by
       CoreGraphics). */

    kCGBlendModeClear,                  /* R = 0 */
    kCGBlendModeCopy,                   /* R = S */
    kCGBlendModeSourceIn,               /* R = S*Da */
    kCGBlendModeSourceOut,              /* R = S*(1 - Da) */
    kCGBlendModeSourceAtop,             /* R = S*Da + D*(1 - Sa) */
    kCGBlendModeDestinationOver,        /* R = S*(1 - Da) + D */
    kCGBlendModeDestinationIn,          /* R = D*Sa */
    kCGBlendModeDestinationOut,         /* R = D*(1 - Sa) */
    kCGBlendModeDestinationAtop,        /* R = S*(1 - Da) + D*Sa */
    kCGBlendModeXOR,                    /* R = S*(1 - Da) + D*(1 - Sa) */
    kCGBlendModePlusDarker,             /* R = MAX(0, (1 - D) + (1 - S)) */
    kCGBlendModePlusLighter             /* R = MIN(1, S + D) */
};
```

另外，还可以根据Path的形状对当前图形实施**剪裁**，扮演类似蒙版的效果。

```objc
CGContextBeginPath (context);
CGContextAddArc (context, w/2, h/2, ((w>h) ? h : w)/2, 0, 2*PI, 0);
CGContextClosePath (context);
CGContextClip (context);
```

通过路径画正弦曲线的代码如下。

```objc
- (void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    [self drawPathWithContext:ctx baseline:self.center.y-100 height:160];
}

- (void)drawPathWithContext:(CGContextRef)ctx baseline:(CGFloat)baseline height:(CGFloat)height {

    // 外部矩形
    CGContextSaveGState(ctx);
    
    CGContextMoveToPoint(ctx, 0, baseline);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, .5);
    CGContextSetLineWidth(ctx, 2);
    CGContextStrokeRect(ctx, CGRectMake(0, baseline, CGRectGetWidth(self.bounds), height));
    
    CGContextRestoreGState(ctx);

    /// 正弦曲线
    CGFloat radius = 50;
    CGFloat tickThickNess = 2;
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, baseline+height/2);
    CGMutablePathRef cgpath = CGPathCreateMutable();
    
    // 坐标轴
    CGPathMoveToPoint(cgpath, NULL, 10, center.y);
    CGPathAddLineToPoint(cgpath, NULL, CGRectGetWidth(self.bounds)-20, center.y);
    CGPathMoveToPoint(cgpath, NULL, center.x, baseline+5);
    CGPathAddLineToPoint(cgpath, NULL, center.x, baseline+height-10);
    CGContextAddPath(ctx, cgpath);
    
    CGContextSaveGState(ctx); {
        CGContextSetLineWidth(ctx,tickThickNess);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextSetFlatness(ctx, 1);
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
        CGContextStrokePath(ctx);
    }
    CGContextRestoreGState(ctx);
    
    // 刻度
    CGPathMoveToPoint(cgpath, NULL, 10, center.y-tickThickNess);
    CGPathAddLineToPoint(cgpath, NULL, CGRectGetWidth(self.bounds)-20, center.y-tickThickNess);
    CGPathMoveToPoint(cgpath, NULL, center.x+tickThickNess, baseline+5);
    CGPathAddLineToPoint(cgpath, NULL, center.x+tickThickNess, baseline+height-10);
    CGContextAddPath(ctx, cgpath);
    
    CGContextSaveGState(ctx); {
        const CGFloat lengths[] = {2,5};
        CGContextSetLineWidth(ctx, tickThickNess);
        CGContextSetLineDash(ctx, 0, lengths, 2);
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
        CGContextStrokePath(ctx);
    }
    CGContextRestoreGState(ctx);
    
    // 右半部分圆弧
    CGPathMoveToPoint(cgpath, NULL, center.x+radius*2, center.y);
    CGPathAddArc(cgpath, NULL, center.x+radius, center.y, radius, 0, M_PI, YES);
    
    // 左半部分
    CGPathMoveToPoint(cgpath, NULL, center.x, center.y);
    CGPathAddArc(cgpath, NULL, center.x-radius, center.y, radius, 0, M_PI, NO);
    
    CGContextAddPath(ctx, cgpath);
    
    // 状态
    CGContextSaveGState(ctx); {
        CGContextSetLineWidth(ctx, 1);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextSetFlatness(ctx, 1);
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
        CGContextStrokePath(ctx);
    }
    
    CGContextRestoreGState(ctx);
    CGPathRelease(cgpath);
}
```

# 变换

Quartz 2D定义了两个完全独立的坐标空间：用户空间和设备空间，用户空间表示绘图内容，设备空间表示设备的原生分辨率，它们之间没有什么关联。当需要将绘图内容显示在屏幕上，或者打印输出时，Quartz会自动完成从用户坐标空间向设备坐标空间的转换。

如果想对绘图内容做一些变换，我们只需要操作当前变化矩阵**CTM**(current transformation matrix)，也可以通过放射变换实现。其中变换类型一共分为三种，但它们之间可以组合：
- **平移**
- **缩放**
- **旋转**

## 使用
### 操作CTM

默认情况下，CTM是伴随着Context而创建的一个单位矩阵，通过直接操作CTM，可快速实现对当前Context的变换操作，方法有：
- 平移：CGContextTranslateCTM
- 旋转：CGContextRotateCTM
- 缩放：CGContextScaleCTM

### 放射变换

放射变换和CTM类似，只不过前者先操作一个3x3矩阵，然后将此矩阵作用于上下文中，实现真正的变换。方法有：
- CGAffineTransformMakeTranslation
- CGAffineTransformTranslate
- CGAffineTransformTranslate
- CGAffineTransformRotate
- CGAffineTransformMakeScale
- CGAffineTransformScale

```objc
- (void)drawCicleToPath:(CGMutablePathRef)path angle:(CGFloat)angle {
    const CGPoint center = self.center;
    const CGFloat radius = 100.0;
          CGFloat ratio  = 4.0;
    
    CGFloat width, height, scale;
    
    width = CGRectGetWidth(self.bounds)*.5;
    height = width/ratio;
    scale = [self cicleScaleAtAngle:angle];
    
    // 注意，旋转中心是anchorPoint，而不是center
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform = CGAffineTransformMakeRotation(angle/100);
    transform = CGAffineTransformTranslate(transform, -cos(angle), -sin(angle));
    transform = CGAffineTransformScale(transform, 1-scale*.5, .5*(1+scale));
    
    CGPathAddArc(path,
                 &transform,
                 center.x,
                 center.y,
                 radius,
                 0,
                 2*M_PI-1e-5, NO);
}
```

背后的数学原理见：[放射变换的数学原理](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_affine/dq_affine.html#//apple_ref/doc/uid/TP30001066-CH204-SW1)。

# 渐变

在Quartz 2D中有两个渐变实现CGShapingRef和CGGradientRef，都可以用来实现线性渐变和径向渐变。

CGShadingRef和CGGradientRef之间的区别在于，前者的自由度更大，可以实现自定义渐变样式，使用起来比较麻烦；而后者是前者的一个子集，使用更加方便，只需要提供一个渐变颜色序列和位置，就能够实现。

## CGGradient

```objc
@implementation QuartzGradientViewExample

CGGradientRef CreateGradient() {
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    size_t num_locations    = 2;
    CGFloat locations[2]    = { 0.0, 1.0};
    CGFloat components[8]   = { 0.95, 0.3, 0.4, 1.0,
                                0.10, 0.20, 0.30, 1.0 };
    
    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericGray);
    gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                   components,
                                                   locations,
                                                   num_locations);
    
    return gradient;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(),
                                CreateGradient(),
                                CGPointMake(0, 0),
                                CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)),
                                kCGGradientDrawsAfterEndLocation);
    
    CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(),
                                CreateGradient(),
                                self.center, 10,
                                self.center, 200,
                                kCGGradientDrawsAfterEndLocation);
    
}


@end
```

## CGShading

```objc
@implementation QuartzShadingViewExample

static void myCalculateShadingValues (void *info,
                            const CGFloat *in,
                            CGFloat *out) {
    CGFloat v;
    size_t k, components;
    static const CGFloat c[] = {1, 0, .5, 0 };
 
    components = (size_t)info;
 
    v = *in;
    for (k = 0; k < components -1; k++)
        *out++ = c[k] * v;
     *out++ = 1;
}


static CGFunctionRef myGetFunction (CGColorSpaceRef colorspace) {
    size_t numComponents;
    static const CGFloat input_value_range [2] = { 0, 1 };
    static const CGFloat output_value_ranges [8] = { 0, 1, 0, 1, 0, 1, 0, 1 };
    static const CGFunctionCallbacks callbacks = { 0,
                                &myCalculateShadingValues,
                                NULL };
 
    numComponents = 1 + CGColorSpaceGetNumberOfComponents (colorspace);
    return CGFunctionCreate ((void *) numComponents,
                                1,
                                input_value_range,
                                numComponents,
                                output_value_ranges,
                                &callbacks);
}

void myPaintRadialShading (CGContextRef myContext, CGRect bounds) {
    CGPoint startPoint, endPoint;
    CGFloat startRadius, endRadius;
    CGAffineTransform myTransform;
    CGColorSpaceRef colorspace;
    CGShadingRef shading;
    CGFunctionRef shadingFuction;
    
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
 
    startPoint = CGPointMake(0.25,0.3);
    startRadius = .1;
    endPoint = CGPointMake(.7,0.7);
    endRadius = .25;
 
    colorspace = CGColorSpaceCreateDeviceRGB();
    shadingFuction = myGetFunction (colorspace);
 
    shading = CGShadingCreateRadial (colorspace,
                            startPoint, startRadius,
                            endPoint, endRadius,
                            shadingFuction,
                            false, false);
 
    myTransform = CGAffineTransformMakeScale (width, height);
    CGContextConcatCTM (myContext, myTransform);
    CGContextSaveGState (myContext);
 
    CGContextClipToRect (myContext, CGRectMake(0, 0, 1, 1));
    CGContextSetRGBFillColor (myContext, 1, 1, 1, 1);
    CGContextFillRect (myContext, CGRectMake(0, 0, 1, 1));
 
    CGContextDrawShading (myContext, shading);
    CGColorSpaceRelease (colorspace);
    CGShadingRelease (shading);
    CGFunctionRelease (shadingFuction);
 
    CGContextRestoreGState (myContext);
}

- (void)drawRect:(CGRect)rect{
    myPaintRadialShading(UIGraphicsGetCurrentContext(), self.bounds);
}

@end

```

# Other
## 模式

Pattern，模式或图案，一小段可重复绘制的对象，可用来填充图形表明或描边。

```objc
#define H_PATTERN_SIZE 16
#define V_PATTERN_SIZE 18
 
void MySquaredPattern (void *info, CGContextRef myContext) {
    CGFloat subunit = 5; // the pattern cell itself is 16 by 18
 
    CGRect  rect1 = {{0,0}, {subunit, subunit}},
            rect2 = {{subunit, subunit}, {subunit, subunit}},
            rect3 = {{0,subunit}, {subunit, subunit}},
            rect4 = {{subunit,0}, {subunit, subunit}};
 
    CGContextSetRGBFillColor (myContext, 1, 1, 1, 0.5);
    CGContextFillRect (myContext, rect1);
    CGContextSetRGBFillColor (myContext, 1, 0, 0, 0.5);
    CGContextFillRect (myContext, rect2);
    CGContextSetRGBFillColor (myContext, 0, 1, 0, 0.5);
    CGContextFillRect (myContext, rect3);
    CGContextSetRGBFillColor (myContext, .5, 0, .5, 0.5);
    CGContextFillRect (myContext, rect4);
}

void MyPatternPaint(CGContextRef context, CGRect rect) {
    CGPatternRef    pattern;
    CGColorSpaceRef patternSpace;
    CGFloat         alpha = 1;
    static const    CGPatternCallbacks callbacks = {
                        0,
                        &MySquaredPattern,
                        NULL
                    };
    patternSpace =  CGColorSpaceCreatePattern(NULL);

    CGContextSaveGState(context);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    
    pattern = CGPatternCreate(NULL,
                              CGRectMake(0, 0, H_PATTERN_SIZE, V_PATTERN_SIZE),
                              CGAffineTransformMake(1, 0, 0, 1, 0, 0),
                              H_PATTERN_SIZE,
                              V_PATTERN_SIZE,
                              kCGPatternTilingConstantSpacing,
                              true,
                              &callbacks);
    
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    
}

- (void)drawRect:(CGRect)rect {
    CGRect square = CGRectMake(0, (CGRectGetHeight(self.bounds)-CGRectGetWidth(self.bounds))/2, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds));
    
    MyPatternPaint(UIGraphicsGetCurrentContext(), square);
}
```

## 透明图层

图层和PS中的图层概念类似，可以给层对象分别设置不同的效果，然后合成一体。

通过执行CGContextBeginTransparencyLayer，即可开启一个全新的图层，CGContextBeginTransparencyLayer则表示关闭当前图层。

```objc
- (void)drawRect:(CGRect)rect {
    NSUInteger   count      = 100;
    CGContextRef context    = UIGraphicsGetCurrentContext();
    CGFloat      angleSeg   = M_PI*2/count;
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.f);
    
    for (int i=0; i<count; i++) {
        CGContextBeginTransparencyLayer(context, NULL);
        [self drawCicleToContext:context angle:i*angleSeg];
        CGContextEndTransparencyLayer(context);
    }
}
```