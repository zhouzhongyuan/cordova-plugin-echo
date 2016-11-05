//
//  PlaceOrderBasicController.h
//  离线app
//
//  Created by 王吉源 on 16/10/14.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RootViewController.h"

@interface PlaceOrderBasicController : RootViewController
@property(nonatomic,strong)NSString *orderId;
-(void)calculationPrice;
@end
