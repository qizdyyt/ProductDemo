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

- (NSString *)EI_stringByPadRight:(NSUInteger)totalWidth{
    return [self EI_stringByPadRight:totalWidth paddingChar:' '];
}
- (NSString *)EI_stringByPadRight:(NSUInteger)totalWidth paddingChar:(char)paddingChar{
    
    if ([self length] >= totalWidth)
        return self;
    
    NSMutableString *paddedString = [NSMutableString stringWithFormat:@"%@", self];
    
    while (paddedString.length < totalWidth)
    {
        [paddedString appendString:[NSString stringWithFormat:@"%c",paddingChar]];
    }
    
    return paddedString;
}

- (NSString *)EI_stringByPadLeft:(NSUInteger)totalWidth{
    
    return [self EI_stringByPadLeft:totalWidth paddingChar:' '];
}
- (NSString *)EI_stringByPadLeft:(NSUInteger)totalWidth paddingChar:(char)paddingChar{
    
    if ([self length] >= totalWidth)
        return self;
    
    NSInteger strLength = [self length];
    NSMutableString *paddedString = [NSMutableString string];
    
    while ([paddedString length] < totalWidth - strLength)
    {
        [paddedString appendString:[NSString stringWithFormat:@"%c",paddingChar]];
    }
    
    [paddedString appendString:[NSMutableString stringWithFormat:@"%@", self]];
    
    return paddedString;
}


- (NSString *)fmtLimitLength:(NSUInteger)length
{
    if (length >= self.length || length == 0) {
        return self;
    }
    return [self substringToIndex:length];
}


- (NSUInteger)indexOfString:(NSString *)str {
    NSRange range = [self rangeOfString:str];
    return range.location;
}

- (NSUInteger)lastIndexOfString:(NSString *)str {
    NSRange range = [self rangeOfString:str options:NSBackwardsSearch];
    return range.location;
}

- (NSString *)substringFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (toIndex <= fromIndex) {
        return @"";
    }
    NSRange range = NSMakeRange(fromIndex, toIndex - fromIndex);
    return [self substringWithRange:range];
}

- (NSString *)substringFromString:(NSString *)fromStr endString:(NSString *)endStr {
    
    NSUInteger fromIndex = [self rangeOfString:fromStr].location;
    NSUInteger endIndex = [self rangeOfString:endStr options:NSBackwardsSearch].location + endStr.length;
    
    if (fromIndex == NSNotFound || endIndex == NSNotFound || endIndex <= fromIndex) {
        return @"";
    }
    
    NSRange range = NSMakeRange(fromIndex, endIndex);
    return [self substringWithRange:range];
}

@end
