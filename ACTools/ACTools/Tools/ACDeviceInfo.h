//
//  ACDeviceInfo.h
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACDeviceInfo : NSObject

/*!
 * @brief APP名称
 */
+ (NSString *)applicationDisplayName;

/*!
 * @brief 当前版本号
 */
+ (NSString *)applicationVersion;

/*!
 * @brief 系统版本 e.g. @"4.0"
 * 
 */
+ (NSString *)phoneSystemVersion;

/*!
 * @brief 系统名称 e.g. @"iOS"
 */
+ (NSString *)phoneSystemName;

/*!
 * @brief 系统首选语言
 */
+ (NSString *)systemPreferredLanguage;

/*!
 * @brief 手机类型 e.g. @"iPhone", @"iPod touch"
 */
+ (NSString *)phoneModel;

/*!
 * @brief 广告标识符
 */
+ (NSString *)advertisingIdentifier;

/*!
 * @brief 供应商标识符
 */
+ (NSString *)identifierForVendor;

/*!
 *  @brief 网络运营商
 */
+ (NSString *)telephonyCarrier;

/*!
 * @brief 移动城市码
 */
+ (NSString *)mobileCountryCode;

/*!
 * @brief 移动网络码
 */
+ (NSString *)mobileNetworkCode;

/*!
 * @brief 电池电量
 */
+ (CGFloat)batteryLevel;

/*!
 * @brief 设备IP地址
 */
+ (NSString *)deviceIpAddress;

/*!
 * @brief 本地wifiIP地址
 */
+ (NSString *)localWifiIpAddress;

/*!
 * @brief wifi名称
 */
+ (NSString *)wifiName;

/*!
 * @brief 总物理内存
 */
+ (long long)totalMemorySize;

/*!
 * @brief 总物理内存字符串 单位、KB、MB、GB
 */
+ (NSString *)totalMemorySizeString;

/*!
 * @brief 可用物理内存
 */
+ (long long)availableMemorySize;

/*!
 * @brief 可用物理内存字符串 单位、KB、MB、GB
 */
+ (NSString *)availableMemorySizeString;

/*!
 * @brief 总磁盘大小
 */
+ (long long)totalDiskSize;

/*!
 * @brief 总磁盘大小 单位、KB、MB、GB
 */
+ (NSString *)totalDiskSizeString;

/*!
 * @brief 可用磁盘大小
 */
+ (long long)availableDiskSize;

/*!
 * @brief 可用磁盘大小 单位、KB、MB、GB
 */
+ (NSString *)availableDiskSizeString;

/*!
 * @brief 是否越狱
 */
+ (BOOL)isJailbrokenDevice;

/*!
 * @brief 屏幕亮度 0 .. 1.0,
 */
+ (CGFloat)brightness;

/*!
 * @brief 网络类型 2G、3G、4G
 */
+ (NSString *)networkType;

/*!
 * @brief 设备型号 iphone5、 iphone7、  ....
 */
+ (NSString *)deviceName;

/*!
 * @brief 本地城市编码
 */
+ (NSString *)localCountryCode;


@end

NS_ASSUME_NONNULL_END
