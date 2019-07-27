//
//  ACKeychainManager.m
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import "ACKeychainManager.h"
#import <Security/Security.h>
#import <AdSupport/AdSupport.h>

/*标识APP(IDFA, UUID) 确保唯一*/
#define AC_APP_IDFA @"com.ac.test.idfa"
#define kIsStringValid(text) (text && text!=NULL && text.length>0)

@implementation ACKeychainManager

#pragma mark - keychain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)name
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(__bridge id)(kSecClassGenericPassword), kSecClass, name, kSecAttrService, name, kSecAttrAccount, kSecAttrAccessibleAfterFirstUnlock, kSecAttrAccessible,nil];
}

+ (void)AC_keychainSaveWithName:(NSString *)name data:(id)data {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:name];
    SecItemDelete((__bridge CFDictionaryRef)(keychainQuery));
    NSError *archiveError = nil;
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:NO error:&archiveError];
    if (archiveError) {
        NSLog(@"class:%@  ERROR: %@", NSStringFromClass(self), archiveError);
    }
    if (archiveData) {
        [keychainQuery setObject:archiveData
                          forKey:(__bridge id<NSCopying>)(kSecValueData)];
    }
    SecItemAdd((__bridge CFDictionaryRef)(keychainQuery), NULL);
}

+ (id)AC_keychainLoadWithName:(NSString *)name {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:name];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id<NSCopying>)(kSecReturnData)];
    [keychainQuery setObject:(__bridge id)(kSecMatchLimitOne) forKey:(__bridge id<NSCopying>)(kSecMatchLimit)];
    
    CFTypeRef result = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, &result) == noErr) {
        NSError *unarchiveError = nil;
        ret = [NSKeyedUnarchiver unarchivedObjectOfClass:NSObject.class fromData:(__bridge NSData*)result error:&unarchiveError];
        if (unarchiveError) {
            NSLog(@"class:%@  ERROR: %@", NSStringFromClass(self), unarchiveError);
        }
    }
    return ret;
}

+ (void)AC_keychainDeleteWithName:(NSString *)name {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:name];
    SecItemDelete((__bridge CFDictionaryRef)(keychainQuery));
}


#pragma mark - IDFA

+ (void)AC_keychainDeleteIDFA {
    [self AC_keychainDeleteWithName:AC_APP_IDFA];
}

+ (NSString*)AC_keychainLoadIDFA {
    NSString *deviceID = [self AC_keychainLoadWithName:AC_APP_IDFA];
    if (kIsStringValid(deviceID)) {
        return deviceID;
    } else {
        if ([ASIdentifierManager sharedManager].advertisingTrackingEnabled) {
            deviceID = [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] lowercaseString];
            [self AC_keychainSaveWithName:AC_APP_IDFA data:deviceID];
            return deviceID;
        } else {
            deviceID = [self AC_UUID];
            [self AC_keychainSaveWithName:AC_APP_IDFA data:deviceID];
            if (kIsStringValid(deviceID)) {
                return deviceID;
            }
        }
    }
    return nil;
}

#pragma mark - UUID
+ (NSString*)AC_UUID {
    CFUUIDRef uuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, uuid);
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(uuid);
    CFRelease(uuidString);
    return [result lowercaseString];
}

@end
