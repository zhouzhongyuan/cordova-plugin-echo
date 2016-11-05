//
//  FilterCustomerController.m
//  离线app
//
//  Created by 王吉源 on 16/10/25.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "FilterCustomerController.h"
#import <CoreData/CoreData.h>
@interface FilterCustomerController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation FilterCustomerController
-(RootTableView *)tableView{
    if (!_tableView) {
        _tableView=[[RootTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.scrollEnabled=NO;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchDatabase];
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
-(void)searchDatabase{
    NSFetchRequest *request;
    if (_isBrand) {
        request= [NSFetchRequest fetchRequestWithEntityName:@"MaterialGroupModel"];
    }else{
        if (_isGroup) {
            request= [NSFetchRequest fetchRequestWithEntityName:@"CustomerGroupModel"];
        }else{
            request= [NSFetchRequest fetchRequestWithEntityName:@"DistributionChannelModel"];
        }
    }
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    
    NSArray *sortDescriptors=[NSArray arrayWithObject:sort];
    
    [request setSortDescriptors:sortDescriptors];
    NSError *error;
    _dataSource = [kCoreDataContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor hexValue:0x333333];
    if (_isBrand) {
        MaterialGroupModel *model = [_dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
    }else{
        if (_isGroup) {
            CustomerGroupModel *model = [_dataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = model.name;
        }else{
            DistributionChannelModel *model = [_dataSource objectAtIndex:indexPath.row];
            cell.textLabel.text =model.name;
        }
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH-15, 1)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:view];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isBrand) {
        MaterialGroupModel *model = [_dataSource objectAtIndex:indexPath.row];
        if (_successBrand) {
            _successBrand(model);
        }
    }else{
        if (_isGroup) {
            CustomerGroupModel *model = [_dataSource objectAtIndex:indexPath.row];
            if (_successGroup) {
                _successGroup(model);
            }
        }else{
            DistributionChannelModel *model = [_dataSource objectAtIndex:indexPath.row];
            if (_successChannel) {
                _successChannel(model);
            }
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


@end
