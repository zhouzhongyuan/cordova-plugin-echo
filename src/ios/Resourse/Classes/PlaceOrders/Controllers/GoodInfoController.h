//
//  GoodInfoController.h
//  离线app
//
//  Created by 王吉源 on 16/10/18.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RootViewController.h"
#import "PlaceOrderGoodModel.h"
@interface GoodInfoController : RootViewController
@property(nonatomic,strong)void(^successBlock)();
@property(nonatomic,strong)PlaceOrderGoodModel *placeOrderGoodModel;
@property(nonatomic,assign)BOOL isLook;
@property(nonatomic,assign)BOOL cannotChange;//是不是不可以改动
@end
