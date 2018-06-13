//
//  NSString+ZDUtil.h
//  ProductDemo
//
//  Created by qizd on 2018/6/13.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZDUtil)
///nil -> @""
+ (NSString *)Null2EmptyStr:(id)myVal;
///nil, @"", null -> @"null"
+ (NSString *)Null2NullStr:(id)myVal;

+ (BOOL)isEmptyString:(NSString *)myVal;





@end
