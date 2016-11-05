//
//  PlaceOrderListController.m
//  离线app
//
//  Created by 王吉源 on 16/10/21.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "PlaceOrderListController.h"
#import "PlaceOrderListUnupController.h"
#import "PlaceOrderListUpController.h"
@interface PlaceOrderListController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIView *greenView1;
@property(nonatomic,strong)UIView *greenView2;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)PlaceOrderListUnupController *mallVc;
@property(nonatomic,strong)PlaceOrderListUpController *jiudian;

@end

@implementation PlaceOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"抄单列表";
    //上面的view
    UIView *myview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self.view addSubview:myview];
    myview.backgroundColor=[UIColor whiteColor];
    for (int i=0; i<2; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 48)];
        [button setTitle:@"未上传抄单" forState:UIControlStateNormal];
        
        if (i==1) {
            [button setTitle:@"已上传抄单" forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
        if (i==0) {
            [button setTitleColor:APPMAINBLUECOLOR forState:UIControlStateNormal];
        }
        button.tag=i+100;
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(selectFootprintAction:) forControlEvents:UIControlEventTouchUpInside];
        [myview addSubview:button];
    }
    _greenView1=[[UIView alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH/2, 2)];
    _greenView1.backgroundColor=APPMAINBLUECOLOR;
    [myview addSubview:_greenView1];
    _greenView2=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 48, SCREEN_WIDTH/2, 2)];
    _greenView2.backgroundColor=APPMAINBLUECOLOR;
    [myview addSubview:_greenView2];
    _greenView2.hidden=YES;
    [self addController];
}
- (void)addController{
    _mallVc = [[PlaceOrderListUnupController alloc]init];
    _jiudian = [[PlaceOrderListUpController alloc]init];
    
    [self addChildViewController:_mallVc];
    [self addChildViewController:_jiudian];
    
    _mallVc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH -64-50);
    _jiudian.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGTH - 64-50);
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGTH - 60-75+35)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled=NO;
    _scrollView.delegate=self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView addSubview:_mallVc.view];
    [_scrollView addSubview:_jiudian.view];
    
    [self.view addSubview:_scrollView];
}
-(void)selectFootprintAction:(UIButton *)sender{
    
    if (sender.tag==100) {
        _greenView1.hidden=NO;
        _greenView2.hidden=YES;
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        [sender setTitleColor:APPMAINBLUECOLOR forState:UIControlStateNormal];
        UIButton *button1=(UIButton *)[self.view viewWithTag:101];
        [button1 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
    }else if (sender.tag==101){
        _greenView1.hidden=YES;
        _greenView2.hidden=NO;
        [sender setTitleColor:APPMAINBLUECOLOR forState:UIControlStateNormal];
        UIButton *button1=(UIButton *)[self.view viewWithTag:100];
        [button1 setTitleColor:[UIColor hexValue:0x333333] forState:UIControlStateNormal];
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }
}



@end
