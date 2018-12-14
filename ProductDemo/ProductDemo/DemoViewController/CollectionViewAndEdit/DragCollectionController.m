//
//  DragCollectionController.m
//  ProductDemo
//
//  Created by qizd on 2018/12/13.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "DragCollectionController.h"

#import "ZDCollectionViewCell.h"

typedef NS_ENUM(NSUInteger, DragCellDirection) {
    DragCellDirectionNone = 0,
    DragCellDirectionLeft,
    DragCellDirectionRight,
    DragCellDirectionUp,
    DragCellDirectionDown,
};

@interface DragCollectionController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *collectionData;
@property (nonatomic, retain) NSMutableArray<NSMutableArray *> *tableData;

@property (nonatomic, retain) NSIndexPath *originIndexPath;
@property (nonatomic, retain) UICollectionViewCell *orignalCell;
@property (nonatomic, retain) UICollectionView *originCollectionView;
@property (nonatomic, assign) CGPoint originCenter;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, retain) UIView *tmpMoveView;
@property (nonatomic, weak) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, retain) CADisplayLink *edgeTimer;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic) BOOL isDraging;


@end

@implementation DragCollectionController

NSString *const collectionReusId = @"collectionReusId";
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
        [collectionView registerClass:NSClassFromString(@"ZDCollectionViewCell") forCellWithReuseIdentifier:collectionReusId];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = 1;
        self.longPressGesture = longPress;
        [collectionView addGestureRecognizer:self.longPressGesture];
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
 *  手势在屏幕中的坐标转换到Collection
 */



/**
 *  监听手势的开始
 */
- (void)gestureBegan:(UILongPressGestureRecognizer *)longPressGesture {
    CGPoint pointInCollection = [longPressGesture locationInView:longPressGesture.view];
    UICollectionView *gestureView = (UICollectionView*)longPressGesture.view;
    self.originCollectionView = gestureView;
    NSIndexPath *oriIndexPath = [gestureView indexPathForItemAtPoint:pointInCollection];
    if (!oriIndexPath) {//oriIndexPath要存在，表示点击位置在cell里面
        return;
    }
    self.isDraging = YES;
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
    self.originCenter = cell.center;
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
    NSLog(@"________________________%@", NSStringFromCGPoint(self.lastPoint));
    //移动截图
    [UIView animateWithDuration:0.1 animations:^{
        self.tmpMoveView.center = self.lastPoint;
    }];
    NSIndexPath *index = [self getChangedIndexPath:longPressGesture];
    // 没有取到或者距离隐藏的最近时就返回
    if (!index) {
        return;
    }
    self.currentIndexPath = index;
    self.originCenter = [self.originCollectionView cellForItemAtIndexPath:_currentIndexPath].center;
    //更新数据
    [self updateSourceData];
    // 移动 会调用willMoveToIndexPath方法更新数据源
    [self.originCollectionView moveItemAtIndexPath:_originIndexPath toIndexPath:_currentIndexPath];
    
    self.originIndexPath = self.currentIndexPath;
    [self.originCollectionView reloadItemsAtIndexPaths:@[self.originIndexPath]];
    
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
    if (!self.originIndexPath) {
        return;
    }
    // 结束动画过程中停止交互，防止出问题
    self.originCollectionView.userInteractionEnabled = NO;
    UICollectionViewCell *cell = [self.originCollectionView cellForItemAtIndexPath:_originIndexPath];
    // 结束拖拽了
    self.isDraging = NO;
    // 给截图视图一个动画移动到隐藏cell的新位置
    [UIView animateWithDuration:0.25 animations:^{
        if (!cell) {
            self.tmpMoveView.center = self.originCenter;
        } else {
            self.tmpMoveView.center = cell.center;
        }
        self.tmpMoveView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.tmpMoveView.alpha = 1.0;
    } completion:^(BOOL finished) {
        // 移除截图视图、显示隐藏的cell并开启交互
        [self.tmpMoveView removeFromSuperview];
        self.tmpMoveView = nil;
        cell.hidden = NO;
        self.originCollectionView.userInteractionEnabled = YES;
    }];
    // 关闭定时器
    self.originIndexPath = nil;
    [self _stopEdgeTimer];
    
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

//监听是否拖动到边缘,并处理
- (void)moveCell {
    NSIndexPath *index = [self getChangedIndexPath:_longPressGesture];
    // 没有取到或者距离隐藏的最近时就返回
    if (!index) {
        return;
    }
    self.currentIndexPath = index;
    self.originCenter = [self.originCollectionView cellForItemAtIndexPath:_currentIndexPath].center;
    //更新数据
    [self updateSourceData];
    // 移动 会调用willMoveToIndexPath方法更新数据源
    [self.originCollectionView moveItemAtIndexPath:_originIndexPath toIndexPath:_currentIndexPath];
    
    self.originIndexPath = self.currentIndexPath;
    [self.originCollectionView reloadItemsAtIndexPaths:@[self.originIndexPath]];
}

- (void)_edgeScroll {
    DragCellDirection dirction =  DragCellDirectionNone;//[self getDragDirection];
    NSLog(@"+++++++++++++++++++%@", NSStringFromCGPoint(self.lastPoint));
    switch (dirction) {
        case DragCellDirectionLeft:{
            //这里的动画必须设为NO
            [self.originCollectionView setContentOffset:CGPointMake(self.originCollectionView.contentOffset.x - 4, self.originCollectionView.contentOffset.y) animated:NO];
            self.tmpMoveView.center = CGPointMake(self.tmpMoveView.center.x - 4, self.tmpMoveView.center.y);
            _lastPoint.x -= 4;
        }
            break;
        case DragCellDirectionRight:{
            [self.originCollectionView setContentOffset:CGPointMake(self.originCollectionView.contentOffset.x + 4, self.originCollectionView.contentOffset.y) animated:NO];
            self.tmpMoveView.center = CGPointMake(self.tmpMoveView.center.x + 4, self.tmpMoveView.center.y);
            _lastPoint.x += 4;
        }
            break;
        case DragCellDirectionDown:{
            [self.originCollectionView setContentOffset:CGPointMake(self.originCollectionView.contentOffset.x, self.originCollectionView.contentOffset.y - 4) animated:NO];
            self.tmpMoveView.center = CGPointMake(self.tmpMoveView.center.x, self.tmpMoveView.center.y - 4);
            _lastPoint.y -= 4;
        }
            break;
        case DragCellDirectionUp:{
            [self.originCollectionView setContentOffset:CGPointMake(self.originCollectionView.contentOffset.x, self.originCollectionView.contentOffset.y + 4) animated:NO];
            self.tmpMoveView.center = CGPointMake(self.tmpMoveView.center.x, self.tmpMoveView.center.y + 4);
            _lastPoint.y += 4;
        }
            break;
            
        default:
            break;
    }
    
}

- (DragCellDirection)getDragDirection {
    if (self.originCollectionView.bounds.size.height + self.originCollectionView.contentOffset.y - self.tmpMoveView.center.y < self.tmpMoveView.bounds.size.height / 2 && self.originCollectionView.bounds.size.height + self.originCollectionView.contentOffset.y < self.originCollectionView.contentSize.height) {
        return DragCellDirectionDown;
    } else if (self.tmpMoveView.center.y - self.originCollectionView.contentOffset.y < self.tmpMoveView.bounds.size.height / 2 && self.originCollectionView.contentOffset.y > 0) {
        return DragCellDirectionUp;
    } else if (self.originCollectionView.bounds.size.width + self.originCollectionView.contentOffset.x - self.tmpMoveView.center.x < self.tmpMoveView.bounds.size.width / 2 && self.originCollectionView.bounds.size.width + self.originCollectionView.contentOffset.x < self.originCollectionView.contentSize.width) {
        return DragCellDirectionRight;
    } else if (self.tmpMoveView.center.x - self.originCollectionView.contentOffset.x < self.tmpMoveView.bounds.size.width / 2 && self.originCollectionView.contentOffset.x > 0) {
        return DragCellDirectionLeft;
    }
    return DragCellDirectionNone;
}


#pragma mark - CollectionView delegate and DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tableData[collectionView.tag].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionReusId forIndexPath:indexPath];
    /*
     注意:
     UICollectioncView的cell和UITableView的cell不太一样,
     UITableView有默认的子控件
     UICollectionViewCell除了contentView以外, 没有提供默认的子控件
     设置UICollectionViewCell需要自定义 最好结合Xib使用
     */
    // 2.使用
    cell.backgroundColor = [UIColor greenColor];
    cell.content = [NSString stringWithFormat:@"%@", self.tableData[collectionView.tag][indexPath.row]];
    if (self.isDraging) {
        cell.hidden = self.originIndexPath && self.originIndexPath.item == indexPath.item && self.originIndexPath.section == indexPath.section;
    } else {
        cell.hidden = NO;
    }
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

#pragma mark - 更新数据
- (void)updateSourceData {
    NSMutableArray *changedArray = self.tableData[self.originCollectionView.tag].mutableCopy;
    if (_currentIndexPath.section == _originIndexPath.section) {
        NSMutableArray *orignalSection = changedArray;
        if (_currentIndexPath.item > _originIndexPath.item) {
            for (NSUInteger i = _originIndexPath.item; i < _currentIndexPath.item ; i ++) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
            }
        } else {
            for (NSUInteger i = _originIndexPath.item; i > _currentIndexPath.item ; i --) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
            }
        }
    } else {
        NSMutableArray *orignalSection = changedArray[_originIndexPath.section];
        NSMutableArray *currentSection = changedArray[_currentIndexPath.section];
        [currentSection insertObject:orignalSection[_originIndexPath.item] atIndex:_currentIndexPath.item];
        [orignalSection removeObjectAtIndex:_originIndexPath.item];
    }
    [self.tableData replaceObjectAtIndex:self.originCollectionView.tag withObject:changedArray];
}

@end
