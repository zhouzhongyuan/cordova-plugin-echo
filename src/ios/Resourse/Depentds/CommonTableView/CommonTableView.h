//
//  CommonTableView.h
//  不一样的烟火
//
//  Created by 吉源 on 16/5/25.
//  Copyright © 2016年 吉源. All rights reserved.
//

#import "RootTableView.h"

@interface CommonTableView : RootTableView
@property(nonatomic,strong)void(^selectedIndex)(NSInteger index);
-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)array detialTitleArray:(NSArray *)detialArray;
@end
