//
//  PlaceOrderListDetailController.h
//  离线app
//
//  Created by 王吉源 on 16/10/26.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RootViewController.h"
#import "PlaceOrderModel.h"
@interface PlaceOrderListDetailController : RootViewController
@property(nonatomic,strong)PlaceOrderModel *orderModel;
@property(nonatomic,strong)void (^successBlock)();
@property(nonatomic,assign)BOOL isUp;
@end
