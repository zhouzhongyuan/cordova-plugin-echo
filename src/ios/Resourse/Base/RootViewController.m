//
//  RootViewController.m
//  不一样的烟火
//
//  Created by 吉源 on 16/5/12.
//  Copyright © 2016年 吉源. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"

@interface RootViewController ()

@end

@implementation RootViewController
- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];//
    //设置IQKeyboardManager开始
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followupDetail:) name:@"goToNotice" object:nil];
    if ([UIDevice currentDevice].systemVersion.doubleValue>=8.0) {
        if (APPDELEGATE.isNotic) {
            
            APPDELEGATE.isNotic=NO;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"goToNotice" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)followupDetail:(NSNotification *)info{
    if (APPDELEGATE.isActivite) {//前台
        return;
    }
    
}


@end
