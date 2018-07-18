//
//  NSString+Fmt.m
//  ProductDemo
//
//  Created by qizd on 2018/6/13.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "NSString+Fmt.h"

@implementation NSString (Fmt)

+ (NSString *)Null2EmptyStr:(id)myVal {
    
    NSString *reVal = [NSString stringWithFormat:@"%@",myVal];
    if (myVal == [NSNull null] || myVal == nil) {
        reVal = @"";
    }
    return reVal;
}

+ (NSString *)Null2NullStr:(id)myVal {
    
    NSString *reVal = [NSString stringWithFormat:@"%@",myVal];
    if (myVal == [NSNull null] || myVal == nil || [myVal isEqual: @""] || [[myVal lowercaseString] isEqualToString:@"null"]) {
        reVal = @"Null";
    }
    
    return reVal;
}

+ (BOOL)isEmptyString:(NSString *)myVal {
    
    if (myVal == nil) { return YES; }
    if ([myVal isEqualToString:@""] || [myVal isEqualToString:@"null"] || [myVal isEqualToString:@"Null"]) { return YES; }
    return NO;
}

//原理：emoji转换成utf-8编码后是4位，中文3位，英文1位
+ (NSString *)MySQLUTF8Safe:(NSString *)aString {
    
    const NSInteger maxCharcaterLength = 3;
    
    NSMutableString *tempString = [aString mutableCopy];
    
    [tempString enumerateSubstringsInRange:NSMakeRange(0, tempString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        NSUInteger lengthOfCharcater = [substring lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        if (lengthOfCharcater > maxCharcaterLength) {
            [tempString deleteCharactersInRange:substringRange];
        }
    }];
    
    return tempString;
}
@end
