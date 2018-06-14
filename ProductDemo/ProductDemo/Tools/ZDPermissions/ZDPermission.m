//
//  ZDPermission.m
//  ProductDemo
//
//  Created by qizd on 2018/6/14.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "ZDPermission.h"

@implementation ZDPermission

+ (BOOL)authorized {
    return NO;
}

+ (NSInteger)authorizationStatus {
    return 0;
}

+ (void)authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    
}

@end
