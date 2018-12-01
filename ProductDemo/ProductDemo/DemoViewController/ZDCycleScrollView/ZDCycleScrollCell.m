//
//  ZDCycleScrollCell.m
//  ProductDemo
//
//  Created by qizd on 2018/9/5.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "ZDCycleScrollCell.h"
#import "NSString+Fmt.h"
#import "UIView+ZDCategory.h"

@interface ZDCycleScrollCell()

@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ZDCycleScrollCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    if ([NSString isEmptyString:self.title]) {
        
    } else {
        CGFloat titleLabelW = self.zd_width;
        CGFloat titleLabelH = self.titleHeight;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = self.zd_height - titleLabelH;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    }
}

- (void)setTitle:(NSString *)title {
    
}

- (CGFloat)titleHeight {
    if (_titleHeight > 0) {
        return _titleHeight;
    } else {
        if (![NSString isEmptyString:self.title]) {
            return self.bounds.size.height * 0.2;
        }
    }
    return 0;
}

@end
