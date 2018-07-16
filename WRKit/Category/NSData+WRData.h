//
//  NSData+WRData.h
//  tCCSC
//
//  Created by IMAC on 2018/4/20.
//  Copyright © 2018年 IMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (WRData)


/*!
    get the readable size string of data,
    return a formated string ended with KB, MB,GB,TB and so on
 */
-(NSString *)readableSizeString;

/*!
 write Exif information(including GPS and TIFF informations) to a compressed image stream.
 @param imgData the compressed image data
 @param ExifDict the Exif information, is a dictionary format
 */
+ (NSData *)imageDataWithExifOriginalImageData:(NSData *)imgData ExifDic:(NSDictionary *)ExifDict;

@end
