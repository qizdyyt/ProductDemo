//
//  FileTools.h
//  ProductDemo
//
//  Created by 祁子栋 on 2020/4/30.
//  Copyright © 2020 qizd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileTools : NSObject
///遍历路径下某个后缀的所有文件
+ (void)showAllFileWithPath:(NSString *) path WithSuffix:(NSString *)suffix;



@end


