//
//  RetreatGoodCell.m
//  离线app
//
//  Created by 王吉源 on 16/10/24.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RetreatGoodCell.h"

@implementation RetreatGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_editButton setBackgroundColor:APPMAINCOLOR];
    [_delButton setBackgroundColor:APPMAINCOLOR];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
