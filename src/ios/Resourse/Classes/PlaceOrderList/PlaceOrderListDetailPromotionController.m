//
//  PlaceOrderListDetailPromotionController.m
//  离线app
//
//  Created by 王吉源 on 16/10/26.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "PlaceOrderListDetailPromotionController.h"
#import "PromotionGoodController.h"
#import "PromotionCell.h"
#import "PromotionGoodModel.h"
#import "PromotionSendController.h"
#import "JudgeCustomerOptional.h"
@interface PlaceOrderListDetailPromotionController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,assign)BOOL canChange;
@end

@implementation PlaceOrderListDetailPromotionController
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
    [self.view addSubview:self.tableView];
    [self searchData];
}
-(void)changeStatusWithCanChange:(BOOL)canChange{
    _canChange = canChange;
    [_tableView reloadData];
}
-(void)searchData{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PromotionGoodModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"1"];
    NSSortDescriptor *sort= [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    _dataSource = [kCoreDataContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    [_tableView reloadData];
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
    if (indexPath.section < _dataSource.count) {
        PromotionGoodModel *model  = [_dataSource objectAtIndex:indexPath.section];
        PromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PromotionCell" owner:nil options:nil]firstObject];
        }
        cell.ruleLabel.text = [NSString stringWithFormat:@"促销规则：%@",model.ruleName];
        cell.typeLabel.text = [NSString stringWithFormat:@"促销类型：%@",model.typeName];
        [cell.editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.delButton addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
        if (!_canChange) {
            cell.editButton.hidden = YES;
            cell.sendButton.hidden = YES;
            cell.delButton.hidden = YES;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_canChange) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if (indexPath.section == _dataSource.count) {
        PromotionGoodController *controller = [[PromotionGoodController alloc]init];
        controller.isLook = YES;
        [self.navigationController pushViewController:controller animated:YES];
        DefineWeakSelf;
        [controller setStorageData:^{
            [weakSelf searchData];
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(void)editAction:(UIButton *)sender{
    UIView *obj = sender;
    while (![obj isKindOfClass:[UITableViewCell class]]) {
        obj = obj.superview;
    }
    PromotionCell *cell = (PromotionCell *)obj;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    PromotionGoodModel *model  = [_dataSource objectAtIndex:indexPath.section];
    PromotionGoodController *controller = [[PromotionGoodController alloc]init];
    controller.goodModel = model;
    controller.isLook = YES;
    [self.navigationController pushViewController:controller animated:YES];
    DefineWeakSelf;
    [controller setStorageData:^{
        [weakSelf searchData];
    }];
}
-(void)sendAction:(UIButton *)sender{
    UIView *obj = sender;
    while (![obj isKindOfClass:[UITableViewCell class]]) {
        obj = obj.superview;
    }
    PromotionCell *cell = (PromotionCell *)obj;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    PromotionGoodModel *model  = [_dataSource objectAtIndex:indexPath.section];
    PromotionSendController *controller = [[PromotionSendController alloc]init];
    controller.goodModel = model;
    controller.isLook = YES;
    [self.navigationController pushViewController:controller animated:YES];
    DefineWeakSelf;
    [controller setSuccessBlock:^{
        if (weakSelf.changeBlock) {
            weakSelf.changeBlock();
        }
    }];
}
-(void)delAction:(UIButton *)sender{
    UIView *obj = sender;
    while (![obj isKindOfClass:[UITableViewCell class]]) {
        obj = obj.superview;
    }
    PromotionCell *cell = (PromotionCell *)obj;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    PromotionGoodModel *model  = [_dataSource objectAtIndex:indexPath.row];
    [kCoreDataContext deleteObject:model];
    [self searchData];
    NSError *error = nil;
    if (![kCoreDataContext save:&error]) {
        NSLog(@"插入数据错误:%@", error.userInfo);
    }
    [_tableView reloadData];
}

@end
