//
//  ZDPermissionCalendar.h
//  ProductDemo
//
//  Created by qizd on 2018/6/14.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface ZDPermissionCalendar : NSObject

+ (BOOL)authorized;

+ (EKAuthorizationStatus)authorizationStatus;

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;


@end
