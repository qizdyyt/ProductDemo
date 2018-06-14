//
//  ZDPermissionPhotos.m
//  ProductDemo
//
//  Created by qizd on 2018/6/14.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "ZDPermissionPhotos.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ZDPermissionPhotos

+ (BOOL)authorized {
    return [self authorizationStatus] == PHAuthorizationStatusAuthorized;
}

/**
 photo permission status
 
 @return
 0 :NotDetermined
 1 :Restricted
 2 :Denied
 3 :Authorized
 */
+ (NSInteger)authorizationStatus {
    
    if (@available(iOS 8, *)) {
        return [PHPhotoLibrary authorizationStatus];
    }else {
        return [ALAssetsLibrary authorizationStatus];
    }
    
}

+ (void)authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    PHAuthorizationStatus status = [self authorizationStatus];
    
    switch (status) {
        case PHAuthorizationStatusAuthorized://通过
            if (completion) {
                completion(YES, NO);
            }
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            if (completion) {
                completion(NO, NO);
            }
        }
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(status == PHAuthorizationStatusAuthorized, YES);
                    });
                }
            }];
        }
        default:
        {
            if (completion) {
                completion(NO, NO);
            }
        }
            break;
    }
}

@end
