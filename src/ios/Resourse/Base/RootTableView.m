//
//  RootTableView.m
//  不一样的烟火
//
//  Created by 吉源 on 16/5/12.
//  Copyright © 2016年 吉源. All rights reserved.
//

#import "RootTableView.h"

@interface RootTableView()

@end
@implementation RootTableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self=[super initWithFrame:frame style:style]) {
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self setExtraCellLineHidden:self];
    }
    return self;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
@end
