//
//  CollectionAndTable.m
//  ProductDemo
//
//  Created by qizd on 2018/12/11.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "CollectionAndTable.h"
#import "ZDCollectionViewCell.h"

typedef NS_ENUM(NSUInteger, DragCellDirection) {
    DragCellDirectionNone = 0,
    DragCellDirectionLeft,
    DragCellDirectionRight,
    DragCellDirectionUp,
    DragCellDirectionDown,
};

@interface CollectionAndTable ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *collectionData;
@property (nonatomic, retain) NSMutableArray<NSMutableArray *> *tableData;
@property (nonatomic, retain) NSMutableArray<NSValue *> *collectionOffsets;

@property (nonatomic, retain) NSIndexPath *originCollectionIndexPath;
@property (nonatomic, strong) NSIndexPath *currentCollectionIndexPath;
@property (nonatomic, retain) UICollectionViewCell *orignalCollectionCell;

@property (nonatomic, assign) CGPoint originCollectionPoint; //原始的点击中心
@property (nonatomic, assign) CGPoint originTablePoint; //原始的点击中心


@property (nonatomic, retain) UIView *tmpMoveView;
@property (nonatomic, weak) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, retain) CADisplayLink *edgeTimer;
@property (nonatomic, assign) CGPoint lastTablePoint; //最后的点击中心
@property (nonatomic, assign) CGPoint lastCollectionPoint; //最后的点击中心
@property (nonatomic) BOOL isDraging;

@property (nonatomic, retain) NSIndexPath *oriTableIndex; //原始的在table的index
@property (nonatomic, retain) NSIndexPath *currentTableIndex;

@property (nonatomic, retain) UICollectionView *originCollectionView;
@property (nonatomic, retain) UICollectionView *currentCollectionView;

@property (nonatomic, assign) CGFloat checkTimeInterval;
@property (nonatomic, retain) NSDate *preStartMoveTime;
@end

@implementation CollectionAndTable

NSString *const collectionId = @"collectionId";
NSUInteger addTag = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight * 0.6) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //长按手势添加到tableView中
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1;
    self.longPressGesture = longPress;
    [self.tableView addGestureRecognizer:self.longPressGesture];
    self.preStartMoveTime = [NSDate date];
    self.checkTimeInterval = 500;
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
        [cell.contentView addSubview:collectionView];
        if (@available(iOS 10.0, *)) {
            collectionView.prefetchingEnabled = NO;
        } else {
            // Fallback on earlier versions
        }
        [collectionView registerClass:NSClassFromString(@"ZDCollectionViewCell") forCellWithReuseIdentifier:collectionId];
        
    }
    UICollectionView *collectionView = (UICollectionView *)(cell.contentView.subviews[0]);
    collectionView.tag = indexPath.row + addTag;
    [collectionView reloadData];
    [collectionView setContentOffset:[self.collectionOffsets[indexPath.row] CGPointValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionView *collectionView = (UICollectionView *)(cell.contentView.subviews[0]);
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

#pragma mark - gesture
/**
 *  监听手势的改变
 */
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture {
    //修改对应的手势改变
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
    CGPoint pointInTable = [longPressGesture locationInView:longPressGesture.view];
    UITableView *gestureView = (UITableView*)longPressGesture.view;
    //找到最初点击的table的celle和它的位置
    self.oriTableIndex = [gestureView indexPathForRowAtPoint:pointInTable];
    if (!self.oriTableIndex) {
        return;
    }
    self.originTablePoint = pointInTable;
    UITableViewCell *oriTableCell = [self.tableView cellForRowAtIndexPath:self.oriTableIndex];
    //找到点击cell里的Collection和对应的cell
    self.originCollectionView = [oriTableCell viewWithTag:self.oriTableIndex.row + addTag];
    CGPoint pointInCollection = [self.tableView convertPoint:pointInTable toView:self.originCollectionView];
    
    NSIndexPath *oriCollectionIndex = [self.originCollectionView indexPathForItemAtPoint:pointInCollection];
    
    if (!oriCollectionIndex) {//oriIndexPath要存在，表示点击位置在cell里面
        return;
    }
    self.isDraging = YES;
    self.originCollectionIndexPath = oriCollectionIndex;
    UICollectionViewCell *touchedCollectionCell = [self.originCollectionView cellForItemAtIndexPath:oriCollectionIndex];
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
    self.tmpMoveView = [touchedCollectionCell snapshotViewAfterScreenUpdates:NO];
    [gestureView addSubview:self.tmpMoveView];
    //隐藏原来cell
    touchedCollectionCell.hidden = YES;
    self.orignalCollectionCell = touchedCollectionCell;
    self.originCollectionPoint = touchedCollectionCell.center;
    
    CGRect tmpFrame = [self.originCollectionView convertRect:touchedCollectionCell.frame toView:self.tableView];
    self.tmpMoveView.frame = tmpFrame;
    //动画放大并移动到触摸点下
    [UIView animateWithDuration:0.25 animations:^{
        self.tmpMoveView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.tmpMoveView.center = CGPointMake(pointInTable.x, pointInTable.y);
        self.tmpMoveView.alpha = 0.6;
    }];
    
    self.currentCollectionView = self.originCollectionView;
    self.currentCollectionIndexPath = self.originCollectionIndexPath;
    self.currentTableIndex = self.oriTableIndex;
    self.lastTablePoint = self.originTablePoint;
    self.lastCollectionPoint = self.originCollectionPoint;
}
/**
 *  监听手势的移动
 */
- (void)gestureChanged:(UILongPressGestureRecognizer *)longPressGesture {
    if ([[NSDate date] timeIntervalSinceDate:self.preStartMoveTime] < 0.1) {
        return;
    }
    //需要触摸到具体的cell中，才是有效的手势
    if (!self.originCollectionIndexPath) {
        return;
    }
    if (!_edgeTimer) {
        [self _setEdgeTimer];
    }
    //当前手指位置
    self.lastTablePoint = [longPressGesture locationInView:longPressGesture.view];
    //移动截图
    [UIView animateWithDuration:0.1 animations:^{
        self.tmpMoveView.center = self.lastTablePoint;
    }];
    //计算获取要交换的index
    NSIndexPath *index = [self getChangedIndexPath:longPressGesture];
    
    // 没有取到或者距离隐藏的最近时就返回
    if (!index) {
        return;
    }
    self.currentCollectionIndexPath = index;
    
    //将当前的中心点更新tableView和Collection的原始点
    self.originCollectionPoint = [self.currentCollectionView cellForItemAtIndexPath:self.currentCollectionIndexPath].center;
    self.originTablePoint = [self.currentCollectionView convertPoint:self.originCollectionPoint toView:self.tableView];
    
    //更新数据
    [self updateSourceData];
    //更新cell，同时更新原始的index和View
    if (self.currentTableIndex.row != self.oriTableIndex.row) {
        //如果是不同的Collection一个插入，一个删除
        
        [self.currentCollectionView insertItemsAtIndexPaths:@[self.currentCollectionIndexPath]];
        [self.currentCollectionView reloadItemsAtIndexPaths:@[self.currentCollectionIndexPath]];
        
        [self.originCollectionView deleteItemsAtIndexPaths:@[self.originCollectionIndexPath]];
        [self.originCollectionView reloadData];
        self.originCollectionIndexPath = self.currentCollectionIndexPath;
        self.originCollectionView = self.currentCollectionView;
        
        self.oriTableIndex = self.currentTableIndex;
    } else {
        //如果在一个Collection，移动cell
        [self.originCollectionView moveItemAtIndexPath:self.originCollectionIndexPath toIndexPath:self.currentCollectionIndexPath];
        [self.originCollectionView reloadItemsAtIndexPaths:@[self.currentCollectionIndexPath]];
        self.originCollectionIndexPath = self.currentCollectionIndexPath;
    }
    
}

//获得移动后应该交换位置的对应indexPath
- (nullable NSIndexPath *)getChangedIndexPath:(UILongPressGestureRecognizer *)longPressGesture {
    
    //获得当前的tableindex和tablecell
    self.tableView = (UITableView *)longPressGesture.view;
    self.currentTableIndex = [self.tableView indexPathForRowAtPoint:self.lastTablePoint];
    if (!self.currentTableIndex) {
        return nil;
    }
    UITableViewCell *currentTableCell = [self.tableView cellForRowAtIndexPath:self.currentTableIndex];
    
    //获得当前的Collection
    self.currentCollectionView = (UICollectionView *)[currentTableCell viewWithTag:self.currentTableIndex.row + addTag];
    self.lastCollectionPoint = [self.tableView convertPoint:self.lastTablePoint toView:self.currentCollectionView];
    
    __block NSIndexPath *index = nil;
    __block CGFloat length = MAXFLOAT;
    for (UICollectionViewCell *cell in self.currentCollectionView.visibleCells) {
        if (CGRectContainsPoint(cell.frame, self.lastCollectionPoint)) {
            index = [self.currentCollectionView indexPathForCell:cell];
        }
    }
    //判断这个Index是否需要返回
    if (index){
        //不同的tablecell，必返回
        if (self.currentTableIndex.row != self.oriTableIndex.row) {
            return index;
        }
        //找到且不是当前的cell，返回这个index
        if (index.row == self.originCollectionIndexPath.row && index.section == self.originCollectionIndexPath.section) {
            return nil;
        }
        return index;
    }
    
    //查找最应该交换的cell
    __weak typeof(self) weakSelf = self;
    [[self.currentCollectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) self = weakSelf;
        CGPoint p1 = self.lastCollectionPoint;
        CGPoint p2 = obj.center;
        CGFloat distance = sqrt(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2));
        if (distance < length) {
            length = distance;
            index = [self.currentCollectionView indexPathForCell:obj];
        }
    }];
    if (!index) {
        return nil;
    }
    
    //不同的tablecell，必返回
    if (self.currentTableIndex.row != self.oriTableIndex.row) {
        return index;
    }
    if ((index.item == self.originCollectionIndexPath.item) && (index.row == self.originCollectionIndexPath.row)) {
        // 最近的就是隐藏的Cell时,return nil
        return nil;
    }
    return index;
}
/**
 *  监听手势的取消或结束
 */
- (void)gestureEndOrCancle:(UILongPressGestureRecognizer *)longPressGesture {
    if (!self.originCollectionIndexPath) {
        return;
    }
    // 结束动画过程中停止交互，防止出问题
    self.originCollectionView.userInteractionEnabled = NO;
    UICollectionViewCell *cell = [self.originCollectionView cellForItemAtIndexPath:self.originCollectionIndexPath];
    // 结束拖拽了
    self.isDraging = NO;
    
    
    // 给截图视图一个动画移动到隐藏cell的新位置
    [UIView animateWithDuration:0.25 animations:^{
        if (!cell) {
            self.tmpMoveView.center = self.originTablePoint;
        } else {
            CGPoint tmpCenter = [self.originCollectionView convertPoint:cell.center toView:self.tableView];
            self.tmpMoveView.center = tmpCenter;
        }
        self.tmpMoveView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.tmpMoveView.alpha = 1.0;
    } completion:^(BOOL finished) {
        // 移除截图视图、显示隐藏的cell并开启交互
        [self.tmpMoveView removeFromSuperview];
        self.tmpMoveView = nil;
        cell.hidden = NO;
        self.originCollectionView.userInteractionEnabled = YES;
        
        [self.collectionOffsets replaceObjectAtIndex:self.originCollectionView.tag - addTag withObject:[NSValue valueWithCGPoint:self.originCollectionView.contentOffset]];
    }];
    
    self.originCollectionIndexPath = nil;
    self.currentCollectionIndexPath = nil;
    self.oriTableIndex = nil;
    self.currentTableIndex = nil;
    
    // 关闭定时器
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

- (void)_edgeScroll {
    DragCellDirection dirction =  [self getDragDirection];
    switch (dirction) {
        case DragCellDirectionLeft:{
            if (self.originCollectionView.contentOffset.x <= 0) {
                return;
            }
            //这里的动画必须设为NO
            [self.originCollectionView setContentOffset:CGPointMake(self.originCollectionView.contentOffset.x - 4, self.originCollectionView.contentOffset.y) animated:NO];
            //在自动滚动过程中，实时的属性位置
            [self gestureChanged:self.longPressGesture];
            
        }
            break;
        case DragCellDirectionRight:{
            if (self.originCollectionView.contentOffset.x >= self.originCollectionView.contentSize.width - self.originCollectionView.frame.size.width) {
                return;
            }
            [self.originCollectionView setContentOffset:CGPointMake(self.originCollectionView.contentOffset.x + 4, self.originCollectionView.contentOffset.y) animated:NO];
            [self gestureChanged:self.longPressGesture];
        }
            break;
        case DragCellDirectionDown:{
            if (self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.frame.size.height) {
                return;
            }
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + 4) animated:NO];
            [self gestureChanged:self.longPressGesture];
        }
            break;
        case DragCellDirectionUp:{
            if (self.tableView.contentOffset.y <= 0) {
                return;
            }
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y - 4) animated:NO];
            [self gestureChanged:self.longPressGesture];
        }
            break;

        default:
            break;
    }
}

- (DragCellDirection)getDragDirection {
    CGFloat limitGap = self.tmpMoveView.frame.size.width * 0.75 * 0.5;
    CGFloat gapRight = self.tableView.frame.size.width - self.lastTablePoint.x;
    CGFloat gapLeft = self.lastTablePoint.x;
    //此时lastTablePoint对应的是在TableView的ContentSize中的位置，需要计算
    CGFloat gapBottom = self.tableView.frame.size.height - (self.lastTablePoint.y - self.tableView.contentOffset.y);
    CGFloat gapTop = self.lastTablePoint.y - self.tableView.contentOffset.y;
    
    //要求超过四分之一，且触摸点距离左边的距离小于距离上边与下边的距离
    if (gapLeft < limitGap && gapLeft < gapTop && gapLeft < gapBottom) {
        return DragCellDirectionLeft;
    }
    
    if (gapRight < limitGap && gapRight < gapTop && gapRight < gapBottom) {
        return DragCellDirectionRight;
    }
    
    if (gapBottom < limitGap && gapBottom < gapRight && gapBottom < gapLeft) {
        return DragCellDirectionDown;
    }
    
    if (gapTop < limitGap && gapTop < gapRight && gapTop < gapLeft) {
        return DragCellDirectionUp;
    }
    return DragCellDirectionNone;
}


#pragma mark - CollectionView delegate and DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tableData[collectionView.tag - addTag].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    cell.content = [NSString stringWithFormat:@"%@", self.tableData[collectionView.tag - addTag][indexPath.row]];
    if (self.isDraging) {
        if (self.originCollectionView.tag == self.currentCollectionView.tag) {
            //修复上下拖动时cell不显示
            if (collectionView.tag == self.currentCollectionView.tag) {
                cell.hidden = self.currentCollectionIndexPath && self.currentCollectionIndexPath.item == indexPath.item && self.currentCollectionIndexPath.section == indexPath.section;
            }else {
                cell.hidden = NO;
            }
            
        }else {
            if (collectionView.tag == self.currentCollectionView.tag) {
                cell.hidden = self.currentCollectionIndexPath && self.currentCollectionIndexPath.item == indexPath.item && self.currentCollectionIndexPath.section == indexPath.section;
            } else {
                cell.hidden = NO;
            }
        }
//        NSLog(@"%ld, ----%ld, %ld, %@, %@", collectionView.tag, (long)self.originCollectionView.tag, self.currentCollectionView.tag, self.currentCollectionIndexPath, indexPath);
        
    } else {
        cell.hidden = NO;
    }
    // 3.返回
    return cell;
    
}

//-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    id obj = [_collectionData objectAtIndex:sourceIndexPath.item];
//    [_collectionData removeObject:obj];
//    [_collectionData insertObject:obj atIndex:destinationIndexPath.item];
//    //    [self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
//}

#pragma mark - Scroll delegate
//消耗太大
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if ([scrollView isKindOfClass:[UICollectionView class]]) {
//        NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
//        NSLog(@"22222222222222%@", NSStringFromCGPoint(scrollView.contentOffset));
        [self.collectionOffsets replaceObjectAtIndex:scrollView.tag - addTag withObject:[NSValue valueWithCGPoint:scrollView.contentOffset]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
//        NSLog(@"33333333333333%@", NSStringFromCGPoint(scrollView.contentOffset));
        [self.collectionOffsets replaceObjectAtIndex:scrollView.tag - addTag withObject:[NSValue valueWithCGPoint:scrollView.contentOffset]];
    }
}

#pragma mark - 初始化数据
- (void)initData {
    self.collectionData = [NSMutableArray array];
    self.collectionOffsets = [NSMutableArray array];
    for (int i = 0; i < 15; i++) {
        [self.collectionData addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.tableData = [NSMutableArray array];
    for (int i = 0; i < 15; i++) {
        [self.tableData addObject:self.collectionData];
        [self.collectionOffsets addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
    }
    
}

#pragma mark - 更新数据
- (void)updateSourceData {
    NSMutableArray *oriArray = self.tableData[self.originCollectionView.tag - addTag].mutableCopy;
    if (self.originCollectionView.tag != self.currentCollectionView.tag) {
        
        NSMutableArray *curArray = self.tableData[self.currentCollectionView.tag - addTag].mutableCopy;
        [curArray insertObject:oriArray[self.originCollectionIndexPath.item] atIndex:self.currentCollectionIndexPath.item];
        [oriArray removeObjectAtIndex: self.originCollectionIndexPath.item];
        
        [self.tableData replaceObjectAtIndex:(self.currentCollectionView.tag - addTag) withObject:curArray];
    } else {
        if (self.currentCollectionIndexPath.item > self.originCollectionIndexPath.item) {
            for (NSUInteger i = self.originCollectionIndexPath.item; i < self.currentCollectionIndexPath.item ; i ++) {
                [oriArray exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
            }
        } else {
            for (NSUInteger i = self.originCollectionIndexPath.item; i > self.currentCollectionIndexPath.item ; i --) {
                [oriArray exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
            }
        }
    }
    [self.tableData replaceObjectAtIndex:(self.originCollectionView.tag - addTag) withObject:oriArray];
}

@end
