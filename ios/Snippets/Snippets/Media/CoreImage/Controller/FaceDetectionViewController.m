//
//  FaceDetectionViewController.m
//  Snippets
//
//  Created by Walker on 2021/1/6.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "FaceDetectionViewController.h"

@interface FaceDetectionViewController ()
@property (nonatomic) CIContext *context;
@property (nonatomic) UIImage *image;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIAlertController *alert;
@end

@implementation FaceDetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _context = [CIContext context];
    
    [self.view addSubview:self.imageView];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"检测" style:UIBarButtonItemStylePlain target:self action:@selector(detect:)]];
    
    [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *image = (UIImage *)change[NSKeyValueChangeNewKey];
        for (UIView *view in self.imageView.subviews) {
            [view removeFromSuperview];
        }
        [self.imageView setImage:image];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self.view];
    if (CGRectContainsPoint(self.imageView.frame, point)) {
        [self presentViewController:self.alert animated:YES completion:^{
            
        }];
    }
}

- (void)detect:(UIBarButtonItem *)sender{
    CIImage *image = [CIImage imageWithData:UIImageJPEGRepresentation(self.image, .95)];
    NSLog(@"image size: %@", NSStringFromCGSize(self.image.size));
    
    NSDictionary *options = @{CIDetectorAccuracy: CIDetectorAccuracyLow};
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:_context options:options];
    options = @{CIDetectorImageOrientation: [[image properties] valueForKey:(NSString *)kCGImagePropertyOrientation]};
    
    NSArray *features = [detector featuresInImage:image options:options];
    
    for (CIFaceFeature *feature in features) {
        NSLog(@"face bounds: %@", NSStringFromCGRect(feature.bounds));
        [self drawBorderWithFaceFeature:feature];
    }
}

- (void)drawBorderWithFaceFeature:(CIFaceFeature *)feature{
    CGRect frame = [self convertFaceBoundsToView:feature.bounds];
    NSLog(@"converted face bounds: %@", NSStringFromCGRect(frame));

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.layer.borderWidth = 2.f;
    [self.imageView addSubview:label];
}

/**
 * Note: the bounds from CIFaceFeature does not satisfy UIView's coordinates.
 * In UIView, the origin is at top left corner, but in CoreImage, the origin is at bottom left corner.
 */
- (CGRect)convertFaceBoundsToView:(CGRect)bounds{
    CGFloat newY = self.image.size.height - CGRectGetMaxY(bounds);
    CGFloat ratio = CGRectGetWidth(self.imageView.bounds)/self.image.size.width;
    return CGRectMake(CGRectGetMinX(bounds)*ratio, newY*ratio, CGRectGetWidth(bounds)*ratio, CGRectGetHeight(bounds)*ratio);
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = self.image;
    }
    return _imageView;
}

- (UIImage *)image{
    if (!_image) {
        _image = [UIImage imageNamed:@"shannon.jpg"];
    }
    return _image;
}

- (UIAlertController *)alert{
    if (!_alert) {
        _alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString *name in @[@"shannon.jpg",
                                 @"auction.jpg",
                                 @"blackboard.jpg",
                                 @"stevejobs.jpg",
                                 @"family.png"
                               ]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:[name componentsSeparatedByString:@"."].firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.image = [UIImage imageNamed:name];
            }];
            [_alert addAction:action];
        }
        [_alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _alert;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGSize size = self.image.size;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    self.imageView.frame = CGRectMake(0, 0, width, width*(size.height/size.width));
    self.imageView.center = self.view.center;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
