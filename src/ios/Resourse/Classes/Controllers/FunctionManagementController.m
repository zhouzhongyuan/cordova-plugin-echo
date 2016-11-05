//
//  FunctionManagementController.m
//  离线app
//
//  Created by 王吉源 on 16/10/14.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "FunctionManagementController.h"
#import "ManagementCollectionCell.h"
#import "PlaceOrderController.h"
#import "PlaceOrderListController.h"
#import "PlaceOrderListController.h"
#import "RetreatOrderController.h"
#import "RetreatOrderListController.h"
#import "SearchStockController.h"
#import "SearchPriceController.h"
#import "SearchActivityController.h"
@interface FunctionManagementController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)NSArray *images;
@end

@implementation FunctionManagementController
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH-64) collectionViewLayout:layout];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        UINib *cellNib=[UINib nibWithNibName:@"ManagementCollectionCell" bundle:nil];
        [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"collectionCell"];
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator=NO;
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能管理";
    _images = @[@"icon_placeOrder",@"icon_backOrder",@"icon_queryStock",@"icon_queryPrice",@"icon_queryActivity",@"icon_orderList",@"icon_backOrderList"];
    _titles = @[@"抄单",@"退单",@"商品库存查询",@"价格查询",@"促销活动查询",@"抄单列表",@"退单列表"];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    if (_isGo) {
        PlaceOrderController *controller = [[PlaceOrderController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _titles.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ManagementCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.label.text = [_titles objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[_images objectAtIndex:indexPath.row]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-40)/3, 100);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PlaceOrderController *controller = [[PlaceOrderController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
    }else if (indexPath.row == 5){
        PlaceOrderListController *controller = [[PlaceOrderListController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
    }else if (indexPath.row == 1){
        RetreatOrderController *controller = [[RetreatOrderController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
    }else if (indexPath.row == 6){
        RetreatOrderListController *controller = [[RetreatOrderListController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
    }else if (indexPath.row == 2){
        SearchStockController *controller = [[SearchStockController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
    }else if (indexPath.row == 3){
        SearchPriceController *controller = [[SearchPriceController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
    }else if (indexPath.row == 4){
        SearchActivityController *controller = [[SearchActivityController alloc]init];
        [self.navigationController pushViewController:controller animated:true];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
}
@end
