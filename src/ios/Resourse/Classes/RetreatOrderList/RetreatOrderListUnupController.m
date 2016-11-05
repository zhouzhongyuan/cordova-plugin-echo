//
//  RetreatOrderListUnupController.m
//  离线app
//
//  Created by 王吉源 on 16/10/25.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RetreatOrderListUnupController.h"
#import <CoreData/CoreData.h>
#import "PlaceOrderListCell.h"
#import "RetreatOrderModel.h"
#import "RetreatOrderListDetailController.h"
#import "RetreatOrderGoodModel.h"
@interface RetreatOrderListUnupController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation RetreatOrderListUnupController
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
    [self searchDatabase];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setBottomButtons];
}
-(void)searchDatabase{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RetreatOrderModel"];
    request.predicate = [NSPredicate predicateWithFormat:@"isUp=%@",@"0"];
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
    RetreatOrderModel *model = [_dataSource objectAtIndex:indexPath.section];
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
    RetreatOrderModel *model = [_dataSource objectAtIndex:indexPath.section];
    //复制一份订单和商品
    [self copyGoodWithOrderId:model.id];
    RetreatOrderListDetailController *controller = [[RetreatOrderListDetailController alloc]init];
    controller.orderModel = model;
    controller.headerImage1 = [UIImage imageWithData:model.image1];
    controller.headerImage2 = [UIImage imageWithData:model.image2];
    controller.headerImage3 = [UIImage imageWithData:model.image3];
    controller.headerImage4 = [UIImage imageWithData:model.image4];
    controller.totlePrice = model.total;
    controller.reasonId = model.returnReason;
    controller.number = model.totalquantity;
    [self.navigationController pushViewController:controller animated:true];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    DefineWeakSelf;
    [controller setSuccessBlock:^{
        [weakSelf searchDatabase];
        [weakSelf.tableView reloadData];
    }];
}
-(void)copyGoodWithOrderId:(NSString *)orderId{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RetreatOrderGoodModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",orderId];
    NSSortDescriptor *sort= [NSSortDescriptor sortDescriptorWithKey:@"material" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    for (RetreatOrderGoodModel *model1 in arr) {
        RetreatOrderGoodModel *model2=[NSEntityDescription insertNewObjectForEntityForName:@"RetreatOrderGoodModel" inManagedObjectContext:kCoreDataContext];
        model2.smallunit = model1.smallunit;
        model2.quantity = model1.quantity;
        model2.price = model1.price;
        model2.note = model1.note;
        model2.midunit = model1.midunit;
        model2.materialName = model1.materialName;
        model2.material = model1.material;
        model2.bigunit = model1.bigunit;
        model2.batchnumber = model1.batchnumber;
        model2.amount = model1.amount;
        model2.basicunit = model1.basicunit;
        model2.dateofmanufacture = model1.dateofmanufacture;
        model2.orderId = @"1";
        [kCoreDataContext save:&error];
        if (error) {
            NSLog(@"%@",error.userInfo);
        }
    }
}
-(void)setBottomButtons{
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGTH-64-50-50, SCREEN_WIDTH, 50)];
    [saveButton setBackgroundColor:APPMAINCOLOR];
    [saveButton setTitle:@"上传" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
}
-(void)saveAction{
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    RetreatOrderModel *model = [_dataSource objectAtIndex:indexPath.section];
    //删除数据
    [kCoreDataContext deleteObject:model];
    
    //保存, 将删除操作更新到数据库中
    [kCoreDataContext save:nil];
    //删除对应的商品
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RetreatOrderGoodModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",model.id];
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:nil];
    for (RetreatOrderGoodModel *model in arr) {
        [kCoreDataContext deleteObject:model];
    }
    [self searchDatabase];
    [_tableView reloadData];
}
@end
