//
//  CustomerGroupJsonModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/25.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "JSONModel.h"


@protocol CustomerGroupListModel <NSObject>
@end
@interface CustomerGroupListModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*code;
@property(nonatomic,strong)NSString <Optional>*name;
@end
@interface CustomerGroupJsonModel : JSONModel
@property(nonatomic,strong)NSArray <CustomerGroupListModel,Optional>*customerGroup;
@end
