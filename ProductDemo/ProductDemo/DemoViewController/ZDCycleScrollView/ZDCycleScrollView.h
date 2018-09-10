//
//  ZDCycleScrollView.h
//  ProductDemo
//
//  Created by qizd on 2018/9/5.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZDCycleScrollViewDelegate <NSObject>

@end

@interface ZDCycleScrollView : UIView

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<ZDCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;

//图片数量
@property (nonatomic, assign) NSInteger itemCount;
//图片URL或者name数组
@property (nonatomic, strong) NSArray *imageUrlList;
@property (nonatomic, strong) NSArray *imageNames;

//标题列表
@property (nonatomic, strong) NSArray *titleList;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, weak) id<ZDCycleScrollViewDelegate> delegate;

@end
