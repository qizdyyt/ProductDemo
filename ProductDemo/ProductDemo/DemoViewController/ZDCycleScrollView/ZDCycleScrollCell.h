//
//  ZDCycleScrollCell.h
//  ProductDemo
//
//  Created by qizd on 2018/9/5.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDCycleScrollCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *title;

@property (nonatomic, assign) CGFloat titleHeight;

@end
