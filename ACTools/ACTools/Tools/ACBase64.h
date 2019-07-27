//
//  ACBase64.h
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (ACBase64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;

@end


@interface NSString (ACBase64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;

@end

NS_ASSUME_NONNULL_END
