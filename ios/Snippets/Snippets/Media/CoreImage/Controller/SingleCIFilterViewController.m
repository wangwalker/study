//
//  SingleCIFilterViewController.m
//  Snippets
//
//  Created by Walker on 2020/12/16.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "SingleCIFilterViewController.h"

void kGaussianBlurRadiusContext(void) {};

@interface SingleCIFilterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *processedImageView;
@property (weak, nonatomic) IBOutlet UISlider *blurRadiusSlider;
@property (weak, nonatomic) IBOutlet UILabel *blurRadiusLabel;

@property (nonatomic) CIImage *inputImage;

@end

@implementation SingleCIFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (IBAction)changeBlurRadius:(UISlider *)sender {
    [self.blurRadiusLabel setText:[NSString stringWithFormat:@"%.1f", sender.value]];
}


- (IBAction)startProcess:(UIButton *)sender {
    [self blurImageWithRadius:self.blurRadiusSlider.value];
}

- (IBAction)startProcessWithChain:(UIButton *)sender {
    CIImage *blurImg, *bloomImg, *croppedImg;
    blurImg = [self processWithImage:self.inputImage
                         fileterName:@"CIGaussianBlur"
                              params:@{kCIInputRadiusKey: @(1.2)}];
    bloomImg = [self processWithImage:blurImg
                          fileterName:@"CIBloom"
                               params:@{kCIInputRadiusKey: @(8.0),
                                        kCIInputIntensityKey: @(1.0)}];
    croppedImg = [bloomImg imageByCroppingToRect:CGRectMake(50, 100, 300, 300)];
    
    [self.processedImageView setImage:[UIImage imageWithCIImage:croppedImg]];
}

- (void)blurImageWithRadius:(CGFloat)radius {
    CIFilter *gaussianBlur = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlur setValue:@(radius) forKey:@"inputRadius"];
    [gaussianBlur setValue:self.inputImage forKey:@"inputImage"];
    
    [self.processedImageView setImage:[UIImage imageWithCIImage:gaussianBlur.outputImage]];
}

- (CIImage *)processWithImage:(CIImage *)image fileterName:(NSString *)name params:(NSDictionary *)params {
    CIFilter *filter = [CIFilter filterWithName:name];
    [filter setValue:image forKey:@"inputImage"];
    for (NSString *key in params.allKeys) {
        [filter setValue:params[key] forKey:key];
    }
    return filter.outputImage;
}

- (void)createCIImageMethods {
    CIImage *ciimg;
    
    // 1. URL
    ciimg = [[CIImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"some-url"]];
    
    // 2. bytes
    ciimg = [CIImage imageWithData:[NSData dataWithContentsOfFile:@"some-file-path"]];
    
    // 3. UIImage
    ciimg = [CIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"some-img-name"], .9)];
    ciimg = [CIImage imageWithData:UIImagePNGRepresentation([UIImage imageNamed:@"png-name"])];
    
    // 4. CGImageRef
    ciimg = [CIImage imageWithCGImage:[UIImage imageNamed:@"some-img"].CGImage];
    
    //...
}

- (CIImage *)inputImage{
    if (!_inputImage) {
        UIImage *originalImage = [UIImage imageNamed:@"blackboard.jpg"];
        _inputImage = [CIImage imageWithData: UIImageJPEGRepresentation(originalImage, .9)];
    }
    return _inputImage;
}

@end
