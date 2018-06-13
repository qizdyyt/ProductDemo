//
//  IconUtil.m
//  TestTTF
//
//  Created by qizd on 2018/4/23.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "IconUtil.h"
#import <CoreText/CoreText.h>
#import "NSString+ZDUtil.h"

static NSString *const kDefaultFontFileName = @"EMIconDefault.ttf";

@interface IconUtil()

@end

@implementation IconUtil

+ (UIFont *)fontWithIconID:(NSString *)iconID size:(CGFloat)size {
    
    //用合适办法获取iconID进而获得icon的字体与unicode
    
    //这里字体名不要是nil，可以是@“”，大小最小给1
    //否则font在没有情况下不会为nil，而是一个默认值
    return [self fontWithFontFileName:[NSString Null2EmptyStr:@"fontFile"] withSize:MAX(size, 1)];
}

+ (BOOL)hasRegistFont:(NSString *)fontName {
    for (NSString *fontRegistName in [UIFont familyNames]) {
        if ([fontName isEqualToString:fontRegistName]) {
            return YES;
        }
    }
    return NO;
}

/*******    核心方法       *******/
+ (UIFont *)fontWithFontFileName:(NSString *)name withSize:(CGFloat)size {
    
    UIFont *font = [UIFont fontWithName:name size:size];
    
    if (!font || ![self hasRegistFont:name]) {
        
        NSString *fontFileDirectory = [self fontFileDirectoryPath];
        NSString *fontFilePath = [fontFileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ttf", name]];
        NSURL *fontFileURL = [NSURL fileURLWithPath:fontFilePath];
        
        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontFileURL);
        if (!fontDataProvider) {
            return [self systemDefaultFontWithFontSize:size];
        }
        
        CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
        CFErrorRef error;

        if(!CTFontManagerRegisterGraphicsFont(newFont, &error)){

            CFStringRef errorDescription = CFErrorCopyDescription(error);

            NSLog(@"Register font failure with error: %@", errorDescription);
            CFRelease(errorDescription);
            CFRelease(newFont);
            CFRelease(fontDataProvider);
            return nil;
        }
        
//        if (!CTFontManagerRegisterFontsForURL((__bridge CFURLRef)[NSURL fileURLWithPath:fontFilePath], kCTFontManagerScopeProcess, &error)) {
//            CFStringRef errorDescription = CFErrorCopyDescription(error);
//
//            ElogError(@"Register font failure with error: %@", errorDescription);
//            CFRelease(errorDescription);
//            CFRelease(newFont);
//            CFRelease(fontDataProvider);
//            return nil;
//        }
        

        CFRelease(newFont);
        CFRelease(fontDataProvider);
        font = [UIFont fontWithName:name size:size];
        
    }
    return font;
}

+ (UIFont *)systemDefaultFontWithFontSize:(CGFloat)fontSize {
    
    UIFont*(^getFont)(CGFloat) = ^(CGFloat fontSize){
        UIFont *font = [UIFont fontWithName:@"EMIcon" size:fontSize];
        return font;
    };
    
    UIFont *font = getFont(fontSize);
    if (font) {
        return font;
    }
    
    [self loadSystemDefaultFont];
    return getFont(fontSize);
}

+ (void)loadSystemDefaultFont {
    
    CFErrorRef error = NULL;
    
    NSString *fontFileDirectory = [self fontFileDirectoryPath];
    NSString *fontFilePath = [fontFileDirectory stringByAppendingPathComponent:kDefaultFontFileName];
    NSURL *fontFileURL = [NSURL fileURLWithPath:fontFilePath];
    
    if ([NSFileManager.defaultManager fileExistsAtPath:fontFilePath]) {
        [NSFileManager.defaultManager removeItemAtPath:fontFilePath error:nil];
    }
    
    NSString *bundleFontFilePath = [[NSBundle mainBundle] pathForResource:@"EMIcon" ofType:@"ttf"];
    [NSFileManager.defaultManager copyItemAtPath:bundleFontFilePath toPath:fontFilePath error:nil];
    
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontFileURL);
    CGFontRef defaultFont = CGFontCreateWithDataProvider(fontDataProvider);
//    CTFontManagerRegisterFontsForURL((__bridge CFURLRef)[NSURL fileURLWithPath:fontFilePath], kCTFontManagerScopeProcess, &error);
    CTFontManagerRegisterGraphicsFont(defaultFont, &error);
    if (error) {
        NSLog(@"%@", ((__bridge NSError*)error).localizedDescription);
        return;
    }
}
/*******    核心方法       *******/
+ (NSString *)readIconWithUnicodeStr:(NSString *)unicode {
    unichar ch = [self stringFromHexString:unicode];
    NSString * str = [NSString stringWithCharacters:&ch length:1];
    return str;
}

//+ (NSString *)readIconWithuUnicode:(unichar)code{
//    NSString *codestr = [NSString stringWithFormat:@"%hu",code];
//    unichar unicode = [codestr intValue];
//    NSString * str = [NSString stringWithCharacters:&unicode length:1];
//    return str;
//}

+ (NSString *)textWithIconID:(NSString *)iconID {
    return [self textWithIconID:iconID isMenuItem:NO];
}

+ (NSString *)textWithIconID:(NSString *)iconID isMenuItem:(BOOL)isMenuItem {
    
    NSString *iconCode = @"";//[EIDatabaseHelper.sharedHelper dlookupFieldWithField:@"Code" table:@"[Icons]" where:[NSString stringWithFormat:@"IconID = '%@'", iconID]];
    if ([NSString isEmptyString:iconCode]) {
        
        if ([iconID isEqualToString:@"e81f"] ||
            [iconID isEqualToString:@"e80e"]) {
            iconCode = iconID;
        }
        else {
            iconCode = @"e821";
        }
    }
    
    return [self readIconWithUnicodeStr:iconCode];
}

+ (NSString *)fontFileDirectoryPath {
    NSString *fontFileDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    fontFileDirectoryPath = [fontFileDirectoryPath stringByAppendingPathComponent:@"FontFiles"];
    if (![NSFileManager.defaultManager fileExistsAtPath:fontFileDirectoryPath]) {
        [NSFileManager.defaultManager createDirectoryAtPath:fontFileDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return fontFileDirectoryPath;
}

+ (int)stringFromHexString:(NSString *)hexString { //
    
    NSString *tmpHexString = [hexString lowercaseString];//转换为小写
    int length = (int)tmpHexString.length;
    unsigned int sum = 0;
    for (int i = length - 1; i >= 0; i--) {
        
        char c = (char)[tmpHexString characterAtIndex:i];
        if (c>='0'&&c<='9') {
            
            c = c-'0';
//            NSLog(@"-->");
        }
        else if(c>='a'&&c<='f')
        {
            c=c-'a'+10;
//            NSLog(@"<--");
        }
        sum+=c*(int)pow(16, length-1-i);
    }
    return sum;
}


@end
