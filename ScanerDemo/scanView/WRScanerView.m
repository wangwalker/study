//
//  WRScanerView.m
//  ScanerDemo
//
//  Created by jfy on 2017/1/11.
//  Copyright © 2017年 Walker. All rights reserved.
//

#import "WRScanerView.h"

@interface WRScanerView()

@property (nonatomic,strong) UIImageView *moveImage;

@end

@implementation WRScanerView

#pragma mark - init
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initProperties];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initProperties];
    }
    return self;
}

-(void)initProperties
{
    self.scanSquareLength = self.bounds.size.width - 100;
    
    _scanRect = CGRectMake(self.bounds.size.width/2.0 - self.scanSquareLength/2.0,
                           self.bounds.size.height/2.0 - self.scanSquareLength/2.0,
                           self.scanSquareLength,
                           self.scanSquareLength);

    [self setBackgroundColor:[UIColor clearColor]];
    [self setTintColor:[UIColor greenColor]];
    
}

#pragma mark -move line
-(void)startMoveLine
{
    if (_moveImage)
    {
        [self removeMoveLine];
    }
    
    _moveImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moveImage"]];
    _moveImage.frame = CGRectMake(0, 0,self.bounds.size.width, 15.0f);
    [self addSubview:self.moveImage];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = @(self.scanRect.origin.y + 10);
    animation.toValue = @(self.scanRect.origin.y + self.scanRect.size.height - 30);
    animation.autoreverses = YES;
    animation.repeatCount = NSIntegerMax;
    animation.duration = 1.5f;
    
    [self.moveImage.layer addAnimation:animation forKey:nil];
}

-(void)removeMoveLine
{
    [self.moveImage removeFromSuperview];
    self.moveImage = nil;
}

#pragma mark - scan rect and border
- (void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //绘制扫描背景
    [self addScreenFillRect:ctx rect:self.bounds];
    
    //绘制扫描区域
    [self addCenterClearRect:ctx rect:self.scanRect];
    
    //绘制边
    [self addWhiteRect:ctx rect:self.scanRect];
    
    //绘制角
    [self addCornerLineWithContext:ctx rect:self.scanRect];
    
    [self startMoveLine];
}

- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    //边角颜色，绿色[UIColor greenColor]
    CGContextSetRGBStrokeColor(ctx, 1 /255.0, 255/255.0, 1/255.0, 1);
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

-(void)addGradientLayerForView:(UIView *)view fromColor:(UIColor *)fColor toColor:(UIColor *)tColor
{
    UIView *gradentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,view.bounds.size.width, view.bounds.size.height)];
    [self addSubview:gradentView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = gradentView.bounds;
    
    [gradentView.layer addSublayer:gradientLayer];
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    gradientLayer.colors = @[(__bridge id)fColor.CGColor,
                             (__bridge id)tColor.CGColor,
                             (__bridge id)tColor.CGColor,
                             (__bridge id)tColor.CGColor,
                             (__bridge id)fColor.CGColor,];
    
}

- (UIImage*) imageWithView:(UIView*) view
{
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(view.bounds.size);
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);//调整显示精度
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(currnetContext, 1);
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}

@end
