//
//  RetreatOrderController.m
//  离线app
//
//  Created by 王吉源 on 16/10/21.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "RetreatOrderController.h"
#import "PhotographCell.h"
#import "NSDate+Utils.h"
#import "LCActionSheet.h"
#import "IOSAuthorized.h"
#import "SelectRetreatReasonController.h"
#import "RetreatReasonModel.h"
#import "RetreatGoodInfoController.h"
#import "RetreatOrderGoodModel.h"
#import "RetreatGoodCell.h"
#import "RetreatOrderModel.h"
#import "UserModel.h"
@interface RetreatOrderController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LCActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,assign)NSInteger selectImage;
@property(nonatomic,assign)BOOL userCarema;
@property(nonatomic,strong)UIImage *headerImage1;
@property(nonatomic,strong)UIImage *headerImage2;
@property(nonatomic,strong)UIImage *headerImage3;
@property(nonatomic,strong)UIImage *headerImage4;
@property(nonatomic,strong)RetreatReasonModel *retreatReasonModel;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)NSString *totlePrice;
@property(nonatomic,strong)NSString *number;
@end

@implementation RetreatOrderController
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
    _titles = @[@"单据日期：",@"退货原因：",@"净价值：",@"商品总数：",@"实退总数：",@"拍照："];
    self.title = @"销售退货通知";
    NSUserDefaults *defatults = [NSUserDefaults standardUserDefaults];
    _headerImage1 = [UIImage imageWithData:[defatults valueForKey:@"image1"]];
    _headerImage2 = [UIImage imageWithData:[defatults valueForKey:@"image2"]];
    _headerImage3 = [UIImage imageWithData:[defatults valueForKey:@"image3"]];
    _headerImage4 = [UIImage imageWithData:[defatults valueForKey:@"image4"]];
    _retreatReasonModel = [self searchReason];
    [self searchDatabase];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setBottomButtons];
}
-(RetreatReasonModel *)searchReason{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ReturnReasonModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"code=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"reasonCode"]];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    
    NSArray *sortDescriptors=[NSArray arrayWithObject:sort];
    
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    RetreatReasonModel *model = [arr firstObject];
    return model;
}
-(void)setBottomButtons{
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGTH-64-50, SCREEN_WIDTH/2, 50)];
    [saveButton setBackgroundColor:APPMAINCOLOR];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGTH-50-64, SCREEN_WIDTH/2, 50)];
    [cancelButton setBackgroundColor:APPMAINCOLOR];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}
-(void)saveAction{
    if (_dataSource.count == 0) {
        [SVProgressHUD showImage:nil status:@"您尚未添加商品"];
        return;
    }
    if (!_retreatReasonModel) {
        [SVProgressHUD showImage:nil status:@"请选择退货原因"];
        return;
    }
    NSString *currentTime = [NSDate currentFullTimeString];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserModel"];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    NSArray *sortDescriptors=[NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    UserModel *userModel = [arr lastObject];
    RetreatOrderModel *model=[NSEntityDescription insertNewObjectForEntityForName:@"RetreatOrderModel" inManagedObjectContext:kCoreDataContext];
    model.totalquantity = _number;
    model.total = _totlePrice;
    model.staff = userModel.code;
    model.returnReason = _retreatReasonModel.code;
    model.returnReasonName = _retreatReasonModel.name;
    model.image1 = UIImageJPEGRepresentation(_headerImage1, 0.3);
    model.image2 = UIImageJPEGRepresentation(_headerImage2, 0.3);
    model.image3 = UIImageJPEGRepresentation(_headerImage3, 0.3);
    model.image4 = UIImageJPEGRepresentation(_headerImage4, 0.3);
    model.imageUrl1 = nil;
    model.imageUrl2 = nil;
    model.imageUrl3 = nil;
    model.imageUrl4 = nil;
    model.id = currentTime;
    model.date = [NSDate currentTimeString];
    model.customer=SIGLETON.customerModel.code;
    model.customerName = SIGLETON.customerModel.name;
    model.staffName = userModel.name;
    model.company=userModel.companycode;
    model.isUp = @"0";
    [kCoreDataContext save:&error];
    
    if (error ) {
        NSLog(@"%@",error.userInfo);
    }
    //更新商品俩表中的商品
    NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"RetreatOrderGoodModel"];
    request1.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"0"];
    NSSortDescriptor *sort1= [NSSortDescriptor sortDescriptorWithKey:@"material" ascending:YES];
    NSArray *sortDescriptors1 = [NSArray arrayWithObject:sort1];
    [request1 setSortDescriptors:sortDescriptors1];
    NSArray *goods = [kCoreDataContext executeFetchRequest:request1 error:&error];
    for (RetreatOrderGoodModel *modelGood in goods) {
        modelGood.orderId = currentTime;
    }
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"image1"];
    [defaults removeObjectForKey:@"image2"];
    [defaults removeObjectForKey:@"image3"];
    [defaults removeObjectForKey:@"image4"];
    [defaults removeObjectForKey:@"reasonCode"];
    [self.navigationController popViewControllerAnimated:true];
}
-(void)cancelAction{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"image1"];
    [defaults removeObjectForKey:@"image2"];
    [defaults removeObjectForKey:@"image3"];
    [defaults removeObjectForKey:@"image4"];
    [defaults removeObjectForKey:@"reasonCode"];
    for (RetreatOrderGoodModel *model in _dataSource) {
        [kCoreDataContext deleteObject:model];
    }
    [self.navigationController popViewControllerAnimated:true];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }
    return _dataSource.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == _dataSource.count) {
            return 60;
        }
        return 100;
    }
    if (indexPath.row == 5) {
        return 80;
    }
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 30)];
        label.text = @"    销售退货明细";
        label.textColor = [UIColor hexValue:0x333333];
        label.font = [UIFont systemFontOfSize:14];
        return label;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == _dataSource.count) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            }
            cell.imageView.image = [UIImage imageNamed:@"icon_add"];
            return cell;

        }
        RetreatOrderGoodModel *model = [_dataSource objectAtIndex:indexPath.row];
        RetreatGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RetreatGoodCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"RetreatGoodCell" owner:nil options:nil]firstObject];
        }
        cell.nameLabel.text = [NSString stringWithFormat:@"物料：%@",model.materialName];
        cell.numLabel.text = [NSString stringWithFormat:@"订单数量：%ld",model.quantity.integerValue];
        cell.actualLabel.text = [NSString stringWithFormat:@"实退数量：%ld",model.quantity.integerValue];
        cell.unitLabel.text = [NSString stringWithFormat:@"单位：%@",model.basicunit];
        cell.priceLabel.text = [NSString stringWithFormat:@"单价%.2f",model.price.doubleValue];
        cell.totlePrice.text = [NSString stringWithFormat:@"批次：%@",model.batchnumber];
        [cell.delButton addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 99, SCREEN_WIDTH-15, 1)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell addSubview:view];
        return cell;
    }
    if (indexPath.row == 5) {
        PhotographCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotographCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PhotographCell" owner:nil options:nil]firstObject];
        }
        [cell.botton1 addTarget:self action:@selector(upDatePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button2 addTarget:self action:@selector(upDatePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button3 addTarget:self action:@selector(upDatePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button4 addTarget:self action:@selector(upDatePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        if (_headerImage4) {
            [cell.botton1 setImage:_headerImage1 forState:UIControlStateNormal];
            [cell.button2 setImage:_headerImage2 forState:UIControlStateNormal];
            [cell.button3 setImage:_headerImage3 forState:UIControlStateNormal];
            [cell.button4 setImage:_headerImage4 forState:UIControlStateNormal];
        }else if (_headerImage3){
            [cell.botton1 setImage:_headerImage1 forState:UIControlStateNormal];
            [cell.button2 setImage:_headerImage2 forState:UIControlStateNormal];
            [cell.button3 setImage:_headerImage3 forState:UIControlStateNormal];
            [cell.button4 setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        }else if(_headerImage2){
            [cell.botton1 setImage:_headerImage1 forState:UIControlStateNormal];
            [cell.button2 setImage:_headerImage2 forState:UIControlStateNormal];
            [cell.button3 setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
            [cell.button4 setHidden:YES];
        }else if (_headerImage1){
            [cell.botton1 setImage:_headerImage1 forState:UIControlStateNormal];
            [cell.button2 setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
            [cell.button3 setHidden:YES];
            [cell.button4 setHidden:YES];
        }else{
            [cell.botton1 setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
            [cell.button2 setHidden:YES];
            [cell.button3 setHidden:YES];
            [cell.button4 setHidden:YES];
        }
        
        return cell;
    }
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
    textField.delegate = self;
    textField.userInteractionEnabled = NO;
    switch (indexPath.row) {
        case 0:{
            textField.text = [NSDate currentTimeString];
        }
            break;
        case 1:{
            textField.placeholder = @"请选择退货原因";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            textField.text = _retreatReasonModel.name;
        }
            break;
        case 2:{
            textField.text = _totlePrice;
        }
            break;
        case 3:{
            textField.text = _number;
        }
            break;
        case 4:{
            textField.text = _number;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DefineWeakSelf;
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            SelectRetreatReasonController *controller= [[SelectRetreatReasonController alloc]init];
            [self.navigationController pushViewController:controller animated:true];
            __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [controller setSuccessBlock:^(RetreatReasonModel *model) {
                weakSelf.retreatReasonModel = model;
                [defaults setValue:model.code forKey:@"reasonCode"];
                [weakSelf.tableView reloadData];
            }];
        }
    }else{
        if (indexPath.row ==_dataSource.count) {
            RetreatGoodInfoController *controller = [[RetreatGoodInfoController alloc]init];
            [self.navigationController pushViewController:controller animated:true];
            [controller setSuccessBlock:^{
                [weakSelf searchDatabase];
                [weakSelf.tableView reloadData];
            }];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(void)delAction:(UIButton *)sender{
    UIView *obj = (UIView *)sender;
    while (![obj isKindOfClass:[UITableViewCell class]]) {
        obj = obj.superview;
    }
    RetreatGoodCell *cell = (RetreatGoodCell *)obj;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    RetreatOrderGoodModel *model = [_dataSource objectAtIndex:indexPath.row];
    [kCoreDataContext deleteObject:model];
    [kCoreDataContext save:nil];
    [self searchDatabase];
    [_tableView reloadData];
    
}
-(void)editAction:(UIButton *)sender{
    UIView *obj = (UIView *)sender;
    while (![obj isKindOfClass:[UITableViewCell class]]) {
        obj = obj.superview;
    }
    RetreatGoodCell *cell = (RetreatGoodCell *)obj;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    RetreatOrderGoodModel *model = [_dataSource objectAtIndex:indexPath.row];
    RetreatGoodInfoController *controller = [[RetreatGoodInfoController alloc]init];
    controller.model = model;
    DefineWeakSelf;
    [self.navigationController pushViewController:controller animated:true];
    [controller setSuccessBlock:^{
        [weakSelf searchDatabase];
        [weakSelf.tableView reloadData];
    }];
}
-(void)upDatePhotoAction:(UIButton *)sender{

    _selectImage = sender.tag;
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"拍照",@"从手机相册选择"] redButtonIndex:-1 delegate:self];
    [sheet show];
}
-(void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        _userCarema = YES;
    }else if(buttonIndex == 1){
        _userCarema = NO;
    }else{
        return;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    if (_userCarema) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([IOSAuthorized isCameraAuthorized]) {
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"该设备不支持相机功能!"];
        }
    }else{
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([IOSAuthorized isPhotosAuthorized]) {
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image= ![info objectForKey:UIImagePickerControllerEditedImage] ? [info objectForKey:UIImagePickerControllerOriginalImage] : [info objectForKey:UIImagePickerControllerEditedImage];
    DefineWeakSelf;
    __block NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    if (_selectImage==1) {
        weakSelf.headerImage1=image;
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        [defaults setValue:imageData forKey:@"image1"];
    }else if (_selectImage==2){
        weakSelf.headerImage2=image;
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        [defaults setValue:imageData forKey:@"image2"];
    }else if (_selectImage==3){
        weakSelf.headerImage3=image;
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        [defaults setValue:imageData forKey:@"image3"];
    }else{
        weakSelf.headerImage4= image;
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        [defaults setValue:imageData forKey:@"image4"];
    }
    [_tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row<_dataSource.count) {
        return YES;
    }
    return NO;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"复制";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    RetreatOrderGoodModel *model = [_dataSource objectAtIndex:indexPath.row];
    RetreatOrderGoodModel *model1 = [NSEntityDescription insertNewObjectForEntityForName:@"RetreatOrderGoodModel" inManagedObjectContext:kCoreDataContext];
    model1.smallunit = model.smallunit;
    model1.quantity = model.quantity;
    model1.price = model.price;
    model1.orderId = model.orderId;
    model1.note = model.note;
    model1.midunit = model.midunit;
    model1.materialName = model.materialName;
    model1.material = model.material;
    model1.bigunit = model.bigunit;
    model1.batchnumber = model.batchnumber;
    model1.amount = model.amount;
    model1.basicunit = model.basicunit;
    model1.dateofmanufacture = model.dateofmanufacture;
    NSError *error = nil;
    [kCoreDataContext save:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    [self searchDatabase];
    [tableView reloadData];
    
}
-(void)searchDatabase{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RetreatOrderGoodModel"];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"material" ascending:YES];
    
    NSArray *sortDescriptors=[NSArray arrayWithObject:sort];
    
    [request setSortDescriptors:sortDescriptors];
    request.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"0"];
    NSError *error;
    _dataSource = [kCoreDataContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    [self calculationNumberAndPrice];
}
-(void)calculationNumberAndPrice{
    double price = 0.0;
    NSInteger number = 0;
    for (RetreatOrderGoodModel *model in _dataSource) {
        price +=model.amount.doubleValue;
        number += model.quantity.integerValue;
    }
    _totlePrice = [NSString stringWithFormat:@"%.2f",price];
    _number = [NSString stringWithFormat:@"%ld",number];
}
@end
