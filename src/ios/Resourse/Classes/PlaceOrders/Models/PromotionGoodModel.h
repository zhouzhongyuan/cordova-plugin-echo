//
//  PromotionGoodModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/17.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PromotionGoodModel : NSManagedObject
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *ruleCode;
@property(nonatomic,strong)NSString *ruleName;
@property(nonatomic,strong)NSString *typeCode;
@property(nonatomic,strong)NSString *typeName;
@property(nonatomic,strong)NSString *orderId;
@end
