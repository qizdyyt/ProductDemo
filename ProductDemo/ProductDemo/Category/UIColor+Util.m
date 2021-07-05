//
//  UIColor+Util.m
//  ProductDemo
//
//  Created by qizd on 2018/11/19.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)


+ (UIColor *)colorFromRGB:(int)rgbValue
{
    return [self colorFromRGB:rgbValue alpha:1.0f];
}

+ (UIColor *)colorFromRGB:(int)rgbValue alpha:(float)alpha
{
    float red = ((float)((rgbValue & 0xFF0000) >> 16))/255.0;
    float green = ((float)((rgbValue & 0xFF00) >> 8))/255.0;
    float blue = ((float)(rgbValue & 0xFF))/255.0;
    return [self colorWithRed:red green:green blue:blue alpha:alpha];
}

//0-255
+ (UIColor *)colorFromR:(float)red g:(float)green b:(float)blue a:(float)alpha
{
    return [self colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

@end
