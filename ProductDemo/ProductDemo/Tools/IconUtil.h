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
@interface IconUtil : NSObject

+ (UIFont *)fontWithIconID:(NSString *)iconID size:(CGFloat)size;

+ (NSString *)textWithIconID:(NSString *)iconID;
+ (NSString *)textWithIconID:(NSString *)iconID isMenuItem:(BOOL) isMenuItem;

@property (class, nonatomic, readonly) NSString *fontFileDirectoryPath;

/*******    核心方法       *******/
+ (NSString *)readIconWithUnicodeStr:(NSString *)unicode;
@end
