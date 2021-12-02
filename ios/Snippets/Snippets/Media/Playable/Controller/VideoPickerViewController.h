//
//  VideoPickerViewController.h
//  Snippets
//
//  Created by Walker Wang on 2021/11/30.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <PhotosUI/PHPicker.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "BaseSnippetViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^VideoPickedHandler)(void);

@class VideoPickerProxy;

API_AVAILABLE(ios(14))
@interface VideoPickerViewController : BaseSnippetViewController

- (void)pickVideoWithCompletionHandler:(VideoPickedHandler)handler;

@property (nonatomic) PHPickerConfiguration *config;
@property (nonatomic) PHPickerViewController *pickerController;
@property (nonatomic) UIImagePickerController *imagePicker;

@property (nonatomic, readonly) VideoPickerProxy *videoProxy;

@end

NS_ASSUME_NONNULL_END
