//
//  PromotionTypeModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/14.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PromotionTypeModel : NSManagedObject
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *name;

@end
