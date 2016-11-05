//
//  CutomerJsonModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/17.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "JSONModel.h"

@protocol CutomerListModel <NSObject>
@end
@interface CutomerListModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*code;
@property(nonatomic,strong)NSString <Optional>*distributionChannel;
@property(nonatomic,strong)NSString <Optional>*name;
@property(nonatomic,strong)NSString <Optional>*region;
@property(nonatomic,strong)NSString <Optional>*route;
@property(nonatomic,strong)NSString <Optional>*salecode;
@property(nonatomic,strong)NSString <Optional>*saletype;
@property(nonatomic,strong)NSString <Optional>*customerGroup;
@end
@interface CutomerJsonModel : JSONModel
@property(nonatomic,strong)NSArray <CutomerListModel,Optional> *customer;
@end
