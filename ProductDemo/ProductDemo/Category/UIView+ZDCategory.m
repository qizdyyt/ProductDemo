//
//  UIView+ZDCategory.m
//  ProductDemo
//
//  Created by qizd on 2018/9/5.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "UIView+ZDCategory.h"

@implementation UIView (ZDCategory)

- (CGFloat)zd_height
{
    return self.frame.size.height;
}

- (void)setZd_height:(CGFloat)zd_height
{
    CGRect temp = self.frame;
    temp.size.height = zd_height;
    self.frame = temp;
}

- (CGFloat)zd_width
{
    return self.frame.size.width;
}

- (void)setZd_width:(CGFloat)zd_width
{
    CGRect temp = self.frame;
    temp.size.width = zd_width;
    self.frame = temp;
}


- (CGFloat)zd_y
{
    return self.frame.origin.y;
}

- (void)setZd_y:(CGFloat)zd_y
{
    CGRect temp = self.frame;
    temp.origin.y = zd_y;
    self.frame = temp;
}

- (CGFloat)zd_x
{
    return self.frame.origin.x;
}

- (void)setZd_x:(CGFloat)zd_x
{
    CGRect temp = self.frame;
    temp.origin.x = zd_x;
    self.frame = temp;
}
@end
