//
//  DeviceInfoUtil.m
//  ProductDemo
//
//  Created by qizd on 2018/6/13.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "DeviceInfoUtil.h"

/**
 设备类型、信息的判断、获取等
 */
@implementation DeviceInfoUtil


+ (unsigned)getFreeDiskspacePrivate {
    NSDictionary *atDict = [[NSFileManager defaultManager] attributesOfFileSystemForPath:@"/" error:NULL];
    unsigned freeSpace = [[atDict objectForKey:NSFileSystemFreeSize] unsignedIntValue];
    NSLog(@"%s - Free Diskspace: %u bytes - %u MiB", __PRETTY_FUNCTION__, freeSpace, (freeSpace/1024)/1024);
    
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];

    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }

    NSLog(@"%@", totalFreeSpace) ;
    NSLog(@"%@", freeSpace) ;
    return freeSpace;
}

@end
