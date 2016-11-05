//
//  PromotionGoodController.h
//  离线app
//
//  Created by 王吉源 on 16/10/14.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RootViewController.h"
#import "PromotionTypeModel.h"
#import "PromotionRuleModel.h"
#import <CoreData/CoreData.h>
#import "PromotionGoodModel.h"
@interface PromotionGoodController : RootViewController
@property(nonatomic,strong)void (^StorageData)();
@property(nonatomic,strong)PromotionGoodModel *goodModel;
@property(nonatomic,assign)BOOL isLook;
@end
