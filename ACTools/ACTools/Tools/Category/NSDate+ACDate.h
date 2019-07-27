//
//  NSDate+ACDate.h
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** ====== 时间格式 */
static NSString *const kDateFormatter_AC_YMDHMS = @"yyyy-MM-dd HH:mm:ss";
static NSString *const kDateFormatter_AC_YMDHM = @"yyyy-MM-dd HH:mm";
static NSString *const kDateFormatter_AC_YMDH = @"yyyy-MM-dd HH";
static NSString *const kDateFormatter_AC_YMD = @"yyyy-MM-dd";
static NSString *const kDateFormatter_AC_YM = @"yyyy-MM";
static NSString *const kDateFormatter_AC_HMS = @"HH:mm:ss";
static NSString *const kDateFormatter_AC_HM = @"HH:mm";


@interface NSDate (ACDate)

/*  ****  **** **** ****  Date  ****  **** **** **** */

/*!
* @brief 获取本地当前时间
*/
+ (NSDate *)AC_localeDate;

/*!
 * @brief 时间字符串指定format格式输出对应的时间(NSDate)
 * @discussion format（默认值为@"yyyy-MM-dd HH:mm"）
 */
+ (NSDate *)AC_dateWithString:(NSString *)dateStr format:(NSString *)format;

/*!
 * @brief date指定format格式输出对应的时间字符串
 * @discussion format（默认值为@"yyyy-MM-dd HH:mm"）
 */
+ (NSString *)AC_stringWithDate:(NSDate *)date format:(NSString *)format;


/*  ****  **** **** ****  Calendar  ****  **** **** **** */

/*!
 * @brief 日期中日对应的整数值 如: 2019-07-24  -> 24
 */
+ (NSInteger)AC_dayValueWithDate:(NSDate *)date;

/*!
 * @brief 日期中月份对应的整数值 如: 2019-07-24  -> 7
 */
+ (NSInteger)AC_monthValueWithDate:(NSDate *)date;

/*!
 * @brief 日期中年份对应的整数值 如: 2019-07-24  -> 2019
 */
+ (NSInteger)AC_yearValueWithDate:(NSDate *)date;

/*!
 * @brief 日期当天周几对应的整数值 如: 2019-07-24  -> 3
 */
+ (NSInteger)AC_weekDayWithDate:(NSDate *)date;

/*!
 * @brief 日期月数第一天周几对应的整数值 如: 2019-07-24  -> 1
 */
+ (NSInteger)AC_weekDayForFirstDayOfMonthWithDate:(NSDate *)date;

/*!
 * @brief 日期当月总天数对应的数值 如: 2019-07-24  -> 31
 */
+ (NSInteger)AC_daysOfMonthWithDate:(NSDate *)date;

/*!
 * @brief 当前日期偏移 offset 天数之后的日期 如 2019-07-24 偏移-7天 ->  2019-07-17
 * @discussion offset 为正数偏移至未来的某一天  为负数偏移至过去的某一天
 */
+ (NSDate *)AC_offsetDaysDateWithDate:(NSDate *)date offset:(NSInteger)offset;

/*!
 * @brief 当前日期偏移 offset 月份之后的日期 如 2019-07-24 偏移-7月 ->  2018-12-17
 * @discussion offset 为正数偏移至未来的某一月份  为负数偏移至过去的某一月份
 */
+ (NSDate *)AC_offsetMonthsDateWithDate:(NSDate *)date offset:(NSInteger)offset;

/*!
 * @brief 当前日期偏移 offset 月份之后的日期 如 2019-07-24 偏移-7年 ->  2012-07-17
 * @discussion offset 为正数偏移至未来的某一年份  为负数偏移至过去的某一年份
 */
+ (NSDate *)AC_offsetYearsDateWithDate:(NSDate *)date offset:(NSInteger)offset;


@end

NS_ASSUME_NONNULL_END
