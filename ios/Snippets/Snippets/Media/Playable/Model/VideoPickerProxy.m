//
//  VideoPickerProxy.m
//  Snippets
//
//  Created by Walker Wang on 2021/11/30.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "VideoPickerProxy.h"

@implementation VideoPickerProxy

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)){
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSItemProvider *provider = results.firstObject.itemProvider;
    if ([provider canLoadObjectOfClass:PHLivePhoto.class]) {
        [provider loadObjectOfClass:PHLivePhoto.class completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            
        }];
    }
    [provider loadFileRepresentationForTypeIdentifier: (NSString *)kUTTypeMovie completionHandler:^(NSURL * _Nullable url, NSError * _Nullable error) {
        NSError *localError;
        NSURL *movieUrl = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:&localError] URLByAppendingPathComponent:[url.path componentsSeparatedByString:@"/"].lastObject];
        if ([[NSFileManager defaultManager] fileExistsAtPath:movieUrl.path]) {
            [[NSFileManager defaultManager] removeItemAtURL:movieUrl error:&localError];
        }
        if ([[NSFileManager defaultManager] copyItemAtURL:url toURL:movieUrl error:&localError]) {
            self.videoUrl = movieUrl;
            NSLog(@"video file url is at %@", movieUrl.path);
        } else {
            NSLog(@"copy video failed, %@", localError.debugDescription);
        }
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (![mediaType isEqualToString:(NSString *)kUTTypeMovie])
        return;
    NSURL *mediaURl = [info objectForKey:UIImagePickerControllerMediaURL];
    self.videoUrl = mediaURl;
}

@end
