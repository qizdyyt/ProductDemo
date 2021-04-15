//
//  NSString+JudgeType.m
//  ProductDemo
//
//  Created by qizd on 2018/6/13.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "NSString+JudgeType.h"
static NSString *const kEmailRegex = @"[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?";

static NSString *const kNumberRegex = @"^[-,+]?[0-9]+\\.?[0-9]*$";

/**
 判断字符串是否符合特定类型格式如：邮箱、电话、密码、数字等
 */
@implementation NSString (JudgeType)

- (BOOL)isEmail
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kEmailRegex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isNumber
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kNumberRegex];
    return [predicate evaluateWithObject:self];
}

@end
