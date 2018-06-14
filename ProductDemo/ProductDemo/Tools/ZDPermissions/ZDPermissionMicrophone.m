//
//  ZDPermissionMicrophone.m
//  ProductDemo
//
//  Created by qizd on 2018/6/14.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "ZDPermissionMicrophone.h"

#define kHasBeenAskedForMicrophonePermission @"HasBeenAskedForMicrophonePermission"

@implementation ZDPermissionMicrophone

+ (BOOL)authorized {
    return [self authorizationStatus] == AVAudioSessionRecordPermissionGranted;
}

+ (AVAudioSessionRecordPermission)authorizationStatus {
    if ( @available(iOS 8,*) ){
        return [[AVAudioSession sharedInstance] recordPermission];
    }
    else if (@available(iOS 7,*))
    {
        bool hasBeenAsked =
        [[NSUserDefaults standardUserDefaults] boolForKey:kHasBeenAskedForMicrophonePermission];
        if (hasBeenAsked) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            __block BOOL hasAccess;
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                hasAccess = granted;
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            return hasAccess ? 2 : 1;
        } else {
            return 0;
        }
    }
    else
        return 2;
}

+ (void)authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    
}
@end
