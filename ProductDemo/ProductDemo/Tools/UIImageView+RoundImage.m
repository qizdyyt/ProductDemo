//
//  UIImageView+RoundImage.m
//  ProductDemo
//
//  Created by qizd on 2018/9/5.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "UIImageView+RoundImage.h"

@implementation UIImageView (RoundImage)

- (void)zd_drawRectWithRoundedCornerRadius:(CGFloat)radius size:(CGSize)size image:(UIImage *)image{
    CGRect drawRect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:drawRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath);
    
    CGContextClip(UIGraphicsGetCurrentContext());
    [image drawInRect:drawRect];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    
    UIImage *resImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    return resImg;
    self.image = resImg;
}
@end
