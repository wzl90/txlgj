//
//  OICalendarUtil.mm
//  本文件使用了C++混编，所以扩展名为.mm
//
//  Copyright (c) 2011年 www.octinn.com. All rights reserved.
//

#import "OICalendarUtil.h"
#import "SolarDate.h"
#import "ChineseDate.h"
//五行名称
static NSArray *wuXing = @[@"金",@"水",@"木",@"火",@"土",@"金",@"水"];
//纳音名称
static NSArray *naYin = @[@"海中金",@"炉中火",@"大林木",@"路旁土",@"剑锋金",@"山头火",@"洞下水",@"城墙土",@"白腊金",@"杨柳木",@"泉中水",@"屋上土",@"霹雷火",@"松柏木",@"常流水",@"沙中金",@"山下火",@"平地木",@"壁上土",@"金箔金",@"佛灯火",@"天河水",@"大驿土",@"钗钏金",@"桑松木",@"大溪水",@"沙中土",@"天上火",@"石榴木",@"大海水"];
//天干名称
static NSArray *tianGan = @[@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸"];
//地支名称
static NSArray *diZhi = @[@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥"];
//农历年份
static NSArray *luanrYears = @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];
//农历月份
static NSArray *lunarMonths = @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月"];
//农历日期
static NSArray * lunarDays = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",@"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
//节气名称
static NSArray *jieqiArray = @[@"小寒", @"大寒", @"立春", @"雨水", @"惊蛰", @"春分", @"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至", @"小暑", @"大暑", @"立秋", @"处暑", @"白露", @"秋分", @"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至"];
//属相名称
static NSArray *shuXiang = @[@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪"];
//星期
static NSArray *weekdays = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
//星座名称
static NSArray *starArray = @[@"摩羯座",@"水瓶座",@"双鱼座",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座"];
//公历节日
static NSDictionary *solarFV = [[NSDictionary alloc]initWithObjectsAndKeys:@"元旦",@"0101",@"情人节",@"0214",@"妇女节",@"0308",@"植树节",@"0312",@"愚人节",@"0401",@"劳动节",@"0501",@"青年节",@"0504",@"护士节",@"0512",@"儿童节",@"0601",@"教师节",@"0910",@"国庆节",@"1001",@"万圣节",@"1101",@"平安夜",@"1224",@"圣诞节",@"1225", nil];
//农历节日
static NSDictionary *lunarFV = [[NSDictionary alloc]initWithObjectsAndKeys:@"春节",@"0101",@"元宵节",@"0115",@"端午节",@"0505",@"七夕节",@"0707",@"中元节",@"0715",@"中秋节",@"0815",@"重阳节",@"0909",@"腊八节",@"1208",@"小年",@"1223", nil];
//周几节日
static NSDictionary *weekFV = [[NSDictionary alloc]initWithObjectsAndKeys:@"母亲节",@"0520",@"父亲节",@"0630",@"感恩节",@"1144", nil];

static NSCalendar *calendar = nil;



@implementation OICalendarUtil

+ (NSCalendar*)currentCalendar
{
    if(!calendar)
    {
        calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setLocale:[NSLocale systemLocale]];
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        [calendar setMinimumDaysInFirstWeek:7];
    }
    return calendar;
}

+ (void)resetCalendarTimeZone
{
    if(calendar)
    {
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    }
}

+ (NSDateComponents *)toSolarDateWithYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day
{
    ChineseDate chineseDate=ChineseDate((int)_year, (int)[OICalendarUtil monthFromMineToCppWithYear:_year month:_month], (int)_day);
    SolarDate solarDate=chineseDate.ToSolarDate();
    NSDateComponents *dc=[[NSDateComponents alloc]init];
    dc.year=solarDate.GetYear();
    dc.month=solarDate.GetMonth();
    dc.day=solarDate.GetDay();
    return dc;
}

+ (NSDateComponents *)toChineseDateWithYear:(NSUInteger)_year month:(NSUInteger)_month day:(NSUInteger)_day
{
    SolarDate solarDate=SolarDate((int)_year, (int)_month, (int)_day);
    ChineseDate chineseDate;
    solarDate.ToChineseDate(chineseDate);
    NSDateComponents *dc=[[NSDateComponents alloc]init];
    dc.year=chineseDate.GetYear();
    dc.month=chineseDate.GetMonth();
    int run=ChineseCalendarDB::GetLeapMonth(chineseDate.GetYear());
    if(run!=0)
    {
        if (chineseDate.GetMonth()==run+1) {
            dc.month=1-chineseDate.GetMonth();
        } else if(chineseDate.GetMonth()<=run) {
            dc.month=chineseDate.GetMonth();
        } else {
            dc.month=chineseDate.GetMonth()-1;
        }
    }
    dc.day=chineseDate.GetDay();
    return dc;
}

+ (int)weekDayWithSolarYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day {
    SolarDate solarDate=SolarDate((int)_year, (int)_month, (int)_day);
    return solarDate.ToWeek();
}

+ (int)weekDayWithChineseYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day {
    NSDateComponents *dc=[OICalendarUtil toSolarDateWithYear:_year month:_month day:_day];
    return [OICalendarUtil weekDayWithSolarYear:dc.year month:dc.month day:dc.day];
}

+ (NSString *)weekdayString:(NSUInteger)_weekday
{
    return [weekdays objectAtIndex:_weekday];
}

+ (NSUInteger)monthFromMineToCppWithYear:(NSUInteger)_year month:(NSInteger)_month
{
    int runMonth=ChineseCalendarDB::GetLeapMonth((int)_year);
    int month_=(int)_month;
    if(month_<0)
    {
        month_ = abs(month_)+1;
    }
    else {
        if(runMonth!=0&&month_>runMonth)
            month_ = month_+1;
    }
    return month_;
}

+ (NSNumber *)monthFromCppToMineWithYear:(NSUInteger)_year month:(NSUInteger)_month
{
    int run=ChineseCalendarDB::GetLeapMonth((int)_year);
    if (run==0) {
        return [NSNumber numberWithInt:(int)_month];
    } else {
        if (_month==run+1) {
            return [NSNumber numberWithInt:1-(int)_month];//存储为负数
        } else if(_month<=run) {
            return [NSNumber numberWithInt:(int)_month];
        } else {
            return [NSNumber numberWithInt:(int)_month-1];
        }
    }
}

+ (NSString *)animalWithYear:(NSUInteger)_year
{
    std::pair<int, int> p=ChineseCalendarDB::GetEraAndYearOfLunar((int)_year);
    int jiazi=p.second-1;

    return [shuXiang objectAtIndex:jiazi%12];
}

+ (NSString*)animalWithChineseYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day lichun:(BOOL)_lichun
{
    if(_lichun)
    {
        NSDateComponents *dc=[OICalendarUtil toSolarDateWithYear:_year month:_month day:_day];
        return [OICalendarUtil animalWithSolarYear:dc.year month:dc.month day:dc.day lichun:_lichun];
    }
    return [OICalendarUtil animalWithYear:_year];
}

+ (NSString*)animalWithSolarYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day lichun:(BOOL)_lichun
{
    if(_lichun)
    {
        int birthYear = (int)_year;
        
        if(_month==2)
        {
            int dayOfLiChun = ChineseCalendarDB::GetSolarTerm((int)_year,3);//立春是公历年份第三个节气
            if(_day<dayOfLiChun)
            {
                birthYear--;
            }
        }
        else if(_month<2)
        {
            birthYear --;
        }
        return [OICalendarUtil animalWithYear:birthYear];
    }
    NSDateComponents *dc = [OICalendarUtil toChineseDateWithYear:_year month:_month day:_day];
    return [OICalendarUtil animalWithYear:dc.year];
}

+ (void)jiaziWithYear:(NSUInteger)_year outEra:(int *)era outJiazi:(int *)jiazi
{
    std::pair<int, int> p=ChineseCalendarDB::GetEraAndYearOfLunar((int)_year);
    *era=p.first;
    *jiazi=p.second;
}

+ (NSString *)jiaziStringWithYear:(NSUInteger)_year
{
    std::pair<int, int> p=ChineseCalendarDB::GetEraAndYearOfLunar((int)_year);
    int jiazi=p.second-1;
   
    return [NSString stringWithFormat:@"%@%@",[tianGan objectAtIndex:jiazi % 10],[diZhi objectAtIndex:jiazi % 12]];
}

+ (NSString *)lunarMonthString:(NSInteger)_month
{
    if(_month<0)
    {
        return [NSString stringWithFormat:@"闰%@",[lunarMonths objectAtIndex:abs((int)_month) - 1]];
    }
    return [lunarMonths objectAtIndex:abs((int)_month - 1)%12];
}

+ (NSString *)lunarDayString:(NSUInteger)_day
{
    return [lunarDays objectAtIndex:(_day-1)%30];
}

+ (NSString*)jieqiWithSolarYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day
{
    BOOL find = NO;
    int index = (int)_month*2-1;
    if(_day==ChineseCalendarDB::GetSolarTerm((int)_year, index))
    {
        find = YES;
    }
    else 
    {
        index++;
        if(_day==ChineseCalendarDB::GetSolarTerm((int)_year, index))
        {
            find = YES;
        }
    }
    if(find)
        return [jieqiArray objectAtIndex:index-1];

    return nil;
}

+ (NSString *)jieqiWithChineseYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day
{
    NSDateComponents *dc=[OICalendarUtil toSolarDateWithYear:_year month:_month day:_day];
    return [OICalendarUtil jieqiWithSolarYear:dc.year month:dc.month day:dc.day];
}

+ (NSUInteger)jieqiDayWithYear:(NSUInteger)_year index:(NSUInteger)_index
{
    return ChineseCalendarDB::GetSolarTerm((int)_year, (int)_index);
}

+ (NSString*)solarFVWithMonth:(NSUInteger)_month day:(NSUInteger)_day
{
    return [solarFV objectForKey:[NSString stringWithFormat:@"%02d%02d",(int)_month,(int)_day]];
}

+ (NSString*)lunarFVWithYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day
{
    ChineseDate chinesDate = ChineseDate((int)_year, (int)[OICalendarUtil monthFromMineToCppWithYear:_year month:_month], (int)_day);
    
    if(chinesDate.YearDay()==ChineseCalendarDB::GetYearDays((int)_year))
        return @"除夕";
    return [lunarFV objectForKey:[NSString stringWithFormat:@"%02d%02d",(int)_month,(int)_day]];
}

+ (NSString*)weekFVWithYear:(NSUInteger)_year month:(NSUInteger)_month day:(NSUInteger)_day
{
    SolarDate solarDate=SolarDate((int)_year, (int)_month, (int)_day);
    int weekday = solarDate.ToWeek();
    int weekIndex = (int)_day / 7 + ((int)_day % 7 > 0 ? 1 : 0);
    return [weekFV objectForKey:[NSString stringWithFormat:@"%02d%d%d",(int)_month,weekIndex,weekday]];
}

+ (NSString*)toChineseString:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day
{
    std::pair<int, int> p=ChineseCalendarDB::GetEraAndYearOfLunar((int)_year);
    int jiazi=p.second-1;
    NSString *yearString = [NSString stringWithFormat:@"%@%@年",[tianGan objectAtIndex:jiazi % 10],[diZhi objectAtIndex:jiazi % 12]];
    NSString *monthString = [OICalendarUtil lunarMonthString:_month];
    return [NSString stringWithFormat:@"%@%@%@",yearString,monthString,[lunarDays objectAtIndex:(_day-1)%30]];
}

+ (NSString*)toChineseStringWithNumber:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day
{
//    std::pair<int, int> p=ChineseCalendarDB::GetEraAndYearOfLunar(_year);
//    int jiazi=p.second-1;
    
    int year = (int)_year;
    int year1 = year/1000;      year = year%1000;
    int year2 = year/100;       year = year%100;
    int year3 = year/10;        year = year%10;
    int year4 = year;
    
    NSString *year1Chinese = [luanrYears objectAtIndex:year1];
    NSString *year2Chinese = [luanrYears objectAtIndex:year2];
    NSString *year3Chinese = [luanrYears objectAtIndex:year3];
    NSString *year4Chinese = [luanrYears objectAtIndex:year4];
    
//    NSString *yearString = [NSString stringWithFormat:@"%@%@%@%@(%@%@)年", year1Chinese, year2Chinese, year3Chinese, year4Chinese,[tianGan objectAtIndex:jiazi % 10],[diZhi objectAtIndex:jiazi % 12]];
    NSString *yearString = [NSString stringWithFormat:@"%@%@%@%@年", year1Chinese, year2Chinese, year3Chinese, year4Chinese];
    NSString *monthString = [OICalendarUtil lunarMonthString:_month];
    return [NSString stringWithFormat:@"%@%@%@",yearString,monthString,[lunarDays objectAtIndex:(_day-1)%30]];
}

+ (NSDate *)countBirthdayAfterYears:(NSInteger)years forBirthday:(NSInteger)_month day:(NSUInteger)_day isLunar:(BOOL)isLunar specialOn:(BOOL)_special
{
    if(_month==0||_day==0)
        return [NSDate date];
    NSCalendar *cal=[OICalendarUtil currentCalendar];
    //设置当前时间的相关字段
    NSDate 	*currentDate = [NSDate date];
    NSDateComponents *dc = nil;
    dc = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
    dc.year = dc.year + years;
    
    //考虑到闰月的问题，如近期碰到的闰四月问题，平四月的生日过去之后，闰四月的生日计算
    //分为今年和明年的生日，今年的生日需要考虑平月生日刚过并且闰月生日还没过的问题。明年的生日只用算平月。
    //不过都要注意在此农历算法中，有闰月的年份，闰月之后的月份数是需要+1的。
    int month = abs((int)_month);
    if(isLunar)
    {
        SolarDate solarDate=SolarDate((int)dc.year, (int)dc.month, (int)dc.day);
        ChineseDate chineseDate;
        
        int bMonth = month;//需要计算的这一年有闰月，闰月之后的月份数需要+1
        //从公历对象转为农历对象
        solarDate.ToChineseDate(chineseDate);
        int year = chineseDate.GetYear();
        
        int run=ChineseCalendarDB::GetLeapMonth(year);
        if (run!=0)
        {
            if(month>run)
                bMonth = month+1;
        }
        //写出今年的农历生日
        ChineseDate nextChinesDate = ChineseDate(year,bMonth,(int)_day);
        //如果和今天的农历是同一天，那不用判断日期是否有效，直接返回今天
        if(chineseDate==nextChinesDate)
            return [cal dateFromComponents:dc];
        else if(chineseDate.IsPrior(nextChinesDate))
        {
            //如果今天在生日之前并且是一个有效的农历日期，那么返回此农历日期的公历
            if(nextChinesDate.IsValidDate())
            {
                SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
                [dc setYear:nextSolarDate.GetYear()];
                [dc setMonth:nextSolarDate.GetMonth()];
                [dc setDay:nextSolarDate.GetDay()];
                return [cal dateFromComponents:dc];
            }
            if(_special)
            {
                nextChinesDate = ChineseDate(year,bMonth,(int)_day-1);
                SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
                [dc setYear:nextSolarDate.GetYear()];
                [dc setMonth:nextSolarDate.GetMonth()];
                [dc setDay:nextSolarDate.GetDay()];
                return [cal dateFromComponents:dc];
            }
        }
        //上一步若没有返回，则说明之前写出的农历日期已经过了，或者没有过但无效（如30号的生日，刚好今年的这个月份没有30号）
        //如果生日的月份在今年有闰月，那么再判断一下闰月的生日有没有过掉
        /*2014.10.20
         农历生日只过平月的。除非是生日本身是闰月，并且当年有闰月。这种情况当年会提醒两个农历生日。
         */
        if (month==run&&_month<0)
        {
            nextChinesDate = ChineseDate(year,month+1,(int)_day);
            if(chineseDate==nextChinesDate)
                return [cal dateFromComponents:dc];
            else if(chineseDate.IsPrior(nextChinesDate))
            {
                if(nextChinesDate.IsValidDate())
                {
                    SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
                    [dc setYear:nextSolarDate.GetYear()];
                    [dc setMonth:nextSolarDate.GetMonth()];
                    [dc setDay:nextSolarDate.GetDay()];
                    return [cal dateFromComponents:dc];
                }
                if(_special)//如果本身是闰月，可以按照特殊生日的条件来提前一天过
                {
                    nextChinesDate = ChineseDate(year,month+1,(int)_day-1);
                    SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
                    [dc setYear:nextSolarDate.GetYear()];
                    [dc setMonth:nextSolarDate.GetMonth()];
                    [dc setDay:nextSolarDate.GetDay()];
                    return [cal dateFromComponents:dc];
                }
            }
        }
        //如果今年的生日确实已经过了，那就走下面这步吧。
        while (year<2050) {
            bMonth = month;
            run=ChineseCalendarDB::GetLeapMonth(++year);
            if (run!=0)
            {
                if(month>run)
                    bMonth = month+1;
            }
            nextChinesDate = ChineseDate(year,bMonth,(int)_day);
            if(nextChinesDate.IsValidDate())
                break;
            if(_special)
            {
                nextChinesDate = ChineseDate(year,bMonth,(int)_day-1);
                break;
            }
            //农历生日为30号，平月没有30号，而闰月却有30号的情况
            //例如2017年的农历6月，平六月只有29天，闰六月有30天，若在2016年12月计算下个农历六月三十号生日，则应该得出2017年的闰六月三十号
            if(month==run)
            {
                nextChinesDate = ChineseDate(year,month+1,(int)_day);
                if(nextChinesDate.IsValidDate())
                    break;
                /*
                 进入此处已经说明：
                 1.今年的生日已经过掉
                 2.生日为农历30号
                 3.该年的平月无30号，且用户未开启特殊生日。
                 由此得出结论，下面的代码无效。
                 */
                //                if(_special)
                //                {
                //                    nextChinesDate = ChineseDate(year,month+1,_day-1);
                //                    break;
                //                }
            }
        }
        SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
        [dc setYear:nextSolarDate.GetYear()];
        [dc setMonth:nextSolarDate.GetMonth()];
        [dc setDay:nextSolarDate.GetDay()];
    }
    else
    {
        int year = (int)dc.year;
        int day = (int)_day;
        if(dc.month>month||(dc.month==month&&dc.day>_day))
        {
            year++;
        }
        while (TRUE&&year<2050) {
            SolarDate nextDate = SolarDate(year,month,(int)_day);
            //考虑2月29日的情况
            if(nextDate.IsValidDate())
                break;
            else if(_special)
            {
                day--;
                break;
            }
            year++;
        }
        [dc setYear:year];
        [dc setMonth:month];
        [dc setDay:day];
    }
    return [cal dateFromComponents:dc];
}

+ (NSDate*)nextBirthday:(NSInteger)_month day:(NSUInteger)_day isLunar:(BOOL)isLunar specialOn:(BOOL)_special
{
    if(_month==0||_day==0)
        return [NSDate date];
    NSCalendar *cal=[OICalendarUtil currentCalendar];
    //设置当前时间的相关字段
    NSDate 	*currentDate = [NSDate date];
    NSDateComponents *dc = nil;
    dc = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
    
    //考虑到闰月的问题，如近期碰到的闰四月问题，平四月的生日过去之后，闰四月的生日计算
    //分为今年和明年的生日，今年的生日需要考虑平月生日刚过并且闰月生日还没过的问题。明年的生日只用算平月。
    //不过都要注意在此农历算法中，有闰月的年份，闰月之后的月份数是需要+1的。
    int month = abs((int)_month);
    if(isLunar)
    {
        SolarDate solarDate=SolarDate((int)dc.year, (int)dc.month, (int)dc.day);
        ChineseDate chineseDate;
        
        int bMonth = month;//需要计算的这一年有闰月，闰月之后的月份数需要+1
        //从公历对象转为农历对象
        solarDate.ToChineseDate(chineseDate);
        int year = chineseDate.GetYear();
        
        int run=ChineseCalendarDB::GetLeapMonth(year);
        if (run!=0) 
        {
            if(month>run)
                bMonth = month+1;
        }
        //写出今年的农历生日
        ChineseDate nextChinesDate = ChineseDate(year,bMonth,(int)_day);
        //如果和今天的农历是同一天，那不用判断日期是否有效，直接返回今天
        if(chineseDate==nextChinesDate)
            return [cal dateFromComponents:dc];
        else if(chineseDate.IsPrior(nextChinesDate))
        {
            //如果今天在生日之前并且是一个有效的农历日期，那么返回此农历日期的公历
            if(nextChinesDate.IsValidDate())
            {
                SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
                [dc setYear:nextSolarDate.GetYear()];
                [dc setMonth:nextSolarDate.GetMonth()];
                [dc setDay:nextSolarDate.GetDay()];
                return [cal dateFromComponents:dc];
            }
            if(_special)
            {
                nextChinesDate = ChineseDate(year,bMonth,(int)_day-1);
                SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
                [dc setYear:nextSolarDate.GetYear()];
                [dc setMonth:nextSolarDate.GetMonth()];
                [dc setDay:nextSolarDate.GetDay()];
                return [cal dateFromComponents:dc];
            }
        }
        //上一步若没有返回，则说明之前写出的农历日期已经过了，或者没有过但无效（如30号的生日，刚好今年的这个月份没有30号）
        //如果生日的月份在今年有闰月，那么再判断一下闰月的生日有没有过掉
        /*2014.10.20
         农历生日只过平月的。除非是生日本身是闰月，并且当年有闰月。这种情况当年会提醒两个农历生日。
         */
        if (month==run&&_month<0)
        {
            nextChinesDate = ChineseDate(year,month+1,(int)_day);
            if(chineseDate==nextChinesDate)
                return [cal dateFromComponents:dc];
            else if(chineseDate.IsPrior(nextChinesDate))
            {
                if(nextChinesDate.IsValidDate())
                {
                    SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
                    [dc setYear:nextSolarDate.GetYear()];
                    [dc setMonth:nextSolarDate.GetMonth()];
                    [dc setDay:nextSolarDate.GetDay()];
                    return [cal dateFromComponents:dc];
                }
                if(_special)//如果本身是闰月，可以按照特殊生日的条件来提前一天过
                {
                    nextChinesDate = ChineseDate(year,month+1,(int)_day-1);
                    SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
                    [dc setYear:nextSolarDate.GetYear()];
                    [dc setMonth:nextSolarDate.GetMonth()];
                    [dc setDay:nextSolarDate.GetDay()];
                    return [cal dateFromComponents:dc];
                }
            }
        }
        //如果今年的生日确实已经过了，那就走下面这步吧。
        while (year<2050) {
            bMonth = month;
            run=ChineseCalendarDB::GetLeapMonth(++year);
            if (run!=0) 
            {
                if(month>run)
                    bMonth = month+1;
            }
            nextChinesDate = ChineseDate(year,bMonth,(int)_day);
            if(nextChinesDate.IsValidDate())
                break;
            if(_special)
            {
                nextChinesDate = ChineseDate(year,bMonth,(int)_day-1);
                break;
            }
            //农历生日为30号，平月没有30号，而闰月却有30号的情况
            //例如2017年的农历6月，平六月只有29天，闰六月有30天，若在2016年12月计算下个农历六月三十号生日，则应该得出2017年的闰六月三十号
            if(month==run)
            {
                nextChinesDate = ChineseDate(year,month+1,(int)_day);
                if(nextChinesDate.IsValidDate())
                    break;
                /*
                 进入此处已经说明：
                 1.今年的生日已经过掉
                 2.生日为农历30号
                 3.该年的平月无30号，且用户未开启特殊生日。
                 由此得出结论，下面的代码无效。
                 */
//                if(_special)
//                {
//                    nextChinesDate = ChineseDate(year,month+1,_day-1);
//                    break;
//                }
            }
        }
        SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
        [dc setYear:nextSolarDate.GetYear()];
        [dc setMonth:nextSolarDate.GetMonth()];
        [dc setDay:nextSolarDate.GetDay()];
    }
    else 
    {
        int year = (int)dc.year;
        int day = (int)_day;
        if(dc.month>month||(dc.month==month&&dc.day>_day))
        {
            year++;
        }
        while (TRUE&&year<2050) {
            SolarDate nextDate = SolarDate(year,month,(int)_day);
            //考虑2月29日的情况
            if(nextDate.IsValidDate())
                break;
            else if(_special)
            {
                day--;
                break;
            }
            year++;
        }
        [dc setYear:year];
        [dc setMonth:month];
        [dc setDay:day];
    }
    return [cal dateFromComponents:dc];
}

+ (NSDate*)nextBirthdayWithBaseDate:(NSDate *)baseDate month:(NSInteger)_month day:(NSUInteger)_day isLunar:(BOOL)isLunar specialOn:(BOOL)_special
{
    if(_month==0||_day==0)
        return [NSDate date];
    NSCalendar *cal=[OICalendarUtil currentCalendar];
    //设置当前时间的相关字段
    NSDate 	*currentDate = baseDate;
    NSDateComponents *dc = nil;
    dc = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
    
    //考虑到闰月的问题，如近期碰到的闰四月问题，平四月的生日过去之后，闰四月的生日计算
    //分为今年和明年的生日，今年的生日需要考虑平月生日刚过并且闰月生日还没过的问题。明年的生日只用算平月。
    //不过都要注意在此农历算法中，有闰月的年份，闰月之后的月份数是需要+1的。
    int month = abs((int)_month);
    if(isLunar)
    {
        SolarDate solarDate=SolarDate((int)dc.year, (int)dc.month, (int)dc.day);
        ChineseDate chineseDate;
        
        int bMonth = month;//需要计算的这一年有闰月，闰月之后的月份数需要+1
        //从公历对象转为农历对象
        solarDate.ToChineseDate(chineseDate);
        int year = chineseDate.GetYear();
        
        int run=ChineseCalendarDB::GetLeapMonth(year);
        if (run!=0)
        {
            if(month>run)
                bMonth = month+1;
        }
        //写出今年的农历生日
        ChineseDate nextChinesDate = ChineseDate(year,bMonth,(int)_day);
        //如果和今天的农历是同一天，那不用判断日期是否有效，直接返回今天
        if(chineseDate==nextChinesDate)
            return [cal dateFromComponents:dc];
        else if(chineseDate.IsPrior(nextChinesDate))
        {
            //如果今天在生日之前并且是一个有效的农历日期，那么返回此农历日期的公历
            if(nextChinesDate.IsValidDate())
            {
                SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
                [dc setYear:nextSolarDate.GetYear()];
                [dc setMonth:nextSolarDate.GetMonth()];
                [dc setDay:nextSolarDate.GetDay()];
                return [cal dateFromComponents:dc];
            }
            if(_special)
            {
                nextChinesDate = ChineseDate(year,bMonth,(int)_day-1);
                SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
                [dc setYear:nextSolarDate.GetYear()];
                [dc setMonth:nextSolarDate.GetMonth()];
                [dc setDay:nextSolarDate.GetDay()];
                return [cal dateFromComponents:dc];
            }
        }
        //上一步若没有返回，则说明之前写出的农历日期已经过了，或者没有过但无效（如30号的生日，刚好今年的这个月份没有30号）
        //如果生日的月份在今年有闰月，那么再判断一下闰月的生日有没有过掉
        /*2014.10.20
         农历生日只过平月的。除非是生日本身是闰月，并且当年有闰月。这种情况当年会提醒两个农历生日。
         */
        if (month==run&&_month<0)
        {
            nextChinesDate = ChineseDate(year,month+1,(int)_day);
            if(chineseDate==nextChinesDate)
                return [cal dateFromComponents:dc];
            else if(chineseDate.IsPrior(nextChinesDate))
            {
                if(nextChinesDate.IsValidDate())
                {
                    SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
                    [dc setYear:nextSolarDate.GetYear()];
                    [dc setMonth:nextSolarDate.GetMonth()];
                    [dc setDay:nextSolarDate.GetDay()];
                    return [cal dateFromComponents:dc];
                }
                if(_special)//如果本身是闰月，可以按照特殊生日的条件来提前一天过
                {
                    nextChinesDate = ChineseDate(year,month+1,(int)_day-1);
                    SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
                    [dc setYear:nextSolarDate.GetYear()];
                    [dc setMonth:nextSolarDate.GetMonth()];
                    [dc setDay:nextSolarDate.GetDay()];
                    return [cal dateFromComponents:dc];
                }
            }
        }
        //如果今年的生日确实已经过了，那就走下面这步吧。
        while (year<2050) {
            bMonth = month;
            run=ChineseCalendarDB::GetLeapMonth(++year);
            if (run!=0)
            {
                if(month>run)
                    bMonth = month+1;
            }
            nextChinesDate = ChineseDate(year,bMonth,(int)_day);
            if(nextChinesDate.IsValidDate())
                break;
            if(_special)
            {
                nextChinesDate = ChineseDate(year,bMonth,(int)_day-1);
                break;
            }
            //农历生日为30号，平月没有30号，而闰月却有30号的情况
            //例如2017年的农历6月，平六月只有29天，闰六月有30天，若在2016年12月计算下个农历六月三十号生日，则应该得出2017年的闰六月三十号
            if(month==run)
            {
                nextChinesDate = ChineseDate(year,month+1,(int)_day);
                if(nextChinesDate.IsValidDate())
                    break;
                /*
                 进入此处已经说明：
                 1.今年的生日已经过掉
                 2.生日为农历30号
                 3.该年的平月无30号，且用户未开启特殊生日。
                 由此得出结论，下面的代码无效。
                 */
                //                if(_special)
                //                {
                //                    nextChinesDate = ChineseDate(year,month+1,_day-1);
                //                    break;
                //                }
            }
        }
        SolarDate nextSolarDate = nextChinesDate.ToSolarDate();
        [dc setYear:nextSolarDate.GetYear()];
        [dc setMonth:nextSolarDate.GetMonth()];
        [dc setDay:nextSolarDate.GetDay()];
    }
    else
    {
        int year = (int)dc.year;
        int day = (int)_day;
        if(dc.month>month||(dc.month==month&&dc.day>_day))
        {
            year++;
        }
        while (TRUE&&year<2050) {
            SolarDate nextDate = SolarDate(year,month,(int)_day);
            //考虑2月29日的情况
            if(nextDate.IsValidDate())
                break;
            else if(_special)
            {
                day--;
                break;
            }
            year++;
        }
        [dc setYear:year];
        [dc setMonth:month];
        [dc setDay:day];
    }
    return [cal dateFromComponents:dc];
}

+ (BOOL)isSpecial:(NSInteger)_month day:(NSUInteger)_day isLunar:(BOOL)isLunar
{
    if(isLunar)
    {
        if(_day<30)
            return NO;
        
        NSCalendar *cal=[OICalendarUtil currentCalendar];
        
        NSDateComponents *dc = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
        
        int month = abs((int)_month);
        SolarDate solarDate=SolarDate((int)dc.year, (int)dc.month, (int)dc.day);
        ChineseDate chineseDate;
        
        int bMonth = month;//需要计算的这一年有闰月，闰月之后的月份数需要+1
        //从公历对象转为农历对象
        solarDate.ToChineseDate(chineseDate);
        int year = chineseDate.GetYear();
        
        int run=ChineseCalendarDB::GetLeapMonth(year);
        if (run!=0)
        {
            if(month>=run)
                bMonth = month+1;
        }
        if(bMonth<chineseDate.GetMonth())
        {
            year ++;
            run=ChineseCalendarDB::GetLeapMonth(year);
        }
        if(run!=0)
        {
            if(month>run)
                bMonth = month + 1;
        }
        ChineseDate nextChinesDate = ChineseDate(year,bMonth,30);
        if(nextChinesDate.IsValidDate()&&chineseDate.IsPrior(nextChinesDate))
            return NO;
        
        if(month==run)
        {
            nextChinesDate = ChineseDate(year,bMonth+1,30);
            if(nextChinesDate.IsValidDate())
                return NO;
        }
    }
    else
    {
        if(_month!=2||(_month==2&&_day<29))
            return NO;
        
        NSCalendar *cal=[OICalendarUtil currentCalendar];
        
        NSDateComponents *dc = [cal components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
        
        int year = (int)dc.year;
        if(dc.month>2)
        {
            year++;
        }
        SolarDate nextDate = SolarDate(year,2,29);
        if(nextDate.IsValidDate())
            return NO;
    }
    return YES;
}

+ (NSString*)starString:(NSInteger)_month day:(NSInteger)_day
{
    int daySep[13] = {22,20,19,21,20,21,22,23,23,23,24,23,22};//分别是12月，1月...11月，12月的星座分割日
    if(_day>=daySep[_month])
    {
        return [starArray objectAtIndex:_month];
    }
    return [starArray objectAtIndex:(_month+11)%12];
}

+ (BOOL)isLeapYear:(NSUInteger)_year
{
    return (!(_year % 4) && (_year % 100)) || !(_year % 400);
}

+ (NSUInteger)yearDay:(NSDateComponents *)_date
{
    SolarDate solarDate = SolarDate((int)_date.year,(int)_date.month,(int)_date.day);
    return solarDate.YearDay();
}

+ (NSDateComponents *)dateFromYearDay:(NSUInteger)_days year:(NSUInteger)_year
{
    SolarDate solarDate = SolarDate((int)_year,1,1);
    solarDate.FromYearDay((int)_days);
    NSDateComponents *dc=[[NSDateComponents alloc]init];
    dc.year=solarDate.GetYear();
    dc.month=solarDate.GetMonth();
    dc.day=solarDate.GetDay();
    return dc;
}

+ (NSUInteger)seasonOfDate:(NSDate *)date
{
    NSDateComponents *dc = [[OICalendarUtil currentCalendar]components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    if(dc.year<1901||dc.year>2049)
        return 0;
    int day = ChineseCalendarDB::GetSolarTerm((int)dc.year, 3);
    SolarDate solarDate = SolarDate((int)dc.year,(int)dc.month,(int)dc.day);
    SolarDate tempDate = SolarDate((int)dc.year,2,day);//立春日
    if(solarDate.IsPrior(tempDate))
        return 3;
    day = ChineseCalendarDB::GetSolarTerm((int)dc.year, 9);
    tempDate = SolarDate((int)dc.year,5,day);//立夏日
    if(solarDate.IsPrior(tempDate))
        return 0;
    day = ChineseCalendarDB::GetSolarTerm((int)dc.year, 15);
    tempDate = SolarDate((int)dc.year,8,day);//立秋日
    if(solarDate.IsPrior(tempDate))
        return 1;
    day = ChineseCalendarDB::GetSolarTerm((int)dc.year, 21);
    tempDate = SolarDate((int)dc.year,11,day);//立冬日
    if(solarDate.IsPrior(tempDate))
        return 2;
    return 3;
}

+ (NSInteger)daysFrom:(NSDateComponents *)_fromDate toDate:(NSDateComponents *)_toDate
{
    SolarDate fromDate = SolarDate((int)_fromDate.year,(int)_fromDate.month,(int)_fromDate.day);
    SolarDate toDate = SolarDate((int)_toDate.year,(int)_toDate.month,(int)_toDate.day);
    return toDate.Diff(fromDate);
}

+ (NSString*)getGanWuXing:(NSUInteger)_gan
{
    return [wuXing objectAtIndex:_gan/2+2];
}

+ (NSString*)getZhiWuXing:(NSUInteger)_zhi
{
    int z = (_zhi+5)%12;
    if(z%3==0)
        return [wuXing objectAtIndex:4];
    return [wuXing objectAtIndex:z/3];
}

+ (void)baziOfDate:(NSDate *)date ganzhi:(int *)ganzhi
{
    NSDateComponents *dc = [[OICalendarUtil currentCalendar]components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour) fromDate:date];
    int year = (int)dc.year;
    int month = (int)dc.month;
    int day = (int)dc.day;
    int hour = (int)dc.hour;
    int baziYear = year;
    if(month==2)
    {
        int dayOfLiChun = ChineseCalendarDB::GetSolarTerm(year,3);
        if(day<dayOfLiChun)
            baziYear--;
    }
    else if(month<2)
    {
        baziYear--;
    }
    int yearGan = (baziYear-4)%10;
    int yearZhi = (baziYear-4)%12;
    
    int monthGan,monthZhi;
    int termDay = ChineseCalendarDB::GetSolarTerm(year, month*2-1);
    if(day<termDay)
    {
        monthZhi = (month+11)%12;
    }
    else
    {
        monthZhi = month%12;
    }
    monthGan = monthZhi;
    if(monthZhi<2)
    {
        monthGan += 2;
    }
    else if(monthZhi>9)
    {
        monthGan -= 10;
    }
    monthGan = (monthGan +(yearGan%5)*2)%10;
    if(month<=2)
    {
        year -= 1;
        month += 12;
    }
    int c = year/100;
    int y = year%100;
    int i = month%2==0?6:0;
    int dayGan = (4*c+c/4+5*y+y/4+3*(month+1)/5+day-4)%10;
    int dayZhi = (8*c+c/4+5*y+y/4+3*(month+1)/5+day+6+i)%12;
    
    int hourZhi = ((hour+1)/2)%12;
    int hourGan = (hourZhi+(dayGan%5)*2)%10;

    ganzhi[0] = yearGan;
    ganzhi[1] = yearZhi;
    ganzhi[2] = monthGan;
    ganzhi[3] = monthZhi;
    ganzhi[4] = dayGan;
    ganzhi[5] = dayZhi;
    ganzhi[6] = hourGan;
    ganzhi[7] = hourZhi;
}

+ (NSString*)baziOfGan:(int)gan zhi:(int)zhi
{
    return [NSString stringWithFormat:@"%@%@",tianGan[gan],diZhi[zhi]];
}

+ (int)getGanZhiIndex:(int)gan zhi:(int)zhi
{
    return (36*gan+25*zhi)%60;
}

+ (NSString*)nayinOfGan:(int)gan zhi:(int)zhi
{
    return naYin[[OICalendarUtil getGanZhiIndex:gan zhi:zhi]/2];
}

+ (NSString*)wuxingOfGan:(int)gan zhi:(int)zhi
{
    return [NSString stringWithFormat:@"%@%@",[OICalendarUtil getGanWuXing:gan],[OICalendarUtil getZhiWuXing:zhi]];
}

/*
 甲   乙   丙   丁
 子月
 丑月
 寅月
 */
const double ganScore[12][10] = {
    1.2, 	1.2, 	1.0, 	1.0, 	1.0, 	1.0, 	1.0, 	1.0, 	1.2, 	1.2,//子月
    1.06, 	1.06, 	1.0, 	1.0, 	1.1, 	1.1, 	1.14, 	1.14, 	1.1, 	1.1,//丑月
    1.14, 	1.14, 	1.2, 	1.2, 	1.06, 	1.06, 	1.0, 	1.0, 	1.0, 	1.0,//寅月
    1.2, 	1.2, 	1.2, 	1.2, 	1.0, 	1.0, 	1.0, 	1.0, 	1.0, 	1.0,//卯月
    1.1, 	1.1, 	1.06, 	1.06, 	1.1, 	1.1, 	1.1, 	1.1, 	1.04, 	1.04,//辰月
    1.0, 	1.0, 	1.14, 	1.14, 	1.14, 	1.14, 	1.06, 	1.06, 	1.06, 	1.06,//巳月
    1.0,	1.0, 	1.2, 	1.2, 	1.2, 	1.2, 	1.0, 	1.0, 	1.0, 	1.0,//午月
    1.04, 	1.04, 	1.1, 	1.1, 	1.16, 	1.16, 	1.1, 	1.1, 	1.0, 	1.0,//未月
    1.06, 	1.06, 	1.0, 	1.0, 	1.0, 	1.0, 	1.14, 	1.14, 	1.2, 	1.2,//申月
    1.0, 	1.0, 	1.0, 	1.0, 	1.0, 	1.0, 	1.2, 	1.2, 	1.2, 	1.2,//酉月
    1.0, 	1.0, 	1.04, 	1.04, 	1.14, 	1.14, 	1.16, 	1.16, 	1.06, 	1.06,//戌月
    1.2, 	1.2, 	1.0, 	1.0, 	1.0, 	1.0, 	1.0, 	1.0, 	1.14, 	1.14,//亥月
};

/*
 子月  丑月
 子  癸
 丑  癸
 丑  辛
 */
const double zhiGanScore[24][14] = {
    0,	9,	1.2,	1.1,	1.0,	1.0,	1.04,	1.06,	1.0,	1.0,	1.2,	1.2,	1.06,	1.14,
    1,	9,	0.36,	0.33,	0.3,	0.3,	0.312,	0.318,	0.3,	0.3,	0.36,	0.36,	0.318,	0.342,
    1,	7,	0.2,	0.228,	0.2,	0.2,	0.23,	0.212,	0.2,	0.22,	0.228,	0.248,	0.232,	0.2,
    1,	5,	0.5,	0.55,	0.53,	0.5,	0.55,	0.57,	0.6,	0.58,	0.5,	0.5,	0.57,	0.5,
    2,	2,	0.3,	0.3,	0.36,	0.36,	0.318,	0.342,	0.36,	0.33,	0.3,	0.3,	0.342,	0.318,
    2,	0,	0.84,	0.742,	0.798,	0.84,	0.77,	0.7,	0.7,	0.728,	0.742,	0.7,	0.7,	0.84,
    3,	1,	1.2,	1.06,	1.14,	1.2,	1.1,	1.0,	1.0,	1.04,	1.06,	1.0,	1.0,	1.2,
    4,	1,	0.36,	0.318,	0.342,	0.36,	0.33,	0.3,	0.3,	0.312,	0.318,	0.3,	0.3,	0.36,
    4,	9,	0.24,	0.22,	0.2,	0.2,	0.208,	0.2,	0.2,	0.2,	0.24,	0.24,	0.212,	0.228,
    4,	4,	0.5,	0.55,	0.53,	0.5,	0.55,	0.6,	0.6,	0.58,	0.5,	0.5,	0.57,	0.5,
    5,	6,	0.3,	0.342,	0.3,	0.3,	0.33,	0.3,	0.3,	0.33,	0.342,	0.36,	0.348,	0.3,
    5,	2,	0.7,	0.7,	0.84,	0.84,	0.742,	0.84,	0.84,	0.798,	0.7,	0.7,	0.728,	0.742,
    6,	3,	1.0,	1.0,	1.2,	1.2,	1.06,	1.14,	1.2,	1.1,	1.0,	1.0,	1.04,	1.06,
    7,	3,	0.3,	0.3,	0.36,	0.36,	0.318,	0.342,	0.36,	0.33,	0.3,	0.3,	0.312,	0.318,
    7,	1,	0.24,	0.212,	0.228,	0.24,	0.22,	0.2,	0.2,	0.208,	0.212,	0.2,	0.2,	0.24,
    7,	5,	0.5,	0.55,	0.53,	0.5,	0.55,	0.57,	0.6,	0.58,	0.5,	0.5,	0.57,	0.5,
    8,	8,	0.36,	0.33,	0.3,	0.3,	0.312,	0.318,	0.3,	0.3,	0.36,	0.36,	0.318,	0.342,
    8,	6,	0.7,	0.798,	0.7,	0.7,	0.77,	0.742,	0.7,	0.77,	0.798,	0.84,	0.812,	0.7,
    9,	7,	1.0,	1.14,	1.0,	1.0,	1.1,	1.06,	1.0,	1.1,	1.14,	1.2,	1.16,	1.0,
    10,	7,	0.3,	0.342,	0.3,	0.3,	0.33,	0.318,	0.3,	0.33,	0.342,	0.36,	0.348,	0.3,
    10,	3,	0.2,	0.2,	0.24,	0.24,	0.212,	0.228,	0.24,	0.22,	0.2,	0.2,	0.208,	0.212,
    10,	4,	0.5,	0.55,	0.53,	0.5,	0.55,	0.57,	0.6,	0.58,	5.0,	0.5,	0.57,	0.5,
    11,	0,	0.36,	0.318,	0.342,	0.36,	0.33,	0.3,	0.3,	0.312,	0.318,	0.3,	0.3,	0.36,
    11,	8,	0.84,	0.77,	0.7,	0.7,	0.728,	0.742,	0.7,	0.7,	0.84,	0.84,	0.724,	0.798,
};
+ (void)wuxingScore:(int*)ganzhi score:(double *)score
{
    double ganscore[10] = {0};//天干得分，
    int monthZhi = ganzhi[3];
    for(int i = 0;i<8;i++)
    {
        if(i%2==0)//直接取干分数
        {
            ganscore[ganzhi[i]] += ganScore[monthZhi][ganzhi[i]];
        }
        else//取支里藏干分数
        {
            int zhi = ganzhi[i];
            for(int j = zhi;j<24;j++)
            {
                int tempZhi = zhiGanScore[j][0];
                if(tempZhi==zhi)
                {
                    int zhiLiGan = zhiGanScore[j][1];
                    ganscore[zhiLiGan] += zhiGanScore[j][monthZhi+2];
                }
                else if(tempZhi<zhi)
                    continue;
                else
                    break;
            }
        }
    }
    //天干得分对应到五行得分，五行顺序为金水木火土
    for(int i = 0;i<10;i++)
    {
        score[(i/2+2)%5] += ganscore[i]*10;
    }
}
+(NSString*)toChineseYear:(NSUInteger)_year
{
    std::pair<int, int> p=ChineseCalendarDB::GetEraAndYearOfLunar((int)_year);
    int jiazi=p.second-1;
    NSString *yearString = [NSString stringWithFormat:@"%@%@年",[tianGan objectAtIndex:jiazi % 10],[diZhi objectAtIndex:jiazi % 12]];
    return yearString;
}
+(NSString*)toChineseMonthAndDay:(NSUInteger)_month day:(NSUInteger)_day
{
    NSString *monthString = [OICalendarUtil lunarMonthString:_month];
    return [NSString stringWithFormat:@"%@%@",monthString,[lunarDays objectAtIndex:(_day-1)%30]];
}
+(NSDateComponents*)getDatebySomeYear:(int)_year isLunar:(BOOL)_isLunar
{
    NSDateComponents *todayDC = [[OICalendarUtil currentCalendar]components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDateComponents *someDC = [[NSDateComponents alloc]init];
    if (_isLunar)
    {
        NSDateComponents *lunarDC = [OICalendarUtil toChineseDateWithYear:todayDC.year month:todayDC.month day:todayDC.day];
        int month = (int)lunarDC.month;
        int day = (int)lunarDC.day;
        ChineseDate chineseDate = ChineseDate(_year, month, day);
        while (chineseDate.IsValidDate()==NO)
        {
            chineseDate.AdjustDays(-1);
        }
        SolarDate solarDate=chineseDate.ToSolarDate();
        someDC.year=solarDate.GetYear();
        someDC.month=solarDate.GetMonth();
        someDC.day=solarDate.GetDay();
    }
    else
    {
        someDC.year = _year;
        someDC.month = todayDC.month;
        if((_year%4==0&&_year%100!=0)||(_year%400==0))
        {
            someDC.day = (int)todayDC.day;
        }
        else
        {
            if (todayDC.month==2)
            {
                if (todayDC.day==29)
                {
                    someDC.day=28;
                }
                else
                {
                    someDC.day = todayDC.day;
                }
            }
            else
            {
                someDC.day = (int)todayDC.day;
            }
        }
    }
    return someDC;
}
@end
