//
//  PromotionSendController.m
//  离线app
//
//  Created by 王吉源 on 16/10/18.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "PromotionSendController.h"
#import "PromotionJsonModel.h"
#import <CoreData/CoreData.h>
#import "PromotionModel.h"
#import "PromotionGoodCell.h"
#import "CustomerModel.h"
#import "PlaceOrderGoodModel.h"
@interface PromotionSendController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)RootTableView *tableView;
@property (nonatomic, strong) NSFileManager *fileMgr;
@property (nonatomic, strong) NSString *documentsPath;
@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,assign)NSInteger selectCell;
@end

@implementation PromotionSendController
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
    self.title = @"特价转让明细";
    _selectCell =-1;
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
    [self setBottomButton];
    [self searchDatabase];
}
-(void)searchDatabase{
    Sigleton *sigleton = [Sigleton standard];
    CustomerModel *customerModel = sigleton.customerModel;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PromotionModel"];
    //添加查询条件
    request.predicate=[NSPredicate predicateWithFormat:@"(salescode=%@ AND type=%@ AND customercode=%@)",_goodModel.ruleCode,_goodModel.typeName,customerModel.code];
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
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGTH-64-50, SCREEN_WIDTH, 50)];
    [saveButton setBackgroundColor:APPMAINCOLOR];
    [saveButton setTitle:@"分配" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];

}
-(void)saveAction{
//    if (_placeOrderGoodModel) {
//        //先查出数据, 然后再更新
//        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
//        //添加查询条件
//        request.predicate=[NSPredicate predicateWithFormat:@"materialCode=%@",_placeOrderGoodModel.materialCode];
//        //执行查询
//        NSArray *arr = [kCoreDataContext executeFetchRequest:request error:nil];
//        model = [arr firstObject];
//    }else{
//        
//    }
    if (_selectCell<0) {
        [SVProgressHUD showImage:nil status:@"请选择一件商品进行分配"];
        return;
    }
    PromotionModel *model1 = [_dataSource objectAtIndex:_selectCell];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"(materialCode=%@ AND orderId=%@)",model1.materialcode,_isLook?@"1":@"0"];
    NSSortDescriptor *sort= [NSSortDescriptor sortDescriptorWithKey:@"materialCode" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    if (arr.count>0) {
        [SVProgressHUD showImage:nil status:@"此商品已存在，不能重复添加"];
        return;
    }
    PlaceOrderGoodModel *model= [NSEntityDescription insertNewObjectForEntityForName:@"PlaceOrderGoodModel" inManagedObjectContext:kCoreDataContext];
    model.type = _goodModel.typeName;
    model.stockQuantity = nil;
    model.spec = nil;
    model.smallunit = nil;
    model.salesType = _goodModel.typeName;
    model.salesRule = _goodModel.ruleCode;
    model.salesID = model1.code;
    model.quantity = @"0";
    model.price = model1.price;
    model.note = nil;
    model.materialCode = model1.materialcode;
    model.materialName = model1.materialname;
    model.midunit = nil;
    model.bigunit = nil;
    model.amount = nil;
    model.orderId = _isLook?@"1":@"0";
    if (![kCoreDataContext save:&error]) {
        NSLog(@"插入数据错误:%@", error.userInfo);
    }
    if (_successBlock) {
        _successBlock();
    }
    [self.navigationController popViewControllerAnimated:true];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PromotionModel *model = [_dataSource objectAtIndex:indexPath.row];
    PromotionGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionGoodCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PromotionGoodCell" owner:nil options:nil]firstObject];
    }
    cell.nameLabel.text = model.materialname;
    cell.countLabel.text = @"数量：0";
    cell.selectImage.image = [UIImage imageNamed:indexPath.row == _selectCell?@"icon_select_circle":@"icon_unselect_circle"];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 79, SCREEN_WIDTH-15, 1)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:view];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectCell = indexPath.row;
    [_tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
