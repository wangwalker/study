//
//  ColorConverter.m
//  Snippets
//
//  Created by Walker on 2020/11/30.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "ColorConvertor.h"

@implementation ColorConvertor

- (instancetype)init{
    if ((self = [super init])) {
        self.lComponent = arc4random()%100;
        self.aComponent = arc4random()%255-128;
        self.bComponent = arc4random()%255-128;
    }
    return self;
}

- (double)redComponent{
    float var_Y = ( self.lComponent + 16. ) / 116.;
    float var_X = self.aComponent / 500. + var_Y;
    float var_Z = var_Y - self.bComponent / 200.;

    if ( pow(var_Y,3) > 0.008856 ) var_Y = pow(var_Y,3);
    else                      var_Y = ( var_Y - 16. / 116. ) / 7.787;
    if ( pow(var_X,3) > 0.008856 ) var_X = pow(var_X,3);
    else                      var_X = ( var_X - 16. / 116. ) / 7.787;
    if ( pow(var_Z,3) > 0.008856 ) var_Z = pow(var_Z,3);
    else                      var_Z = ( var_Z - 16. / 116. ) / 7.787;

    float X = 95.047 * var_X ;    //ref_X =  95.047     Observer= 2°, Illuminant= D65
    float Y = 100.000 * var_Y  ;   //ref_Y = 100.000
    float Z = 108.883 * var_Z ;    //ref_Z = 108.883

    var_X = X / 100. ;       //X from 0 to  95.047      (Observer = 2°, Illuminant = D65)
    var_Y = Y / 100. ;       //Y from 0 to 100.000
    var_Z = Z / 100. ;      //Z from 0 to 108.883
    
    float var_R = var_X *  3.2406 + var_Y * -1.5372 + var_Z * -0.4986;
    if ( var_R > 0.0031308 ) var_R = 1.055 * pow(var_R , ( 1 / 2.4 ))  - 0.055;
    else                     var_R = 12.92 * var_R;
        
    return var_R*255.;
}

- (double)greenComponent{
    float var_Y = ( self.lComponent + 16. ) / 116.;
    float var_X = self.aComponent / 500. + var_Y;
    float var_Z = var_Y - self.bComponent / 200.;

    if ( pow(var_Y,3) > 0.008856 ) var_Y = pow(var_Y,3);
    else                      var_Y = ( var_Y - 16. / 116. ) / 7.787;
    if ( pow(var_X,3) > 0.008856 ) var_X = pow(var_X,3);
    else                      var_X = ( var_X - 16. / 116. ) / 7.787;
    if ( pow(var_Z,3) > 0.008856 ) var_Z = pow(var_Z,3);
    else                      var_Z = ( var_Z - 16. / 116. ) / 7.787;

    float X = 95.047 * var_X ;    //ref_X =  95.047     Observer= 2°, Illuminant= D65
    float Y = 100.000 * var_Y  ;   //ref_Y = 100.000
    float Z = 108.883 * var_Z ;    //ref_Z = 108.883


    var_X = X / 100. ;       //X from 0 to  95.047      (Observer = 2°, Illuminant = D65)
    var_Y = Y / 100. ;       //Y from 0 to 100.000
    var_Z = Z / 100. ;      //Z from 0 to 108.883
    
    float var_G = var_X * -0.9689 + var_Y *  1.8758 + var_Z *  0.0415;
    if ( var_G > 0.0031308 ) var_G = 1.055 * pow(var_G , ( 1 / 2.4 ) )  - 0.055;
    else                     var_G = 12.92 * var_G;
    
    return var_G*255.;
}

- (double)blueComponent{
    float var_Y = ( self.lComponent + 16. ) / 116.;
    float var_X = self.aComponent / 500. + var_Y;
    float var_Z = var_Y - self.bComponent / 200.;

    if ( pow(var_Y,3) > 0.008856 ) var_Y = pow(var_Y,3);
    else                      var_Y = ( var_Y - 16. / 116. ) / 7.787;
    if ( pow(var_X,3) > 0.008856 ) var_X = pow(var_X,3);
    else                      var_X = ( var_X - 16. / 116. ) / 7.787;
    if ( pow(var_Z,3) > 0.008856 ) var_Z = pow(var_Z,3);
    else                      var_Z = ( var_Z - 16. / 116. ) / 7.787;

    float X = 95.047 * var_X ;    //ref_X =  95.047     Observer= 2°, Illuminant= D65
    float Y = 100.000 * var_Y  ;   //ref_Y = 100.000
    float Z = 108.883 * var_Z ;    //ref_Z = 108.883


    var_X = X / 100. ;       //X from 0 to  95.047      (Observer = 2°, Illuminant = D65)
    var_Y = Y / 100. ;       //Y from 0 to 100.000
    var_Z = Z / 100. ;      //Z from 0 to 108.883
    
    float var_B = var_X *  0.0557 + var_Y * -0.2040 + var_Z *  1.0570;
    if ( var_B > 0.0031308 ) var_B = 1.055 * pow( var_B , ( 1 / 2.4 ) ) - 0.055;
    else                     var_B = 12.92 * var_B;
    
    return var_B*255.;
}

- (UIColor *)color{
    return [UIColor colorWithRed:self.redComponent*100/255.
                           green:self.greenComponent*100/255.
                            blue:self.blueComponent*100/255.
                           alpha:1.];
}

#pragma mark - KVO

+ (NSSet<NSString *> *)keyPathsForValuesAffectingRedComponent{
    return [NSSet setWithObject:@"lComponent"];
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingGreenComponent{
    return [NSSet setWithObjects:@"lComponent", @"aComponent", nil];
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingBlueComponent{
    return [NSSet setWithObjects:@"lComponent", @"bComponent", nil];
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingColor{
    return [NSSet setWithObjects:@"redComponent", @"greenComponent", @"blueComponent", nil];
}


@end
