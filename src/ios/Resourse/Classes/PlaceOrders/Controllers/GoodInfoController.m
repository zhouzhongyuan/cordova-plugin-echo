//
//  GoodInfoController.m
//  离线app
//
//  Created by 王吉源 on 16/10/18.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "GoodInfoController.h"
#import "HCScanQRViewController.h"
#import "SearchMaterialController.h"
#import "MaterialModel.h"
#import "MaterialPriceJsonModel.h"
#import "MaterialPriceModel.h"
#import <CoreData/CoreData.h>
#import "StockModel.h"
#import "StockJsonModel.h"

@interface GoodInfoController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)MaterialModel *goodModel;
@property (nonatomic, strong) NSFileManager *fileMgr;
@property (nonatomic, strong) NSString *documentsPath;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *stock;

@property(nonatomic,strong)NSString *bigNum;
@property(nonatomic,strong)NSString *mediumNum;
@property(nonatomic,strong)NSString *smallNum;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)NSString *note;
@property(nonatomic,strong)NSString *totlePrice;
@end

@implementation GoodInfoController
-(RootTableView *)tableView{
    if (!_tableView) {
        if (_cannotChange) {
            _tableView=[[RootTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH-64) style:UITableViewStylePlain];
        }else{
           _tableView=[[RootTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH-64-50) style:UITableViewStylePlain];
        }
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品信息";
    _titles = @[@"商品拍照条码",@"商品激光条码",@"商品",@"规格",@"当前库存",@"大单位数量",@"中单位数量",@"小单位数量",@"数量",@"销售单价",@"订单金额",@"备注"];

    if (_placeOrderGoodModel) {
        [self arrangeDatabase];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    if (!_cannotChange) {
        [self setBottomButton];
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardDidShow{
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH-64-50-216);
}
- (void)keyboardDidHide
{
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH-64-50);
}


-(void)seachPriceDatabase{
    Sigleton *sigleton = [Sigleton standard];
    CustomerModel *customerModel = sigleton.customerModel;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MaterialPriceModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"(materialcode=%@ AND customercode=%@)",_goodModel.code,customerModel.code];
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
    MaterialPriceModel *model = [arr firstObject];
    _price =model.price;
}

-(void)seachStockDatabase{
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
    StockModel *model = [arr firstObject];
    _stock =model.normal;
}
-(void)setBottomButton{
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGTH-64-50, SCREEN_WIDTH, 50)];
    [saveButton setBackgroundColor:APPMAINCOLOR];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
}
-(void)saveAction{
    [self.view endEditing:true];
    if (!_goodModel) {
        [SVProgressHUD showImage:nil status:@"请选择商品"];
        return;
    }
    if (_stock.integerValue == 0) {
        [SVProgressHUD showImage:nil status:@"此商品没有库存，不能添加"];
        return;
    }
    if (_price.integerValue == 0) {
        [SVProgressHUD showImage:nil status:@"查不到此商品的价格，不能添加"];
        return;
    }
    if (_number.integerValue==0) {
        [SVProgressHUD showImage:nil status:@"请填写商品数量"];
        return;
    }
    PlaceOrderGoodModel *model;
    if (_placeOrderGoodModel) {
        //先查出数据, 然后再更新
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
        //添加查询条件
        request.predicate=[NSPredicate predicateWithFormat:@"(materialCode=%@ AND orderId=%@)",_placeOrderGoodModel.materialCode,_isLook?@"1":@"0"];
        //执行查询
        NSArray *arr = [kCoreDataContext executeFetchRequest:request error:nil];
        NSLog(@"%ld",arr.count);
        model = [arr firstObject];
    }else{
         model= [NSEntityDescription insertNewObjectForEntityForName:@"PlaceOrderGoodModel" inManagedObjectContext:kCoreDataContext];
    }
    model.type = nil;
    model.stockQuantity = _stock;
    model.spec = _goodModel.spec;
    model.smallunit = _smallNum;
    model.salesType = nil;
    model.salesRule = nil;
    model.salesID = nil;
    model.quantity = _number;
    model.price = _price;
    model.note = _note;
    model.materialCode = _goodModel.code;
    model.materialName = _goodModel.name;
    model.midunit = _mediumNum;
    model.bigunit = _bigNum;
    model.amount = _totlePrice;
    model.orderId =_isLook?@"1":@"0";
    NSError *error =nil;
    if (![kCoreDataContext save:&error]) {
        NSLog(@"插入数据错误:%@", error.userInfo);
    }
    if (_successBlock) {
        _successBlock();
    }
    [self.navigationController popViewControllerAnimated:true];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6&&[_goodModel.midscale isEqualToString:@"0"]) {
        return 0;
    }
    return 44;
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
    cell.textLabel.textColor = [UIColor hexValue:0x333333];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [_titles objectAtIndex:indexPath.row];
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(110, 0, SCREEN_WIDTH-130, 44)];
    textField.textColor = [UIColor hexValue:0x666666];
    textField.font = [UIFont systemFontOfSize:14];
    [cell addSubview:textField];
    textField.delegate = self;
    textField.userInteractionEnabled = NO;
    switch (indexPath.row) {
        case 0:{
            textField.placeholder = @"请扫条形码";
            if (!_placeOrderGoodModel) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            textField.text = _goodModel.barcode;
        }
            break;
        case 1:{
            textField.placeholder = @"请输入激光码";
            textField.tag = 6;
            if (!_placeOrderGoodModel) {
                textField.userInteractionEnabled = YES;
            }
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = _goodModel.barcode;
        }
            break;
        case 2:{
            textField.placeholder = @"请选择商品";
            if (!_placeOrderGoodModel) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            textField.text = _goodModel.name;
        }
            break;
        case 3:{
            textField.placeholder = @"";
            textField.text = _goodModel.spec;
        }
            break;
        case 4:{
            textField.placeholder = @"";
            textField.text = _stock;
        }
            break;
        case 5:{
            textField.placeholder = @"请填写大单位数量";
            textField.userInteractionEnabled = _goodModel;
            textField.tag = 1;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = _bigNum;
        }
            break;
        case 6:{
            textField.placeholder = @"请填写中单位数量";
            textField.userInteractionEnabled = _goodModel;
            textField.tag =2;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = _mediumNum;
        }
            break;
        case 7:{
            textField.placeholder = @"请填写小单位数量";
            textField.userInteractionEnabled = _goodModel;
            textField.tag = 3;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = _smallNum;
        }
            break;
        case 8:{
            textField.placeholder = @"请填写数量";
            textField.userInteractionEnabled = _goodModel;
            textField.tag =4;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = _number;
        }
            break;
        case 9:{
            textField.placeholder = @"";
            textField.text = _price;
        }
            break;
        case 10:{
            textField.placeholder = @"";
            textField.text = _totlePrice;
        }
            break;
        case 11:{
            textField.placeholder = @"请填写备注";
            textField.userInteractionEnabled = _goodModel;
            textField.tag = 5;
            textField.text = _note;
        }
            break;
            
        default:
            break;
    }
    if (_cannotChange) {
        textField.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH-15, 1)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:view];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_cannotChange) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    [self.view endEditing:true];
    DefineWeakSelf;
    if (!_placeOrderGoodModel) {
        if (indexPath.row == 0) {
            HCScanQRViewController *controller = [[HCScanQRViewController alloc]init];
            [self.navigationController pushViewController:controller animated:true];
                    [controller successfulGetQRCodeInfo:^(NSString *QRCodeInfo) {
                        [weakSelf searchGoodWithBarCode:QRCodeInfo];
                    }];
        }else if (indexPath.row == 2){
            SearchMaterialController *controller = [[SearchMaterialController alloc]init];
            controller.isLook = YES;
            [self.navigationController pushViewController:controller animated:true];
            [controller setSuccessSeachGood:^(MaterialModel *model) {
                weakSelf.goodModel = model;
                [weakSelf seachPriceDatabase];
                [weakSelf seachStockDatabase];
                weakSelf.bigNum = nil;
                weakSelf.mediumNum = nil;
                weakSelf.smallNum =nil;
                weakSelf.number =nil;
                weakSelf.note = nil;
                weakSelf.totlePrice =nil;
                [weakSelf.tableView reloadData];
            }];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 1) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 4) {
            return NO;
        }
    }else if (textField.tag == 2){
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 5) {
            return NO;
        }
    }else if (textField.tag == 3){
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }else if (textField.tag == 4){
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }else if (textField.tag == 5){
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }else if (textField.tag == 6){
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag ==1) {
        if (textField.text.length == 0) {
            _bigNum = nil;
        }else{
            _bigNum = textField.text;
        }
    }else if (textField.tag ==2){
        if (textField.text.length == 0) {
            _mediumNum = nil;
        }else{
            _mediumNum = textField.text;
        }
    }else if (textField.tag ==3){
        if (textField.text.length == 0) {
            _smallNum = nil;
        }else{
            _smallNum = textField.text;
        }
    }else if (textField.tag == 4){
        if (textField.text.length == 0) {
            _number = nil;
        }else{
            _number = textField.text;
        }
    }else if (textField.tag == 5){
        if (textField.text.length == 0) {
            _note = nil;
        }else{
            _note = textField.text;
        }
    }else if (textField.tag == 6){
        if (textField.text.length>0) {
            [self searchGoodWithBarCode:textField.text];
        }
        
    }
    if (textField.tag<4) {
        [self calculationNumber];
    }else if (textField.tag == 4){
        [self calculationVariousNumber];
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
        return;
    }
    self.goodModel = [arr firstObject];
    if ([self cheakUpdlicteWithBarcode:self.goodModel.code]) {
        [SVProgressHUD showImage:nil status:@"此商品已存在，不能重复添加"];
        return;
    }
    [self seachPriceDatabase];
    [self seachStockDatabase];
    self.bigNum = nil;
    self.mediumNum = nil;
    self.smallNum =nil;
    self.number =nil;
    self.note = nil;
    self.totlePrice =nil;
    [self.tableView reloadData];
    
}
-(BOOL)cheakUpdlicteWithBarcode:(NSString *)barcode{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"(materialCode=%@ AND orderId=%@)",barcode,_isLook?@"1":@"0"];
    
    NSSortDescriptor *sort= [NSSortDescriptor sortDescriptorWithKey:@"materialCode" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    if (arr.count>0) {
        return YES;
    }
    return NO;
}
-(void)calculationNumber{
    _number = [NSString stringWithFormat:@"%ld",_bigNum.integerValue * _goodModel.bigscale.integerValue + _mediumNum.integerValue *_goodModel.midscale.integerValue + _smallNum.integerValue];
    [self calculationPrice];
    [_tableView reloadData];
}
-(void)calculationVariousNumber{
    _bigNum = [NSString stringWithFormat:@"%ld",_number.integerValue/_goodModel.bigscale.integerValue];
    if ([_goodModel.midscale isEqualToString:@"0"]) {
        _smallNum = [NSString stringWithFormat:@"%ld",_number.integerValue%_goodModel.bigscale.integerValue];
    }else{
        _mediumNum = [NSString stringWithFormat:@"%ld",_number.integerValue%_goodModel.bigscale.integerValue/_goodModel.midscale.integerValue];
        _smallNum = [NSString stringWithFormat:@"%ld",_number.integerValue%_goodModel.bigscale.integerValue%_goodModel.midscale.integerValue];
    }
    [self calculationPrice];
    [_tableView reloadData];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:true];
}
-(void)calculationPrice{
    _totlePrice = [NSString stringWithFormat:@"%.2f",_number.integerValue*_price.doubleValue];
}

#pragma mark - 把上页的数据进行整理
-(void)arrangeDatabase{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MaterialModel"];
    //添加查询条件
    request.predicate=[NSPredicate predicateWithFormat:@"code=%@",_placeOrderGoodModel.materialCode];
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    NSArray *sortDescriptors=[NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    _goodModel = [arr firstObject];
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    _stock = _placeOrderGoodModel.stockQuantity;
    _bigNum = _placeOrderGoodModel.bigunit;
    _mediumNum = _placeOrderGoodModel.midunit;
    _smallNum = _placeOrderGoodModel.smallunit;
    _number = _placeOrderGoodModel.quantity;
    _price = _placeOrderGoodModel.price;
    _totlePrice = _placeOrderGoodModel.amount;
    _note = _placeOrderGoodModel.note;
    if (_stock.length==0) {
        [self seachStockDatabase];
    }
}
@end
