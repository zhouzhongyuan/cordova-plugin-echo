//
//  FirstController.m
//  离线app
//
//  Created by 王吉源 on 16/10/13.
//  Copyright © 2016年 王吉源. All rights reserved.
//

#import "FirstController.h"
#import "SelectCustomerController.h"
#import "CustomerModel.h"
#import "FunctionManagementController.h"
#import "SVProgressHUD.h"
#import "CustomerModel.h"
#import "AppDelegate.h"
#import "JudgeCustomerOptional.h"
#import "UserModel.h"
#import "UserJsonModel.h"
#import "CustomerGroupModel.h"
#import "CustomerGroupJsonModel.h"
#import "DistributionChannelModel.h"
#import "DistributionChannelJsonModel.h"
#import "MaterialGroupJsonModel.h"
#import "MaterialGroupModel.h"
#import "PromotionGoodModel.h"
#import "PlaceOrderGoodModel.h"
#import "RetreatOrderModel.h"
#import "RetreatOrderGoodModel.h"
#import "CutomerJsonModel.h"
#import "RetreatReasonJsonModel.h"
#import "PromotionTypeJsonModel.h"
#import "PromotionTypeModel.h"
#import "PromotionRuleJsonModel.h"
#import "PromotionRuleModel.h"
#import "PromotionJsonModel.h"
#import "PromotionModel.h"
#import "MaterialJsonModel.h"
#import "MaterialModel.h"
#import "MaterialPriceJsonModel.h"
#import "MaterialPriceModel.h"
#import "StockJsonModel.h"
#import "StockModel.h"
@interface FirstController ()<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate>
@property(nonatomic,strong)RootTableView *tableView;
@property(nonatomic,strong)CustomerModel *customterModel;
@property (nonatomic, strong) NSFileManager *fileMgr;
@property (nonatomic, strong) NSString *documentsPath;
@property(nonatomic,strong)UserJsonModel *userJsonModel;
@property(nonatomic,strong)NSArray *fileNames;
@property(nonatomic,assign)NSInteger index;//下载第几个文件
@property (nonatomic, strong) NSFileHandle *writeFileHandle;
@end

@implementation FirstController
-(RootTableView *)tableView{
    if (!_tableView) {
        _tableView=[[RootTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择客户";
    self.fileMgr = [NSFileManager defaultManager];
    self.documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",self.documentsPath);
    if (APPDELEGATE.isAdd) {
        [self analysisUser];
        [self saveUser];
        [self analysisGroup];
        [self analysisChannel];
        [self analysisBrand];
        [self analysisCustomer];
        [self analysisReason];
        [self analysisRule];
        [self analysisType];
        [self analysisPromotion];
        [self analysisGood];
        [self analysisPriceDatabase];
        [self analysisStockDatabase];
    }
    [self delTemporarySeeOrder];
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setBottomButton];
    [self judgmentCache];
    _fileNames = @[@"Customer.txt",@"CustomerGroup.txt",@"DistributionChannel.txt",@"Material.txt",@"MaterialPrice.txt",@"Promotion.txt",@"PromotionType.txt",@"ReturnReason.txt",@"RuleNo.txt",@"Stock.txt",@"User.txt",@"MaterialGroup.txt"];

    
}
#pragma mark - 删除临时查看的抄单
-(void)delTemporarySeeOrder{
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
    
    
    NSFetchRequest *request3 = [NSFetchRequest fetchRequestWithEntityName:@"RetreatOrderGoodModel"];
    request3.predicate=[NSPredicate predicateWithFormat:@"orderId=%@",@"1"];
    NSArray *arr3 = [kCoreDataContext executeFetchRequest:request3 error:nil];
    
    for (RetreatOrderGoodModel *p in arr3) {
        
        //删除数据
        [kCoreDataContext deleteObject:p];
        
    }
    
    //保存, 将删除操作更新到数据库中
    [kCoreDataContext save:nil];
    
    
}
-(void)analysisStockDatabase{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSError *error = nil;
    NSString *sourcePath = [self.documentsPath stringByAppendingPathComponent:@"Stock.txt"];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [NSString stringWithContentsOfFile:sourcePath encoding:encode error:&error];
    StockJsonModel *model = [[StockJsonModel alloc]initWithString:string error:&error];
    for (StockListModel *modelSub in model.stock) {
        [arr addObject:modelSub];
    }
    for (StockListModel *model1 in arr) {
        StockModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"StockModel" inManagedObjectContext:kCoreDataContext];
        model.normal = model1.normal;
        model.materialname = model1.materialname;
        model.expired = model1.expired;
        model.code = model1.code;
        model.amount = model1.amount;
        model.advent = model1.advent;
        if (![kCoreDataContext save:&error]) {
            NSLog(@"插入数据错误:%@", error.userInfo);
        }
    }
}

-(void)analysisPriceDatabase{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSError *error = nil;
    NSString *sourcePath = [self.documentsPath stringByAppendingPathComponent:@"MaterialPrice.txt"];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [NSString stringWithContentsOfFile:sourcePath encoding:encode error:&error];
    MaterialPriceJsonModel *model = [[MaterialPriceJsonModel alloc]initWithString:string error:&error];
    for (MaterialPriceListModel *modelSub in model.materialPrice) {
        [arr addObject:modelSub];
    }
    for (MaterialPriceListModel *model1 in arr) {
        MaterialPriceModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"MaterialPriceModel" inManagedObjectContext:kCoreDataContext];
        model.price = model1.price;
        model.materialname = model1.materialname;
        model.materialcode = model1.materialcode;
        model.customercode = model1.customercode;
        model.customer = model1.customer;
        model.pricetype = model1.pricetype;
        model.validdatefrom = model1.validdatefrom;
        model.validdateend = model1.validdateend;
        
        if (![kCoreDataContext save:&error]) {
            NSLog(@"插入数据错误:%@", error.userInfo);
        }
    }
}
-(void)savePriceDatabase{
    
}
-(void)analysisGood{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSError *error=nil;
    NSString *sourcePath = [self.documentsPath stringByAppendingPathComponent:@"Material.txt"];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [NSString stringWithContentsOfFile:sourcePath encoding:encode error:&error];
    MaterialJsonModel *model = [[MaterialJsonModel alloc]initWithString:string error:&error];
    arr = [[NSMutableArray alloc]init];
    for (MaterialListModel *modelSub in model.material) {
        [arr addObject:modelSub];
    }
    for (MaterialListModel *model1 in arr) {
        MaterialModel *model=[NSEntityDescription insertNewObjectForEntityForName:@"MaterialModel" inManagedObjectContext:kCoreDataContext];
        model.spec = model1.spec;
        model.series = model1.series;
        model.name = model1.name;
        model.midunit = model1.midunit;
        model.midscale = model1.midscale;
        model.brand = model1.brand;
        model.bigunit = model1.bigunit;
        model.bigscale = model1.bigscale;
        model.basicunit = model1.basicunit;
        model.barcode = model1.barcode;
        model.code = model1.code;
        NSError *error = nil;
        if (![kCoreDataContext save:&error]) {
            NSLog(@"插入数据错误:%@", error.userInfo);
        }
    }
}

-(void)analysisPromotion{
    NSError *error=nil;
    NSString *sourcePath = [self.documentsPath stringByAppendingPathComponent:@"Promotion.txt"];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [NSString stringWithContentsOfFile:sourcePath encoding:encode error:&error];
    PromotionJsonModel *model = [[PromotionJsonModel alloc]initWithString:string error:&error];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (PromotionListModel *modelSub in model.promotion) {
        [arr addObject:modelSub];
    }
    for (PromotionListModel *model1 in arr) {
        PromotionModel *model=[NSEntityDescription insertNewObjectForEntityForName:@"PromotionModel" inManagedObjectContext:kCoreDataContext];
        model.type = model1.type;
        model.startdate = model1.startdate;
        model.salesname = model1.salesname;
        model.salescode = model1.salescode;
        model.price = model1.price;
        model.materialname = model1.materialname;
        model.materialcode = model1.materialcode;
        model.enddate = model1.enddate;
        model.customercode = model1.customercode;
        model.customer = model1.customer;
        model.code = model1.code;
        model.name = model1.name;
        model.brand = model1.brand;
        if (error) {
            NSLog(@"插入数据错误:%@", error.userInfo);
        }
    }
}

#pragma mark - 解析数据促销类型和规则
-(void)analysisType{
    NSError *error=nil;
    NSString *sourcePath = [self.documentsPath stringByAppendingPathComponent:@"PromotionType.txt"];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [NSString stringWithContentsOfFile:sourcePath encoding:encode error:&error];
    PromotionTypeJsonModel *model = [[PromotionTypeJsonModel alloc]initWithString:string error:&error];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (PromotionTypeListModel *modelSub in model.promotionType) {
        [arr addObject:modelSub];
    }
    for (PromotionTypeListModel *model1 in arr) {
        PromotionTypeModel *model=[NSEntityDescription insertNewObjectForEntityForName:@"PromotionTypeModel" inManagedObjectContext:kCoreDataContext];
        model.code=model1.code;
        model.name=model1.name;
        //使用上下文将赋值过的模型对象存储数据库中(增操作)
        if (![kCoreDataContext save:&error]) {
            NSLog(@"插入数据错误:%@", error.userInfo);
        }
    }
}
-(void)analysisRule{
    NSError *error=nil;
    NSString *sourcePath = [self.documentsPath stringByAppendingPathComponent:@"RuleNo.txt"];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [NSString stringWithContentsOfFile:sourcePath encoding:encode error:&error];
    PromotionRuleJsonModel *model = [[PromotionRuleJsonModel alloc]initWithString:string error:&error];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (PromotionRuleListModel *modelSub in model.ruleNo) {
        [arr addObject:modelSub];
    }
    for (PromotionRuleListModel *model1 in arr) {
        PromotionRuleModel *model=[NSEntityDescription insertNewObjectForEntityForName:@"PromotionRuleModel" inManagedObjectContext:kCoreDataContext];
        model.code=model1.code;
        model.name=model1.name;
        model.type = model1.type;
        //使用上下文将赋值过的模型对象存储数据库中(增操作)
        if (![kCoreDataContext save:&error]) {
            NSLog(@"插入数据错误:%@", error.userInfo);
        }
    }
}

-(void)analysisReason{
    NSError *error=nil;
    NSString *sourcePath = [self.documentsPath stringByAppendingPathComponent:@"ReturnReason.txt"];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [NSString stringWithContentsOfFile:sourcePath encoding:encode error:&error];
    RetreatReasonJsonModel *model = [[RetreatReasonJsonModel alloc]initWithString:string error:&error];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (RetreatReasonListModel *modelSub in model.returnReason) {
        [arr addObject:modelSub];
    }
    for (RetreatReasonListModel *model1 in arr) {
        RetreatReasonModel *model=[NSEntityDescription insertNewObjectForEntityForName:@"ReturnReasonModel" inManagedObjectContext:kCoreDataContext];
        
        model.name=model1.name;
        model.code=model1.code;
        //保存, 将插入操作更新到数据库
        NSError *error;
        [kCoreDataContext save:&error];
        if (error) {
            NSLog(@"%@",error.userInfo);
        }
    }
}

-(void)analysisCustomer{
    NSError *error=nil;
    NSString *sourcePath = [self.documentsPath stringByAppendingPathComponent:@"Customer.txt"];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [NSString stringWithContentsOfFile:sourcePath encoding:encode error:&error];
    CutomerJsonModel *model = [[CutomerJsonModel alloc]initWithString:string error:&error];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (CutomerListModel *modelSub in model.customer) {
        [arr addObject:modelSub];
    }
    for (CutomerListModel *model1 in arr) {
        CustomerModel *model=[NSEntityDescription insertNewObjectForEntityForName:@"CustomerModel" inManagedObjectContext:kCoreDataContext];
        model.code=model1.code;
        model.distributionChannel=model1.distributionChannel;
        model.name=model1.name;
        model.region=model1.region;
        model.route=model1.route;
        model.salecode=model1.salecode;
        model.saletype=model1.saletype;
        model.customerGroup =model1.customerGroup;
        NSError *error = nil;
        if (![kCoreDataContext save:&error]) {
            NSLog(@"插入数据错误:%@", error.userInfo);
        }
    }
}

-(void)analysisBrand{
    NSError *error=nil;
    NSString *sourcePath = [self.documentsPath stringByAppendingPathComponent:@"MaterialGroup.txt"];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [NSString stringWithContentsOfFile:sourcePath encoding:encode error:&error];
    MaterialGroupJsonModel *model = [[MaterialGroupJsonModel alloc]initWithString:string error:&error];
    for (MaterialGroupListModel *model1 in model.materialGroup) {
        MaterialGroupModel *model2=[NSEntityDescription insertNewObjectForEntityForName:@"MaterialGroupModel" inManagedObjectContext:kCoreDataContext];
        model2.code = model1.code;
        model2.name = model1.name;
        NSError *error = nil;
        if (![kCoreDataContext save:&error]) {
            NSLog(@"插入数据错误:%@", error.userInfo);
        }
    }
}
-(void)analysisGroup{
    NSError *error=nil;
    NSString *sourcePath = [self.documentsPath stringByAppendingPathComponent:@"CustomerGroup.txt"];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [NSString stringWithContentsOfFile:sourcePath encoding:encode error:&error];
    CustomerGroupJsonModel *model = [[CustomerGroupJsonModel alloc]initWithString:string error:&error];
    for (CustomerGroupListModel *model1 in model.customerGroup) {
        CustomerGroupModel *model2=[NSEntityDescription insertNewObjectForEntityForName:@"CustomerGroupModel" inManagedObjectContext:kCoreDataContext];
        model2.code = model1.code;
        model2.name = model1.name;
        NSError *error = nil;
        if (![kCoreDataContext save:&error]) {
            NSLog(@"插入数据错误:%@", error.userInfo);
        }
    }
}
-(void)analysisChannel{
    NSError *error=nil;
    NSString *sourcePath = [self.documentsPath stringByAppendingPathComponent:@"DistributionChannel.txt"];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [NSString stringWithContentsOfFile:sourcePath encoding:encode error:&error];
    DistributionChannelJsonModel *model = [[DistributionChannelJsonModel alloc]initWithString:string error:&error];
    for (DistributionChannelListModel *model1 in model.distributionChannel) {
        CustomerGroupModel *model2=[NSEntityDescription insertNewObjectForEntityForName:@"DistributionChannelModel" inManagedObjectContext:kCoreDataContext];
        model2.code = model1.code;
        model2.name = model1.name;
        NSError *error = nil;
        if (![kCoreDataContext save:&error]) {
            NSLog(@"插入数据错误:%@", error.userInfo);
        }
    }

}
-(void)analysisUser{
    NSError *error=nil;
    NSString *sourcePath = [self.documentsPath stringByAppendingPathComponent:@"User.txt"];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [NSString stringWithContentsOfFile:sourcePath encoding:encode error:&error];

    _userJsonModel = [[UserJsonModel alloc]initWithString:string error:&error];
}
-(void)saveUser{
    UserModel *model=[NSEntityDescription insertNewObjectForEntityForName:@"UserModel" inManagedObjectContext:kCoreDataContext];
    model.code = _userJsonModel.user.code;
    model.name = _userJsonModel.user.name;
    model.companycode = _userJsonModel.user.companycode;
    model.company = _userJsonModel.user.company;
    model.lasttime = _userJsonModel.user.lasttime;
    NSError *error = nil;
    if (![kCoreDataContext save:&error]) {
        NSLog(@"插入数据错误:%@", error.userInfo);
    }
}
#define mark - 判断有没有未完成的订单
-(void)judgmentCache{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"customer"]) {
        NSLog(@"%@",[defaults objectForKey:@"customer"]);
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"您有未完成的订单，是否继续操做" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [defaults removeObjectForKey:@"customer"];
            [JudgeCustomerOptional delGoodAndPromotionWithOrderId:nil];
        }];
        UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CustomerModel"];
            request.predicate=[NSPredicate predicateWithFormat:@"code=%@",[defaults objectForKey:@"customer"]];
            NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
            NSArray *sortDescriptors=[NSArray arrayWithObject:sort];
            [request setSortDescriptors:sortDescriptors];
            NSError *error;
            NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
            if (error) {
                NSLog(@"%@",error.userInfo);
            }
            _customterModel = [arr firstObject];
            SIGLETON.customerModel = [arr firstObject];
            [_tableView reloadData];
            FunctionManagementController *controller1 = [[FunctionManagementController alloc]init];
            controller1.isGo = YES;
            [self.navigationController pushViewController:controller1 animated:true];
        }];
        [controller addAction:cancelAction];
        [controller addAction:cancelAction1];
        [APPDELEGATE.window.rootViewController presentViewController:controller animated:true completion:nil];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (_customterModel) {
        cell.textLabel.text = _customterModel.name;
    }else{
        cell.textLabel.text = @"请选择客户";
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH-15, 1)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:view];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectCustomerController *controller = [[SelectCustomerController alloc]init];
    [self.navigationController pushViewController:controller animated:true];
    DefineWeakSelf;
    [controller setReturnCustomter:^(CustomerModel *model) {
        weakSelf.customterModel = model;
        [weakSelf.tableView reloadData];
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(void)loadDataAction{
    if (_index<12) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://115.29.33.75:8080/%@",[_fileNames objectAtIndex:_index]]]];
        //执行下载大文件的动作
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
}
#pragma mark --- NSURLConnectionDataDelegate
//接收到服务器返回响应Response触发方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%s", __func__);//打印执行的方法名字
    //创建一个/Libary/Caches/yyyy的空文件
    NSString *filePath = [self.documentsPath stringByAppendingPathComponent:[_fileNames objectAtIndex:_index]];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    
    //初始化写文件句柄(指针)
    self.writeFileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    
    //从response中的某个属性来获取整个文件的大小
}
//接收到服务器返回的数据的触发方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%s", __func__);
    //将服务器"每次"返回的data添加到self.fileData后面
    //    [self.fileData appendData:data];
    //currentTotalLength: 到目前为止下载的数据大小
    //更新进度条
    
    //先将服务器返回的数据写入yyyy文件中
    [self.writeFileHandle writeData:data];
    
    //挪动文件指针到文件的最后面
    [self.writeFileHandle seekToEndOfFile];
}
//已经接收到服务器返回的"所有"数据的触发方法
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%s", __func__);
    NSLog(@"结束了");
    //收尾工作
    [self.writeFileHandle closeFile];
    _index++;
    if (_index==12) {
        [SVProgressHUD showImage:nil status:@"全部文件已经下好了"];
    }
    [self loadDataAction];
    //将下载好的所有数据都写到沙盒文件中:xxx/Library/caches/xxxx
    //    NSString *finalFilePath = [self.cachesPath stringByAppendingPathComponent:@"xxxx"];
    //    [self.fileData writeToFile:finalFilePath atomically:YES];
}

-(void)setBottomButton{
    UIButton *button0=[[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGTH-64-70-70, SCREEN_WIDTH-20, 50)];
    [button0 setBackgroundColor:APPMAINCOLOR];
    button0.titleLabel.font=[UIFont systemFontOfSize:16];
    [button0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button0 addTarget:self action:@selector(loadDataAction) forControlEvents:UIControlEventTouchUpInside];
    button0.layer.cornerRadius=3;
    [button0 setTitle:@"下载数据" forState:UIControlStateNormal];
    [self.view addSubview:button0];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGTH-64-70, SCREEN_WIDTH-20, 50)];
    [button setBackgroundColor:APPMAINCOLOR];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius=3;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UIButton *closeButton=[[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGTH-64-70, SCREEN_WIDTH-20, 50)];
    [closeButton setBackgroundColor:APPMAINCOLOR];
    closeButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.layer.cornerRadius=3;
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.view addSubview:closeButton];
}
-(void)sureAction{
    if (!_customterModel) {
        [SVProgressHUD showImage:nil status:@"请选择客户"];
        return;
    }
    FunctionManagementController *controller = [[FunctionManagementController alloc]init];
    SIGLETON.customerModel = _customterModel;
    [self.navigationController pushViewController:controller animated:true];
}
-(void)closeView{
    [self dismissModalViewControllerAnimated:YES];
}
@end
