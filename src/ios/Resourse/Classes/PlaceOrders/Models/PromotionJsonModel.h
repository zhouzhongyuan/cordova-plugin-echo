//
//  PromotionJsonModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/18.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "JSONModel.h"

@protocol PromotionListModel <NSObject>
@end
@interface PromotionListModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*type;
@property(nonatomic,strong)NSString <Optional>*startdate;
@property(nonatomic,strong)NSString <Optional>*salesname;
@property(nonatomic,strong)NSString <Optional>*salescode;
@property(nonatomic,strong)NSString <Optional>*price;
@property(nonatomic,strong)NSString <Optional>*materialname;
@property(nonatomic,strong)NSString <Optional>*materialcode;
@property(nonatomic,strong)NSString <Optional>*enddate;
@property(nonatomic,strong)NSString <Optional>*customercode;
@property(nonatomic,strong)NSString <Optional>*customer;
@property(nonatomic,strong)NSString <Optional>*code;
@property(nonatomic,strong)NSString <Optional>*name;
@property(nonatomic,strong)NSString <Optional>*brand;
@end
@interface PromotionJsonModel : JSONModel
@property(nonatomic,strong)NSArray <PromotionListModel,Optional> *promotion;
@end
