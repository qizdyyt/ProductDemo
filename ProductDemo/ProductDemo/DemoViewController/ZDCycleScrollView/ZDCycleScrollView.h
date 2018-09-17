//
//  ZDCycleScrollView.h
//  ProductDemo
//
//  Created by qizd on 2018/9/5.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZDCycleScrollViewDelegate <NSObject>

@end

@interface ZDCycleScrollView : UIView

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<ZDCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;


//////////////////////  数据源API //////////////////////

//图片URL或者name数组
@property (nonatomic, strong) NSArray *imageUrlList;
@property (nonatomic, strong) NSArray *imageNames;

/**显示的标签列表 */
@property (nonatomic, strong) NSArray *titleList;

//////////////////////  滚动控制API //////////////////////

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

//////////////////////  监听回调API //////////////////////
@property (nonatomic, weak) id<ZDCycleScrollViewDelegate> delegate;
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);

/** block方式监听滚动 */
@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);

/** 可以调用此方法手动控制滚动到哪一个index */
- (void)makeScrollViewScrollToIndex:(NSInteger)index;

/** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
- (void)adjustWhenControllerViewWillAppera;

//////////////////////  自定义样式API  //////////////////////

/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;

/** 是否显示分页控件，默认YES */
@property (nonatomic, assign) BOOL showPageControl;

/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;

@end
