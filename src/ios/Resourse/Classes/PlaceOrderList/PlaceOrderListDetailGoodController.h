//
//  PlaceOrderListDetailGoodController.h
//  离线app
//
//  Created by 王吉源 on 16/10/26.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RootViewController.h"
#import "PlaceOrderModel.h"
@interface PlaceOrderListDetailGoodController : RootViewController
@property(nonatomic,strong)PlaceOrderModel *orderModel;
-(void)dataDidChange;
-(void)changeStatusWithCanChange:(BOOL)canChange;

@end
