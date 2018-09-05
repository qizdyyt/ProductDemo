//
//  ZDCycleScrollView.m
//  ProductDemo
//
//  Created by qizd on 2018/9/5.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "ZDCycleScrollView.h"
#import "UIView+ZDCategory.h"

@implementation ZDCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.zd_x = 12;
        self.zd_width = 15;
    }
    return self;
}

@end
