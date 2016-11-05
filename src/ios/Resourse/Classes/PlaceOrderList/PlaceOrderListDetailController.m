//
//  PlaceOrderListDetailController.m
//  离线app
//
//  Created by 王吉源 on 16/10/26.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "PlaceOrderListDetailController.h"
#import "PlaceOrderListDetailBasicController.h"
#import "PlaceOrderListDetailPromotionController.h"
#import "PlaceOrderListDetailGoodController.h"
#import "PromotionGoodModel.h"
#import "PlaceOrderGoodModel.h"
#import "JudgeCustomerOptional.h"
@interface PlaceOrderListDetailController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIView *greenView1;
@property(nonatomic,strong)UIView *greenView2;
@property(nonatomic,strong)UIView *greenView3;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)PlaceOrderListDetailBasicController *mallVc;
@property(nonatomic,strong)PlaceOrderListDetailPromotionController *jiudian;
@property(nonatomic,strong)PlaceOrderListDetailGoodController *mallVc1;
@property(nonatomic,strong)NSString *currentTime;
@property(nonatomic,assign)BOOL canChange;
@end

@implementation PlaceOrderListDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"抄单信息";
    if (!_isUp) {
        [self setBottomButtons];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    //上面的view
    UIView *myview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self.view addSubview:myview];
    myview.backgroundColor=[UIColor whiteColor];
    
    for (int i=0; i<3; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 48)];
        [button setTitle:@"基本信息" forState:UIControlStateNormal];
        
        if (i==1) {
            [button setTitle:@"促销商品" forState:UIControlStateNormal];
        }else if (i==2){
            [button setTitle:@"商品信息" forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
        if (i==0) {
            [button setTitleColor:APPMAINBLUECOLOR forState:UIControlStateNormal];
        }
        button.tag=i+100;
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(selectCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        [myview addSubview:button];
        
    }
    _greenView1=[[UIView alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH/3, 2)];
    _greenView1.backgroundColor=APPMAINBLUECOLOR;
    [myview addSubview:_greenView1];
    _greenView2=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 48, SCREEN_WIDTH/3, 2)];
    _greenView2.backgroundColor=APPMAINBLUECOLOR;
    [myview addSubview:_greenView2];
    _greenView3=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, 48, SCREEN_WIDTH/3, 2)];
    _greenView3.backgroundColor=APPMAINBLUECOLOR;
    [myview addSubview:_greenView3];
    _greenView2.hidden=YES;
    _greenView3.hidden=YES;
    [self addController];
}
-(void)saveAction:(UIButton *)sender{
    if (!_canChange) {
        _canChange = !_canChange;
        [sender setTitle:_canChange?@"确定":@"修改" forState:UIControlStateNormal];
        [_jiudian changeStatusWithCanChange:_canChange];
        [_mallVc1 changeStatusWithCanChange:_canChange];
    }else{
        //先修改订单表
        _orderModel.total = [JudgeCustomerOptional calculationTotlePriceWithOrderId:_orderModel.id];
        [kCoreDataContext save:nil];
        //删除原来订单里的商品和促销
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PromotionGoodModel"];
        request.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",_orderModel.id];
        NSArray *arr = [kCoreDataContext executeFetchRequest:request error:nil];
        for (PromotionGoodModel *model in arr) {
            [kCoreDataContext deleteObject:model];
        }
        
        NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
        request1.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",_orderModel.id];
        NSArray *arr1 = [kCoreDataContext executeFetchRequest:request1 error:nil];
        for (PlaceOrderGoodModel *model in arr1) {
            [kCoreDataContext deleteObject:model];
        }
        //把orderId为1 的商品和促销换回来
        //先查出数据, 然后再更新
        NSFetchRequest *request2 = [NSFetchRequest fetchRequestWithEntityName:@"PromotionGoodModel"];
        
        //添加查询条件
        request2.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"1"];
        
        //执行查询
        NSArray *arr2 = [kCoreDataContext executeFetchRequest:request2 error:nil];
        for (PromotionGoodModel *model in arr2) {
            model.orderId =_orderModel.id;
        }
        
        //先查出数据, 然后再更新
        NSFetchRequest *request3 = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
        
        //添加查询条件
        request3.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"1"];
        
        //执行查询
        NSArray *arr3 = [kCoreDataContext executeFetchRequest:request3 error:nil];
        for (PlaceOrderGoodModel *model in arr3) {
            model.orderId =_orderModel.id;
        }
        if (_successBlock) {
            _successBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)setBottomButtons{
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGTH-64-50, SCREEN_WIDTH, 50)];
    [saveButton setBackgroundColor:APPMAINCOLOR];
    [saveButton setTitle:@"修改" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}
- (void)addController
{
    
    _mallVc = [[PlaceOrderListDetailBasicController alloc]init];
    _mallVc.orderModel = _orderModel;
    _jiudian = [[PlaceOrderListDetailPromotionController alloc]init];
    _mallVc.orderModel = _orderModel;
    _mallVc1 = [[PlaceOrderListDetailGoodController alloc]init];
    _mallVc.orderModel = _orderModel;
    
    [self addChildViewController:_mallVc];
    [self addChildViewController:_jiudian];
    [self addChildViewController:_mallVc1];
    DefineWeakSelf;
    [_jiudian setChangeBlock:^{
        [weakSelf.mallVc1 dataDidChange];
    }];

    if (_isUp) {
        _mallVc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH -64-50);
        _jiudian.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGTH - 64-50);
        _mallVc1.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGTH -64-50);
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGTH -64-50)];
    }else{
        _mallVc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH -64-50-50);
        _jiudian.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGTH - 64-50-50);
        _mallVc1.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGTH -64-50-50);
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGTH -64-50-50)];
    }
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate=self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView addSubview:_mallVc.view];
    [_scrollView addSubview:_jiudian.view];
    [_scrollView addSubview:_mallVc1.view];
    
    [self.view addSubview:_scrollView];
}
-(void)selectCodeAction:(UIButton *)sender{
    
    if (sender.tag==100) {
        _greenView1.hidden=NO;
        _greenView2.hidden=YES;
        _greenView3.hidden=YES;
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        [sender setTitleColor:APPMAINBLUECOLOR forState:UIControlStateNormal];
        UIButton *button1=(UIButton *)[self.view viewWithTag:101];
        [button1 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
        UIButton *button2=(UIButton *)[self.view viewWithTag:102];
        [button2 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
        [_mallVc calculationPrice];
    }else if (sender.tag==101){
        _greenView1.hidden=YES;
        _greenView2.hidden=NO;
        _greenView3.hidden=YES;
        [sender setTitleColor:APPMAINBLUECOLOR forState:UIControlStateNormal];
        UIButton *button1=(UIButton *)[self.view viewWithTag:100];
        [button1 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
        UIButton *button2=(UIButton *)[self.view viewWithTag:102];
        [button2 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }else if (sender.tag==102){
        _greenView1.hidden=YES;
        _greenView2.hidden=YES;
        _greenView3.hidden=NO;
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0)];
        [sender setTitleColor:APPMAINBLUECOLOR forState:UIControlStateNormal];
        UIButton *button1=(UIButton *)[self.view viewWithTag:100];
        [button1 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
        UIButton *button2=(UIButton *)[self.view viewWithTag:101];
        [button2 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x>SCREEN_WIDTH/2&&scrollView.contentOffset.x<SCREEN_WIDTH*3/2) {
        _greenView1.hidden=YES;
        _greenView2.hidden=NO;
        _greenView3.hidden=YES;
        UIButton *button=(UIButton *)[self.view viewWithTag:101];
        [button setTitleColor:APPMAINBLUECOLOR forState:UIControlStateNormal];
        UIButton *button1=(UIButton *)[self.view viewWithTag:100];
        [button1 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
        UIButton *button2=(UIButton *)[self.view viewWithTag:102];
        [button2 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
    }else if (scrollView.contentOffset.x>SCREEN_WIDTH*3/2&&scrollView.contentOffset.x<SCREEN_WIDTH*5/2){
        _greenView1.hidden=YES;
        _greenView2.hidden=YES;
        _greenView3.hidden=NO;
        UIButton *button=(UIButton *)[self.view viewWithTag:102];
        [button setTitleColor:APPMAINBLUECOLOR forState:UIControlStateNormal];
        UIButton *button1=(UIButton *)[self.view viewWithTag:101];
        [button1 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
        UIButton *button2=(UIButton *)[self.view viewWithTag:100];
        [button2 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
    }else{
        _greenView1.hidden=NO;
        _greenView2.hidden=YES;
        _greenView3.hidden=YES;
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        UIButton *button=(UIButton *)[self.view viewWithTag:100];
        [button setTitleColor:APPMAINBLUECOLOR forState:UIControlStateNormal];
        UIButton *button1=(UIButton *)[self.view viewWithTag:101];
        [button1 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
        UIButton *button2=(UIButton *)[self.view viewWithTag:102];
        [button2 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
        [_mallVc calculationPrice];
    }
}
-(void)back:(UIButton *)sender{
    if (_canChange) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否放弃修改" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self delDatabase];
        }];
        [controller addAction:cancelAction];
        [controller addAction:cancelAction1];
        [APPDELEGATE.window.rootViewController presentViewController:controller animated:true completion:nil];
    }else{
        [self delDatabase];
    }
}
-(void)delDatabase{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PromotionGoodModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"1"];
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:nil];
    
    for (PromotionGoodModel *p in arr) {
        
        //删除数据
        [kCoreDataContext deleteObject:p];
        
    }
    
    //保存, 将删除操作更新到数据库中
    [kCoreDataContext save:nil];
    
    NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
    request1.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"1"];
    NSArray *arr1 = [kCoreDataContext executeFetchRequest:request1 error:nil];
    
    for (PlaceOrderGoodModel *p in arr1) {
        
        //删除数据
        [kCoreDataContext deleteObject:p];
        
    }
    
    //保存, 将删除操作更新到数据库中
    [kCoreDataContext save:nil];
    [self.navigationController popViewControllerAnimated:true];
}
@end
