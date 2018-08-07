//
//  DismissTransition.m
//  ProductDemo
//
//  Created by qizd on 2018/7/11.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "DismissTransition.h"

@implementation DismissTransition

/** 动画时间 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *fromView;
    UIView *toView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }else{
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    BOOL isDismiss = (fromViewController.presentingViewController == toViewController);
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    if (isDismiss) {
        fromView.frame = fromFrame;
        toView.frame = CGRectOffset(toFrame, toFrame.size.width*0.3*-1, 0);
    }
    
    if (isDismiss) {
        [containerView insertSubview:toView belowSubview:fromView];
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isDismiss) {
            toView.frame = toFrame;
            fromView.frame = CGRectOffset(fromFrame, fromFrame.size.width, 0);
        }
    } completion:^(BOOL finished) {
        BOOL wasCancel = [transitionContext transitionWasCancelled];
        if (wasCancel) {
            [toView removeFromSuperview];
        }
        [transitionContext completeTransition:!wasCancel];
    }];
    
}


@end
