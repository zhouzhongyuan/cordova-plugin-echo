//
//  MaterialJsonModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/18.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "JSONModel.h"

@protocol MaterialListModel <NSObject>
@end
@interface MaterialListModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*spec;
@property(nonatomic,strong)NSString <Optional>*series;
@property(nonatomic,strong)NSString <Optional>*name;
@property(nonatomic,strong)NSString <Optional>*midunit;
@property(nonatomic,strong)NSString <Optional>*midscale;
@property(nonatomic,strong)NSString <Optional>*code;
@property(nonatomic,strong)NSString <Optional>*brand;
@property(nonatomic,strong)NSString <Optional>*bigunit;
@property(nonatomic,strong)NSString <Optional>*bigscale;
@property(nonatomic,strong)NSString <Optional>*basicunit;
@property(nonatomic,strong)NSString <Optional>*barcode;
@end
@interface MaterialJsonModel : JSONModel
@property(nonatomic,strong)NSArray <MaterialListModel,Optional> *material;
@end
