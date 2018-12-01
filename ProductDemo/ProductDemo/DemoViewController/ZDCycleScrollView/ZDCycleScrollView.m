//
//  ZDCycleScrollView.m
//  ProductDemo
//
//  Created by qizd on 2018/9/5.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "ZDCycleScrollView.h"
#import "UIView+ZDCategory.h"
#import "ZDCycleScrollCell.h"

typedef enum {
    ZDCycleScrollDataSouceTypeLocal = 0,
    ZDCycleScrollDataSouceTypeNet = 1
}ZDCycleScrollDataSouceType;

@interface ZDCycleScrollView ()<UICollectionViewDelegate, UICollectionViewDataSource>

//图片数量
@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) UIView *titleView;
//数据类型
@property (nonatomic, assign) ZDCycleScrollDataSouceType datasouceType;


@end

@implementation ZDCycleScrollView

NSString *const cellID = @"ZDCycleScrollCell";

#pragma mark - 初始化方法
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<ZDCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage {
    ZDCycleScrollView *cycleView = [[self alloc] initWithFrame:frame];
    cycleView.delegate = delegate;
    cycleView.placeholderImage = placeholderImage;
    return cycleView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initinitialization];
        [self setupMainView];
    }
    return self;
}

- (void)initinitialization {
    _autoScroll = YES;
    _autoScrollTimeInterval = 2.0;
    _showPageControl = YES;
    _infiniteLoop = YES;
    
}

#pragma mark - life circles
- (void)layoutSubviews
{
    self.delegate = self.delegate;
    
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    _mainView.frame = self.bounds;
}

#pragma mark - 初始化collectionView
- (void)setupMainView {
    self.backgroundColor = [UIColor clearColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout = layout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[ZDCycleScrollCell class] forCellWithReuseIdentifier:cellID];
    self.mainView = collectionView;
    
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    [self addSubview:self.mainView];
}

#pragma mark - collectionView delegate与DataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZDCycleScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    switch (self.datasouceType) {
        case ZDCycleScrollDataSouceTypeNet:
            
            break;
        case ZDCycleScrollDataSouceTypeLocal:
            cell.imageView.image = [UIImage imageNamed:self.imageNames[indexPath.row % self.imageNames.count]];
            break;
        default:
            break;
    }
    
    if (self.titleList && indexPath.row < self.titleList.count) {
        cell.title = self.titleList[indexPath.row];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCount;
}

- (void)setupTimer {
    [self invalidateTimer];// 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)automaticScroll {
    if (_itemCount == 0) {
        return;
    }
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(int)targetIndex {
    if (targetIndex >= _itemCount) {
        if (self.infiniteLoop) {
            targetIndex = _itemCount * 0.5;
            [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (int)currentIndex {
    if (_mainView.zd_width == 0 || _mainView.zd_height == 0) {
        return 0;
    }
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }else {
        index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    }
    return MAX(0, index);
}

#pragma mark - setter ----- getter

//- (NSInteger)itemCount {
//    if (self.imageNames) {
//        return self.imageNames.count;
//    }else if(self.imageUrlList) {
//        return self.imageUrlList.count;
//    }
//    return 0;
//}

- (void)setItemCount:(NSInteger)itemCount {
    _itemCount = self.infiniteLoop ? itemCount * 100 : itemCount;
}

- (void)setImageNames:(NSArray *)imageNames {
    _imageNames = imageNames;
    self.datasouceType = ZDCycleScrollDataSouceTypeLocal;
    self.itemCount = imageNames.count;
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setImageUrlList:(NSArray *)imageUrlList {
    _imageUrlList = imageUrlList;
    self.datasouceType = ZDCycleScrollDataSouceTypeNet;
    self.itemCount = imageUrlList.count;
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setDelegate:(id<ZDCycleScrollViewDelegate>)delegate {
    _delegate = delegate;
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    
}

@end
