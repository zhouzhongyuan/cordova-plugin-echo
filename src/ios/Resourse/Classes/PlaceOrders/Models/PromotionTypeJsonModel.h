//
//  PromotionTypeJsonModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/17.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "JSONModel.h"

@protocol PromotionTypeListModel <NSObject>
@end
@interface PromotionTypeListModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*code;
@property(nonatomic,strong)NSString <Optional>*name;
@end
@interface PromotionTypeJsonModel : JSONModel
@property(nonatomic,strong)NSArray <PromotionTypeListModel,Optional> *promotionType;
@end
