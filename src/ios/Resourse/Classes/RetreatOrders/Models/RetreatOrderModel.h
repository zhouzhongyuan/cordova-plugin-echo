//
//  RetreatOrderModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/25.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface RetreatOrderModel : NSManagedObject
@property(nonatomic,strong)NSString *totalquantity;
@property(nonatomic,strong)NSString *total;
@property(nonatomic,strong)NSString *staff;
@property(nonatomic,strong)NSString *returnReasonName;
@property(nonatomic,strong)NSString *returnReason;
@property(nonatomic,strong)NSString *imageUrl4;
@property(nonatomic,strong)NSString *imageUrl3;
@property(nonatomic,strong)NSString *imageUrl2;
@property(nonatomic,strong)NSString *imageUrl1;
@property(nonatomic,strong)NSData *image4;
@property(nonatomic,strong)NSData *image3;
@property(nonatomic,strong)NSData *image2;
@property(nonatomic,strong)NSData *image1;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *customerName;
@property(nonatomic,strong)NSString *customer;
@property(nonatomic,strong)NSString *company;
@property(nonatomic,strong)NSString *staffName;
@property(nonatomic,strong)NSString *isUp;
@end
