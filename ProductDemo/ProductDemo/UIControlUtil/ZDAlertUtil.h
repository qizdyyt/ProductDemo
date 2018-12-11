//
//  ZDAlertUtil.h
//  ProductDemo
//
//  Created by qizd on 2018/11/19.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
///Alert提示工具
@interface ZDAlertUtil : NSObject

+ (void)showAlert:(NSString *)title message:(NSString *)message presenter:(UIViewController *)presenterVC;

+ (void)showAlert:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle presenter:(UIViewController *)presenterVC;
+ (void)showAlert:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle presenter:(UIViewController *)presenterVC action:(UIAlertAction *)action;
+ (void)showAlert:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle presenter:(UIViewController *)presenterVC actions:(NSArray *)actionsArray;

+ (void)showAlert:(NSString *)title message:(NSString *)message presenter:(UIViewController *)presenterVC cancel:(UIAlertAction *)cancelAction action:(UIAlertAction *)action;
+ (void)showAlert:(NSString *)title message:(NSString *)message presenter:(UIViewController *)presenterVC cancel:(UIAlertAction *)cancelAction actions:(NSArray *)actionsArray;

/*------
 ActionSheet
 
 -----*/
+ (void)showActionSheet:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle presenter:(UIViewController *)presenterVC;
+ (void)showActionSheet:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle presenter:(UIViewController *)presenterVC action:(UIAlertAction *)action;
+ (void)showActionSheet:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle presenter:(UIViewController *)presenterVC actions:(NSArray *)actionsArray;
+ (void)showActionSheet:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle presenter:(UIViewController *)presenterVC showInView:(id)view actions:(NSArray *)actionsArray;

+ (void)showAutoAlert:(NSString *)title message:(NSString *)message presenter:(UIViewController *)presentVC cancel:(NSString *)cancelTitle action:(UIAlertAction *)action;
+ (void)showAutoAlert:(NSString *)title message:(NSString *)message presenter:(UIViewController *)presentVC cancel:(NSString *)cancelTitle actions:(NSArray *)actionsArray;



@end

