//
//  MaterialPriceModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/19.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MaterialPriceModel : NSManagedObject
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *materialname;
@property(nonatomic,strong)NSString *materialcode;
@property(nonatomic,strong)NSString *customercode;
@property(nonatomic,strong)NSString *customer;
@property(nonatomic,strong)NSString *pricetype;
@property(nonatomic,strong)NSString *validdatefrom;
@property(nonatomic,strong)NSString *validdateend;
@end
