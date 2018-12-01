//
//  ZDAlertUtil.m
//  ProductDemo
//
//  Created by qizd on 2018/11/19.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "ZDAlertUtil.h"
#import "AppDelegate.h"

@implementation ZDAlertUtil

+ (void)privateShowAlert:(NSString *)title message:(NSString *)message presenter:(UIViewController *)presenterVC view:(id)view style:(UIAlertControllerStyle)style cancelAction:(UIAlertAction *)cancelAction actions:(NSArray *)actionsArray
{
    if (!presenterVC) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        UIViewController *topViewController = appDelegate.rootVC.topViewController;
        while (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        }
        presenterVC = topViewController;
        
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    for (UIAlertAction *action in actionsArray) {
        [alertController addAction:action];
    }
    
    if (cancelAction) {
        [alertController addAction:cancelAction];
    }
    
    if(IS_IPAD)
    {
        if(!view)
        {
            view = presenterVC.view;
        }
        if ([view isKindOfClass:[UIBarButtonItem class]]) {
            alertController.popoverPresentationController.barButtonItem = (UIBarButtonItem *)view;
        }
        else if([view isKindOfClass:[UIView class]])
        {
            UIView *presentView = (UIView *)view;
            alertController.popoverPresentationController.sourceView = presentView;
            alertController.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(presentView.bounds), CGRectGetMidY(presentView.bounds), 1.0, 1.0);
        }
        
    }
    
    [presenterVC presentViewController:alertController animated:YES completion:nil];
}

+ (void)showAlert:(NSString *)title message:(NSString *)message presenter:(UIViewController *)presenterVC
{
    [self showAlert:title message:message cancelTitle:@"OK" presenter:presenterVC];
}

+ (void)showAlert:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle presenter:(UIViewController *)presenterVC
{
    [self showAlert:title message:message cancelTitle:cancelButtonTitle presenter:presenterVC action:nil];
}

+ (void)showAlert:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle presenter:(UIViewController *)presenterVC action:(UIAlertAction *)action
{
    NSArray *actionArray = nil;
    if (action) {
        actionArray = @[action];
    }
    [self showAlert:title message:message cancelTitle:cancelTitle presenter:presenterVC actions:actionArray];
}

+ (void)showAlert:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle presenter:(UIViewController *)presenterVC actions:(NSArray *)actionsArray
{
    UIAlertAction *cancelAction = nil;
    if (cancelTitle) {
        cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    }
    [self showAlert:title message:message presenter:presenterVC cancel:cancelAction actions:actionsArray];
}

+ (void)showAlert:(NSString *)title message:(NSString *)message presenter:(UIViewController *)presenterVC cancel:(UIAlertAction *)cancelAction action:(UIAlertAction *)action
{
    NSArray *actionArray = nil;
    if (action) {
        actionArray = @[action];
    }
    [self showAlert:title message:message presenter:presenterVC cancel:cancelAction actions:actionArray];
}

+ (void)showAlert:(NSString *)title message:(NSString *)message presenter:(UIViewController *)presenterVC cancel:(UIAlertAction *)cancelAction actions:(NSArray *)actionsArray
{
    [self privateShowAlert:title message:message presenter:presenterVC view:nil style:UIAlertControllerStyleAlert cancelAction:cancelAction actions:actionsArray];
    
}

/////////////////////Action
+ (void)showActionSheet:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle presenter:(UIViewController *)presenterVC
{
    [self showActionSheet:title message:message cancelTitle:cancelButtonTitle presenter:presenterVC action:nil];
}
+ (void)showActionSheet:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle presenter:(UIViewController *)presenterVC action:(UIAlertAction *)action
{
    NSArray *actionArray = nil;
    if (action) {
        actionArray = @[action];
    }
    [self showActionSheet:title message:message cancelTitle:cancelButtonTitle presenter:presenterVC actions:actionArray];
}
+ (void)showActionSheet:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle presenter:(UIViewController *)presenterVC actions:(NSArray *)actionsArray
{
    [self showActionSheet:title message:message cancelTitle:cancelButtonTitle presenter:presenterVC showInView:nil actions:actionsArray];
}

+ (void)showActionSheet:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle presenter:(UIViewController *)presenterVC showInView:(id)view actions:(NSArray *)actionsArray
{
    UIAlertAction *cancelAction = nil;
    if (cancelButtonTitle) {
        cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    }
    [self privateShowAlert:title message:message presenter:presenterVC view:view style:UIAlertControllerStyleActionSheet cancelAction:cancelAction actions:actionsArray];
    
    //    UIAlertController *errorActionSheet = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@\n%@!\n%@.\n1) %@.\n2) %@.\n3) %@.",errorStr,unconnect,statusCode,one,two,three] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //    [errorActionSheet addAction:[UIAlertAction actionWithTitle:EILocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //        [errorActionSheet dismissViewControllerAnimated:YES completion:nil];
    //    }]];
    //    [self presentViewController:errorActionSheet animated:YES completion:nil];
    
}

+ (void)showAutoAlert:(NSString *)title message:(NSString *)message presenter:(UIViewController *)presentVC cancel:(NSString *)cancelTitle action:(UIAlertAction *)action
{
    NSArray *actionArray = nil;
    if (action) {
        actionArray = @[action];
    }
    [self showAutoAlert:title message:message presenter:presentVC cancel:cancelTitle actions:actionArray];
}


+ (void)showAutoAlert:(NSString *)title message:(NSString *)message presenter:(UIViewController *)presentVC cancel:(NSString *)cancelTitle actions:(NSArray *)actionsArray
{
    if(IS_IPHONE)
    {
        [self showActionSheet:title message:message cancelTitle:cancelTitle presenter:presentVC actions:actionsArray];
    }
    else
    {
        [self showAlert:title message:message cancelTitle:cancelTitle presenter:presentVC actions:actionsArray];
    }
}


@end
