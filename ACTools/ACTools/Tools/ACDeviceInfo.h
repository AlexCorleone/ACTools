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

/*
 * <#release Content#>
 */
+ (NSString *)applicationDisplayName;

/*
 * <#release Content#>
 */
+ (NSString *)applicationVersion;

/*
 * <#release Content#>
 */
+ (NSString *)phoneSystemVersion;

/*
 * <#release Content#>
 */
+ (NSString *)phoneSystemName;

/*
 * <#release Content#>
 */
+ (NSString *)systemPreferredLanguage;

/*
 * <#release Content#>
 */
+ (NSString *)phoneModel;

/*
 * 广告标识符
 */
+ (NSString *)advertisingIdentifier;

/*
 * 供应商标识符
 */
+ (NSString *)identifierForVendor;

/*
 * <#release Content#>
 */
+ (NSString *)telephonyCarrier;

/*
 * <#release Content#>
 */
+ (NSString *)mobileCountryCode;

/*
 * <#release Content#>
 */
+ (NSString *)mobileNetworkCode;

/*
 * <#release Content#>
 */
+ (CGFloat)batteryLevel;

/*
 * <#release Content#>
 */
+ (NSString *)deviceIpAddress;

/*
 * <#release Content#>
 */
+ (NSString *)localWifiIpAddress;

/*
 * <#release Content#>
 */
+ (NSString *)wifiName;

/*
 * <#release Content#>
 */
+ (long long)totalMemorySize;

/*
 * <#release Content#>
 */
+ (NSString *)totalMemorySizeString;

/*
 * <#release Content#>
 */
+ (long long)availableMemorySize;

/*
 * <#release Content#>
 */
+ (NSString *)availableMemorySizeString;

/*
 * <#release Content#>
 */
+ (long long)totalDiskSize;

/*
 * <#release Content#>
 */
+ (NSString *)totalDiskSizeString;

/*
 * <#release Content#>
 */
+ (long long)availableDiskSize;

/*
 * <#release Content#>
 */
+ (NSString *)availableDiskSizeString;

/*
 * <#release Content#>
 */
+ (BOOL)isJailbrokenDevice;

/*
 * <#release Content#>
 */
+ (CGFloat)brightness;

/*
 * <#release Content#>
 */
+ (NSString *)networkType;

/*
 * <#release Content#>
 */
+ (NSString *)deviceName;

/*
 * <#release Content#>
 */
+ (NSString *)localCountryCode;


@end

NS_ASSUME_NONNULL_END
