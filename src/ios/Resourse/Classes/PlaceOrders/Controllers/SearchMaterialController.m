//
//  SearchMaterialController.m
//  离线app
//
//  Created by 王吉源 on 16/10/18.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "SearchMaterialController.h"
#import "MaterialJsonModel.h"

#import <CoreData/CoreData.h>
@interface SearchMaterialController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)NSString *keyWord;
@property(nonatomic,strong)NSMutableArray *dataJsonSource;
@property (nonatomic, strong) NSFileManager *fileMgr;
@property (nonatomic, strong) NSString *documentsPath;
@property (nonatomic,strong)NSArray *dataSource;
@property(nonatomic,assign)NSInteger selectCell;

@end

@implementation SearchMaterialController
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
    self.title = @"物料查找";
    _selectCell = -1;
    [self searchDatabase];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setBottomButton];
}
-(void)searchDatabase{
    _selectCell = -1;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MaterialModel"];
    //添加查询条件
    if (_keyWord) {
        request.predicate=[NSPredicate predicateWithFormat:@"name CONTAINS %@",_keyWord];
    }
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    NSArray *sortDescriptors=[NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error;
    _dataSource = [kCoreDataContext executeFetchRequest:request error:&error];
    if (_dataSource.count == 0) {
        [SVProgressHUD showImage:nil status:@"尚未查询到符合条件的商品"];
    }
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
}

-(void)setBottomButton{
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGTH-64-50, SCREEN_WIDTH/3, 50)];
    [saveButton setBackgroundColor:APPMAINCOLOR];
    [saveButton setTitle:@"确定" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGTH-64-50, SCREEN_WIDTH/3, 50)];
    [cancelButton setBackgroundColor:APPMAINCOLOR];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, SCREEN_HEIGTH-64-50, SCREEN_WIDTH/3, 50)];
    [searchButton setBackgroundColor:APPMAINCOLOR];
    [searchButton setTitle:@"查询" forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
}
-(void)saveAction{
    if (_selectCell <0) {
        [SVProgressHUD showImage:nil status:@"请选择一件商品"];
        return;
    }
    MaterialModel *model = [_dataSource objectAtIndex:_selectCell];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"(materialCode=%@ AND orderId=%@)",model.code,_isLook?@"1":@"0"];
    
    NSSortDescriptor *sort= [NSSortDescriptor sortDescriptorWithKey:@"materialCode" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    if (arr.count>0) {
        [SVProgressHUD showImage:nil status:@"此商品已存在，不能重复添加"];
        return;
    }
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    
    if (_successSeachGood) {
        _successSeachGood(model);
    }
    [self.navigationController popViewControllerAnimated:true];
}
-(void)cancelAction{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)searchAction{
    [self searchDatabase];
    [_tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
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
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"查找内容：";
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-110, 44)];
        textField.textColor = [UIColor hexValue:0x666666];
        textField.font = [UIFont systemFontOfSize:14];
        [cell addSubview:textField];
        textField.delegate = self;
        textField.text = _keyWord;
        textField.returnKeyType = UIReturnKeySearch;
        textField.placeholder = @"请输入关键字";
    }else{
        if (indexPath.row == _selectCell) {
            cell.imageView.image = [UIImage imageNamed:@"icon_nike"];
        }else{
            cell.imageView.image = nil;
        }
        MaterialModel *model = [_dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH-15, 1)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:view];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:true];
    if (indexPath.section == 1) {
        _selectCell = indexPath.row;
        [tableView reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        _keyWord = nil;
    }else{
        _keyWord = textField.text;
    }
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length == 0) return YES;
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 10) {
        return NO;
    }
    return YES;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:true];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:true];
    [self searchDatabase];
    [_tableView reloadData];
    return YES;
}
@end
