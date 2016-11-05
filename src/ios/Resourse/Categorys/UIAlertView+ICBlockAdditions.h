//
//  UIAlertView+ICBlockAdditions.h
//  iOSCodeProject
//
//  Created by zym on 14-7-18.
//  Copyright (c) 2014年 翔傲信息科技（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  UIAlertView的拓展类，方便创建。
 */

typedef void (^VoidBlock)();
typedef void (^DismissBlock)(NSInteger buttonIndex);
typedef void (^CancelBlock)();
typedef void (^PhotoPickedBlock)(UIImage *chosenImage);


@interface UIAlertView (ICBlockAdditions) <UIAlertViewDelegate>

/**
 *  快速创建
 *
 *  @param title   标题
 *  @param message 内容
 *
 *  @return UIAlertView对象
 */
+ (UIAlertView*) alertViewWithTitle:(NSString*) title 
                            message:(NSString*) message;
/**
 *  快速创建
 *
 *  @param title             标题
 *  @param message           内容
 *  @param cancelButtonTitle 取消按钮内容
 *
 *  @return UIAlertView对象
 */
+ (UIAlertView*) alertViewWithTitle:(NSString*) title 
                            message:(NSString*) message
                  cancelButtonTitle:(NSString*) cancelButtonTitle;

/**
 *  快速创建
 *
 *  @param title             标题
 *  @param message           内容
 *  @param cancelButtonTitle 取消按钮内容
 *  @param otherButtons      其他按钮数组
 *  @param dismissed         其他那妞句柄
 *  @param cancelled         取消按钮句柄
 *
 *  @return UIAlertView对象
 */
+ (UIAlertView*) alertViewWithTitle:(NSString*) title                    
                            message:(NSString*) message 
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(DismissBlock) dismissed                   
                           onCancel:(CancelBlock) cancelled;


@property (nonatomic, copy) DismissBlock dismissBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;
@property (nonatomic, assign) NSString *isManualClose;// 1 yes other no






@end
