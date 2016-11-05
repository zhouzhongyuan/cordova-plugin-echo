//
//  JudgeCustomerOptional.m
//  离线app
//
//  Created by 王吉源 on 16/10/20.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "JudgeCustomerOptional.h"
#import <CoreData/CoreData.h>
#import "PlaceOrderGoodModel.h"
#import "PromotionGoodModel.h"
@implementation JudgeCustomerOptional
+(BOOL)judgeCustomerOptional{
    //先查出数据, 然后再更新
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
    //添加查询条件
    request.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"0"];
    //执行查询
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:nil];
    NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"PromotionGoodModel"];
    //添加查询条件
    //执行查询
    NSArray *arr1 = [kCoreDataContext executeFetchRequest:request1 error:nil];
    if (arr.count == 0 && arr1.count == 0) {
        return YES;
    }
    return NO;
}
+(void)delGoodAndPromotionWithOrderId:(NSString *)orderId{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
    if (orderId) {
        request.predicate = [NSPredicate predicateWithFormat:@"orderId=%@",@"1"];
    }else{
        request.predicate = [NSPredicate predicateWithFormat:@"orderId=%@",@"0"];
    }
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:nil];
    
    for (PlaceOrderGoodModel *p in arr) {
        
        //删除数据
        [kCoreDataContext deleteObject:p];
        
    }
    //保存, 将删除操作更新到数据库中
    [kCoreDataContext save:nil];
    
    NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"PromotionGoodModel"];
    if (orderId) {
        request1.predicate = [NSPredicate predicateWithFormat:@"orderId=%@",@"1"];
    }else{
        request1.predicate = [NSPredicate predicateWithFormat:@"orderId=%@",@"0"];
    }
    NSArray *arr1 = [kCoreDataContext executeFetchRequest:request1 error:nil];
    
    for (PromotionGoodModel *p in arr1) {
        
        //删除数据
        [kCoreDataContext deleteObject:p];
        
    }
    //保存, 将删除操作更新到数据库中
    [kCoreDataContext save:nil];

}
+(NSString *)calculationTotlePriceWithOrderId:(NSString *)orderId{
    //先查出数据, 然后再更新
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceOrderGoodModel"];
    if (orderId) {
        request.predicate = [NSPredicate predicateWithFormat:@"orderId=%@",@"1"];
    }else{
        request.predicate = [NSPredicate predicateWithFormat:@"orderId=%@",@"0"];
    }
    
    //添加查询条件
    //执行查询
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:nil];
    double price = 0.0;
    for (PlaceOrderGoodModel *model in arr) {
        price += model.amount.doubleValue;
    }
    return [NSString stringWithFormat:@"%.2f",price];
}
@end
