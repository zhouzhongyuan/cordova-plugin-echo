//
//  PlaceOrderBasicController.m
//  离线app
//
//  Created by 王吉源 on 16/10/14.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "PlaceOrderBasicController.h"
#import "CustomerModel.h"
#import "SelectCustomerController.h"
#import "JudgeCustomerOptional.h"
#import "NSDate+Utils.h"
@interface PlaceOrderBasicController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)CustomerModel *customterModel;
@property(nonatomic,strong)NSArray *titles;
@end

@implementation PlaceOrderBasicController
-(RootTableView *)tableView{
    if (!_tableView) {
        _tableView=[[RootTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 132) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
-(void)calculationPrice{
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _titles = @[@"单据日期：",@"客户：",@"总金额："];
    _customterModel = SIGLETON.customerModel;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    for (UIView *view in cell.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view removeFromSuperview];
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor hexValue:0x333333];
    cell.textLabel.text = [_titles objectAtIndex:indexPath.row];
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-120, 44)];
    textField.textColor = [UIColor hexValue:0x666666];
    textField.font = [UIFont systemFontOfSize:14];
    [cell addSubview:textField];
    textField.userInteractionEnabled = NO;
    if (indexPath.row == 0) {
        textField.text = [NSDate currentTimeString];
    }else if (indexPath.row == 1){
        textField.textColor = [UIColor hexValue:0x333333];
        textField.text = _customterModel.name;
    }else{
        textField.text = [NSString stringWithFormat:@"¥%.2f",[JudgeCustomerOptional calculationTotlePriceWithOrderId:_orderId].doubleValue];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH-15, 1)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:view];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
//        if (JUDGECUSTOMEROPTIONAL) {
//            SelectCustomerController *controller = [[SelectCustomerController alloc]init];
//            [self.navigationController pushViewController:controller animated:true];
//            DefineWeakSelf;
//            [controller setReturnCustomter:^(CustomerModel *model) {
//                SIGLETON.customerModel = model;
//                weakSelf.customterModel = model;
//                [weakSelf.tableView reloadData];
//            }];
//        }else{
//            [SVProgressHUD showImage:nil status:@"已经选择了商品，无法选择客户"];
//        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
