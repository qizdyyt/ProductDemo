//
//  NSString+Fmt.h
//  ProductDemo
//
//  Created by qizd on 2018/6/13.
//  Copyright © 2018年 qizd. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 对NSString进行各种格式化处理
 */
@interface NSString (Fmt)

///nil -> @""
+ (NSString *)Null2EmptyStr:(id)myVal;
///nil, @"", null -> @"null"
+ (NSString *)Null2NullStr:(id)myVal;
///是否为空字符串
+ (BOOL)isEmptyString:(NSString *)myVal;

///删除字符串中的emoji
+ (NSString *)MySQLUTF8Safe:(NSString *)aString;
@end
