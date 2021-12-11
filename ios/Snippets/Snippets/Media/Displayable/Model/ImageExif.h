//
//  ImageExif.h
//  Snippets
//
//  Created by Walker Wang on 2021/12/5.
//  Copyright © 2021 Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @abstract A pure model used to retrieve exchangeable image file format informatioin.
 @discussion
 Exchangeable image file format (officially Exif, according to JEIDA/JEITA/CIPA specifications) is a standard that specifies the formats for images, sound, and ancillary tags used by digital cameras (including smartphones), scanners and other systems handling image and sound files recorded by digital cameras.
 */
@interface ImageExif : NSObject

+ (instancetype)exifWithImageUrl:(NSURL *)url;

@property (nonatomic, readonly) NSURL *imageUrl;
@property (nonatomic, readonly) NSDictionary *exif;
@property (nonatomic, readonly) NSDictionary *gps;

@end

NS_ASSUME_NONNULL_END
