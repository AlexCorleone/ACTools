//
//  UIImage+ACImage.h
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ACImage)

/*!
 * @brief 指定颜色获取图片
 */
+ (UIImage *)AC_imageWithColor:(UIColor *)color;

/*!
 * @brief 按照指定大小绘制图片
 */
+ (UIImage *)AC_resizeWithImage:(UIImage*)imgage newSize:(CGSize)newSize;

@end

NS_ASSUME_NONNULL_END
