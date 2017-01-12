//
//  WRScanerView.h
//  ScanerDemo
//
//  Created by jfy on 2017/1/11.
//  Copyright © 2017年 Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRScanerView : UIView

@property (nonatomic,assign) CGFloat scanSquareLength;  //扫描框的宽度和高度
@property (nonatomic,strong) UIColor *tintColor;        //主调色
@property (nonatomic,assign) CGRect  scanRect;

-(void)startMoveLine;
-(void)removeMoveLine;

@end
