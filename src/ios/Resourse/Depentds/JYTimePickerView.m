//
//  JYTimePickerView.m
//  TongYan
//
//  Created by 吉源 on 16/4/18.
//  Copyright © 2016年 Alone. All rights reserved.
//

#import "JYTimePickerView.h"
#import "NSDate+Utils.h"
#import "NSDate-Utilities.h"
#import "SVProgressHUD.h"
#define FirstComponent 0
#define SubComponent 1
#define ThirdComponent 2

#define SCREENWIDTH     [[UIScreen mainScreen]bounds].size.width
#define SCREENHEIGHT      [[UIScreen mainScreen]bounds].size.height

@interface JYTimePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@end
@implementation JYTimePickerView{
    UIPickerView *_pickerView;
    
    NSString *_yearStr;
    NSString *_monthStr;
    NSString *_dayStr;
    NSString *_hourStr;
    NSString *_minuteStr;
    NSString *_secondStr;
    
    // 年
    NSMutableArray *_pickerArray;
    // 月
    NSMutableArray *_subPickerArray;
    // 日
    NSMutableArray *_thirdPickerArray;
    
    NSInteger _year;
    NSInteger _month;
    NSInteger _day;
    NSInteger _hour;
    NSInteger _minute;
    NSInteger _second;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, 40, SCREENWIDTH, 216);
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate=self;
        _pickerView.dataSource=self;
        [self addSubview:_pickerView];
        
//        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
//        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, SCREENWIDTH, 40)];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.backgroundColor=APPMAINBLUECOLOR;
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:cancelBtn];
        [self addSubview:_sureBtn];
    }
    return self;
}
#pragma mark-初始化数据
-(void)initData{
    NSDate *nowDate=[NSDate date];
    _year=[nowDate year];
    _month=[nowDate month];
    _day=[nowDate day];
    _hour=nowDate.hour;
    _minute=nowDate.minute;
    _second=nowDate.seconds;
    _yearStr=[NSString stringWithFormat:@"%ld",_year];
    _monthStr=[NSString stringWithFormat:@"%02ld",_month];
    _dayStr=[NSString stringWithFormat:@"%02ld",_day];
    _hourStr=[NSString stringWithFormat:@"%02ld",_hour];
    _minuteStr=[NSString stringWithFormat:@"%02ld",_minute];
    _secondStr=[NSString stringWithFormat:@"%02ld",_second];
    //初始化数据
    _pickerArray=[[NSMutableArray alloc]init];
    _subPickerArray=[[NSMutableArray alloc]init];
    _thirdPickerArray=[[NSMutableArray alloc]init];
    if (_selectTimeStyle==YYYYMMDD_hh_mm) {
        _yearStr=[NSString stringWithFormat:@"%@-%@-%@",_yearStr,_monthStr,_dayStr];
        NSInteger year=_year;
        for (NSInteger i=_month; i<_month+12; i++) {
            NSInteger month=i;
            if (month>12) {
                month-=12;
                if (year==_year) {
                    year++;
                }
            }
            for (NSInteger j=1; j<=[nowDate howManyDaysInThisMonth:year month:i]; j++) {
                [_pickerArray addObject:[NSString stringWithFormat:@"%ld-%02ld-%02ld",year,month,j]];
            }
        }
        for (int i=0; i<24; i++) {
            [_subPickerArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        for (int i=0; i<60; i++) {
            [_thirdPickerArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        [_pickerView selectRow:_day-1 inComponent:0 animated:NO];
        [_pickerView selectRow:_hour inComponent:1 animated:NO];
        [_pickerView selectRow:_minute inComponent:2 animated:NO];
    }else if (_selectTimeStyle==YYYY_MM_DD){
        for (NSInteger i=_year-50; i<_year+50; i++) {
            [_pickerArray addObject:[NSString stringWithFormat:@"%ld",i]];
        }
        for (NSInteger i=1; i<=12; i++) {
            [_subPickerArray addObject:[NSString stringWithFormat:@"%02ld",i]];
        }
        for (NSInteger i=1; i<=[nowDate numDaysInMonth]; i++) {
            [_thirdPickerArray addObject:[NSString stringWithFormat:@"%02ld",i]];
        }
        [_pickerView selectRow:_year-1966 inComponent:0 animated:NO];
        [_pickerView selectRow:_month-1 inComponent:1 animated:NO];
        [_pickerView selectRow:_day-1 inComponent:2 animated:NO];
    }else if (_selectTimeStyle==YYYYMM){
        for (NSInteger i=_year-3; i<_year+3; i++) {
            for (NSInteger j=1; j<13; j++) {
                [_pickerArray addObject:[NSString stringWithFormat:@"%ld年%02ld月",i,j]];
            }
        }
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        
        int year = [dateComponent year];
        int month = [dateComponent month];
        NSString *currentTime = [NSString stringWithFormat:@"%d年%02d月", year, month];
        NSLog(@"%@", _pickerArray);
        for (NSInteger i = 0; i < _pickerArray.count - 1; i++) {
            if ([_pickerArray[i] isEqualToString:currentTime]) {
                
                _yearStr=_pickerArray [i];
                [_pickerView selectRow:i inComponent:0 animated:NO];
            }
        }
    }
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_selectTimeStyle==YYYYMM) {
        return 1;
    }
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == FirstComponent) {
        return [_pickerArray count];
    }
    if (component == SubComponent) {
        return [_subPickerArray count];
    }
    if (component == ThirdComponent) {
        return [_thirdPickerArray count];
    }
    return 10;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == FirstComponent) {
        return [_pickerArray objectAtIndex:row];
    }
    if (component == SubComponent) {
        return [_subPickerArray objectAtIndex:row];
    }
    if (component == ThirdComponent) {
        return [_thirdPickerArray objectAtIndex:row];
    }
    return nil;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_selectTimeStyle==YYYYMMDD_hh_mm) {
        if (component==FirstComponent) {
            _yearStr=[_pickerArray objectAtIndex:row];
        }
        if (component == SubComponent) {
            _hourStr = [_subPickerArray objectAtIndex:row];
        }
        if (component == ThirdComponent) {
            _minuteStr = [_thirdPickerArray objectAtIndex:row];
        }
    }else if (_selectTimeStyle==YYYY_MM_DD) {
        if (component==FirstComponent) {
            _yearStr=[_pickerArray objectAtIndex:row];
        }
        if (component == SubComponent) {
            _monthStr = [_subPickerArray objectAtIndex:row];
        }
        if (component == ThirdComponent) {
            _dayStr = [_thirdPickerArray objectAtIndex:row];
        }
        if ([[NSDate date] howManyDaysInThisMonth:_yearStr.integerValue month:_monthStr.integerValue]!=_thirdPickerArray.count) {
            [_thirdPickerArray removeAllObjects];
            for (NSInteger i=1; i<=[[NSDate date] howManyDaysInThisMonth:_yearStr.integerValue month:_monthStr.integerValue]; i++) {
                [_thirdPickerArray addObject:[NSString stringWithFormat:@"%02ld",i]];
            }
            if (_dayStr.integerValue>_thirdPickerArray.count) {
                _dayStr=[_thirdPickerArray lastObject];
            }
            [_pickerView selectRow:_dayStr.integerValue-1 inComponent:2 animated:NO];
        }
        [_pickerView reloadAllComponents];
    }else if (_selectTimeStyle==YYYYMM){
        _yearStr=[_pickerArray objectAtIndex:row];
    }
    
    
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *myView = nil;
    if (SCREEN_WIDTH>=375) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
    }else{
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 80, 30)];
    }
    
    myView.textAlignment = NSTextAlignmentCenter;
    if (component==0) {
        myView.text = [_pickerArray objectAtIndex:row];
    }else if (component==1){
        myView.text = [_subPickerArray objectAtIndex:row];
    }else{
        myView.text = [_thirdPickerArray objectAtIndex:row];
    }
    myView.font = [UIFont systemFontOfSize:14];//用label来设置字体大小
    
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}
//确定按钮。。返回时间。
- (void)sureClick:(UIButton *)btn {
    if (_selectTimeStyle==YYYYMMDD_hh_mm) {
        NSDate *date=[NSDate dateWithString:[NSString stringWithFormat:@"%@ %@:%@:%@",_yearStr,_hourStr,_minuteStr,@"59"] formatString:@"yyyy-MM-dd HH:mm:ss"];
        if (_isCannotBecomeTime) {
            if ([date isPastDate]) {
                [SVProgressHUD showErrorWithStatus:@"不能早于当前时间"];
                return;
            }
        }
        if (_isCannotLateTime) {
            if (![date isPastDate]) {
                [SVProgressHUD showErrorWithStatus:@"不能晚于当前时间"];
                return;
            }
        }
        NSDictionary *timeDict = @{@"year":_yearStr,
                                   @"month":_hourStr,
                                   @"day":_minuteStr
                                   };
        //确定回调
        _timeCallback(_yearStr,_hourStr,_minuteStr,timeDict);
    }else if (_selectTimeStyle==YYYY_MM_DD){
        NSDate *date=[NSDate dateWithString:[NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",_yearStr,_monthStr,_dayStr,@"23",@"59",@"59"] formatString:@"yyyy-MM-dd HH:mm:ss"];
        if (_isCannotBecomeTime) {
            if ([date isPastDate]) {
                [SVProgressHUD showErrorWithStatus:@"不能早于当前时间"];
                return;
            }
        }
        if (_isCannotLateTime) {
            if (![date isPastDate]) {
                [SVProgressHUD showErrorWithStatus:@"不能晚于当前时间"];
                return;
            }
        }
        NSDictionary *timeDict = @{@"year":_yearStr,
                                   @"month":_monthStr,
                                   @"day":_dayStr
                                   };
        //确定回调
        _timeCallback(_yearStr,_monthStr,_dayStr,timeDict);
    }else if (_selectTimeStyle==YYYYMM){
        NSDictionary *timeDict = @{@"year":_yearStr,
                                   };
        //确定回调
        _timeCallback(_yearStr,@"",@"",timeDict);
    }
    
}
//取消回调
- (void)cancelClick:(UIButton *)btn {
    _cancelCallback();
}
@end
