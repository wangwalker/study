//
//  VideoPickerProxy.h
//  Snippets
//
//  Created by Walker Wang on 2021/11/30.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PhotosUI/PHPicker.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoPickerProxy : NSObject <PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) NSURL *videoUrl;

@end

NS_ASSUME_NONNULL_END
