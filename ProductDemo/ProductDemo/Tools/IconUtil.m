//
//  IconUtil.m
//  TestTTF
//
//  Created by qizd on 2018/4/23.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "IconUtil.h"
#import <CoreText/CoreText.h>
#import "NSString+Fmt.h"

//要想成功卸载动态注册的字体，需要使用同一个CGFontRef注册和卸载
//这时就需要一个东西来保存一下CGFontRef，我用了结构体转NSValue保存到了字典
//具体操作看下方注释代码的记录，搜索fontRefDic

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

/*
 
 
 //
 //  IconUtil.m
 //  TestTTF
 //
 //  Created by qizd on 2018/4/23.
 //  Copyright © 2018年 qizd. All rights reserved.
 //
 
 #import "IconUtil.h"
 #import <CoreText/CoreText.h>
 #import "EIDatabaseHelper.h"
 #import "Fmt.h"
 #import "Encompass-Swift.h"
 
 static NSString *const kDefaultFontFileName = @"EMIconDefault.ttf";
 static BOOL shouldChangeTag = YES;
 NSMutableDictionary *fontRefCache;
 
 @interface IconUtil()
 @property (class, nonatomic, copy) NSMutableDictionary *fontRefDic;
 @end
 
 @implementation IconUtil
 
 + (UIFont *)fontWithIconID:(NSString *)iconID size:(CGFloat)size {
 
 NSString *fontFile = [DB lookupSingleField:@"FontFile" table:@"[Icons]" where:@"IconID = '%@'", iconID];
 return [self fontWithFontFileName:[BC_Fmt Null2EmptyStr:fontFile] withSize:MAX(size, 1)];
 }
 
 + (UIFont *)fontWithIconClass:(NSString *)iconClass size:(CGFloat)size {
 
 NSString *fontFile = [DB lookupSingleField:@"FontFile" table:@"[Icons]" where:@"Class = '%@'", iconClass];
 return [self fontWithFontFileName:[BC_Fmt Null2EmptyStr:fontFile] withSize:MAX(size, 1)];
 }
 
 + (BOOL)hasRegistFont:(NSString *)fontName {
 for (NSString *fontRegistName in [UIFont familyNames]) {
 if ([fontName isEqualToString:fontRegistName]) {
 return YES;
 }
 }
 return NO;
 }
 
 + (UIFont *)fontWithFontFileName:(NSString *)name withSize:(CGFloat)size {
 
 if (shouldChangeTag) {
 size = size + 0.1;
 }
 
 UIFont *font = [UIFont fontWithName:name size:size];
 
 if (!font || ![self hasRegistFont:name]) {
 
 NSString *fontFileDirectory = [self fontFileDirectoryPath];
 NSString *fontFilePath = [fontFileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ttf", name]];
 NSURL *fontFileURL = [NSURL fileURLWithPath:fontFilePath];
 
 CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontFileURL);
 if (!fontDataProvider) {
 return [self systemDefaultFontFileName:name WithFontSize:size];
 }
 
 CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
 CFErrorRef error;
 
 if(!CTFontManagerRegisterGraphicsFont(newFont, &error)){
 
 CFStringRef errorDescription = CFErrorCopyDescription(error);
 
 ElogError(@"Register font failure with error: %@", errorDescription);
 CFRelease(errorDescription);
 CGFontRelease(newFont);
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
 //保存字体结构
 NSValue *fontRefValue = [NSValue value:&newFont withObjCType:@encode(CGFontRef)];
 [IconUtil.fontRefDic setObject:fontRefValue forKey:name];
 
 //        CGFontRelease(newFont);
 CFRelease(fontDataProvider);
 font = [UIFont fontWithName:name size:size];
 
 }
 return font;
 }
 
 + (UIFont *)systemDefaultFontFileName:(NSString *)name WithFontSize:(CGFloat)fontSize {
 NSString *fontName = @"";
 if ([name isEqualToString:@"Command"]) {
 fontName = name;
 }else {
 fontName = @"EMIcon";
 }
 
 UIFont*(^getFont)(CGFloat) = ^(CGFloat fontSize){
 UIFont *font = [UIFont fontWithName:fontName size:fontSize];
 return font;
 };
 
 UIFont *font = getFont(fontSize);
 if (font) {
 return font;
 }
 
 [self loadSystemDefaultFont:fontName];
 return getFont(fontSize);
 }
 
 + (void)loadSystemDefaultFont:(NSString *)fontName {
 
 CFErrorRef error = NULL;
 
 NSString *fontFileDirectory = [self fontFileDirectoryPath];
 NSString *fontFilePath = @"";
 NSString *bundleFontFilePath = @"";
 
 if ([fontName isEqualToString:@"Command"]) {
 fontFilePath = [fontFileDirectory stringByAppendingPathComponent:@"Command.ttf"];
 bundleFontFilePath = [[NSBundle mainBundle] pathForResource:@"Command" ofType:@"ttf"];
 }else {
 fontFilePath = [fontFileDirectory stringByAppendingPathComponent:@"EMIcon.ttf"];
 bundleFontFilePath = [[NSBundle mainBundle] pathForResource:@"EMIcon" ofType:@"ttf"];
 }
 
 NSURL *fontFileURL = [NSURL fileURLWithPath:fontFilePath];
 
 if ([NSFileManager.defaultManager fileExistsAtPath:fontFilePath]) {
 [NSFileManager.defaultManager removeItemAtPath:fontFilePath error:nil];
 }
 
 [NSFileManager.defaultManager copyItemAtPath:bundleFontFilePath toPath:fontFilePath error:nil];
 
 CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontFileURL);
 CGFontRef defaultFont = CGFontCreateWithDataProvider(fontDataProvider);
 CTFontManagerRegisterGraphicsFont(defaultFont, &error);
 
 //保存字体结构
 NSValue *fontRefValue = [NSValue value:&defaultFont withObjCType:@encode(CGFontRef)];
 [IconUtil.fontRefDic setObject:fontRefValue forKey:fontName];
 
 CFRelease(fontDataProvider);
 if (error) {
 ElogError(((__bridge NSError*)error).localizedDescription);
 CFRelease(error);
 return;
 }
 }
 
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
 
 + (NSString *)textWithIconClass:(NSString *)iconClass {
 NSString *iconCode = [DB lookupSingleField:@"Code" table:@"[Icons]" where:@"Class = '%@'", iconClass];
 if ([BC_Fmt isEmptyString:iconCode]) {
 
 iconCode = @"e821";
 }
 
 return [self readIconWithUnicodeStr:iconCode];
 }
 
 + (NSString *)textWithIconID:(NSString *)iconID {
 return [self textWithIconID:iconID isMenuItem:NO];
 }
 
 + (NSString *)textWithIconID:(NSString *)iconID isMenuItem:(BOOL)isMenuItem {
 
 NSString *iconCode = [DB lookupSingleField:@"Code" table:@"[Icons]" where:@"IconID =  '%@'", iconID];
 if ([BC_Fmt isEmptyString:iconCode]) {
 
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
 
 + (NSString *)getIconIDWithIconClass:(NSString *)iconClass
 {
 NSString *iconID = [DB lookupSingleField:@"IconID" table:@"[Icons]" where:@"Class = '%@'", iconClass];
 if ([BC_Fmt isEmptyString:iconID]) {
 
 iconID = @"257";
 }
 
 return iconID;
 }
 
 
 + (NSAttributedString *)getTargetStringWithContent:(NSString *)content IconClass:(NSString *)iconClass MiddleString:(NSString *)midleString ContentColor:(UIColor *)contentColor IconColor:(UIColor *)iconColor Font:(UIFont *)font IconOnLeft:(BOOL)onLeft UnderLine:(BOOL)underLine
 {
 NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
 
 NSMutableDictionary *attriDic = [[NSMutableDictionary alloc] initWithDictionary:@{NSFontAttributeName: font, NSForegroundColorAttributeName: contentColor}];
 if (underLine){
 [attriDic setValue:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
 [attriDic setValue:contentColor forKey:NSUnderlineColorAttributeName];
 }
 
 NSAttributedString *attributerStr1 = [[NSAttributedString alloc] initWithString:content attributes:attriDic];
 NSAttributedString *attributerStr2 = [[NSAttributedString alloc] initWithString:midleString attributes:@{NSFontAttributeName: font}];
 NSAttributedString *attributerStr3 = [[NSAttributedString alloc] initWithString:[IconUtil textWithIconClass:iconClass] attributes:@{NSFontAttributeName: [IconUtil fontWithIconClass:iconClass size:font.pointSize + 5], NSForegroundColorAttributeName: iconColor}];
 
 if (onLeft) {
 [attributedString appendAttributedString:attributerStr3];
 } else {
 [attributedString appendAttributedString:attributerStr1];
 }
 
 [attributedString appendAttributedString:attributerStr2];
 
 if (onLeft) {
 [attributedString appendAttributedString:attributerStr1];
 } else {
 [attributedString appendAttributedString:attributerStr3];
 }
 
 return attributedString;
 }
 
 + (void)unregisterFontWithDownloadFile:(EMAPIDownloadFontFile *)downloadFile {
 NSString *fileName = downloadFile.fileName;
 NSString *fontName = [fileName componentsSeparatedByString:@"."].firstObject;
 NSString *cachePath = downloadFile.filePath;
 NSString *filePath = [[IconUtil fontFileDirectoryPath] stringByAppendingPathComponent:fileName];
 NSFileManager *manager = [NSFileManager defaultManager];
 //卸载默认字体
 //    NSString *defaultIconPath = [[IconUtil fontFileDirectoryPath] stringByAppendingString:@"/EMIconDefault.ttf"];
 //    CGDataProviderRef delFontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:defaultIconPath]);
 //    CGFontRef delFont = CGFontCreateWithDataProvider(delFontDataProvider);
 //    CFErrorRef delError;
 //    if ([manager fileExistsAtPath:defaultIconPath]) {
 //        [manager removeItemAtPath:defaultIconPath error:nil];
 //        if(!CTFontManagerUnregisterGraphicsFont(delFont, &delError)){
 //
 //            CFStringRef errorDescription = CFErrorCopyDescription(delError);
 //            NSLog(@"Failed to unload font: %@", errorDescription);
 //            CFRelease(errorDescription);
 //        }
 //        CGFontRelease(delFont);
 //        CFRelease(delFontDataProvider);
 //    }
 
 //Task 610005 Phone Icon on Call Manager isn't displaying, question mark in a box is. Took 5 minutes to see the Phone Icon
 //已经在缓存中存在，注册过，卸载以重新注册
 if (IconUtil.fontRefDic[fontName]) {
 NSValue *fontRefValue = IconUtil.fontRefDic[fontName];
 CGFontRef defFont;
 [fontRefValue getValue:&defFont];
 CFErrorRef delError;
 if(!CTFontManagerUnregisterGraphicsFont(defFont, &delError)){
 CFStringRef errorDescription = CFErrorCopyDescription(delError);
 NSLog(@"Failed to unload font: %@", errorDescription);
 CFRelease(errorDescription);
 }
 CGFontRelease(defFont);
 }
 if ([manager fileExistsAtPath:filePath]) {
 [manager removeItemAtPath:filePath error:nil];
 }
 [manager moveItemAtPath:cachePath toPath:filePath error:nil];
 
 //    if ([manager fileExistsAtPath:filePath]) {
 //        //卸载已注册旧字体
 //        CGDataProviderRef delFontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:filePath]);
 //        CGFontRef delFont = CGFontCreateWithDataProvider(delFontDataProvider);
 //        CFErrorRef delError;
 //        [manager removeItemAtPath:filePath error:nil];
 //        if(!CTFontManagerUnregisterGraphicsFont(delFont, &delError)){
 //            CFStringRef errorDescription = CFErrorCopyDescription(delError);
 //            NSLog(@"Failed to unload font: %@", errorDescription);
 //            CFRelease(errorDescription);
 //        }
 //        CFRelease(delFontDataProvider);
 //        CGFontRelease(delFont);
 //    }
 //    [manager moveItemAtPath:cachePath toPath:filePath error:nil];
 }
 
 
 + (void)setFontRefDic:(NSMutableDictionary *)fontRefDic {
 fontRefCache = [NSMutableDictionary dictionaryWithDictionary:fontRefDic];
 }
 
 + (NSMutableDictionary *)fontRefDic {
 if (!fontRefCache) {
 fontRefCache = [NSMutableDictionary dictionary];
 
 }
 return fontRefCache;
 }
 
 + (BOOL)shouldChangeSize {
 return shouldChangeTag;
 }
 
 + (void)setShouldChangeSize:(BOOL)shouldChangeSize {
 shouldChangeTag = shouldChangeSize;
 }
 
 @end

 */
