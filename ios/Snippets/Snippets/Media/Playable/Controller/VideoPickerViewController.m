//
//  VideoPickerViewController.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/30.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "VideoPickerViewController.h"
#import "VideoPickerProxy.h"

@interface VideoPickerViewController ()

@end

@implementation VideoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _videoProxy = [VideoPickerProxy new];
    // Do any additional setup after loading the view.
}

- (void)pickVideoWithCompletionHandler:(VideoPickedHandler)handler{
    if (@available(iOS 14.0, *)) {
        [self.navigationController presentViewController:self.pickerController animated:YES completion:^{
            if (handler) {
                handler();
            }
        }];
    } else {
        [self.navigationController presentViewController:self.imagePicker animated:YES completion:^{
            if (handler) {
                handler();
            }
        }];
    }
}

- (PHPickerConfiguration *)config API_AVAILABLE(ios(14)){
    if (!_config) {
        _config = [[PHPickerConfiguration alloc] init];
        _config.filter = PHPickerFilter.videosFilter;
    }
    return _config;
}
- (PHPickerViewController *)pickerController API_AVAILABLE(ios(14)){
    if (!_pickerController) {
        _pickerController = [[PHPickerViewController alloc] initWithConfiguration:self.config];
        _pickerController.delegate = _videoProxy;
    }
    return _pickerController;
}
- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = _videoProxy;
        _imagePicker.videoExportPreset = AVAssetExportPreset1920x1080;
    }
    return _imagePicker;
}

@end
