//
//  UIImageView+RoundImage.h
//  ProductDemo
//
//  Created by qizd on 2018/9/5.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (RoundImage)

//高效的获得一个圆角的图片直接给UIimageView使用，不会造成卡顿
- (void)zd_drawRectWithRoundedCornerRadius:(CGFloat)radius size:(CGSize)size image:(UIImage *)image;
@end
