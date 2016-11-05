//
//  PlaceOrderListUpController.m
//  离线app
//
//  Created by 王吉源 on 16/10/21.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "PlaceOrderListUpController.h"
#import <CoreData/CoreData.h>
#import "PlaceOrderListCell.h"
#import "PlaceOrderModel.h"
#import "PlaceOrderListDetailController.h"
#import "PromotionGoodModel.h"
#import "PlaceOrderGoodModel.h"

@interface PlaceOrderListUpController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation PlaceOrderListUpController
-(RootTableView *)tableView{
    if (!_tableView) {
        _tableView=[[RootTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH-64-50) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchDatabase];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
-(void)searchDatabase{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderModel"];
    request.predicate = [NSPredicate predicateWithFormat:@"isUp=%@",@"1"];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    
    NSArray *sortDescriptors=[NSArray arrayWithObject:sort];
    
    [request setSortDescriptors:sortDescriptors];
    NSError *error;
    _dataSource = [kCoreDataContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 1;
    }
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlaceOrderModel *model = [_dataSource objectAtIndex:indexPath.section];
    PlaceOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceOrderListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PlaceOrderListCell" owner:nil options:nil]firstObject];
    }
    cell.customerLabel.text = model.customerName;
    cell.userLabel.text = model.staffName;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",model.total.doubleValue];
    cell.dateLabel.text = model.date;
    cell.priceLabel.textColor = APPMAINCOLOR;
    cell.userLabel.textColor = [UIColor hexValue:0x777777];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlaceOrderModel *model = [_dataSource objectAtIndex:indexPath.section];
    [self copyPromtionWithOrderId:model.id];
    [self copyGoodWithOrderId:model.id];
    PlaceOrderListDetailController *controller = [[PlaceOrderListDetailController alloc]init];
    controller.orderModel = model;
    controller.isUp = YES;
    [self.navigationController pushViewController:controller animated:true];
    DefineWeakSelf;
    [controller setSuccessBlock:^{
        [weakSelf searchDatabase];
        [weakSelf.tableView reloadData];
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(void)copyPromtionWithOrderId:(NSString *)orderId{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PromotionGoodModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",orderId];
    NSSortDescriptor *sort= [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    for (PromotionGoodModel *model1 in arr) {
        PromotionGoodModel *model2=[NSEntityDescription insertNewObjectForEntityForName:@"PromotionGoodModel" inManagedObjectContext:kCoreDataContext];
        model2.id = model1.id;
        model2.ruleCode = model1.ruleCode;
        model2.ruleName = model1.ruleName;
        model2.typeCode = model1.typeCode;
        model2.typeName = model1.typeName;
        model2.orderId = @"1";
        [kCoreDataContext save:&error];
        if (error) {
            NSLog(@"%@",error.userInfo);
        }
    }
}
-(void)copyGoodWithOrderId:(NSString *)orderId{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",orderId];
    NSSortDescriptor *sort= [NSSortDescriptor sortDescriptorWithKey:@"materialCode" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    for (PlaceOrderGoodModel *model1 in arr) {
        PlaceOrderGoodModel *model2=[NSEntityDescription insertNewObjectForEntityForName:@"PlaceOrderGoodModel" inManagedObjectContext:kCoreDataContext];
        model2.type = model1.type;
        model2.stockQuantity = model1.stockQuantity;
        model2.spec = model1.spec;
        model2.smallunit = model1.smallunit;
        model2.salesType = model1.salesType;
        model2.salesRule = model1.salesRule;
        model2.salesID = model1.salesID;
        model2.quantity = model1.quantity;
        model2.price = model1.price;
        model2.note = model1.note;
        model2.midunit = model1.midunit;
        model2.materialCode = model1.materialCode;
        model2.bigunit = model1.bigunit;
        model2.amount = model1.amount;
        model2.materialName = model1.materialName;
        model2.orderId = @"1";
        
        [kCoreDataContext save:&error];
        if (error) {
            NSLog(@"%@",error.userInfo);
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    PlaceOrderModel *model = [_dataSource objectAtIndex:indexPath.section];
    //删除数据
    [kCoreDataContext deleteObject:model];
    
    //保存, 将删除操作更新到数据库中
    [kCoreDataContext save:nil];
    
    //删除对应的商品和促销
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PromotionGoodModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",model.id];
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:nil];
    for (PromotionGoodModel *model in arr) {
        [kCoreDataContext deleteObject:model];
    }
    
    NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
    request1.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",model.id];
    NSArray *arr1 = [kCoreDataContext executeFetchRequest:request1 error:nil];
    for (PlaceOrderGoodModel *model in arr1) {
        [kCoreDataContext deleteObject:model];
    }
    [self searchDatabase];
    [_tableView reloadData];
}
@end
