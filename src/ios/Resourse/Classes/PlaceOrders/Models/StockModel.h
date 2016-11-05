//
//  StockModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/19.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface StockModel : NSManagedObject
@property(nonatomic,strong)NSString *normal;
@property(nonatomic,strong)NSString *materialname;
@property(nonatomic,strong)NSString *expired;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)NSString *advent;
@end
