//
//  ZDPermissionManager.h
//  ProductDemo
//
//  Created by qizd on 2018/6/14.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ZDPermissionPhotos.h"
#import "ZDPermissionCamera.h"
#import "ZDPermissionNet.h"
#import "ZDPermissionHealth.h"
#import "ZDPermissionCalendar.h"
#import "ZDPermissionContacts.h"
#import "ZDPermissionLocation.h"
#import "ZDPermissionReminders.h"
#import "ZDPermissionMicrophone.h"


typedef NS_ENUM(NSInteger, ZDPermissionType) {
    ZDPermissionType_Photos,
    ZDPermissionType_Camera,
    ZDPermissionType_Microphone,
    ZDPermissionType_Contacts,
    ZDPermissionType_Calendar,
    ZDPermissionType_Net,
    ZDPermissionType_Health,
    ZDPermissionType_Location,
    ZDPermissionType_Reminders
};

@interface ZDPermissionManager : NSObject


/**
 主要用于判断位置服务是否可用

 */
+ (BOOL)isServicesEnabledWithType:(ZDPermissionType)type;


/**
 主要用于判断设备是否支持苹果健康

 */
+ (BOOL)isDeviceSupportedWithType: (ZDPermissionType)type;

+ (BOOL)authorizedWithType: (ZDPermissionType)type;

+ (void)authorizWithType: (ZDPermissionType)type completion:(void (^)(BOOL SUCCEEDED, BOOL isFirst))completion;


/**
 跳转系统权限设置
 */
+ (void)displayAppPrivacySettings;



/**
 弹框提示跳转用户设置
 */
+ (void)showAlertToDislayPrivacySettingWithTitle:(NSString*)title msg:(NSString*)message cancel:(NSString*)cancel setting:(NSString *)setting;
@end
