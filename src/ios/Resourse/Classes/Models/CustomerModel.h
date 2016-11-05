//
//  CustomerModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/13.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CustomerModel : NSManagedObject
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *distributionChannel;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *region;
@property(nonatomic,strong)NSString *route;
@property(nonatomic,strong)NSString *salecode;
@property(nonatomic,strong)NSString *saletype;
@property(nonatomic,strong)NSString *customerGroup;
@end
