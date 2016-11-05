//
//  UserModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/21.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface UserModel : NSManagedObject
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *companycode;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *company;
@property(nonatomic,strong)NSString *lasttime;
@end
