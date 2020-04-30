//
//  FileTools.m
//  ProductDemo
//
//  Created by 祁子栋 on 2020/4/30.
//  Copyright © 2020 qizd. All rights reserved.
//

#import "FileTools.h"

@implementation FileTools

///遍历路径下某个后缀的所有文件
+ (void)showAllFileWithPath:(NSString *) path WithSuffix:(NSString *)suffix{
    NSFileManager * fileManger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (isDir) {
            NSArray * dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
            NSArray *sortedArray = [dirArray sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
            NSString * subPath = nil;
            for (NSString * str in sortedArray) {
                subPath  = [path stringByAppendingPathComponent:str];
                BOOL issubDir = NO;
                [fileManger fileExistsAtPath:subPath isDirectory:&issubDir];
                [self showAllFileWithPath:subPath WithSuffix:suffix];
            }
        }else{
            NSString *fileName = [[path componentsSeparatedByString:@"/"] lastObject];
            if ([fileName hasSuffix:[NSString stringWithFormat:@".%@", suffix]]) {
                //do anything you want
//                NSLog(@"%@", fileName);
                [self increadFileNameNumAtPath:path];
            }
        }
    }else{
        NSLog(@"this path is not exist!");
    }
}


NSInteger num = 0;

+(void)increadFileNameNumAtPath:(NSString *)path {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *newFilePath = [NSString stringWithFormat:@"%@/%ld.jpg",docDir, (long)num];
    [filemanager copyItemAtPath:path toPath:newFilePath error:nil];
    num += 1;
}

+(void)deleteFileAtPath:(NSString *)path {
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray * dirArray = [filemanager contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString *subpath in dirArray) {
        [filemanager removeItemAtPath:subpath error:nil];
    }
}
@end
