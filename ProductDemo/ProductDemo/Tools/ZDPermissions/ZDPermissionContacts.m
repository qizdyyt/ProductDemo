//
//  ZDPermissionContacts.m
//  ProductDemo
//
//  Created by qizd on 2018/6/14.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "ZDPermissionContacts.h"
#import <AddressBook/AddressBook.h>

@implementation ZDPermissionContacts

+ (NSInteger)authorizationStatus {
    if (@available(iOS 9, *)) {
        return [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    } else {
        return ABAddressBookGetAuthorizationStatus();
    }
}


+ (BOOL)authorized {
    if (@available(iOS 9.0, *)) {
        return [self authorizationStatus] == CNAuthorizationStatusAuthorized;
    } else {
        // Fallback on earlier versions
        return [self authorizationStatus] == kABAuthorizationStatusAuthorized;
    }
}

+ (void)authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    
    if (@available(iOS 9,*))
    {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status)
        {
            case CNAuthorizationStatusAuthorized:
            {
                if (completion) {
                    completion(YES,NO);
                }
            }
                break;
            case CNAuthorizationStatusDenied:
            case CNAuthorizationStatusRestricted:
            {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
            case CNAuthorizationStatusNotDetermined:
            {
                [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (completion) {
                            completion(granted,YES);
                        }
                    });
                }];
                
            }
                break;
        }
    }
    else
    {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        
        switch (status) {
            case kABAuthorizationStatusAuthorized: {
                if (completion) {
                    completion(YES,NO);
                }
            } break;
            case kABAuthorizationStatusNotDetermined: {
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(granted,YES);
                        });
                    }
                });
            } break;
            case kABAuthorizationStatusRestricted:
            case kABAuthorizationStatusDenied: {
                if (completion) {
                    completion(NO,NO);
                }
            } break;
        }
    }
    
}

@end
