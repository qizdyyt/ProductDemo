//
//  ZDPermissionHealth.h
//  ProductDemo
//
//  Created by qizd on 2018/6/14.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface ZDPermissionHealth : NSObject

+ (BOOL)authorized;


/*!
 @method        isHealthDataAvailable
 @abstract      Returns YES if HealthKit is supported on the device.
 @discussion    HealthKit is not supported on all iOS devices.  Using HKHealthStore APIs on devices which are not
 supported will result in errors with the HKErrorHealthDataUnavailable code.  Call isHealthDataAvailable
 before attempting to use other parts of the framework.
 */
+ (BOOL)isHealthDataAvailable;

+ (NSInteger)authorizationStatus;

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;

@end
