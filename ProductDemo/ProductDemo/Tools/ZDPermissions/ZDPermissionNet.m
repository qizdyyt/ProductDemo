//
//  ZDPermissionNet.m
//  ProductDemo
//
//  Created by qizd on 2018/6/14.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "ZDPermissionNet.h"
@import CoreTelephony;

@interface ZDPermissionNet()

@property (nonatomic, strong) id cellularData;

@end

@implementation ZDPermissionNet

+ (instancetype)sharedManager
{
    static ZDPermissionNet* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ZDPermissionNet alloc] init];
        
    });
    
    return _sharedInstance;
}

+ (BOOL)authorized {
    if (@available(iOS 9.0, *)) {
        CTCellularData *cellularData = [ZDPermissionNet sharedManager].cellularData;
        if (!cellularData) {
            cellularData = [[CTCellularData alloc] init];
            [ZDPermissionNet sharedManager].cellularData = cellularData;
        }
        CTCellularDataRestrictedState state = cellularData.restrictedState;
        switch (state) {
            case kCTCellularDataRestricted:
                return NO;
                break;
            case kCTCellularDataNotRestricted:
                return YES;
                break;
            case kCTCellularDataRestrictedStateUnknown:
                return NO;
                break;
            default:
                return NO;
                break;
        }
    } else {
        // Fallback on earlier versions
        return YES;
    }
    
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    if (@available(iOS 10,*)) {
        
        CTCellularData *cellularData = [ZDPermissionNet sharedManager].cellularData;
        if (!cellularData) {
            cellularData = [[CTCellularData alloc] init];
            //不存储，对象cellularData会销毁
            [ZDPermissionNet sharedManager].cellularData = cellularData;
        }
        //当联网权限的状态发生改变时，会在上述方法中捕捉到改变后的状态，可根据更新后的状态执行相应的操作。
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state)
        {
            //            NSLog(@"state:%ld",state);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (state == kCTCellularDataNotRestricted) {
                    //没有限制
                    completion(YES,NO);
                }
                else if (state == kCTCellularDataRestrictedStateUnknown)
                {
                    //没有请求网络或正在等待用户确认权限
                    //                    completion(NO,NO);
                }
                else{
                    //
                    completion(NO,NO);
                }
            });
        };
        
    }
    else
    {
        completion(YES,NO);
    }
    
}

@end
