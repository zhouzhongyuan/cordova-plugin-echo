//
//  SelectRetreatReasonController.h
//  离线app
//
//  Created by 王吉源 on 16/10/24.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RootViewController.h"
#import "RetreatReasonModel.h"
@interface SelectRetreatReasonController : RootViewController
@property(nonatomic,strong)void(^successBlock)(RetreatReasonModel *model);
@end
