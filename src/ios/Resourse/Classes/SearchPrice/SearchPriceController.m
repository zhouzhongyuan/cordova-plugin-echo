//
//  SearchPriceController.m
//  离线app
//
//  Created by 王吉源 on 16/10/25.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "SearchPriceController.h"
#import <CoreData/CoreData.h>
#import "SearchMaterialController.h"
#import "CustomerGroupModel.h"
#import "DistributionChannelModel.h"
#import "FilterCustomerController.h"
#import "SelectCustomerController.h"
#import "CustomerModel.h"
#import "MaterialPriceModel.h"
#import "PriceCell.h"
#import "HCScanQRViewController.h"
@interface SearchPriceController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)NSArray *placeholders;
@property(nonatomic,strong)MaterialModel *goodModel;
@property(nonatomic,strong)CustomerGroupModel *groupModel;
@property(nonatomic,strong)DistributionChannelModel *channelModel;
@property(nonatomic,strong)CustomerModel *customterModel;
@property(nonatomic,strong)MaterialPriceModel *priceModel;
@end

@implementation SearchPriceController
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
    self.title = @"商品价格查询";
    self.titles =@[@"分销渠道",@"客户连锁",@"客户",@"拍照扫码",@"激光扫码",@"商品"];
    self.placeholders =@[@"请选择分销渠道",@"请选择客户连锁",@"请选择客户",@"请扫条形码码",@"请扫激光码",@"请选择商品"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setBottomButtons];
}

-(void)setBottomButtons{
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGTH-64-50, SCREEN_WIDTH, 50)];
    [saveButton setBackgroundColor:APPMAINCOLOR];
    [saveButton setTitle:@"查询" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}
-(void)searchAction{
    if (!_customterModel) {
        [SVProgressHUD showImage:nil status:@"请选择客户"];
        return;
    }
    if (!_goodModel) {
        [SVProgressHUD showImage:nil status:@"请选择商品"];
        return;
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MaterialPriceModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"(materialcode=%@ AND customercode=%@)",_goodModel.code,_customterModel.code];
    NSSortDescriptor *sort= [NSSortDescriptor sortDescriptorWithKey:@"materialcode" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    if (arr.count == 0) {
        [SVProgressHUD showImage:nil status:@"未查询到该商品价格"];
    }
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    _priceModel = [arr firstObject];
    [_tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }
    if (_priceModel) {
        return 70;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 0;
    }
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 30)];
        label.text = @"    库存明细";
        label.textColor = [UIColor hexValue:0x333333];
        label.font = [UIFont systemFontOfSize:14];
        return label;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                [view removeFromSuperview];
            }
        }
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-110, 44)];
        textField.textColor = [UIColor hexValue:0x666666];
        textField.font = [UIFont systemFontOfSize:14];
        [cell addSubview:textField];
        textField.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        textField.placeholder = [_placeholders objectAtIndex:indexPath.row];
        switch (indexPath.row) {
            case 0:{
                textField.text = _channelModel.name;
            }
                break;
            case 1:{
                textField.text = _groupModel.name;
            }
                break;
            case 2:{
                textField.text = _customterModel.name;
            }
                break;
            case 3:{
                textField.text = _goodModel.barcode;
            }
                break;
            case 4:{
                textField.text = _goodModel.barcode;
                textField.delegate = self;
                textField.userInteractionEnabled = YES;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }
                break;
            case 5:{
                textField.text = _goodModel.name;
            }
                break;
            default:
                break;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor hexValue:0x333333];
        cell.textLabel.text = [_titles objectAtIndex:indexPath.row];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH-15, 1)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell addSubview:view];
        return cell;
    }
    PriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PriceCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PriceCell" owner:nil options:nil]firstObject];
    }
    cell.clipsToBounds= YES;
    cell.nameLabel.text = _priceModel.materialname;
    cell.priceTypeLabel.text = [NSString stringWithFormat:@"价格类型：%@",_priceModel.pricetype];
    cell.priceLabel.text = [NSString stringWithFormat:@"价格：%@",_priceModel.price];
    cell.startTIme.text = [NSString stringWithFormat:@"开始时间：%@",_priceModel.validdatefrom];
    cell.endTime.text = [NSString stringWithFormat:@"结束时间：%@",_priceModel.validdateend];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DefineWeakSelf;
    if (indexPath.row == 5) {
        SearchMaterialController *controller = [[SearchMaterialController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
        [controller setSuccessSeachGood:^(MaterialModel *model) {
            weakSelf.goodModel = model;
            [weakSelf.tableView reloadData];
        }];
    }else if (indexPath.row == 0){
        FilterCustomerController *controller = [[FilterCustomerController alloc]init];
        controller.title = @"分销渠道";
        [self.navigationController pushViewController:controller animated:true];
        [controller setSuccessChannel:^(DistributionChannelModel *model) {
            weakSelf.channelModel = model;
            [weakSelf.tableView reloadData];
        }];
    }else if (indexPath.row == 1){
        FilterCustomerController *controller = [[FilterCustomerController alloc]init];
        controller.isGroup = YES;
        controller.title = @"客户连锁";
        [self.navigationController pushViewController:controller animated:true];
        [controller setSuccessGroup:^(CustomerGroupModel *model) {
            weakSelf.groupModel = model;
            [weakSelf.tableView reloadData];
        }];
    }else if (indexPath.row ==2){
        SelectCustomerController *controller = [[SelectCustomerController alloc]init];
        if (_channelModel) {
            controller.channelModel =_channelModel;
        }
        if (_groupModel) {
            controller.groupModel = _groupModel;
        }
        [self.navigationController pushViewController:controller animated:true];
        [controller setReturnCustomter:^(CustomerModel *model) {
            weakSelf.customterModel = model;
            [weakSelf.tableView reloadData];
        }];
    }else if (indexPath.row == 3){
        HCScanQRViewController *controller = [[HCScanQRViewController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
        [controller successfulGetQRCodeInfo:^(NSString *QRCodeInfo) {
            [weakSelf searchGoodWithBarCode:QRCodeInfo];
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length == 0) return YES;
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 20) {
        return NO;
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        [self searchGoodWithBarCode:textField.text];
    }
}
#pragma  mark - 根据激光码找商品
-(void)searchGoodWithBarCode:(NSString *)barCode{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MaterialModel"];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    
    NSArray *sortDescriptors=[NSArray arrayWithObject:sort];
    
    [request setSortDescriptors:sortDescriptors];
    request.predicate = [NSPredicate predicateWithFormat:@"barcode=%@",barCode];
    NSError *error = nil;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    if (arr.count == 0) {
        [SVProgressHUD showImage:nil status:@"没查到对应的商品，请检查激光码"];
        self.goodModel = nil;
        [_tableView reloadData];
        return;
    }
    self.goodModel = [arr firstObject];
    [self.tableView reloadData];
    
}
@end
