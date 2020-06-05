//
//  NSData+WRData.m
//  tCCSC
//
//  Created by IMAC on 2018/4/20.
//  Copyright © 2018年 IMAC. All rights reserved.
//

#import "NSData+WRData.h"
#import <UIKit/UIKit.h>


@implementation NSData (WRData)

-(NSString *)readableSizeString
{
    double imageSize = (double) [self length];
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (imageSize > 1024) {
        imageSize /= 1024.0;
        index ++;
    }
    
    return [NSString stringWithFormat:@"%.2f%@", imageSize, typeArray[index]];
}


+ (NSData *)imageDataWithExifOriginalImageData:(NSData *)imgData ExifDic:(NSDictionary *)ExifDict{
    // 1原图exif/tiff信息
    CFDictionaryRef exif = (CFDictionaryRef)CFDictionaryGetValue((__bridge CFDictionaryRef)ExifDict, kCGImagePropertyExifDictionary);
    CFDictionaryRef tiff = (CFDictionaryRef)CFDictionaryGetValue((__bridge CFDictionaryRef)ExifDict, kCGImagePropertyTIFFDictionary);
    CFDictionaryRef gps = (CFDictionaryRef)CFDictionaryGetValue((__bridge CFDictionaryRef)ExifDict, kCGImagePropertyGPSDictionary);
    
    // 2获取压缩的图片
    CGImageSourceRef compressSource = CGImageSourceCreateWithData((__bridge CFDataRef)imgData, NULL);
    CFDictionaryRef compressImageMetaData = CGImageSourceCopyPropertiesAtIndex(compressSource,0,NULL);
    CFMutableDictionaryRef compressImageMetaDataMu = CFDictionaryCreateMutableCopy(kCFAllocatorDefault, 1, compressImageMetaData);
    
    // 3将原来的exif/tiff等信息设置到压缩后的图片上
    if (exif){
        CFDictionarySetValue(compressImageMetaDataMu, kCGImagePropertyExifDictionary, exif);
    }
    
    if (tiff){
        CFDictionarySetValue(compressImageMetaDataMu, kCGImagePropertyTIFFDictionary, tiff);
    }
    
    if (gps){
        CFDictionarySetValue(compressImageMetaDataMu, kCGImagePropertyGPSDictionary, gps);
    }
    
    NSData *exifData = [self saveImageWithImageData:imgData ExifProperties:(__bridge NSDictionary*)compressImageMetaDataMu];
    
    return exifData;
}

// 将图片的exif信息写入到图片流
+ (NSData *)saveImageWithImageData:(NSData *)data ExifProperties:(NSDictionary *)exifProps{
    
    NSMutableDictionary *exifDict = [NSMutableDictionary dictionaryWithDictionary:exifProps];
//    NSMutableDictionary *gpsDict = [NSMutableDictionary dictionaryWithDictionary:GPSProps];
    
    // 设置properties属性
    CGImageSourceRef imageRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    CFStringRef uti = CGImageSourceGetType(imageRef);
    
    NSMutableData *imageData = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imageData, uti, 1, NULL);
    
    if (!destination)
    {
        NSLog(@"error");
        return nil;
    }
    
    CGImageDestinationAddImageFromSource(destination, imageRef, 0, (__bridge CFDictionaryRef)exifDict);
//    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gpsDict);
    
    BOOL check = CGImageDestinationFinalize(destination);
    
    if (!check)
    {
        NSLog(@"error");
        return nil;
    }
    
    CFRelease(destination);
    CFRelease(uti);
    
    return imageData;
}


@end
