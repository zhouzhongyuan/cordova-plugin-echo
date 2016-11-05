//
//  PlaceOrderModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/21.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PlaceOrderModel : NSManagedObject
@property(nonatomic,strong)NSString *total;
@property(nonatomic,strong)NSString *staff;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *company;
@property(nonatomic,strong)NSString *customer;
@property(nonatomic,strong)NSString *customerName;
@property(nonatomic,strong)NSString *staffName;
@property(nonatomic,strong)NSString *isUp;
@end
