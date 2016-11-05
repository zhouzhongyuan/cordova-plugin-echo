//
//  SearchMaterialController.h
//  离线app
//
//  Created by 王吉源 on 16/10/18.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RootViewController.h"
#import "MaterialModel.h"
@interface SearchMaterialController : RootViewController
@property(nonatomic,strong)void (^successSeachGood)(MaterialModel *model);
@property(nonatomic,assign)BOOL isLook;
@end
