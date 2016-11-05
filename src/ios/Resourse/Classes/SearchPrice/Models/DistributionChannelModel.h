//
//  DistributionChannelModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/25.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DistributionChannelModel : NSManagedObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *code;

@end
