//
//  PromotionSendController.h
//  离线app
//
//  Created by 王吉源 on 16/10/18.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RootViewController.h"
#import "PromotionGoodModel.h"
@interface PromotionSendController : RootViewController
@property(nonatomic,strong)PromotionGoodModel *goodModel;
@property(nonatomic,strong)void (^successBlock)();
@property(nonatomic,assign)BOOL isLook;
@end
