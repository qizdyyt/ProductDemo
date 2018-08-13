//
//  ZDCollectionViewCell.m
//  ProductDemo
//
//  Created by qizd on 2018/8/7.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "ZDCollectionViewCell.h"
@interface ZDCollectionViewCell()
@property (nonatomic, retain) UILabel *contentLabel;

@end
@implementation ZDCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.contentLabel = contentLabel;
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

-(void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
    self.contentLabel.textColor = [UIColor blackColor];
}

@end
