//
//  ZDPermissionManager.m
//  ProductDemo
//
//  Created by qizd on 2018/6/14.
//  Copyright © 2018年 qizd. All rights reserved.
//

#import "ZDPermissionManager.h"


@implementation ZDPermissionManager

+ (BOOL)isServicesEnabledWithType:(ZDPermissionType)type
{
    if (type == ZDPermissionType_Location) {
        return [ZDPermissionLocation isServicesEnabled];
    }
    
    return YES;
}

+ (BOOL)isDeviceSupportedWithType:(ZDPermissionType)type
{
    if (type == ZDPermissionType_Health) {
        
        return  [ZDPermissionHealth isHealthDataAvailable];
    }
    
    return YES;
}

+ (BOOL)authorizedWithType:(ZDPermissionType)type
{
    switch (type) {
        case ZDPermissionType_Location:
            return [ZDPermissionLocation authorized];
            break;
        case ZDPermissionType_Camera:
            return [ZDPermissionCamera authorized];
            break;
        case ZDPermissionType_Photos:
            return [ZDPermissionPhotos authorized];
            break;
        case ZDPermissionType_Contacts:
            return [ZDPermissionContacts authorized];
            break;
        case ZDPermissionType_Reminders:
            return [ZDPermissionReminders authorized];
            break;
        case ZDPermissionType_Calendar:
            return [ZDPermissionCalendar authorized];
            break;
        case ZDPermissionType_Microphone:
            return [ZDPermissionMicrophone authorized];
            break;
        case ZDPermissionType_Health:
            return [ZDPermissionHealth authorized];
            break;
        case ZDPermissionType_Net:
            break;
        default:
            break;
    }
    return NO;
}

+ (void)authorizWithType:(ZDPermissionType)type completion:(void (^)(BOOL, BOOL))completion {
    switch (type) {
        case ZDPermissionType_Location:
            return [ZDPermissionLocation authorizeWithCompletion:completion];
            break;
        case ZDPermissionType_Camera:
            return [ZDPermissionCamera authorizeWithCompletion:completion];
            break;
        case ZDPermissionType_Photos:
            return [ZDPermissionPhotos authorizeWithCompletion:completion];
            break;
        case ZDPermissionType_Contacts:
            return [ZDPermissionContacts authorizeWithCompletion:completion];
            break;
        case ZDPermissionType_Reminders:
            return [ZDPermissionReminders authorizeWithCompletion:completion];
            break;
        case ZDPermissionType_Calendar:
            return [ZDPermissionCalendar authorizeWithCompletion:completion];
            break;
        case ZDPermissionType_Microphone:
            return [ZDPermissionMicrophone authorizeWithCompletion:completion];
            break;
        case ZDPermissionType_Health:
            return [ZDPermissionHealth authorizeWithCompletion:completion];
            break;
        case ZDPermissionType_Net:
            return [ZDPermissionNet authorizeWithCompletion:completion];
            break;
            
        default:
            break;
    }
}


#pragma mark-  disPlayAppPrivacySetting

+ (void)displayAppPrivacySettings
{
    if (@available(iOS 8,*))
    {
        if (UIApplicationOpenSettingsURLString != NULL)
        {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if (@available(iOS 10,*)) {
                [[UIApplication sharedApplication]openURL:appSettings options:@{} completionHandler:^(BOOL success) {
                }];
            }
            else
            {
                [[UIApplication sharedApplication]openURL:appSettings];
            }
        }
    }
}

+ (void)showAlertToDislayPrivacySettingWithTitle:(NSString*)title msg:(NSString*)message cancel:(NSString*)cancel setting:(NSString *)setting
{
    if (@available(iOS 8,*)) {
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        //cancel
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:action];
        
        //ok
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:setting style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self displayAppPrivacySettings];
        }];
        [alertController addAction:okAction];
        
        [[self currentTopViewController] presentViewController:alertController animated:YES completion:nil];
    }
}

+ (UIViewController*)currentTopViewController
{
    UIViewController *currentViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while ([currentViewController presentedViewController])    currentViewController = [currentViewController presentedViewController];
    
    if ([currentViewController isKindOfClass:[UITabBarController class]]
        && ((UITabBarController*)currentViewController).selectedViewController != nil )
    {
        currentViewController = ((UITabBarController*)currentViewController).selectedViewController;
    }
    
    while ([currentViewController isKindOfClass:[UINavigationController class]]
           && [(UINavigationController*)currentViewController topViewController])
    {
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    }
    
    return currentViewController;
}

@end
