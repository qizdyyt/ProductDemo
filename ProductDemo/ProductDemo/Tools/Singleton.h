//
//  Singleton.h
//  ProductDemo
//
//  Created by qizd on 2018/9/5.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

+ (instancetype)sharedInstance;

@property (copy, nonatomic) NSString *singleName;

@end
