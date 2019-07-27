//
//  ACSecurityManager.m
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import "ACSecurityManager.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation ACSecurityManager

+ (NSData *)AC_AES256CryptWithData:(NSData *)data securityKey:(NSString *)securityKey isEncrypt:(BOOL)isEncrypt {
    if (data == nil || securityKey == nil) {
        return nil;
    }
    NSData *indata = data;
    
    Byte tkey[32] = {securityKey.hash};
    CCCryptorRef cryptor;
    CCCryptorStatus status;
    CCOperation cryptType = isEncrypt ? kCCEncrypt : kCCDecrypt;
    status = CCCryptorCreate(cryptType, kCCAlgorithmAES, kCCOptionPKCS7Padding, tkey, kCCKeySizeAES256, NULL, &cryptor);
    if (status != kCCSuccess) {
        return nil;
    }
    
    size_t bufsize = 0;
    size_t moved = 0;
    size_t total = 0;
    bufsize = CCCryptorGetOutputLength(cryptor, indata.length, true);
    char * buf = (char*)malloc(bufsize);
    bzero(buf, bufsize);
    
    status = CCCryptorUpdate(cryptor,
                             indata.bytes,
                             indata.length,
                             buf,
                             bufsize,
                             &moved);
    total += moved;
    if (status != kCCSuccess) {
        return nil;
    }
    
    status = CCCryptorFinal(cryptor,
                           buf+total,
                           bufsize-total, &moved);
    if (status != kCCSuccess) {
        return nil;
    }
    
    total += moved;
    CCCryptorRelease(cryptor);
    
    NSData *retData = [NSData dataWithBytes:buf length:total];
    free(buf);
    
    return retData;
    
}

+ (NSString *)AC_MD5StringWithString:(NSString *)string {
    
    const char * charString = string.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(charString, (CC_LONG)strlen(charString), result);
    
    NSMutableString *md5String = [[NSMutableString alloc] init];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5String appendString:[NSString stringWithFormat:@"%02X", result[i]]];
    }
    return md5String;
}

+ (NSString *)AC_MD5StringWithData:(NSData *)data {
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    CC_MD5_Update(&md5,data.bytes,(CC_LONG)data.length);
    unsigned char dataResult[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(dataResult,&md5);
    NSMutableString *hashString = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        [hashString appendFormat:@"%02X",dataResult[i]];
    }
    return hashString;
}

@end
