//
//  RetreatGoodInfoController.h
//  离线app
//
//  Created by 王吉源 on 16/10/24.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RootViewController.h"
#import "RetreatOrderGoodModel.h"
@interface RetreatGoodInfoController : RootViewController
@property(nonatomic,strong)void (^successBlock)();
@property(nonatomic,strong)RetreatOrderGoodModel *model;
@property(nonatomic,assign)BOOL cannotChange;
@property(nonatomic,assign)BOOL isLook;
@end
