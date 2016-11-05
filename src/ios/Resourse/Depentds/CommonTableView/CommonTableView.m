//
//  CommonTableView.m
//  不一样的烟火
//
//  Created by 吉源 on 16/5/25.
//  Copyright © 2016年 吉源. All rights reserved.
//

#import "CommonTableView.h"

@interface CommonTableView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *detailTitleArray;
@end
@implementation CommonTableView
-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)array detialTitleArray:(NSArray *)detialArray{
    if (self=[super init]) {
        self.frame=frame;
        _titleArray=array;
        _detailTitleArray=detialArray;
        self.delegate=self;
        self.dataSource=self;
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.textColor=[UIColor hexValue:0x333333];
    cell.textLabel.text=[_titleArray objectAtIndex:indexPath.row];
    if (_detailTitleArray.count>=indexPath.row) {
        cell.detailTextLabel.text=[_detailTitleArray objectAtIndex:indexPath.row];
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
    view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [cell addSubview:view];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedIndex) {
        _selectedIndex(indexPath.row);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
