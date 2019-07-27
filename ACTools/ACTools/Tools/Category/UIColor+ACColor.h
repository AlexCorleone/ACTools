//
//  UIColor+ACColor.h
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ACColor)

/*!
 * @brief 将HexString转为UIColor
 * @discussion 支持类型: @"0x000000", @"0X000000", @"#000000", @"000000"
 */
+ (UIColor *)AC_colorWithHexString:(NSString *)hexString;

/*!
 * @brief 将HexString转为UIColor, 支持alpha
 * @discussion 支持类型: @"0x000000", @"0X000000", @"#000000", @"000000"
 */
+ (UIColor *)AC_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/*!
 * @brief 将UIColor转为HexString, 支持alpha
 * @discussion HexString不带 @“0X”， @"0x", @"#" 等标识前缀，
 */
+ (NSString *)AC_hexStringWithColor:(UIColor *)color HasAlpha:(BOOL)hasAlpha;

@end

NS_ASSUME_NONNULL_END
