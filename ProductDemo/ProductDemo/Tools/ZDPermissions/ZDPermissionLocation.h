//
//  ZDPermissionLocation.h
//  ProductDemo
//
//  Created by qizd on 2018/6/14.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ZDPermissionLocation : NSObject

/**
 @return YES if GPS system service enabled,NO if GPS system service is not enabled
 */
+ (BOOL)isServicesEnabled;

/**
 需要先判断服务是否可用，调用isServicesEnabled
 */
+ (BOOL)authorized;

+ (CLAuthorizationStatus)authorizationStatus;

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;

@end
