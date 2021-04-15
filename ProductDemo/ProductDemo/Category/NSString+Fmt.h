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

///是否为空字符串 nil/"null"/""/"Null"
+ (BOOL)isEmptyString:(NSString *)myVal;

///删除字符串中的emoji
+ (NSString *)MySQLUTF8Safe:(NSString *)aString;

///左侧添加空格以对齐到某长度
- (NSString *)EI_stringByPadRight:(NSUInteger)totalWidth;
///右侧添加空格以对齐到某长度
- (NSString *)EI_stringByPadLeft:(NSUInteger)totalWidth;

///限制字符最大长度
- (NSString *)fmtLimitLength:(NSUInteger)length;

///子字符串在字符串中位置
- (NSUInteger)indexOfString:(NSString *)str;

///最后一个子字符串在字符串中位置
- (NSUInteger)lastIndexOfString:(NSString *)str;



@end
