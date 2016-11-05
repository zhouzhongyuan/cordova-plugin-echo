//
//  UserJsonModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/21.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "JSONModel.h"

@protocol UserDetailModel <NSObject>
@end
@interface UserDetailModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*code;
@property(nonatomic,strong)NSString <Optional>*companycode;
@property(nonatomic,strong)NSString <Optional>*name;
@property(nonatomic,strong)NSString <Optional>*company;
@property(nonatomic,strong)NSString <Optional>*lasttime;
@end
@interface UserJsonModel : JSONModel
@property(nonatomic,strong)UserDetailModel <UserDetailModel,Optional>*user;
@end
