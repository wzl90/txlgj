//
//  日历的工具类
//  OICalendarUtil.h
//
//  Copyright (c) 2011年 www.octinn.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//ChineseDate类中，农历的表述方式年月日均为数字，其中月份表示为1~13的数字
//在我们的程序中农历的表述方式年月日均为数字，其中月份若遇上闰月，则表示为负数。
//所以，需要封装一层日历转换
@interface OICalendarUtil : NSObject
+ (NSCalendar*)currentCalendar;
+ (void)resetCalendarTimeZone;
//农历转公历，这里只是借助NSDateComponents存放转换后的年月日
+ (NSDateComponents *)toSolarDateWithYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day;
//公历转农历，这里只是借助NSDateComponents存放转换后的年月日
+ (NSDateComponents *)toChineseDateWithYear:(NSUInteger)_year month:(NSUInteger)_month day:(NSUInteger)_day;
//依据公历日期计算星期
+ (int)weekDayWithSolarYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day;
//依据农历日期计算星期
+ (int)weekDayWithChineseYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day;
//星期字符串
+ (NSString *)weekdayString:(NSUInteger)_weekday;
//这里把农历月份转为1 - 13
+ (NSUInteger)monthFromMineToCppWithYear:(NSUInteger)_year month:(NSInteger)_month;
//这里把1 - 13的月份转为1-12、闰月为负数
+ (NSNumber *)monthFromCppToMineWithYear:(NSUInteger)_year month:(NSUInteger)_month;
//通过农历年份获取生肖
+ (NSString *)animalWithYear:(NSUInteger)_year;
+ (NSString*)animalWithChineseYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day lichun:(BOOL)_lichun;
+ (NSString*)animalWithSolarYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day lichun:(BOOL)_lichun;
//通过年份获取农历的年代和甲子年份，对C++里的ChineseCalendarDB::GetEraAndYearOfLunar()的再次封装，避免视图层介入C++的API
+ (void)jiaziWithYear:(NSUInteger)_year outEra:(int *)era outJiazi:(int *)jiazi;
//通过农历年份获取甲子年
+ (NSString *)jiaziStringWithYear:(NSUInteger)_year;
//农历月份变为字符串
+ (NSString *)lunarMonthString:(NSInteger)_month;
//农历日期变为字符串
+ (NSString *)lunarDayString:(NSUInteger)_day;
//根据公历日期获取节气
+ (NSString *)jieqiWithSolarYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day;
//根据农历日期获取节气
+ (NSString *)jieqiWithChineseYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day;
//根据年返回第几个节气的日子,从1开始
+ (NSUInteger)jieqiDayWithYear:(NSUInteger)_year index:(NSUInteger)_index;
//根据公历月日获取公历节日
+ (NSString*)solarFVWithMonth:(NSUInteger)_month day:(NSUInteger)_day;
//根据农历年月日获取农历节日
+ (NSString*)lunarFVWithYear:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day;
//根据公历年月日获取周几的节日
+ (NSString*)weekFVWithYear:(NSUInteger)_year month:(NSUInteger)_month day:(NSUInteger)_day;
//通过农历获取农历字符串，如：(龙(壬辰)年 八月 廿一)
+ (NSString *)toChineseString:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day;
//通过农历获取农历字符串，如：(一九八七(壬辰)年 八月 廿一)
+ (NSString *)toChineseStringWithNumber:(NSUInteger)_year month:(NSInteger)_month day:(NSUInteger)_day;
//获取下一个生日的公历日期
+ (NSDate *)nextBirthday:(NSInteger)_month day:(NSUInteger)_day isLunar:(BOOL)isLunar specialOn:(BOOL)_special;
//下个生日是否特殊生日
+ (BOOL)isSpecial:(NSInteger)_month day:(NSUInteger)_day isLunar:(BOOL)isLunar;
//获取星座字符串
+ (NSString *)starString:(NSInteger)_month day:(NSInteger)_day;
//是否闰年
+ (BOOL)isLeapYear:(NSUInteger)_year;
//这一年的第几天是什么日期
+ (NSUInteger)yearDay:(NSDateComponents*)_date;
//根据日期返回是这一年的第几天
+ (NSDateComponents *)dateFromYearDay:(NSUInteger)_days year:(NSUInteger)_year;
//根据日期返回是哪个季节，0春天、1夏天、2秋天、3冬天，以四立来区分
+ (NSUInteger)seasonOfDate:(NSDate*)date;
//返回两个日期的天数差
+ (NSInteger)daysFrom:(NSDateComponents*)_fromDate toDate:(NSDateComponents*)_toDate;
//返回天干对应五行
+ (NSString*)getGanWuXing:(NSUInteger)_gan;
//返回地支对应五行
+ (NSString*)getZhiWuXing:(NSUInteger)_zhi;
//返回八字
+ (void)baziOfDate:(NSDate*)date ganzhi:(int*)ganzhi;
+ (NSString*)baziOfGan:(int)gan zhi:(int)zhi;
+ (int)getGanZhiIndex:(int)gan zhi:(int)zhi;
+ (NSString*)nayinOfGan:(int)gan zhi:(int)zhi;
+ (NSString*)wuxingOfGan:(int)gan zhi:(int)zhi;
+ (void)wuxingScore:(int*)ganzhi score:(double*)score;
//返回农历年,丁卯年
+(NSString*)toChineseYear:(NSUInteger)_year;
//返回农历月份和日子
+(NSString*)toChineseMonthAndDay:(NSUInteger)_month day:(NSUInteger)_day;
//返回某个年份的今天的日子
+(NSDateComponents*)getDatebySomeYear:(int)_year isLunar:(BOOL)_isLunar;
+ (NSDate*)nextBirthdayWithBaseDate:(NSDate *)baseDate month:(NSInteger)_month day:(NSUInteger)_day isLunar:(BOOL)isLunar specialOn:(BOOL)_special;
+ (NSDate *)countBirthdayAfterYears:(NSInteger)years forBirthday:(NSInteger)_month day:(NSUInteger)_day isLunar:(BOOL)isLunar specialOn:(BOOL)_special;
@end
