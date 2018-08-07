//
//  CollectionViewDemoController.m
//  ProductDemo
//
//  Created by qizd on 2018/8/7.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "CollectionViewDemoController.h"

@interface CollectionViewDemoController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *carouselView;

@end

@implementation CollectionViewDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置cell间距: 水平间距, 注意点:系统可能会跳转(计算不准确)
    layout.minimumInteritemSpacing = 10;
    //设置垂直间距
    layout.minimumLineSpacing = 50;
    // 设置水平滚动方向
    //水平滚动
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 设置尺寸
    layout.itemSize = CGSizeMake(160, 160);
    //估算的尺寸(一般不需要设置)
    layout.estimatedItemSize = CGSizeMake(100, 100);
    //头部的参考尺寸(就是尺寸)
    layout.headerReferenceSize = CGSizeMake(100, 100);
    //尾部的参考尺寸
    layout.footerReferenceSize = CGSizeMake(100, 100);
    //设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
    if (@available(iOS 9.0, *)) {
        layout.sectionFootersPinToVisibleBounds = YES;
        layout.sectionHeadersPinToVisibleBounds = YES;
    }
    // 设置额外滚动区域
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, ScreenWidth, ScreenHeight - 200) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //设置滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    //设置是否需要弹簧效果
    self.collectionView.bounces = NO;
    [self.view addSubview:self.collectionView];
}


#pragma mark - delegate and DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    /*
     注意:
     UICollectioncView的cell和UITableView的cell不太一样,
     UITableView有默认的子控件
     UICollectionViewCell除了contentView以外, 没有提供默认的子控件
     设置UICollectionViewCell需要自定义 最好结合Xib使用
     */
    // 2.使用
    cell.backgroundColor = (indexPath.item % 2)?[UIColor redColor]:[UIColor greenColor];
    
    // 3.返回
    return cell;
    
}




@end
