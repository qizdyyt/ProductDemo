//
//  ZDPermission.h
//  ProductDemo
//
//  Created by qizd on 2018/6/14.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 权限请求基础类，定义了基础的几个方法
 */
@interface ZDPermission : NSObject

///是否已经请求到了权限
+ (BOOL)authorized;

/**
 当前权限状态

 @return 权限状态值
 */
+ (NSInteger)authorizationStatus;


/**
 请求权限

 @param completion block回调，param1：是否成功，param2：是否第一次
 */
+ (void)authorizeWithCompletion: (void(^)(BOOL granted, BOOL isFirst))completion;
@end
