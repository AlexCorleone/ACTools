//
//  NSDate+ACDate.m
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import "NSDate+ACDate.h"

@implementation NSDate (ACDate)

/*  ****  Date  **** */

+ (NSDate *)AC_localeDate {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}

+ (NSDate *)AC_dateWithString:(NSString *)dateStr format:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    formatter.dateFormat = format ?: kDateFormatter_AC_YMDHM;
    return [formatter dateFromString:dateStr];
}

+ (NSString *)AC_stringWithDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    formatter.dateFormat = format ?: kDateFormatter_AC_YMDHM;
    return [formatter stringFromDate:date];
}

/*  ****  Calendar  **** */

//获取日数
+ (NSInteger)AC_dayValueWithDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    return [components day];
}

//获取月数
+ (NSInteger)AC_monthValueWithDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    return [components month];
}

//获取年数
+ (NSInteger)AC_yearValueWithDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    return [components year];
}

//日期周几 (美国时间周日-周六为 1-7,改为0-6方便计算)
+ (NSInteger)AC_weekDayWithDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:date];
    NSInteger weekDay = [components weekday] - 1;
    weekDay = MAX(weekDay, 0);
    return weekDay;
}

//日期当月第一天周几
+ (NSInteger)AC_weekDayForFirstDayOfMonthWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;  //美国时间周日为星期的第一天，所以周日-周六为1-7，改为0-6方便计算
}

//日期当月总天数
+ (NSInteger)AC_daysOfMonthWithDate:(NSDate *)date {
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

//date偏移指定天数的新日期date
+ (NSDate *)AC_offsetDaysDateWithDate:(NSDate *)date offset:(NSInteger)offset {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setDay:offset];  //year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    return newdate;
}

//date偏移指定月数的新日期date
+ (NSDate *)AC_offsetMonthsDateWithDate:(NSDate *)date offset:(NSInteger)offset {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setMonth:offset];  //year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    return newdate;
}

//date偏移指定年数的新日期date
+ (NSDate *)AC_offsetYearsDateWithDate:(NSDate *)date offset:(NSInteger)offset {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setYear:offset];  //year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    return newdate;
}

@end
