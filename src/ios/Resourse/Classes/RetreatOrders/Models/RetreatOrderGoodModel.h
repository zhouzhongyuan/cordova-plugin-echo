//
//  RetreatOrderGoodModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/24.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface RetreatOrderGoodModel : NSManagedObject
@property(nonatomic,strong)NSString *smallunit;
@property(nonatomic,strong)NSString *quantity;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong)NSString *note;
@property(nonatomic,strong)NSString *midunit;
@property(nonatomic,strong)NSString *materialName;
@property(nonatomic,strong)NSString *material;
@property(nonatomic,strong)NSString *bigunit;
@property(nonatomic,strong)NSString *batchnumber;
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)NSString *basicunit;
@property(nonatomic,strong)NSString *dateofmanufacture;
@end
