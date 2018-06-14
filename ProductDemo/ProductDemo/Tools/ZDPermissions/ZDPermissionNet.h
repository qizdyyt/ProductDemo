//
//  ZDPermissionNet.h
//  ProductDemo
//
//  Created by qizd on 2018/6/14.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDPermissionNet : NSObject

/**
 suggest call this method delay a few seconds after app launch
 remark: just call back data networks permission
 @param completion 回调
 */
+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;

@end
