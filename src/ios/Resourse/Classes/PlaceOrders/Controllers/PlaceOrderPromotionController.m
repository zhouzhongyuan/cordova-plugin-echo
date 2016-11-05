//
//  PlaceOrderPromotionController.m
//  离线app
//
//  Created by 王吉源 on 16/10/14.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "PlaceOrderPromotionController.h"
#import "PromotionGoodController.h"
#import "PromotionCell.h"
#import "PromotionGoodModel.h"
#import "PromotionSendController.h"
#import "JudgeCustomerOptional.h"
@interface PlaceOrderPromotionController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)NSManagedObjectContext *context;//被管理对象上下文(对对象进行增删改查)
@property(nonatomic,strong)NSFetchedResultsController *fetchResultController;//类型结果
@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation PlaceOrderPromotionController
//初始化被管理对象上下文
- (NSManagedObjectContext *)context {
    if (!_context) {
        //从AppDelegate.m获取上下文对象
        _context = APPDELEGATE.managedObjectContext;
    }
    return _context;
}
////初始化结果控制器
//- (NSFetchedResultsController *)fetchResultController {
//    if (_fetchResultController != nil) {
//        return _fetchResultController;
//    }
//    
//    //下面的是该对象为空时的初始化的逻辑
//    //1.创建一个请求对象(指定请求的是哪个实体Entity)
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"PromotionGoodModel" inManagedObjectContext:self.context];
//    request.entity = entityDesc;
//    
//    //2.创建一个排序描述算子
//    /**第一参数：指定排序的列名(字段的名字)
//     第二参数：指定是升序(YES)还是降序(NO)
//     */
//    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
//    request.sortDescriptors = @[sortDesc];
//    
//    /**
//     第三个参数：指定tableView的section按哪列进行归类；name这一列如果名字相同，自动地归为一个section
//     第四个参数：指定缓存的文件名字；提高获取数据的速度(如果遇到相同请求，会从CacheData文件中直接获取数据)
//     */
//    
//    _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_context sectionNameKeyPath:@"id" cacheName:@"CacheData"];
//    
//    //执行请求!!!!
//    NSError *error = nil;
//    if (![_fetchResultController performFetch:&error]) {
//        NSLog(@"执行请求错误:%@", error.userInfo);
//    }
//    
//    //设置代理
//    self.fetchResultController.delegate = self;
//    
//    return _fetchResultController;
//    
//}
-(RootTableView *)tableView{
    if (!_tableView) {
        _tableView=[[RootTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH-64-50-50) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self searchData];
    
}
-(void)searchData{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PromotionGoodModel"];
    request.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"0"];
    NSSortDescriptor *sort= [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    _dataSource = [kCoreDataContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    [_tableView reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<_dataSource.count) {
        return 100;
    }
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < _dataSource.count) {
        PromotionGoodModel *model  = [_dataSource objectAtIndex:indexPath.section];
        PromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PromotionCell" owner:nil options:nil]firstObject];
        }
        cell.ruleLabel.text = [NSString stringWithFormat:@"促销规则：%@",model.ruleName];
        cell.typeLabel.text = [NSString stringWithFormat:@"促销类型：%@",model.typeName];
        [cell.editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.delButton addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.imageView.image = [UIImage imageNamed:@"icon_add"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _dataSource.count) {
        PromotionGoodController *controller = [[PromotionGoodController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
        DefineWeakSelf;
        [controller setStorageData:^{
            [weakSelf searchData];
            [weakSelf saveInfo];
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(void)editAction:(UIButton *)sender{
    UIView *obj = sender;
    while (![obj isKindOfClass:[UITableViewCell class]]) {
        obj = obj.superview;
    }
    PromotionCell *cell = (PromotionCell *)obj;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    PromotionGoodModel *model  = [_dataSource objectAtIndex:indexPath.section];
    PromotionGoodController *controller = [[PromotionGoodController alloc]init];
    controller.goodModel = model;
    [self.navigationController pushViewController:controller animated:YES];
    DefineWeakSelf;
    [controller setStorageData:^{
        [weakSelf searchData];
    }];
}
-(void)sendAction:(UIButton *)sender{
    UIView *obj = sender;
    while (![obj isKindOfClass:[UITableViewCell class]]) {
        obj = obj.superview;
    }
    PromotionCell *cell = (PromotionCell *)obj;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    PromotionGoodModel *model  = [_dataSource objectAtIndex:indexPath.section];
    PromotionSendController *controller = [[PromotionSendController alloc]init];
    controller.goodModel = model;
    [self.navigationController pushViewController:controller animated:YES];
    DefineWeakSelf;
    [controller setSuccessBlock:^{
        if (weakSelf.changeBlock) {
            weakSelf.changeBlock();
        }
    }];
}
-(void)delAction:(UIButton *)sender{
    UIView *obj = sender;
    while (![obj isKindOfClass:[UITableViewCell class]]) {
        obj = obj.superview;
    }
    PromotionCell *cell = (PromotionCell *)obj;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    PromotionGoodModel *model  = [_dataSource objectAtIndex:indexPath.row];
    [self.context deleteObject:model];
    [self searchData];
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"插入数据错误:%@", error.userInfo);
    }
    [_tableView reloadData];
    [self saveInfo];
}
-(void)saveInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (!JUDGECUSTOMEROPTIONAL) {
        if (![defaults valueForKey:@"customer"]) {
            CustomerModel *model = SIGLETON.customerModel;
            [defaults setValue:model.code forKey:@"customer"];
        }
    }else{
        [defaults removeObjectForKey:@"customer"];
    }
}
@end
