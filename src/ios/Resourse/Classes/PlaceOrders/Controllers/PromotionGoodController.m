//
//  PromotionGoodController.m
//  离线app
//
//  Created by 王吉源 on 16/10/14.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "PromotionGoodController.h"
#import "PopupView.h"
#import "LewPopupViewAnimationSlide.h"
#import "CommonTableView.h"
#import "PromotionGoodModel.h"
#import "PromotionRuleJsonModel.h"
#import "PromotionTypeJsonModel.h"
#import "NSDate+Utils.h"
@interface PromotionGoodController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)PromotionTypeModel *promotionTypeModel;
@property(nonatomic,strong)PromotionRuleModel *promotionRuleModel;
@property(nonatomic,strong)NSString *promotionRule;
@property (nonatomic,strong) PopupView *popView;
@property(nonatomic,strong)NSManagedObjectContext *context;//被管理对象上下文(对对象进行增删改查)
@property(nonatomic,strong)NSFetchedResultsController *typeResult;//类型结果
@property(nonatomic,strong)NSFetchedResultsController *ruleResult;//规则结果
@property(nonatomic,strong)NSMutableArray *promotionTypes;
@property(nonatomic,strong)NSMutableArray *promotionRules;


@property (nonatomic, strong) NSFileManager *fileMgr;
@property (nonatomic, strong) NSString *documentsPath;
@end

@implementation PromotionGoodController
//初始化被管理对象上下文
- (NSManagedObjectContext *)context {
    if (!_context) {
        //从AppDelegate.m获取上下文对象
        _context = APPDELEGATE.managedObjectContext;
    }
    return _context;
}
//初始化结果控制器
- (NSFetchedResultsController *)typeResult {
    if (_typeResult != nil) {
        return _typeResult;
    }
    
    //下面的是该对象为空时的初始化的逻辑
    //1.创建一个请求对象(指定请求的是哪个实体Entity)
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"PromotionTypeModel" inManagedObjectContext:self.context];
    request.entity = entityDesc;
    
    //2.创建一个排序描述算子
    /**第一参数：指定排序的列名(字段的名字)
     第二参数：指定是升序(YES)还是降序(NO)
     */
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"code" ascending:YES];
    request.sortDescriptors = @[sortDesc];
    
    /**
     第三个参数：指定tableView的section按哪列进行归类；name这一列如果名字相同，自动地归为一个section
     第四个参数：指定缓存的文件名字；提高获取数据的速度(如果遇到相同请求，会从CacheData文件中直接获取数据)
     */
    
    _typeResult = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_context sectionNameKeyPath:@"code" cacheName:@"CacheData"];
    
    //执行请求!!!!
    NSError *error = nil;
    if (![_typeResult performFetch:&error]) {
        NSLog(@"执行请求错误:%@", error.userInfo);
    }
    
    //设置代理
    self.typeResult.delegate = self;
    
    return _typeResult;
    
}
- (NSFetchedResultsController *)ruleResult {
    if (_ruleResult != nil) {
        return _ruleResult;
    }
    
    //下面的是该对象为空时的初始化的逻辑
    //1.创建一个请求对象(指定请求的是哪个实体Entity)
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"PromotionRuleModel" inManagedObjectContext:self.context];
    request.entity = entityDesc;
    
    //2.创建一个排序描述算子
    /**第一参数：指定排序的列名(字段的名字)
     第二参数：指定是升序(YES)还是降序(NO)
     */
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"code" ascending:YES];
    request.sortDescriptors = @[sortDesc];
    
    /**
     第三个参数：指定tableView的section按哪列进行归类；name这一列如果名字相同，自动地归为一个section
     第四个参数：指定缓存的文件名字；提高获取数据的速度(如果遇到相同请求，会从CacheData文件中直接获取数据)
     */
    
    _ruleResult = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_context sectionNameKeyPath:@"code" cacheName:@"CacheData"];
    
    //执行请求!!!!
    NSError *error = nil;
    if (![_ruleResult performFetch:&error]) {
        NSLog(@"执行请求错误:%@", error.userInfo);
    }
    
    //设置代理
    self.ruleResult.delegate = self;
    
    return _ruleResult;
    
}
-(RootTableView *)tableView{
    if (!_tableView) {
        _tableView=[[RootTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 88) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"促销商品";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    [self setBottomButton];

    _promotionTypes=[[NSMutableArray alloc]init];
    for (int i=0; i<self.typeResult.sections.count; i++) {
        PromotionTypeModel *model = [self.typeResult objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        [_promotionTypes addObject:model];
        if (_goodModel&&[model.code isEqualToString:_goodModel.typeCode]) {
            _promotionTypeModel = model;
        }
    }
    _promotionRules = [[NSMutableArray alloc]init];
    for (int i=0; i<self.ruleResult.sections.count; i++) {
        PromotionRuleModel *model = [self.ruleResult objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        [_promotionRules addObject:model];
        if (_goodModel&&[model.code isEqualToString:_goodModel.ruleCode]) {
            _promotionRuleModel = model;
        }
    }
    
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
    //先查出数据, 然后再更新
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PromotionGoodModel"];
    //添加查询条件
    request.predicate=[NSPredicate predicateWithFormat:@"(ruleCode=%@ AND typeCode=%@ And orderId=%@) ",_promotionRuleModel.code,_promotionTypeModel.code,@"0"];
    NSArray *arr = [self.context executeFetchRequest:request error:nil];
    if (arr.count>0) {
        [SVProgressHUD showImage:nil status:@"此促销规则已存在，不能重复添加"];
        return;
    }
    if (_promotionRuleModel&&_promotionTypeModel) {
        if (_goodModel) {
            //先查出数据, 然后再更新
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PromotionGoodModel"];
            //添加查询条件
            request.predicate=[NSPredicate predicateWithFormat:@"id=%@",_goodModel.id];
            NSArray *arr = [self.context executeFetchRequest:request error:nil];
            PromotionGoodModel *model = [arr firstObject];
            model.ruleCode = _promotionRuleModel.code;
            model.ruleName = _promotionRuleModel.name;
            model.typeCode = _promotionTypeModel.code;
            model.typeName = _promotionTypeModel.name;
            model.orderId =_isLook?@"1":@"0";
            NSError *error = nil;
            if (![self.context save:&error]) {
                NSLog(@"插入数据错误:%@", error.userInfo);
            }
            if (_StorageData) {
                _StorageData();
            }
        }else{
            PromotionGoodModel *model=[NSEntityDescription insertNewObjectForEntityForName:@"PromotionGoodModel" inManagedObjectContext:self.context];
            model.id=[NSDate currentFullTimeString];
            model.ruleCode = _promotionRuleModel.code;
            model.ruleName = _promotionRuleModel.name;
            model.typeCode = _promotionTypeModel.code;
            model.typeName = _promotionTypeModel.name;
            model.orderId =_isLook?@"1":@"0";
            NSError *error = nil;
            if (![self.context save:&error]) {
                NSLog(@"插入数据错误:%@", error.userInfo);
            }
            if (_StorageData) {
                _StorageData();
            }
        }
    }else{
        if (_goodModel) {
            [SVProgressHUD showImage:nil status:@"请选择促销规则"];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:true];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor hexValue:0x333333];
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-120, 44)];
    textField.textColor = [UIColor hexValue:0x333333];
    textField.font = [UIFont systemFontOfSize:14];
    [cell addSubview:textField];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    textField.userInteractionEnabled = NO;
    if (indexPath.row == 0) {
        textField.placeholder = @"请选择促销类型";
        cell.textLabel.text = @"促销类型:";
        textField.text = _promotionTypeModel.name;
    }else{
        textField.placeholder = @"请选择促销规则";
        cell.textLabel.text = @"促销规则:";
        textField.text = _promotionRuleModel.name;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH-15, 1)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:view];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 &&!self.promotionTypeModel) {
        [SVProgressHUD showImage:nil status:@"请先选择促销类型"];
    }else{
        [self selectPromotionWithType:indexPath.row==0];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)selectPromotionWithType:(BOOL)isType{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSMutableArray *arr = [[NSMutableArray alloc]init];;
    if (isType) {
        for (PromotionTypeModel *model in _promotionTypes) {
            [arr addObject:model.name];
        }
        self.popView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, 44*arr.count)];
    }else{
        for (PromotionRuleModel *model in _promotionRules) {
            if ([model.type isEqualToString:_promotionTypeModel.name]) {
                [arr addObject:model.name];
                [array addObject:model];
            }
        }
        if (arr.count == 0) {
            [SVProgressHUD showImage:nil status:@"此类型没有对应的规则"];
            return;
        }
        self.popView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, 44*arr.count)];
    }
    _popView.parentVC = self;
    
    for (UIView* v in _popView.innerView.subviews) {
        [v removeFromSuperview];
    }
    
    CGRect rect = CGRectMake(0, 0, _popView.innerView.frame.size.width, _popView.innerView.frame.size.height);
    
    UIView* contentView = [[UIView alloc] initWithFrame:rect];
    contentView.backgroundColor = [UIColor whiteColor];
    
    contentView.layer.cornerRadius = 7;//设置那个圆角的有多圆
    contentView.layer.borderWidth = 0;//设置边框的宽度，当然可以不要
    contentView.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
    contentView.layer.masksToBounds = YES;
    self.popView.innerView.backgroundColor=[UIColor clearColor];
    [_popView.innerView addSubview:contentView];
    

    CommonTableView *tableView=[[CommonTableView alloc]initWithFrame:rect titleArray:arr detialTitleArray:nil];
    [contentView addSubview:tableView];
    DefineWeakSelf;
    [tableView setSelectedIndex:^(NSInteger index) {
        if (isType) {
            weakSelf.promotionTypeModel = [weakSelf.promotionTypes objectAtIndex:index];
            weakSelf.promotionRuleModel =nil;
        }else{
            weakSelf.promotionRuleModel = [array objectAtIndex:index];
        }
        [weakSelf.tableView reloadData];
        [weakSelf lew_dismissPopupView];
    }];
    LewPopupViewAnimationSlide *animation = [[LewPopupViewAnimationSlide alloc]init];
    animation.type = LewPopupViewAnimationSlideTypeBottomBottom;
    [self lew_presentPopupView:_popView animation:animation dismissed:^{
        NSLog(@"动画结束");
    }];
    return;
}
@end
