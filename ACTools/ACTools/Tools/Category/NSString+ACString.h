//
//  NSString+ACString.h
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ACString)

@property (nonatomic, readonly) BOOL isNull;

/*计算文字大小*/
+ (CGRect)AC_rectWithText:(NSString *)text
                maxWidth:(CGFloat)maxWidth font:(UIFont *)font;
+ (CGRect)AC_rectWithText:(NSString *)text
                maxHeight:(CGFloat)maxHeight font:(UIFont *)font;

/*字符串 富文本*/
+ (NSMutableAttributedString *)AC_StringWithTotalString:(NSString *)totalString
                                   subString:(NSString *)subString
                                    fontSize:(UIFont *)font
                                       color:(UIColor *)color;


/*编码*/

@end

NS_ASSUME_NONNULL_END
