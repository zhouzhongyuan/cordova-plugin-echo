//
//  RetreatReasonJsonModel.h
//  离线app
//
//  Created by 王吉源 on 16/10/24.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "JSONModel.h"

@protocol RetreatReasonListModel <NSObject>
@end
@interface RetreatReasonListModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*code;
@property(nonatomic,strong)NSString <Optional>*name;
@end
@interface RetreatReasonJsonModel : JSONModel
@property(nonatomic,strong)NSArray <RetreatReasonListModel,Optional>*returnReason;
@end
