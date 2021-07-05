//
//  UIImage+Tools.h
//  ProductDemo
//
//  Created by 祁子栋 on 2021/2/17.
//  Copyright © 2021 qizd. All rights reserved.
//

#import <UIKit/UIKit.h>


//TEST

@interface UIImage (Tools)



- (UIImage *)waterMarkWithText:(NSString *)text;
- (UIImage *)waterMarkWithText_New:(NSString *)text;
- (UIImage *)waterMarkWithText_New2:(NSString *)text;

+ (UIImage *)combineImages:(NSArray *)imageArr;
+ (UIImage *)combineImagesNew:(NSArray *)imageArr;
+ (UIImage *)combineImagesVersion2:(NSArray *)imageArr;
+ (UIImage *)combineImagesVersion3:(NSArray *)imageArr withText:(NSArray *)textArr;
@end


