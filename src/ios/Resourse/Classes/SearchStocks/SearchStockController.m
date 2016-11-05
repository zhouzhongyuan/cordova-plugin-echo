//
//  SearchStockController.m
//  离线app
//
//  Created by 王吉源 on 16/10/25.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "SearchStockController.h"
#import <CoreData/CoreData.h>
#import "UserModel.h"
#import "SearchMaterialController.h"
#import "StockCell.h"
#import "StockModel.h"
#import "HCScanQRViewController.h"
@interface SearchStockController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)MaterialModel *goodModel;
@property(nonatomic,strong)StockModel *stockModel;
@end

@implementation SearchStockController
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
    self.title = @"商品库存查询";
    self.titles =@[@"公司",@"拍照扫码",@"激光扫码",@"商品"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setBottomButtons];
}
#pragma mark - 查找厂商
-(NSString *)searchManufacturer{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserModel"];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    NSArray *sortDescriptors=[NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    UserModel *userModel = [arr lastObject];
    NSLog(@"%@",userModel.company);
    return userModel.company;
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
    if (!_goodModel) {
        [SVProgressHUD showImage:nil status:@"请选择商品"];
        return;
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"StockModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"code=%@",_goodModel.code];
    NSSortDescriptor *sort= [NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    if (arr.count == 0) {
        [SVProgressHUD showImage:nil status:@"未查询到该商品库存"];
        return;
    }
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    _stockModel = [arr firstObject];
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }
    if (_stockModel) {
        return 90;
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
        switch (indexPath.row) {
            case 0:{
                textField.text = [self searchManufacturer];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
            case 1:{
                textField.placeholder = @"请扫条形码";
                
                textField.text = _goodModel.barcode;
            }
                break;
            case 2:{
                textField.placeholder = @"请扫激光码";
                textField.userInteractionEnabled = YES;
                textField.text = _goodModel.barcode;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.delegate = self;
            }
                break;
            case 3:{
                textField.placeholder = @"请选择商品";
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
    StockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StockCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"StockCell" owner:nil options:nil]firstObject];
    }
    cell.clipsToBounds= YES;
    cell.nameLabel.text = [NSString stringWithFormat:@"商品：%@",_goodModel.name];
    cell.brandLabel.text = [NSString stringWithFormat:@"品牌：%@",_goodModel.brand];
    cell.seriesLabel.text = [NSString stringWithFormat:@"系列：%@",_goodModel.series];
    cell.amountLabel.text = [NSString stringWithFormat:@"库存总量：%@",_stockModel.amount];
    cell.normalLabel.text = [NSString stringWithFormat:@"正常品：%@",_stockModel.normal];
    cell.adventLabel.text = [NSString stringWithFormat:@"临期品：%@",_stockModel.advent];
    cell.expiredLabel.text = [NSString stringWithFormat:@"过期品：%@",_stockModel.expired];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:true];
    DefineWeakSelf;
    if (indexPath.row == 3) {
        
        SearchMaterialController *controller = [[SearchMaterialController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
        [controller setSuccessSeachGood:^(MaterialModel *model) {
            weakSelf.goodModel = model;
            [weakSelf.tableView reloadData];
        }];
    }else if (indexPath.row == 2){
        HCScanQRViewController *controller = [[HCScanQRViewController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
        [controller successfulGetQRCodeInfo:^(NSString *QRCodeInfo) {
            [weakSelf searchGoodWithBarCode:QRCodeInfo];
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:true];
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
