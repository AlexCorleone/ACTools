//
//  UIColor+ACColor.m
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import "UIColor+ACColor.h"

@implementation UIColor (ACColor)

+ (UIColor *)AC_colorWithHexString:(NSString *)hexString {
    return [self AC_colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)AC_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    hexString = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"0X" withString:@""];

    NSRegularExpression *RegEx = [NSRegularExpression regularExpressionWithPattern:@"^[a-fA-F|0-9]{6}$" options:0 error:nil];
    NSUInteger match = [RegEx numberOfMatchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, hexString.length)];
    
    if (match == 0) { return [UIColor clearColor]; }
    
    NSString *rString = [hexString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [hexString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [hexString substringWithRange:NSMakeRange(4, 2)];
    unsigned int r, g, b;
    BOOL rValue = [[NSScanner scannerWithString:rString] scanHexInt:&r];
    BOOL gValue = [[NSScanner scannerWithString:gString] scanHexInt:&g];
    BOOL bValue = [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (rValue && gValue && bValue) {
        return [UIColor colorWithRed:((float)r/255.0f) green:((float)g/255.0f) blue:((float)b/255.0f) alpha:alpha];
    } else {
        return [UIColor clearColor];
    }
}

+ (NSString *)AC_hexStringWithColor:(UIColor *)color HasAlpha:(BOOL)hasAlpha {
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    int rgb = (int)(r * 255.0f)<<16 | (int)(g * 255.0f)<<8 | (int)(b * 255.0f)<<0;
    if (hasAlpha) {
        rgb = (int)(a * 255.0f)<<24 | (int)(r * 255.0f)<<16 | (int)(g * 255.0f)<<8 | (int)(b * 255.0f)<<0;
    }
    
    return [NSString stringWithFormat:@"%06x", rgb];
}

@end
