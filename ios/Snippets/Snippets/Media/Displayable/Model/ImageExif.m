//
//  ImageExif.m
//  Snippets
//
//  Created by Walker Wang on 2021/12/5.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Photos/Photos.h>
#import "ImageExif.h"

@implementation ImageExif

+ (instancetype)exifWithImageUrl:(NSURL *)url{
    return [[ImageExif alloc] initWithImageUrl:url];
}
- (instancetype)initWithImageUrl:(NSURL *)url{
    if ((self = [super init])) {
        _imageUrl = url;
    }
    return self;
}

- (void)process{
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)_imageUrl, NULL);
    if (source == nil) {
        return;
    }
        
    CFDictionaryRef infoDict = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    if (infoDict) {
        NSDictionary *exif = (__bridge NSDictionary*)CFDictionaryGetValue(infoDict, kCGImagePropertyExifDictionary);
        NSDictionary *gps = (__bridge NSDictionary*)CFDictionaryGetValue(infoDict, kCGImagePropertyGPSDictionary);
        NSDictionary *tiff =  (__bridge NSDictionary *)CFDictionaryGetValue(infoDict, kCGImagePropertyTIFFDictionary);
        
        NSMutableDictionary *ExifInfoDict = [@{} mutableCopy];
        NSMutableDictionary *exifDict = [exif mutableCopy];
        NSMutableDictionary *gpsDict = [gps mutableCopy];
        NSMutableDictionary *tiffDict = [tiff mutableCopy];
        
        /// customize
        [tiffDict setValue: @"artist" forKey:(__bridge NSString*)kCGImagePropertyTIFFArtist];
        [tiffDict setValue: @"snippet" forKey:(__bridge NSString*)kCGImagePropertyTIFFSoftware];
        
        if (exifDict)   {
            [ExifInfoDict setObject:exifDict forKey:(NSString*)kCGImagePropertyExifDictionary];
        }
        if (gpsDict)    {
            [ExifInfoDict setObject:gpsDict forKey:(NSString*)kCGImagePropertyGPSDictionary];
            _gps = gpsDict;
        }
        if (tiffDict)   {
            [ExifInfoDict setObject:tiffDict forKey:(NSString*)kCGImagePropertyTIFFDictionary];
        }
        _exif = ExifInfoDict;
        CFRelease(infoDict);
    }
    CFRelease(source);
}
@end
