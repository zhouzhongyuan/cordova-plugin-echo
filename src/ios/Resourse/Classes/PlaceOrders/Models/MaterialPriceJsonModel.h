//
//  MaterialPriceJsonModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/19.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "JSONModel.h"

@protocol MaterialPriceListModel <NSObject>
@end
@interface MaterialPriceListModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*price;
@property(nonatomic,strong)NSString <Optional>*materialname;
@property(nonatomic,strong)NSString <Optional>*materialcode;
@property(nonatomic,strong)NSString <Optional>*customercode;
@property(nonatomic,strong)NSString <Optional>*customer;
@property(nonatomic,strong)NSString <Optional>*validdatefrom;
@property(nonatomic,strong)NSString <Optional>*pricetype;
@property(nonatomic,strong)NSString <Optional>*validdateend;
@end
@interface MaterialPriceJsonModel : JSONModel
@property(nonatomic,strong)NSArray <MaterialPriceListModel,Optional> *materialPrice;
@end
