//
//  UIView+ZDCategory.h
//  ProductDemo
//
//  Created by qizd on 2018/9/5.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZDCategory)

/**  这里在分类中声明的属性，因为只是想修改View的自身可以拿到属性，所以不用考虑使用runtime进行添加，只需要自己实现setter和getter即可，但是注意方法名的大小写  **/
@property (nonatomic, assign) CGFloat zd_height;
@property (nonatomic, assign) CGFloat zd_width;

@property (nonatomic, assign) CGFloat zd_y;
@property (nonatomic, assign) CGFloat zd_x;
@end
