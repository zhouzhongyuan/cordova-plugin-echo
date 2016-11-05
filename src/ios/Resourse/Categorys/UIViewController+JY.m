//
//  UIViewController+JY.m
//  XiBu_theWasteOfInvestment
//
//  Created by 王吉源 on 16/6/22.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "UIViewController+JY.h"
#import <objc/runtime.h>
@implementation UIViewController (JY)
- (void)setInteractivePopGestureRecognizerEnable:(BOOL)enable{
    NSNumber *value = [NSNumber numberWithBool:enable];
    objc_setAssociatedObject(self, &interactivePopGestureRecognizerEnableKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)getInteractivePopGestureRecognizerEnable{
    NSNumber *value = objc_getAssociatedObject(self, &interactivePopGestureRecognizerEnableKey);
    return [value boolValue];
}
// 返回按钮
- (void)back:(UIButton *)sender {
    // 关闭当前的ViewController
    UIViewController *vc = self.navigationController.topViewController;
    if (vc != nil && [vc isKindOfClass:self.class]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
@end
