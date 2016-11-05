//
//  PromotionModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/18.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PromotionModel : NSManagedObject
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *startdate;
@property(nonatomic,strong)NSString *salesname;
@property(nonatomic,strong)NSString *salescode;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *materialname;
@property(nonatomic,strong)NSString *materialcode;
@property(nonatomic,strong)NSString *enddate;
@property(nonatomic,strong)NSString *customercode;
@property(nonatomic,strong)NSString *customer;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *brand;
@end
