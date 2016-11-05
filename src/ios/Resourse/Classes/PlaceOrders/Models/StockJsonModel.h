//
//  StockJsonModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/19.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "JSONModel.h"


@protocol StockListModel <NSObject>
@end
@interface StockListModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*normal;
@property(nonatomic,strong)NSString <Optional>*materialname;
@property(nonatomic,strong)NSString <Optional>*expired;
@property(nonatomic,strong)NSString <Optional>*code;
@property(nonatomic,strong)NSString <Optional>*amount;
@property(nonatomic,strong)NSString <Optional>*advent;
@end
@interface StockJsonModel : JSONModel
@property(nonatomic,strong)NSArray <StockListModel,Optional>*stock;
@end
