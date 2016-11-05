//
// Created by 段大志 on 16/4/9.
// Copyright (c) 2016 arron. All rights reserved.
//

#import <Foundation/Foundation.h>

// IOS授权管理  隐私设置
@interface IOSAuthorized : NSObject

// "相册"权限,"相机"权限,"通讯录"权限,"录音"权限,"定位"权限
// 1:相册:没有权限系统会自动显示一个页面,"次应用没有权限访问您的照片或者视频. 您可以在"隐私设置"中启用访问 "
// 2:相机:没有权限,会跳到相机页面,但是黑屏

#pragma mark 是否有相册权限;可以不阻断用户,系统默认有提示; 不要阻断系统的提示,否则可能,在有的手机上面有bug;
+ (BOOL) isPhotosAuthorized;

#pragma mark 是否有照相机权限
 + (BOOL) isCameraAuthorized;

#pragma mark 麦克风权限 - 录音
 + (BOOL) isMicroPhoneAuthorized;

#pragma mark 通知的权限
 + (BOOL) isNotificationAuthorized;

#pragma mark 运动与健康
//TODO 找运动app
+ (BOOL) isMotionAndFitnessAuthorized;

#pragma mark 定位
//TODO
+ (BOOL) isLocatonAuthorized;

#pragma mark 通讯录权限
+ (BOOL) isContactsAuthorized;
@end