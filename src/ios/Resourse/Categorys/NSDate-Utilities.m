/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

/*
 #import <humor.h> : Not planning to implement: dateByAskingBoyOut and dateByGettingBabysitter
 ----
 General Thanks: sstreza, Scott Lawrence, Kevin Ballard, NoOneButMe, Avi`, August Joki. Emanuele Vulcano, jcromartiej, Blagovest Dachev, Matthias Plappert,  Slava Bushtruk, Ali Servet Donmez, Ricardo1980, pip8786, Danny Thuerin, Dennis Madsen
*/

#import "NSDate-Utilities.h"
#import "NSDate+Utils.h"

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]


#define SECONDS_PER_MINUTE 60.0
#define SECONDS_PER_HOUR   3600.0
#define SECONDS_PER_DAY    86400.0
#define SECONDS_PER_MONTH  2592000.0
#define SECONDS_PER_YEAR   31536000.0


@implementation NSDate (Utilities)

#pragma mark / Format dates from the current date
- (NSString *)formatWithString:(NSString *)format {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *string = [formatter stringFromDate:self];
	return string;
}

- (NSString *)formatWithStyle:(NSDateFormatterStyle)style {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:style];
	NSString *string = [formatter stringFromDate:self];
	return string;
}

- (NSString *)distanceOfTimeInWords {
	return [self distanceOfTimeInWords:[NSDate date]];
}

- (NSString *)distanceOfTimeInWords:(NSDate *)date {
	NSString *Ago      = NSLocalizedString(@"ago", @"Denotes past dates");
	NSString *FromNow  = NSLocalizedString(@"from now", @"Denotes future dates");
	NSString *LessThan = NSLocalizedString(@"Less than", @"Indicates a less-than number");
	NSString *About    = NSLocalizedString(@"About", @"Indicates an approximate number");
	NSString *Over     = NSLocalizedString(@"Over", @"Indicates an exceeding number");
	NSString *Almost   = NSLocalizedString(@"Almost", @"Indicates an approaching number");
	//NSString *Second   = NSLocalizedString(@"second", @"One second in time");
	NSString *Seconds  = NSLocalizedString(@"seconds", @"More than one second in time");
	NSString *Minute   = NSLocalizedString(@"minute", @"One minute in time");
	NSString *Minutes  = NSLocalizedString(@"minutes", @"More than one minute in time");
	NSString *Hour     = NSLocalizedString(@"hour", @"One hour in time");
	NSString *Hours    = NSLocalizedString(@"hours", @"More than one hour in time");
	NSString *Day      = NSLocalizedString(@"day", @"One day in time");
	NSString *Days     = NSLocalizedString(@"days", @"More than one day in time");
	NSString *Month    = NSLocalizedString(@"month", @"One month in time");
	NSString *Months   = NSLocalizedString(@"months", @"More than one month in time");
	NSString *Year     = NSLocalizedString(@"year", @"One year in time");
	NSString *Years    = NSLocalizedString(@"years", @"More than one year in time");

	NSTimeInterval since = [self timeIntervalSinceDate:date];
	NSString *direction = since <= 0.0 ? Ago : FromNow;
	since = fabs(since);

	int seconds   = (int)since;
	int minutes   = (int)round(since / SECONDS_PER_MINUTE);
	int hours     = (int)round(since / SECONDS_PER_HOUR);
	int days      = (int)round(since / SECONDS_PER_DAY);
	int months    = (int)round(since / SECONDS_PER_MONTH);
	int years     = (int)floor(since / SECONDS_PER_YEAR);
	int offset    = (int)round(floor((float)years / 4.0) * 1440.0);
	int remainder = (minutes - offset) % 525600;

	int number;
	NSString *measure;
	NSString *modifier = @"";

	switch (minutes) {
		case 0 ... 1:
			measure = Seconds;
			switch (seconds) {
				case 0 ... 4:
					number = 5;
					modifier = LessThan;
					break;
				case 5 ... 9:
					number = 10;
					modifier = LessThan;
					break;
				case 10 ... 19:
					number = 20;
					modifier = LessThan;
					break;
				case 20 ... 39:
					number = 30;
					modifier = About;
					break;
				case 40 ... 59:
					number = 1;
					measure = Minute;
					modifier = LessThan;
					break;
				default:
					number = 1;
					measure = Minute;
					modifier = About;
					break;
			}
			break;
		case 2 ... 44:
			number = minutes;
			measure = Minutes;
			break;
		case 45 ... 89:
			number = 1;
			measure = Hour;
			modifier = About;
			break;
		case 90 ... 1439:
			number = hours;
			measure = Hours;
			modifier = About;
			break;
		case 1440 ... 2529:
			number = 1;
			measure = Day;
			break;
		case 2530 ... 43199:
			number = days;
			measure = Days;
			break;
		case 43200 ... 86399:
			number = 1;
			measure = Month;
			modifier = About;
			break;
		case 86400 ... 525599:
			number = months;
			measure = Months;
			break;
		default:
			number = years;
			measure = number == 1 ? Year : Years;
			if (remainder < 131400) {
				modifier = About;
			} else if (remainder < 394200) {
				modifier = Over;
			} else {
				++number;
				measure = Years;
				modifier = Almost;
			}
			break;
	}
	if ([modifier length] > 0) {
		modifier = [modifier stringByAppendingString:@" "];
	}
	return [NSString stringWithFormat:@"%@%d %@ %@", modifier, number, measure, direction];
}

- (NSString *)stringDateWeek
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSInteger unitFlags = NSYearCalendarUnit |
			NSMonthCalendarUnit |
			NSDayCalendarUnit |
			NSWeekdayCalendarUnit |
			NSHourCalendarUnit |
			NSMinuteCalendarUnit |
			NSSecondCalendarUnit;
	NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
	int week = [comps weekday];
	NSString *strWeek = nil;
	bool isNormal = NO;
	switch (week) {
		case 1:
			strWeek = isNormal ? @"星期天" : @"周日";
			break;
		case 2:
			strWeek = isNormal ? @"星期一" : @"周一";
			break;
		case 3:
			strWeek = isNormal ? @"星期二" : @"周二";
			break;
		case 4:
			strWeek = isNormal ? @"星期三" : @"周三";
			break;
		case 5:
			strWeek = isNormal ? @"星期四" : @"周四";
			break;
		case 6:
			strWeek = isNormal ? @"星期五" : @"周五";
			break;
		case 7:
			strWeek = isNormal ? @"星期六" : @"周六";
			break;
		default:
			break;
	}

	return strWeek;

}
//农历转换函数
-(NSString *)LunarForSolar
{
	//天干名称
	NSArray *cTianGan = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸", nil];

	//地支名称
	NSArray *cDiZhi = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];

	//属相名称
	NSArray *cShuXiang = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];

	//农历日期名
	NSArray *cDayName = [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
												  @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
												  @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];

	//农历月份名
	NSArray *cMonName = [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];

	//公历每月前面的天数
	const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};

	//农历数据
	const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
			,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
			,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
			,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
			,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
			,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
			,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
			,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
			,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
			,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};

	static int wCurYear,wCurMonth,wCurDay;
	static int nTheDate,nIsEnd,m,k,n,i,nBit;

	//取当前公历年、月、日
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
	wCurYear = [components year];
	wCurMonth = [components month];
	wCurDay = [components day];

	//计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
	nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
	if((!(wCurYear % 4)) && (wCurMonth > 2))
		nTheDate = nTheDate + 1;

	//计算农历天干、地支、月、日
	nIsEnd = 0;
	m = 0;
	while(nIsEnd != 1)
	{
		if(wNongliData[m] < 4095)
			k = 11;
		else
			k = 12;
		n = k;
		while(n>=0)
		{
			//获取wNongliData(m)的第n个二进制位的值
			nBit = wNongliData[m];
			for(i=1;i<n+1;i++)
				nBit = nBit/2;

			nBit = nBit % 2;

			if (nTheDate <= (29 + nBit))
			{
				nIsEnd = 1;
				break;
			}

			nTheDate = nTheDate - 29 - nBit;
			n = n - 1;
		}
		if(nIsEnd)
			break;
		m = m + 1;
	}
	wCurYear = 1921 + m;
	wCurMonth = k - n + 1;
	wCurDay = nTheDate;
	if (k == 12)
	{
		if (wCurMonth == wNongliData[m] / 65536 + 1)
			wCurMonth = 1 - wCurMonth;
		else if (wCurMonth > wNongliData[m] / 65536 + 1)
			wCurMonth = wCurMonth - 1;
	}

	//生成农历天干、地支、属相
	NSString *szShuXiang = (NSString *)[cShuXiang objectAtIndex:((wCurYear - 4) % 60) % 12];
	NSString *szNongli = [NSString stringWithFormat:@"%@(%@%@)年",szShuXiang, (NSString *)[cTianGan objectAtIndex:((wCurYear - 4) % 60) % 10],(NSString *)[cDiZhi objectAtIndex:((wCurYear - 4) % 60) % 12]];

	//生成农历月、日
	NSString *szNongliDay;
	if (wCurMonth < 1){
//        szNongliDay = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
		szNongliDay = [NSString stringWithFormat:@"%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];

	}
	else{
		szNongliDay = (NSString *)[cMonName objectAtIndex:wCurMonth];
	}

//    NSString *lunarDate = [NSString stringWithFormat:@"%@ %@月 %@",szNongli,szNongliDay,(NSString *)[cDayName objectAtIndex:wCurDay]];

	NSString *lunarDate = [NSString stringWithFormat:@"%@月 %@",szNongliDay,(NSString *)[cDayName objectAtIndex:wCurDay]];


	return lunarDate;
}


#pragma mark Relative Dates

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
	return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
	return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *) dateTomorrow
{
	return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
	return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

#pragma mark Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return ((components1.year == components2.year) &&
			(components1.month == components2.month) && 
			(components1.day == components2.day));
}

- (BOOL) isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if (components1.week != components2.week) return NO;
	
	// Must have a time interval under 1 week. Thanks @aclark
	return (abs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
	return (components1.year == components2.year);
}

- (BOOL) isThisYear
{
    // Thanks, baspellis
	return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return (components1.year == (components2.year + 1));
}

- (BOOL) isLastYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return (components1.year == (components2.year - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}


#pragma mark Roles
- (BOOL) isTypicallyWeekend
{
    NSDateComponents *components = [CURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL) isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}

#pragma mark Adjusting Dates

- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
	return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
	return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;			
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
	return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) dateAtStartOfDay
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	components.hour = 0;
	components.minute = 0;
	components.second = 0;
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
	NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_DAY);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
// 用 anotherDate - self
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:self toDate:anotherDate options:0];
    return components.day;
}

- (NSInteger)distanceInActualDaysToDate:(NSDate *)anotherDate {
	if (  anotherDate == nil || ![anotherDate isKindOfClass:[NSDate class]]) {
		return 0;
	}

	int diffDays             = [self distanceInDaysToDate:anotherDate];//相差的天数,antherDate - self
	NSTimeInterval diffTime  = fabs((fabs(self.timeIntervalSince1970 - anotherDate.timeIntervalSince1970)) - fabs(diffDays)*24*3600);//差值 一天之内的
	NSDate *smallDate = self;//两者小的日期
	if (self.timeIntervalSince1970 - anotherDate.timeIntervalSince1970 > 0) {
		smallDate = anotherDate;
	}
	NSInteger smallDay      = [[smallDate formatStringWithFormat:@"dd"] intValue];

	//先计算天数
	int laveCounts = fabs(diffTime);
	int days = laveCounts/(60*60*24);
	laveCounts = laveCounts - days*(60*60*24);
	//计算小时
	int hours = laveCounts/(60*60);
	laveCounts = laveCounts - hours*(60*60);
	//计算分钟
	int minutes = laveCounts/60;
	laveCounts = laveCounts - minutes*60;
	//剩余未秒数
	int second = laveCounts;
	NSTimeInterval interval = hours * 3600 + minutes*60 + second;

	NSDate *smallDiffDate   = [[NSDate alloc] initWithTimeIntervalSince1970:(interval+smallDate.timeIntervalSince1970)];
	int     smallDiffDay    = [[smallDiffDate formatStringWithFormat:@"dd"] intValue];

	if (smallDay != smallDiffDay) {
		diffDays = (abs(diffDays)+1);
	} else {
		diffDays = abs(diffDays);
	}
	return (anotherDate.timeIntervalSince1970 - self.timeIntervalSince1970 > 0 ) ? diffDays : -diffDays;
}


#pragma mark Decomposing Dates

- (NSInteger) nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return components.hour;
}

- (NSInteger) hour
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.hour;
}

- (NSInteger) minute
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.minute;
}

- (NSInteger) seconds
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.second;
}

- (NSInteger) day
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.day;
}

- (NSInteger) month
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.month;
}

- (NSInteger) week
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.week;
}

- (NSInteger) weekday
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekday;
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekdayOrdinal;
}

- (NSInteger) year
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.year;
}

+ (NSDictionary *)daysInEachMonth
{
    NSDate *toDay = [NSDate date];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    NSMutableDictionary *daysInEachMonth = [NSMutableDictionary dictionary];
    for (int i = 1; i <= 12; i++) {
        
        comp.year = toDay.year;
        comp.month  = i;
        NSDate *preDate = [c dateFromComponents:comp];
        
        NSRange range = [c rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:preDate];
        //        NSLog(@"range:%@",NSStringFromRange(range));
        
        [daysInEachMonth setValue:@(range.length) forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    return (NSDictionary *)daysInEachMonth;
}

+ (NSUInteger)daysInYear
{
    NSDictionary *daysInEachMonth = [NSDate daysInEachMonth];
    NSUInteger allDaysInYear = 0;
    for (NSString *key in daysInEachMonth) {
        
        NSInteger days = [[daysInEachMonth objectForKey:key] integerValue];
        allDaysInYear += days;
    }
    
    return allDaysInYear;
}
@end
