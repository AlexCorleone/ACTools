//
//  ACSecurityManager.h
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACSecurityManager : NSObject

/*AES 加解密 */
+ (NSData *)AC_AES256CryptWithData:(NSData *)data
                   securityKey:(NSString *)securityKey
                     isEncrypt:(BOOL)isEncrypt;

/*MD5 加密*/
+ (NSString *)AC_MD5StringWithString:(NSString *)string;

+ (NSString *)AC_MD5StringWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
