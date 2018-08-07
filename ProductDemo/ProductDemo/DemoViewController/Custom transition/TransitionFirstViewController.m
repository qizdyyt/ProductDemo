//
//  TransitionFirstViewController.m
//  ProductDemo
//
//  Created by qizd on 2018/7/11.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "TransitionFirstViewController.h"
#import "TransitionSecondViewController.h"
#import "PresentTransition.h"
#import "DismissTransition.h"

@interface TransitionFirstViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIImageView *imageView;

@property (retain, nonatomic) UIPercentDrivenInteractiveTransition *percentDrivenTransition;
@end

@implementation TransitionFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.imageView];
    [self.imageView setImage:[UIImage imageNamed:@"bg1.png"]];
    [self.button setTitle:@"Custom Present" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    
    //
    self.transitioningDelegate = self;
}

- (void)jump {
    TransitionSecondViewController *secVC = [[TransitionSecondViewController alloc] init];
    secVC.transitioningDelegate = self;
    [self addScreenLeftEdgePanGestureRecognizer:secVC.view];
    [self presentViewController:secVC animated:YES completion:^{
        
    }];
}

- (void)addScreenLeftEdgePanGestureRecognizer:(UIView *)view{
    UIScreenEdgePanGestureRecognizer *screenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    screenEdgePan.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:screenEdgePan];
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan{
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].keyWindow].x/[UIApplication sharedApplication].keyWindow.bounds.size.width);
    if (edgePan.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        if (edgePan.edges == UIRectEdgeLeft) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else if (edgePan.state == UIGestureRecognizerStateChanged){
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    }else if (edgePan.state == UIGestureRecognizerStateEnded || edgePan.state == UIGestureRecognizerStateCancelled){
        if (progress > 0.5) {
            [_percentDrivenTransition finishInteractiveTransition];
        }else{
            [_percentDrivenTransition cancelInteractiveTransition];
        }
        _percentDrivenTransition = nil;
    }
}

//present 动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[PresentTransition alloc] init];
}
//dismiss 动画 也要实现，否则变成默认的了
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[DismissTransition alloc] init];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _percentDrivenTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _percentDrivenTransition;
}


#pragma mark ----setter and getter
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(ScreenWidth / 2, ScreenHeight / 2, 50, ScreenWidth);
        _button.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
        [self.view addSubview:_button];
    }
    return _button;
}


@end
