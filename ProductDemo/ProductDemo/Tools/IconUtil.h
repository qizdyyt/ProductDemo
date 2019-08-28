//
//  IconUtil.h
//  TestTTF
//
//  Created by qizd on 2018/4/23.
//  Copyright © 2018年 qizd. All rights reserved.
//

/*********
 
 作用：根据字体文件（fontfile）的字体名和每个icon的Unicode，加载图标到label中
 
 ********/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class EMAPIDownloadFontFile;

@interface IconUtil : NSObject

+ (UIFont *)fontWithIconID:(NSString *)iconID size:(CGFloat)size;

+ (NSString *)textWithIconID:(NSString *)iconID;
+ (NSString *)textWithIconID:(NSString *)iconID isMenuItem:(BOOL) isMenuItem;

@property (class, nonatomic, readonly) NSString *fontFileDirectoryPath;
//每次字体文件更新之后要将shouldChangeSize变为相反的值来，进而更改一点字体大小来刷新系统缓存，目前没找到其他更好的解决方案
//After each font file update, you should change the ‘shouldChangeSize’ to the opposite value, and then change the font size to refresh the system cache. No other better solution is found yet.
@property (class, nonatomic, assign) BOOL shouldChangeSize;

+ (UIFont *)fontWithIconClass:(NSString *)iconClass size:(CGFloat)size;
+ (NSString *)textWithIconClass:(NSString *)iconClass;
+ (NSString *)getIconIDWithIconClass:(NSString *)iconClass;

+ (NSAttributedString *)getTargetStringWithContent:(NSString *)content IconClass:(NSString *)iconClass MiddleString:(NSString *)midleString ContentColor:(UIColor *)contentColor IconColor:(UIColor *)iconColor Font:(UIFont *)font IconOnLeft:(BOOL)onLeft UnderLine:(BOOL)underLine;

+ (void)unregisterFontWithDownloadFile:(EMAPIDownloadFontFile *)downloadFile;
@end
