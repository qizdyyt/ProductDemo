//
//  ZDPermissionCamera.m
//  ProductDemo
//
//  Created by qizd on 2018/6/14.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "ZDPermissionCamera.h"

@implementation ZDPermissionCamera

+ (BOOL)authorized {
    return [self authorizationStatus] == AVAuthorizationStatusAuthorized;
}

+ (AVAuthorizationStatus)authorizationStatus {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    } else {
        // Prior to iOS 7 all apps were authorized.
        return AVAuthorizationStatusAuthorized;
    }
}

+ (void)authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    AVAuthorizationStatus status = [self authorizationStatus];
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            if (completion) {
                completion(YES, NO);
            }
            break;
            
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            if (completion) {
                completion(NO, NO);
            }
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(granted, YES);
                    });
                }
            }];
        }
            break;
        default:
            break;
    }
}

@end
