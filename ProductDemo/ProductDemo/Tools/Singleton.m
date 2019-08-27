//
//  Singleton.m
//  ProductDemo
//
//  Created by qizd on 2018/9/5.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "Singleton.h"

static Singleton *_sharedSingleton = nil;

@implementation Singleton


//保证只分配一次存储空间
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
//     @synchronized(self) {
//     if (_instance == nil) {
//     _instance = [super allocWithZone:zone];
//     }
//     }
    
    static dispatch_once_t onceToken;//效果一样
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [super allocWithZone:zone];
    });
    
    return _sharedSingleton;
}

//返回一个实例化对象
+(instancetype)sharedInstance
{
    //注意:最好是写self(不要用Tools)
    
    return [[self alloc]init];
}

//- (instancetype)init {
//    [NSException raise:@"Can't use init" format:@"qweqweqwqweqweqwe"];
//    return nil;
//}




//- (instancetype)init {
//    [NSException raise:@"SingletonPattern"
//                format:@"Cannot instantiate singleton using init method, sharedInstance must be used."];
//
//    return nil;
//}
//
//- (id)copyWithZone:(NSZone *)zone {
//
//    [NSException raise:@"SingletonPattern"
//                format:@"Cannot copy singleton using copy method, sharedInstance must be used."];
//
//    return nil;
//}
//
//+ (Singleton *)sharedInstance {
//
//    if (self != [Singleton class]) {
//
//        [NSException raise:@"SingletonPattern"
//                    format:@"Cannot use sharedInstance method from subclass."];
//    }
//
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        _sharedSingleton = [[Singleton alloc] initInstance];
//    });
//
//    return _sharedSingleton;
//}
//
//#pragma mark - private method
//
//- (id)initInstance {
//
//    return [super init];
//}

@end
