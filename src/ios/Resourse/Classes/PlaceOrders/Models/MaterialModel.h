//
//  MaterialModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/18.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MaterialModel : NSManagedObject
@property(nonatomic,strong)NSString *spec;
@property(nonatomic,strong)NSString *series;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *midunit;
@property(nonatomic,strong)NSString *midscale;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *brand;
@property(nonatomic,strong)NSString *bigunit;
@property(nonatomic,strong)NSString *bigscale;
@property(nonatomic,strong)NSString *basicunit;
@property(nonatomic,strong)NSString *barcode;
@end
