//
//  PlaceOrderListDetailGoodController.m
//  离线app
//
//  Created by 王吉源 on 16/10/26.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "PlaceOrderListDetailGoodController.h"
#import "GoodInfoController.h"
#import "PromotionCell.h"
#import "PlaceOrderGoodModel.h"
#import "JudgeCustomerOptional.h"
@interface PlaceOrderListDetailGoodController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,assign)BOOL canChange;
@end

@implementation PlaceOrderListDetailGoodController
-(RootTableView *)tableView{
    if (!_tableView) {
        _tableView=[[RootTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH-64-50-50) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self searchDatabase];
    [self.view addSubview:self.tableView];
}
-(void)changeStatusWithCanChange:(BOOL)canChange{
    _canChange = canChange;
    [_tableView reloadData];
}
-(void)dataDidChange{
    [self searchDatabase];
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<_dataSource.count) {
        return 100;
    }
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<_dataSource.count) {
        PlaceOrderGoodModel *model = [_dataSource objectAtIndex:indexPath.section];
        PromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PromotionCell" owner:nil options:nil]firstObject];
        }
        cell.ruleLabel.text = model.materialName;
        cell.typeLabel.text = [NSString stringWithFormat:@"数量：%ld",model.quantity.integerValue];
        cell.priceLabel.text = [NSString stringWithFormat:@"单价：%.2f",model.price.doubleValue];
        cell.totlePriceLabel.text = [NSString stringWithFormat:@"金额：%.2f",model.amount.doubleValue];
        cell.editButton.hidden = YES;
        [cell.sendButton addTarget:self action:@selector(firstButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sendButton setBackgroundColor:APPMAINBLUECOLOR];
        [cell.sendButton setTitle:@"编辑" forState:UIControlStateNormal];
        [cell.delButton addTarget:self action:@selector(secondButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (!_canChange) {
            cell.sendButton.hidden = YES;
            [cell.delButton setBackgroundColor:APPMAINBLUECOLOR];
            [cell.delButton setTitle:@"查看" forState:UIControlStateNormal];
        }
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.imageView.image = [UIImage imageNamed:@"icon_add"];
    return cell;
}
-(void)firstButtonAction:(UIButton *)sender{
    UIView *obj = sender;
    while (![obj isKindOfClass:[UITableViewCell class]]) {
        obj = obj.superview;
    }
    PromotionCell *cell = (PromotionCell *)obj;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    PlaceOrderGoodModel *model  = [_dataSource objectAtIndex:indexPath.section];
    GoodInfoController *controller = [[GoodInfoController alloc]init];
    controller.placeOrderGoodModel = model;
    controller.isLook = YES;
    [self.navigationController pushViewController:controller animated:true];
    DefineWeakSelf;
    [controller setSuccessBlock:^{
        [weakSelf searchDatabase];
        [weakSelf.tableView reloadData];
    }];
}
-(void)secondButtonAction:(UIButton *)sender{
    UIView *obj = sender;
    while (![obj isKindOfClass:[UITableViewCell class]]) {
        obj = obj.superview;
    }
    PromotionCell *cell = (PromotionCell *)obj;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    PlaceOrderGoodModel *model  = [_dataSource objectAtIndex:indexPath.section];
    if (_canChange) {
        [kCoreDataContext deleteObject:model];
        NSError *error = nil;
        if (![kCoreDataContext save:&error]) {
            NSLog(@"插入数据错误:%@", error.userInfo);
        }
        [self searchDatabase];
        [_tableView reloadData];
    }else{
        GoodInfoController *controller = [[GoodInfoController alloc]init];
        controller.placeOrderGoodModel = model;
        controller.isLook = YES;
        controller.cannotChange = YES;
        [self.navigationController pushViewController:controller animated:true];
        DefineWeakSelf;
        [controller setSuccessBlock:^{
            [weakSelf searchDatabase];
            [weakSelf.tableView reloadData];
        }];
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_canChange) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if (indexPath.section == _dataSource.count) {
        GoodInfoController *controller = [[GoodInfoController alloc]init];
        controller.isLook = YES;
        [self.navigationController pushViewController:controller animated:true];
        DefineWeakSelf;
        [controller setSuccessBlock:^{
            [weakSelf searchDatabase];
            [weakSelf.tableView reloadData];
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(void)searchDatabase{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"1"];
    NSSortDescriptor *sort= [NSSortDescriptor sortDescriptorWithKey:@"materialCode" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    _dataSource = [kCoreDataContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
}
@end
