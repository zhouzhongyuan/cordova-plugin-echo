//
//  UIViewController+JY.h
//  XiBu_theWasteOfInvestment
//
//  Created by 王吉源 on 16/6/22.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <UIKit/UIKit.h>

static char interactivePopGestureRecognizerEnableKey;
@interface UIViewController (JY)
- (void)setInteractivePopGestureRecognizerEnable:(BOOL)enable;
- (BOOL)getInteractivePopGestureRecognizerEnable;
- (void)back:(UIButton *)sender;
@end
