//
//  ZDMacro.h
//  ProductDemo
//
//  Created by qizd on 2018/6/15.
//  Copyright © 2018年 qizd. All rights reserved.
//


#ifndef ZDMacro_h
#define ZDMacro_h

//获取屏幕宽高
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//float 数值
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]//字符串



#endif /* ZDMacro_h */
