//
// Created by 段大志 on 16/4/9.
// Copyright (c) 2016 arron. All rights reserved.
//

#import "IOSAuthorized.h"
#import "UIAlertView+ICBlockAdditions.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBook.h>


@implementation IOSAuthorized


#pragma mark 是否有相册权限

+ (BOOL)isPhotosAuthorized {
    // 导入头文件 #import <AssetsLibrary/AssetsLibrary.h>
    // #import <AssetsLibrary/ALAssetsLibrary.h>
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusDenied) {
        //无权限
        [UIAlertView alertViewWithTitle:@"无法使用相册"
                //message:@"需要访问您的相机,请到设置里面开启"
                                message:[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-照片\"中允许%@访问相册。", @"该应用"]
                      cancelButtonTitle:nil
                      otherButtonTitles:@[@"设置"]
                              onDismiss:^(NSInteger buttonIndex) {
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", @"123"]]];//权限列表
                              }
                               onCancel:nil];
        return NO;
    }
    //typedef enum {
    //    kCLAuthorizationStatusNotDetermined = 0, // 用户尚未做出选择这个应用程序的问候
    //    kCLAuthorizationStatusRestricted,        // 此应用程序没有被授权访问的照片数据。可能是家长控制权限
    //    kCLAuthorizationStatusDenied,            // 用户已经明确否认了这一照片数据的应用程序访问
    //    kCLAuthorizationStatusAuthorized         // 用户已经授权应用访问照片数据} CLAuthorizationStatus;
    //}
    return YES;
}

#pragma mark 是否有照相机权限
+ (BOOL)isCameraAuthorized {
    //导入系统库 AVFoundation.framework
    //导入头文件 #import <AVFoundation/AVFoundation.h>
    //http://www.jianshu.com/p/19602f48309b  <schme设置>必须
    //http://blog.csdn.net/zhaopenghhhhhh/article/details/49668375 各种跳转的url
    //http://blog.csdn.net/mideveloper/article/details/46444195    各种权限的判断
   //    CFBundleURLTypes 添加一个schem prefs
    AVAuthorizationStatus avStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    BOOL isHaveCamera = (avStatus == AVAuthorizationStatusAuthorized || avStatus == AVAuthorizationStatusNotDetermined);
    if (!isHaveCamera) {
        [UIAlertView alertViewWithTitle:@"无法使用相机"
                //message:@"需要访问您的相机,请到设置里面开启"
                                message:[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"中允许%@访问相机。", @"该应用"]
                      cancelButtonTitle:nil
                      otherButtonTitles:@[@"设置"]
                              onDismiss:^(NSInteger buttonIndex) {
                                  //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];//wife
                                  //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General"]];//通用
                                  //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=ManagedConfigurationList"]];//通用-配置列表
                                  //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"]];//通知列表
                                  //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=com.cyds.zunyi88"]];//权限列表
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", @"123"]]];//权限列表
                              }
                               onCancel:nil];
    }
    return isHaveCamera;
}

#pragma mark 麦克风权限 - 录音

+ (BOOL)isMicroPhoneAuthorized {
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    if (!bCanRecord) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertView alertViewWithTitle:@"麦克风被禁用"
                                    message:[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-麦克风\"中允许%@访问麦克风。", @"该应用"]
                          cancelButtonTitle:nil
                          otherButtonTitles:@[@"设置"]
                                  onDismiss:^(NSInteger buttonIndex) {
                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", @"123"]]];//权限列表
                                  }
                                   onCancel:nil];
        });
    }
    return bCanRecord;
}

#pragma mark 通知的权限
+ (BOOL)isNotificationAuthorized {
    BOOL isAllowNotifi = NO;
    //iOS8 check if user allow notification
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            isAllowNotifi = YES;
        }
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (UIRemoteNotificationTypeNone != type)
            isAllowNotifi = YES;
    }
    if (!isAllowNotifi) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertView alertViewWithTitle:@"无法消息推送"
                                    message:[NSString stringWithFormat:@"请在iPhone的\"[设置]-[通知]-找到[%@]-[允许通知]\"。", @"该应用"]
                          cancelButtonTitle:nil  //仿照qq的不让取消
                          otherButtonTitles:@[@"设置"]
                                  onDismiss:^(NSInteger buttonIndex) {
                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=ManagedConfigurationList"]];//通用-配置列表
                                  }
                                   onCancel:nil];
        });
    }
    return isAllowNotifi;
}

+ (BOOL)isLocatonAuthorized {
    //#import <CoreLocation/CoreLocation.h>
    //CLLocationManager
    //CLAuthorizationStatus
    //参见-车世家or溜达 定位权限写法
    return NO;
}

+ (BOOL)isContactsAuthorized {
    // #import <AddressBook/AddressBook.h>
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted)
    {
        [UIAlertView alertViewWithTitle:@"未获取通讯录权限"
                                message:[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-通讯录\"中允许%@访问通讯录。", @"该应用"]
                      cancelButtonTitle:nil
                      otherButtonTitles:@[@"设置"]
                              onDismiss:^(NSInteger buttonIndex) {
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", @"123"]]];//权限列表
                              }
                               onCancel:nil];
        return NO;
    }
    return YES;
}


//
//UIAlertView alertViewWithTitle:@"无法定位"
//message:[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-定位服务\"中允许%@使用定位服务。", APPNAME]
//cancelButtonTitle:nil  //仿照qq的不让取消
//otherButtonTitles:@[@"设置"]
//onDismiss:^(NSInteger buttonIndex) {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", APPIDENTIFIER]]];//权限列表
//}
//onCancel:nil];

@end