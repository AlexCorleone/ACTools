//
//  NSString+ACString.m
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import "NSString+ACString.h"

@implementation NSString (ACString)

/*计算文字大小*/
#pragma mark - Public String Size

+ (CGRect)AC_rectWithText:(NSString *)text
                 maxWidth:(CGFloat)maxWidth font:(UIFont *)font {
    CGSize textSize = [text sizeForFont:font size:CGSizeMake(maxWidth, 0) mode:0];
    return CGRectMake(0, 0, textSize.width, textSize.height);
}

+ (CGRect)AC_rectWithText:(NSString *)text
                maxHeight:(CGFloat)maxHeight font:(UIFont *)font {
    CGSize textSize = [text sizeForFont:font size:CGSizeMake(0, maxHeight) mode:0];
    return CGRectMake(0, 0, textSize.width, textSize.height);
}

#pragma mark - Private

//文字大小计算
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode
{
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping)
        {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                      attributes:attr context:nil];
        result = rect.size;
    } else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

#pragma mark - Public String Attribute

//富文本
+ (NSMutableAttributedString *)AC_StringWithTotalString:(NSString *)totalString
                                              subString:(NSString *)subString
                                               fontSize:(UIFont *)font
                                                  color:(UIColor *)color {
    
    NSRange range = [NSString AC_rangeOfSubString:subString withTotalString:totalString];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:totalString];
    [attributeString addAttribute:NSFontAttributeName value:font range:range];
    [attributeString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attributeString;
}

#pragma mark - Private

+ (NSRange)AC_rangeOfSubString:(NSString *)subString withTotalString:(NSString *)totalString {
    NSUInteger subStringLenth = subString.length;
    for (NSUInteger i = 0; i < (totalString.length - subStringLenth); i++)
    {
        NSString *tempString = [totalString substringWithRange:NSMakeRange(i, subStringLenth)];
        BOOL flag = [tempString isEqualToString:subString];
        if (flag)
        {
            return NSMakeRange(i, subStringLenth);
        }
    }
    return NSMakeRange(0, 0);
}

#pragma mark - Setter && Getter

@dynamic isNull;

- (BOOL)isNull {
        return (self == nil
                || [self isKindOfClass:[NSNull class]]
                || [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0);
}

@end
