//
//  ACKeychainManager.h
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACKeychainManager : NSObject

/*!
 * @brief <#API提示内容#>
 * @discussion <#注释信息#>
 */
+ (void)AC_keychainSaveWithName:(NSString *)name data:(id)data;

/*!
 * @brief <#API提示内容#>
 * @discussion <#注释信息#>
 */
+ (id)AC_keychainLoadWithName:(NSString *)name;

/*!
 * @brief <#API提示内容#>
 * @discussion <#注释信息#>
 */
+ (void)AC_keychainDeleteWithName:(NSString *)name;


/*APP IDFA 设备唯一标识*/

/*!
 * @brief <#API提示内容#>
 * @discussion <#注释信息#>
 */
+ (NSString*)AC_keychainLoadIDFA;

/*!
 * @brief <#API提示内容#>
 * @discussion <#注释信息#>
 */
+ (void)AC_keychainDeleteIDFA;

@end

NS_ASSUME_NONNULL_END
