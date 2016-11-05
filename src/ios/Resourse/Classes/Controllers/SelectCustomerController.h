//
//  SelectCustomerController.h
//  离线app
//
//  Created by 王吉源 on 16/10/13.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RootViewController.h"
#import "CustomerModel.h"
#import "CustomerGroupModel.h"
#import "DistributionChannelModel.h"
@interface SelectCustomerController : RootViewController
@property(nonatomic,strong)void (^returnCustomter)(CustomerModel *model);
@property(nonatomic,strong)CustomerGroupModel *groupModel;
@property(nonatomic,strong)DistributionChannelModel *channelModel;
@end
