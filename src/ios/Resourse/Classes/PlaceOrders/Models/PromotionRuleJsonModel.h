//
//  PromotionRuleJsonModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/17.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "JSONModel.h"

@protocol PromotionRuleListModel <NSObject>
@end
@interface PromotionRuleListModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*code;
@property(nonatomic,strong)NSString <Optional>*name;
@property(nonatomic,strong)NSString <Optional>*type;
@end
@interface PromotionRuleJsonModel : JSONModel
@property(nonatomic,strong)NSArray <PromotionRuleListModel,Optional> *ruleNo;
@end
