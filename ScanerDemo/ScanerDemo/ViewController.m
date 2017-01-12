//
//  ViewController.m
//  ScanerDemo
//
//  Created by jfy on 2017/1/11.
//  Copyright © 2017年 Walker. All rights reserved.
//

#import "ViewController.h"
#import "scanView/WRScanerView.h"


@import AVFoundation;

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) WRScanerView               *scanerView;
@property (strong,nonatomic) AVCaptureSession           *session;//取景视图
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scanerView = [[WRScanerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    
    [self.view addSubview:self.scanerView];
    
    if (!_session)
    {
        [self setupAVFoundation];
        
        //调整摄像头取景区域
        CGRect rect = self.view.bounds;
        rect.origin.y = self.navigationController.navigationBarHidden ? 0 : 64;
        self.previewLayer.frame = rect;
    }
}

// 初始化扫码
- (void)setupAVFoundation
{
    //创建会话
    self.session = [[AVCaptureSession alloc] init];
    
    //获取摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if(input)
    {
        [self.session addInput:input];
    }
    else
    {
        //出错处理
        NSLog(@"scanError:%@", error);
        NSString *msg = @"模拟器上无法进行扫码，请在真机上进行测试";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:conform];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
        
        return;
    }
    
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:output];
    
    //设置扫码类型
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeEAN13Code,//条形码
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code];
    //设置代理，在主线程刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //创建摄像头取景区域
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    if ([self.previewLayer connection].isVideoOrientationSupported)
        [self.previewLayer connection].videoOrientation = AVCaptureVideoOrientationPortrait;
    
    __weak typeof(self) weakSelf = self;//避免循环引用
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil
        queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note)
    {
        if (weakSelf)
        {
            //调整扫描区域
            AVCaptureMetadataOutput *output = weakSelf.session.outputs.firstObject;
            output.rectOfInterest = [weakSelf.previewLayer metadataOutputRectOfInterestForRect:weakSelf.scanerView.scanRect];
        }
        
    }];
    
    //开始扫码
    [self.session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataMachineReadableCodeObject *metadata in metadataObjects)
    {
        //用metadata.stringValue可以获取到具体的字符串,二维码可以是任意的字符串，条形码只能是有限位数字
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode])
        {
            [self.session stopRunning];
            
            // your contrete conduct
            
            break;
        }
        else
        {
            [self.session stopRunning];
            
            //your contrete conduct
            
            break;
        }
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
