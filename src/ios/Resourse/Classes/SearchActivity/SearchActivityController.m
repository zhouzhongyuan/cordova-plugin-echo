//
//  SearchActivityController.m
//  离线app
//
//  Created by 王吉源 on 16/10/25.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "SearchActivityController.h"
#import <CoreData/CoreData.h>
#import "MaterialModel.h"
#import "CustomerModel.h"
#import "ActivityCell.h"
#import "SelectCustomerController.h"
#import "SearchMaterialController.h"
#import "MaterialGroupModel.h"
#import "PromotionModel.h"
#import "FilterCustomerController.h"
#import "JYTimePickerView.h"
#import "HCScanQRViewController.h"
@interface SearchActivityController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)NSArray *placeholders;
@property(nonatomic,strong)MaterialModel *goodModel;
@property(nonatomic,strong)CustomerModel *customterModel;
@property(nonatomic,strong)MaterialGroupModel *brandModel;
@property(nonatomic,strong)NSString *startTime1;
@property(nonatomic,strong)NSString *startTime2;
@property(nonatomic,strong)NSString *endTime1;
@property(nonatomic,strong)NSString *endTime2;
@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation SearchActivityController
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
    self.title = @"促销活动查询";
    _customterModel = SIGLETON.customerModel;
    self.titles =@[@"客户",@"拍照扫码",@"激光扫码",@"商品",@"品牌",@"开始时间",@"到",@"结束时间",@"到"];
    self.placeholders =@[@"请选择客户",@"请扫条形码码",@"请扫激光码",@"请选择商品",@"请选择商品品牌",@"请选择开始时间",@"请选择开始时间",@"请选择结束时间",@"请选择结束时间"];
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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PromotionModel"];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    NSArray *sortDescriptors=[NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSMutableString *string = [[NSMutableString alloc]initWithString:@"("];
    [string appendFormat:@"customercode=%@",_customterModel.code];
    if (_goodModel) {
        [string appendFormat:@" AND materialcode=%@",_goodModel.code];
    }
    if (_brandModel) {
        [string appendFormat:@" AND brand=\"%@\"",_brandModel.name];
    }
    if (_startTime1) {
        [string appendFormat:@"AND startdate>=%ld",_startTime1.integerValue];
    }
    if (_startTime2) {
        [string appendFormat:@"AND startdate<=%ld",_startTime2.integerValue];
    }
    if (_endTime1) {
        [string appendFormat:@"AND enddate>=%ld",_endTime1.integerValue];
    }
    if (_endTime2) {
        [string appendFormat:@"AND enddate<=%ld",_endTime2.integerValue];
    }
    if ([string containsString:@"AND"]) {
        [string appendString:@")"];
    }else{
        [string deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    request.predicate = [NSPredicate predicateWithFormat:string];
    NSError *error;
    _dataSource = [kCoreDataContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    if (_dataSource.count==0) {
        [SVProgressHUD showImage:nil status:@"尚未查询到符合条件的活动"];
    }
    [_tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 9;
    }
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }

    return 190;
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
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        label.text = @"    明细";
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
                textField.text = _customterModel.name;
            }
                break;
            case 1:{
                textField.text = _goodModel.barcode;
            }
                break;
            case 2:{
                textField.text = _goodModel.barcode;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.delegate = self;
                textField.userInteractionEnabled = YES;
            }
                break;
            case 3:{
                textField.text = _goodModel.name;
            }
                break;
            case 4:{
                textField.text = _brandModel.name;
            }
                break;
            case 5:{
                textField.text = _startTime1;
                textField.userInteractionEnabled = YES;
                JYTimePickerView *timePickView = [[JYTimePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 256)];
                timePickView.selectTimeStyle=YYYY_MM_DD;
                [timePickView initData];
                [timePickView setTimeCallback:^(NSString *firstStr, NSString *secondStr, NSString *thirdStr, NSDictionary *timeDict) {
                    _startTime1=[NSString stringWithFormat:@"%@%@%@",firstStr,secondStr,thirdStr];
                    textField.text=_startTime1;
                    [textField resignFirstResponder];
                }];
                // 取消回调
                [timePickView setCancelCallback:^{
                    [textField resignFirstResponder];
                }];
                textField.inputView=timePickView;
            }
                break;
            case 6:{
                textField.text = _startTime2;
                textField.userInteractionEnabled = YES;
                JYTimePickerView *timePickView = [[JYTimePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 256)];
                timePickView.selectTimeStyle=YYYY_MM_DD;
                [timePickView initData];
                [timePickView setTimeCallback:^(NSString *firstStr, NSString *secondStr, NSString *thirdStr, NSDictionary *timeDict) {
                    _startTime2=[NSString stringWithFormat:@"%@%@%@",firstStr,secondStr,thirdStr];
                    textField.text=_startTime2;
                    [textField resignFirstResponder];
                }];
                // 取消回调
                [timePickView setCancelCallback:^{
                    [textField resignFirstResponder];
                }];
                textField.inputView=timePickView;
            }
                break;
            case 7:{
                textField.text = _endTime1;
                textField.userInteractionEnabled = YES;
                JYTimePickerView *timePickView = [[JYTimePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 256)];
                timePickView.selectTimeStyle=YYYY_MM_DD;
                [timePickView initData];
                [timePickView setTimeCallback:^(NSString *firstStr, NSString *secondStr, NSString *thirdStr, NSDictionary *timeDict) {
                    _endTime1=[NSString stringWithFormat:@"%@%@%@",firstStr,secondStr,thirdStr];
                    textField.text=_endTime1;
                    [textField resignFirstResponder];
                }];
                // 取消回调
                [timePickView setCancelCallback:^{
                    [textField resignFirstResponder];
                }];
                textField.inputView=timePickView;
            }
                break;
            case 8:{
                textField.text = _endTime2;
                textField.userInteractionEnabled = YES;
                JYTimePickerView *timePickView = [[JYTimePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 256)];
                timePickView.selectTimeStyle=YYYY_MM_DD;
                [timePickView initData];
                [timePickView setTimeCallback:^(NSString *firstStr, NSString *secondStr, NSString *thirdStr, NSDictionary *timeDict) {
                    _endTime2=[NSString stringWithFormat:@"%@%@%@",firstStr,secondStr,thirdStr];
                    textField.text=_endTime2;
                    [textField resignFirstResponder];
                }];
                // 取消回调
                [timePickView setCancelCallback:^{
                    [textField resignFirstResponder];
                }];
                textField.inputView=timePickView;
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
    PromotionModel *model = [_dataSource objectAtIndex:indexPath.row];
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil]firstObject];
    }
    cell.clipsToBounds = YES;
    cell.label1.text = [NSString stringWithFormat:@"%ld 促销活动号：%@",indexPath.row+1,model.code];
    cell.label2.text = [NSString stringWithFormat:@"客户：%@",model.customer];
    cell.label3.text = [NSString stringWithFormat:@"促销类型：%@",model.type];
    cell.label4.text = [NSString stringWithFormat:@"物料：%@",model.materialname];
    cell.label5.text = [NSString stringWithFormat:@"活动政策：%@",@""];
    cell.label6.text = [NSString stringWithFormat:@"结案要求：%@",@""];
    cell.label7.text = [NSString stringWithFormat:@"活动要求：%@",@""];
    cell.label8.text = [NSString stringWithFormat:@"活动主题：%@",@""];
    cell.label9.text = [NSString stringWithFormat:@"活动目的：%@",@""];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 189, SCREEN_WIDTH-15, 1)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:view];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:true];
    DefineWeakSelf;
    if (indexPath.row == 0) {
        SelectCustomerController *controller = [[SelectCustomerController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
        [controller setReturnCustomter:^(CustomerModel *model) {
            weakSelf.customterModel = model;
            [weakSelf.tableView reloadData];
        }];
    }else if (indexPath.row == 3){
        SearchMaterialController *controller = [[SearchMaterialController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
        [controller setSuccessSeachGood:^(MaterialModel *model) {
            weakSelf.goodModel = model;
            [weakSelf.tableView reloadData];
        }];
    }else if (indexPath.row == 4){
        FilterCustomerController *controller = [[FilterCustomerController alloc]init];
        controller.isBrand = YES;
        controller.title = @"品牌列表";
        [self.navigationController pushViewController:controller animated:true];
        [controller setSuccessBrand:^(MaterialGroupModel *model) {
            _brandModel = model;
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
