//
//  FilterCustomerController.h
//  离线app
//
//  Created by 王吉源 on 16/10/25.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RootViewController.h"
#import "CustomerGroupModel.h"
#import "DistributionChannelModel.h"
#import "MaterialGroupModel.h"
@interface FilterCustomerController : RootViewController
@property(nonatomic,assign)BOOL isBrand;
@property(nonatomic,assign)BOOL isGroup;
@property(nonatomic,strong)void(^successGroup)(CustomerGroupModel *model);
@property(nonatomic,strong)void(^successChannel)(DistributionChannelModel *model);
@property(nonatomic,strong)void(^successBrand)(MaterialGroupModel *model);
@end
