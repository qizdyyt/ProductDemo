//
//  PresentTransition.m
//  ProductDemo
//
//  Created by qizd on 2018/7/11.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "PresentTransition.h"


@implementation PresentTransition 

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //转场的容器图，动画完成之后会消失
    UIView *container = [transitionContext containerView];
    
    UIView *fromView;
    UIView *toView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }else{
        fromView = fromVC.view;
        toView = toVC.view;
    }
    //对应关系
    BOOL isPresent = (toVC.presentingViewController == fromVC);
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
    
    if (isPresent) {
        fromView.frame = fromFrame;
        toView.frame = CGRectOffset(toFrame, toFrame.size.width, 0);
    }
    
    if (isPresent) {
        [container addSubview:toView];
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresent) {
            toView.frame = toFrame;
            fromView.frame = CGRectOffset(fromFrame, fromFrame.size.width*0.3*-1, 0);
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        
        if (wasCancelled)
            [toView removeFromSuperview];
        
        [transitionContext completeTransition:!wasCancelled];
    }];
    
    
    
    /*********/
    /*
     [container addSubview:toVC.view];
     [container bringSubviewToFront:fromVC.view];
    //改变m34
    CATransform3D transfrom = CATransform3DIdentity;
    transfrom.m34 = -0.002;
    container.layer.sublayerTransform = transfrom;
    
    //设置archPoint和position
    CGRect initalFrame = [transitionContext initialFrameForViewController:fromVC];
    toVC.view.frame = initalFrame;
    fromVC.view.frame = initalFrame;
    fromVC.view.layer.anchorPoint = CGPointMake(0, 0.5);
    fromVC.view.layer.position = CGPointMake(0, initalFrame.size.height / 2.0);
    
    //添加阴影效果--渐变颜色图层
    CAGradientLayer *shadowLayer = [[CAGradientLayer alloc] init];
    shadowLayer.colors = @[[UIColor colorWithWhite:0 alpha:1],
                           [UIColor colorWithWhite:0 alpha:0.5],
                           [UIColor colorWithWhite:1 alpha:0.5]];
    shadowLayer.startPoint = CGPointMake(0, 0.5);
    shadowLayer.endPoint = CGPointMake(1, 0.5);
    shadowLayer.frame = initalFrame;
    
    UIView *shadow = [[UIView alloc] initWithFrame:initalFrame];
    shadow.backgroundColor = [UIColor clearColor];
    [shadow.layer addSublayer:shadowLayer];
    [fromVC.view addSubview:shadow];
    shadow.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
        shadow.alpha = 1.0;
    } completion:^(BOOL finished) {
        fromVC.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
        fromVC.view.layer.position = CGPointMake(CGRectGetMidX(initalFrame), CGRectGetMidY(initalFrame));
        fromVC.view.layer.transform = CATransform3DIdentity;
        [shadow removeFromSuperview];
        
        [transitionContext completeTransition:YES];
    }];
    */
    /*********/
    
    
    
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}
@end
