//
//  PlaceOrderListCell.h
//  离线app
//
//  Created by 王吉源 on 16/10/21.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
