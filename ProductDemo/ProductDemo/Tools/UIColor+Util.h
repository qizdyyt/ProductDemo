//
//  UIColor+Util.h
//  ProductDemo
//
//  Created by qizd on 2018/11/19.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (Util)

///[self colorFromRGB:0x1672c1];
+ (UIColor *)colorFromRGB:(int)rgbValue;
+ (UIColor *)colorFromRGB:(int)rgbValue alpha:(float)alpha;

+ (UIColor *)colorFromR:(float)red g:(float)green b:(float)blue a:(float)alpha;

@end


