//
//  JYTimePickerView.h
//  TongYan
//
//  Created by 吉源 on 16/4/18.
//  Copyright © 2016年 Alone. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @author danzhu, 15-04-18 14:04:05
 *
 *  时间三级联动视图
 *
 *  @since 1.0
 */
@interface JYTimePickerView : UIView
typedef NS_ENUM(NSInteger, SelectTimeStyle) {
    YYYYMMDD_hh_mm     = 1,//(e.g. 2016-12-22 10时 10分)
    YYYY_MM_DD,        //(e.g. 2016-12-22)
    hh_mm_ss,           //(e.g. 10-10-10)
    YYYYMM,             //(e.g. 2016年10月)
};
@property(nonatomic,assign)SelectTimeStyle selectTimeStyle;
@property(nonatomic ,assign)BOOL isCannotBecomeTime;//不能早于当前时间
@property(nonatomic ,assign)BOOL isCannotLateTime;//不能晚于当前时间
@property (nonatomic, strong)UIButton *sureBtn;//确定按钮


- (void)initData;
/**
 *  @author 吉源, 16-04-18 14:04:37
 *
 *  点击确认按钮，回调
 *
 *  @since 1.0
 */
@property(strong, nonatomic)void (^timeCallback)(NSString *year,NSString *month,NSString *day,NSDictionary *timeDict);

/**
 点击取消按钮，回调
 */
@property(strong, nonatomic)void (^cancelCallback)();
@end
