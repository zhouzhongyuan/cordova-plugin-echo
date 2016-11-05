//
//  PlaceOrderController.m
//  离线app
//
//  Created by 王吉源 on 16/10/14.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "PlaceOrderController.h"
#import "PlaceOrderBasicController.h"
#import "PlaceOrderPromotionController.h"
#import "PlaceOrderGoodController.h"
#import "JudgeCustomerOptional.h"
#import "CustomerModel.h"
#import "PlaceOrderModel.h"
#import "JudgeCustomerOptional.h"
#import "UserModel.h"
#import "NSDate+Utils.h"
#import "PlaceOrderGoodModel.h"
#import "PromotionGoodModel.h"
@interface PlaceOrderController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIView *greenView1;
@property(nonatomic,strong)UIView *greenView2;
@property(nonatomic,strong)UIView *greenView3;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)PlaceOrderBasicController *mallVc;
@property(nonatomic,strong)PlaceOrderPromotionController *jiudian;
@property(nonatomic,strong)PlaceOrderGoodController *mallVc1;
@property(nonatomic,strong)NSString *currentTime;
@end

@implementation PlaceOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"门店抄单";
    [self setBottomButtons];
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
    NSFetchRequest *request0 = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
    //添加查询条件
    request0.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"0"];
    //执行查询
    NSArray *arr0 = [kCoreDataContext executeFetchRequest:request0 error:nil];
    if (arr0.count == 0) {
        [SVProgressHUD showImage:nil status:@"尚未添加商品"];
        return;
    }else{
        for (PlaceOrderGoodModel *model in arr0) {
            if (model.amount.integerValue == 0) {
                [SVProgressHUD showImage:nil status:@"有商品数量为0，不能生成订单"];
                return ; 
            }
        }
    }
    _currentTime =[NSDate currentFullTimeString];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserModel"];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    NSArray *sortDescriptors=[NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    UserModel *userModel = [arr lastObject];

    PlaceOrderModel *model=[NSEntityDescription insertNewObjectForEntityForName:@"PlaceOrderModel" inManagedObjectContext:kCoreDataContext];
    model.total=[JudgeCustomerOptional calculationTotlePriceWithOrderId:_orderId];
    model.staff=userModel.code;
    model.id= _currentTime;
    model.date=[NSDate currentTimeString];
    model.company=userModel.companycode;
    model.customer=SIGLETON.customerModel.code;
    model.staffName = userModel.name;
    model.customerName = SIGLETON.customerModel.name;
    model.isUp = @"0";
        //保存, 将插入操作更新到数据库
    [kCoreDataContext save:&error];
    
    if (error ) {
        NSLog(@"%@",error.userInfo);
    }
    //更新商品俩表中的商品
    NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
    request1.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"0"];
    NSSortDescriptor *sort1= [NSSortDescriptor sortDescriptorWithKey:@"materialCode" ascending:YES];
    NSArray *sortDescriptors1 = [NSArray arrayWithObject:sort1];
    [request1 setSortDescriptors:sortDescriptors1];
    NSArray *goods = [kCoreDataContext executeFetchRequest:request1 error:&error];
    for (PlaceOrderGoodModel *modelGood in goods) {
        modelGood.orderId = _currentTime;
    }
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    NSFetchRequest *request2 = [NSFetchRequest fetchRequestWithEntityName:@"PromotionGoodModel"];
    request2.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"0"];
    NSSortDescriptor *sort2= [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    NSArray *sortDescriptors2 = [NSArray arrayWithObject:sort2];
    [request2 setSortDescriptors:sortDescriptors2];
    NSArray *goods1 = [kCoreDataContext executeFetchRequest:request2 error:&error];
    for (PromotionGoodModel *modelGood in goods1) {
        modelGood.orderId = _currentTime;
    }
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"customer"];
    [JudgeCustomerOptional delGoodAndPromotionWithOrderId:_orderId];
    [self.navigationController popViewControllerAnimated:true];
}
-(void)cancelAction{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"customer"];
    [JudgeCustomerOptional delGoodAndPromotionWithOrderId:_orderId];
    [self.navigationController popViewControllerAnimated:true];
}
- (void)addController
{

    _mallVc = [[PlaceOrderBasicController alloc]init];
    _mallVc.orderId = _orderId;
    _jiudian = [[PlaceOrderPromotionController alloc]init];
    _jiudian.orderId = _orderId;
    _mallVc1 = [[PlaceOrderGoodController alloc]init];
    _mallVc1.orderId = _orderId;
    
    [self addChildViewController:_mallVc];
    [self addChildViewController:_jiudian];
    [self addChildViewController:_mallVc1];
    DefineWeakSelf;
    [_jiudian setChangeBlock:^{
        [weakSelf.mallVc1 dataDidChange];
    }];
    _mallVc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH -64-50-50);
    _jiudian.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGTH - 64-50-50);
    _mallVc1.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGTH -64-50-50);
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGTH -64-50-50)];
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


@end
