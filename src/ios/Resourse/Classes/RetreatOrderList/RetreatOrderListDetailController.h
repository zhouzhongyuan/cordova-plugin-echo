//
//  RetreatOrderListDetailController.h
//  离线app
//
//  Created by 王吉源 on 16/10/27.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RootViewController.h"
#import "RetreatOrderModel.h"
#import "RetreatReasonModel.h"
@interface RetreatOrderListDetailController : RootViewController
@property(nonatomic,strong)RetreatOrderModel *orderModel;
//@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong)UIImage *headerImage1;
@property(nonatomic,strong)UIImage *headerImage2;
@property(nonatomic,strong)UIImage *headerImage3;
@property(nonatomic,strong)UIImage *headerImage4;
@property(nonatomic,strong)NSString *reasonId;
@property(nonatomic,strong)NSString *totlePrice;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)void (^successBlock)();
@property(nonatomic,assign)BOOL isUp;
@end
