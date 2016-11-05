//
//  SelectCustomerController.m
//  离线app
//
//  Created by 王吉源 on 16/10/13.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "SelectCustomerController.h"
#import <CoreData/CoreData.h>
#import "CutomerJsonModel.h"
@interface SelectCustomerController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)NSManagedObjectContext *context;//被管理对象上下文(对对象进行增删改查)

@property (nonatomic, strong) NSFileManager *fileMgr;
@property (nonatomic, strong) NSString *documentsPath;
@end

@implementation SelectCustomerController
//初始化被管理对象上下文
- (NSManagedObjectContext *)context {
    if (!_context) {
        //从AppDelegate.m获取上下文对象
        _context = APPDELEGATE.managedObjectContext;
    }
    return _context;
}
-(RootTableView *)tableView{
    if (!_tableView) {
        _tableView=[[RootTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
//        _tableView.scrollEnabled=NO;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户列表";
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    //创建查询请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CustomerModel"];
    if (_groupModel&&_channelModel) {
        request.predicate = [NSPredicate predicateWithFormat:@"(distributionChannel=%@ AND customerGroup=%@)",_channelModel.name,_groupModel.name];
    }else if (_groupModel){
        request.predicate = [NSPredicate predicateWithFormat:@"customerGroup=%@",_groupModel.name];
    }else if (_channelModel){
        request.predicate = [NSPredicate predicateWithFormat:@"distributionChannel=%@",_channelModel.name];
    }
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    
    NSArray *sortDescriptors=[NSArray arrayWithObject:sort];
    
    [request setSortDescriptors:sortDescriptors];
    NSError *error;
    _dataSource = [kCoreDataContext executeFetchRequest:request error:&error];
    
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerModel *model = [_dataSource objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor hexValue:0x333333];
    cell.textLabel.text = model.name;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH-15, 1)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:view];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerModel *model = [_dataSource objectAtIndex:indexPath.row];
    if (_returnCustomter) {
        _returnCustomter(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
@end
