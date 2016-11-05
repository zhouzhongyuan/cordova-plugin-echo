//
//  PlaceOrderGoodModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/19.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PlaceOrderGoodModel : NSManagedObject
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *stockQuantity;
@property(nonatomic,strong)NSString *spec;
@property(nonatomic,strong)NSString *smallunit;
@property(nonatomic,strong)NSString *salesType;
@property(nonatomic,strong)NSString *salesRule;
@property(nonatomic,strong)NSString *salesID;
@property(nonatomic,strong)NSString *quantity;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *note;
@property(nonatomic,strong)NSString *midunit;
@property(nonatomic,strong)NSString *materialCode;
@property(nonatomic,strong)NSString *bigunit;
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)NSString *materialName;
@property(nonatomic,strong)NSString *orderId;
@end
