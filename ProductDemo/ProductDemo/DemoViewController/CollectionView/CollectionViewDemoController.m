//
//  CollectionViewDemoController.m
//  ProductDemo
//
//  Created by qizd on 2018/8/7.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "CollectionViewDemoController.h"
#import "ZDCollectionViewCell.h"

@interface CollectionViewDemoController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *carouselView;

@property (nonatomic, retain) NSMutableArray *data;

@property (nonatomic, weak) UILongPressGestureRecognizer *longGestureRecognizer;

@end

@implementation CollectionViewDemoController

NSString * const ReuseIdentifier = @"CellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    [self initData];
    [self initCollectionView];
    
    [self addLongPressGesture];
    
    
}

#pragma mark - 添加长按手势
- (void)addLongPressGesture {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.5;
    [self.collectionView addGestureRecognizer:longPress];
    self.longGestureRecognizer = longPress;
}

/**********
    关于collectionView编辑的说明：
 iOS9之后，collectionView内部支持手动拖拽移动或者交换cell的位置。但是，在iOS9中，垂直方向到达边缘后可以自动滚动，但是水平方向，需要cell的高度与collectionView的高度基本一致才可以。
 iOS10、iOS11没有这个问题可以正常使用
 *********/
- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    CGPoint pressPoint = [gesture locationInView:self.collectionView];
    NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:pressPoint];
    if (selectIndexPath) {
        switch (gesture.state) {
            case UIGestureRecognizerStateBegan:
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
                
                break;
            case UIGestureRecognizerStateChanged:
                [self.collectionView updateInteractiveMovementTargetPosition:pressPoint];
                
                break;
            case UIGestureRecognizerStateEnded:
                [self.collectionView endInteractiveMovement];
                break;
            default:
                [self.collectionView cancelInteractiveMovement];
                break;
        }
    }
}

#pragma mark - delegate and DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    /*
     注意:
     UICollectioncView的cell和UITableView的cell不太一样,
     UITableView有默认的子控件
     UICollectionViewCell除了contentView以外, 没有提供默认的子控件
     设置UICollectionViewCell需要自定义 最好结合Xib使用
     */
    // 2.使用
    cell.backgroundColor = [UIColor greenColor];
    cell.content = [NSString stringWithFormat:@"%@", self.data[indexPath.row]];
    // 3.返回
    return cell;
    
}

//-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id obj = [_data objectAtIndex:sourceIndexPath.item];
    [_data removeObject:obj];
    [_data insertObject:obj atIndex:destinationIndexPath.item];
    [self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}


#pragma mark - 初始化collectionView
- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置cell间距: 水平间距, 注意点:系统可能会跳转(计算不准确)-----
#warning collection编辑时这里可能导致崩溃
//    layout.minimumInteritemSpacing = 20;
    //设置垂直间距
//    layout.minimumLineSpacing = 50;
    // 设置水平滚动方向
    //水平滚动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 设置尺寸
    layout.itemSize = CGSizeMake(300, 300);
    //估算的尺寸(一般不需要设置)
//    layout.estimatedItemSize = CGSizeMake(100, 100);
    //头部的参考尺寸(就是尺寸)----个人测试只有高度生效，宽度随便都没啥效果。。
    layout.headerReferenceSize = CGSizeMake(100, 0);
    //尾部的参考尺寸
    layout.footerReferenceSize = CGSizeMake(100, 0);
    //设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
    if (@available(iOS 9.0, *)) {
        layout.sectionFootersPinToVisibleBounds = YES;
        layout.sectionHeadersPinToVisibleBounds = YES;
    }
    // 设置额外滚动区域
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, ScreenWidth, 300) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //设置滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    //设置是否需要弹簧效果
    self.collectionView.bounces = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:NSClassFromString(@"ZDCollectionViewCell") forCellWithReuseIdentifier:ReuseIdentifier];
}

#pragma mark - 初始化数据
- (void)initData {
    self.data = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        [self.data addObject:[NSString stringWithFormat:@"%d", i]];
    }
}


@end
