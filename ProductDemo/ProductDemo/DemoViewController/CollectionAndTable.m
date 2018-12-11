//
//  CollectionAndTable.m
//  ProductDemo
//
//  Created by qizd on 2018/12/11.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "CollectionAndTable.h"
#import "ZDCollectionViewCell.h"

@interface CollectionAndTable ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *collectionData;
@property (nonatomic, retain) NSMutableArray<NSMutableArray *> *tableData;

@property (nonatomic, retain) NSIndexPath *originIndexPath;
@property (nonatomic, retain) UICollectionViewCell *orignalCell;
@property (nonatomic, assign) CGPoint originCenter;
@property (nonatomic, strong) NSIndexPath *moveIndexPath;

@property (nonatomic, retain) UIView *tmpMoveView;
@property (nonatomic, weak) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, retain) CADisplayLink *edgeTimer;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic) BOOL isPanning;


@end

@implementation CollectionAndTable

NSString *const collectionId = @"collectionId";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.6) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - TableView delegate and DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellId = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        //添加CollectionView
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
        layout.itemSize = CGSizeMake(100, 100);
        //估算的尺寸(一般不需要设置)
        //    layout.estimatedItemSize = CGSizeMake(100, 100);
        //头部的参考尺寸(就是尺寸)----个人测试只有一个方向的长度生效，另外一个随便都没啥效果。。
        layout.headerReferenceSize = CGSizeMake(10, 100);
        //尾部的参考尺寸
        layout.footerReferenceSize = CGSizeMake(10, 100);
        //设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
        if (@available(iOS 9.0, *)) {
            layout.sectionFootersPinToVisibleBounds = YES;
            layout.sectionHeadersPinToVisibleBounds = YES;
        }
        // 设置额外滚动区域
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        //设置滚动条
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        //设置是否需要弹簧效果
        collectionView.bounces = YES;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.tag = indexPath.row;
        [cell.contentView addSubview:collectionView];
        if (@available(iOS 10.0, *)) {
            collectionView.prefetchingEnabled = NO;
        } else {
            // Fallback on earlier versions
        }
        [collectionView registerClass:NSClassFromString(@"ZDCollectionViewCell") forCellWithReuseIdentifier:collectionId];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = 1;
        [collectionView addGestureRecognizer:longPress];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

/**
 *  监听手势的改变
 */
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture {
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        [self gestureBegan:longPressGesture];
    }
    if (longPressGesture.state == UIGestureRecognizerStateChanged) {
        [self gestureChanged:longPressGesture];
    }
    if (longPressGesture.state == UIGestureRecognizerStateCancelled ||
        longPressGesture.state == UIGestureRecognizerStateEnded){
        [self gestureEndOrCancle:longPressGesture];
    }
}
/**
 *  监听手势的开始
 */
- (void)gestureBegan:(UILongPressGestureRecognizer *)longPressGesture {
    CGPoint pointInCollection = [longPressGesture locationInView:longPressGesture.view];
    UICollectionView *gestureView = (UICollectionView*)longPressGesture.view;
    NSIndexPath *oriIndexPath = [gestureView indexPathForItemAtPoint:pointInCollection];
    NSLog(@"%@", oriIndexPath);
    if (!oriIndexPath) {//oriIndexPath要存在，表示点击位置在cell里面
        return;
    }
    self.originIndexPath = oriIndexPath;
    UICollectionViewCell *cell = [gestureView cellForItemAtIndexPath:oriIndexPath];
    if(self.tmpMoveView) {
        self.tmpMoveView = nil;
    }
//    UIImage *snap;
//    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, 1.0f, 0);
//    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
//    snap = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIView *tempMoveCell = [UIView new];
//    tempMoveCell.layer.contents = (__bridge id)snap.CGImage;
//    self.tmpMoveView = tempMoveCell;
    self.tmpMoveView = [cell snapshotViewAfterScreenUpdates:NO];
    [gestureView addSubview:self.tmpMoveView];
    //隐藏原来cell
    cell.hidden = YES;
    self.orignalCell = cell;
    self.tmpMoveView.frame = cell.frame;
    //动画放大并移动到触摸点下
    [UIView animateWithDuration:0.25 animations:^{
        self.tmpMoveView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.tmpMoveView.center = CGPointMake(pointInCollection.x, pointInCollection.y);
        self.tmpMoveView.alpha = 0.6;
    }];
}
/**
 *  监听手势的移动
 */
- (void)gestureChanged:(UILongPressGestureRecognizer *)longPressGesture {
    if (!_edgeTimer) {
        [self _setEdgeTimer];
    }
    //当前手指位置
    self.lastPoint = [longPressGesture locationInView:longPressGesture.view];
    //移动截图
    [UIView animateWithDuration:0.1 animations:^{
        self.tmpMoveView.center = self.lastPoint;
    }];
    NSIndexPath *index = [self getChangedIndexPath:longPressGesture];
    // 没有取到或者距离隐藏的最近时就返回
    if (!index) {
        return;
    }
    
}

//获得移动后应该交换位置的对应indexPath
- (nullable NSIndexPath *)getChangedIndexPath:(UILongPressGestureRecognizer *)longPressGesture {
    UICollectionView *collectionView = (UICollectionView *)longPressGesture.view;
    __block NSIndexPath *index = nil;
    __block CGFloat length = MAXFLOAT;
    for (UICollectionViewCell *cell in collectionView.visibleCells) {
        if (CGRectContainsPoint(cell.frame, self.lastPoint)) {
            index = [collectionView indexPathForCell:cell];
        }
    }
    //找到且不是当前的cell，返回这个index
    if (index){
        if (index.row == self.originIndexPath.row && index.section == self.originIndexPath.section) {
            return nil;
        }
        return index;
    }
    
    //查找最应该交换的cell
    __weak typeof(self) weakSelf = self;
    [[collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) self = weakSelf;
        CGPoint p1 = self.tmpMoveView.center;
        CGPoint p2 = obj.center;
        CGFloat distance = sqrt(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2));
        if (distance < length) {
            length = distance;
            index = [collectionView indexPathForCell:obj];
        }
    }];
    if (!index) {
        return nil;
    }
    if ((index.item == self.originIndexPath.item) && (index.row == self.originIndexPath.row)) {
        // 最近的就是隐藏的Cell时,return nil
        return nil;
    }
    return index;
}
/**
 *  监听手势的取消或结束
 */
- (void)gestureEndOrCancle:(UILongPressGestureRecognizer *)longPressGesture {
    
}

#pragma - mark timer
- (void)_setEdgeTimer{
    if (!_edgeTimer) {
        _edgeTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(_edgeScroll)];
        [_edgeTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)_stopEdgeTimer{
    if (_edgeTimer) {
        [_edgeTimer invalidate];
        _edgeTimer = nil;
    }
}


#pragma mark - CollectionView delegate and DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tableData[collectionView.tag].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionId forIndexPath:indexPath];
    /*
     注意:
     UICollectioncView的cell和UITableView的cell不太一样,
     UITableView有默认的子控件
     UICollectionViewCell除了contentView以外, 没有提供默认的子控件
     设置UICollectionViewCell需要自定义 最好结合Xib使用
     */
    // 2.使用
    cell.backgroundColor = [UIColor greenColor];
    cell.content = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    // 3.返回
    return cell;
    
}

//-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id obj = [_collectionData objectAtIndex:sourceIndexPath.item];
    [_collectionData removeObject:obj];
    [_collectionData insertObject:obj atIndex:destinationIndexPath.item];
    //    [self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

#pragma mark - 初始化数据
- (void)initData {
    self.collectionData = [NSMutableArray array];
    for (int i = 0; i < 15; i++) {
        [self.collectionData addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.tableData = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        [self.tableData addObject:self.collectionData];
    }
}
@end
