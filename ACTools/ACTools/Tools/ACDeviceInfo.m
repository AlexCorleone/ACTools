//
//  ACDeviceInfo.m
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import "ACDeviceInfo.h"
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <sys/socket.h> // Per msqr
#include <net/if.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <arpa/inet.h>
#import <sys/mount.h>
#import <mach/vm_statistics.h>
#import <mach/message.h>
#import <mach/mach_host.h>
#import <mach/arm/kern_return.h>
#include <netdb.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#include <resolv.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import "sys/utsname.h"
#import <sys/stat.h>

NS_INLINE NSDictionary * _appInfoDictionary (void) {
    return [[NSBundle mainBundle] infoDictionary];
}

NS_INLINE UIDevice * _currentDevice (void) {
    return [UIDevice currentDevice];
}

@implementation ACDeviceInfo


+ (NSString *)applicationDisplayName {
    return _appInfoDictionary()[@"CFBundleDisplayName"];
}

+ (NSString *)applicationVersion {
    return _appInfoDictionary()[@"CFBundleShortVersionString"];
}

+ (NSString *)phoneSystemVersion {
    return [_currentDevice() systemVersion];
    
}

+ (NSString *)phoneSystemName {
    return [_currentDevice() systemName];
}

+ (NSString *)systemPreferredLanguage {
    return [NSLocale preferredLanguages][0];
}

+ (NSString *)phoneModel {
    return [_currentDevice() model];
}

+ (NSString *)advertisingIdentifier {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (NSString *)identifierForVendor {
    return [[_currentDevice() identifierForVendor] UUIDString];
}

+ (NSString *)telephonyCarrier {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc]init];
    NSDictionary <NSString *, CTCarrier *> *providers = [networkInfo serviceSubscriberCellularProviders];
    if (providers.allKeys.count == 0) {
        return nil;
    }
    CTCarrier *carrier = providers[providers.allKeys.firstObject];
    if (!carrier.isoCountryCode) {
        return nil;
    }
    return [carrier carrierName];
}

+ (NSString *)mobileCountryCode {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc]init];
    NSDictionary <NSString *, CTCarrier *> *providers = [networkInfo serviceSubscriberCellularProviders];
    if (providers.allKeys.count == 0) {
        return nil;
    }
    CTCarrier *carrier = providers[providers.allKeys.firstObject];
    if (!carrier.isoCountryCode) {
        return nil;
    }
    return [carrier mobileCountryCode];
}

+ (NSString *)mobileNetworkCode {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc]init];
    NSDictionary <NSString *, CTCarrier *> *providers = [networkInfo serviceSubscriberCellularProviders];
    
    if (providers.allKeys.count == 0) {
        return nil;
    }
    CTCarrier *carrier = providers[providers.allKeys.firstObject];
    if (!carrier.isoCountryCode) {
        return nil;
    }
    return [carrier mobileNetworkCode];
}

+ (CGFloat)batteryLevel {
    _currentDevice().batteryMonitoringEnabled = YES;
    return [_currentDevice() batteryLevel];
}

+ (NSString *)deviceIpAddress {
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    NSMutableArray *ips = [NSMutableArray array];
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0) {
        for (ptr = buffer; ptr < buffer + ifc.ifc_len;) {
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    
    for (int i = 0; i < ips.count; i++) {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@", ips.lastObject];
        }
    }
    return deviceIP;
}

+ (NSString *)localWifiIpAddress {
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}

+ (NSString *)wifiName {
    NSString *wifiName = nil;
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            wifiName = [dict valueForKey:@"SSID"];
        }
    }
    
    return wifiName;
}

+ (long long)totalMemorySize {
    return [[NSProcessInfo processInfo] physicalMemory];
}

+ (NSString *)totalMemorySizeString {
    return [self fileSizeToString:[self totalMemorySize]];
}

+ (long long)availableMemorySize {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}

+ (NSString *)availableMemorySizeString {
    return [self fileSizeToString:[self availableMemorySize]];
}

+ (long long)totalDiskSize {
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return freeSpace;
}

+ (NSString *)totalDiskSizeString {
    return [self fileSizeToString:[self totalDiskSize]];
}

+ (long long)availableDiskSize {
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace;
}

+ (NSString *)availableDiskSizeString {
    return [self fileSizeToString:[self availableMemorySize]];
}

+ (BOOL)isJailbrokenDevice {
    BOOL jailbroken = NO;
    NSString * cydiaPath = @"/Applications/Cydia.app";
    NSString * aptPath = @"/private/var/lib/apt";
    NSString *applications = @"/User/Applications/";
    NSString *mobile = @"/Library/MobileSubstrate/MobileSubstrate.dylib";
    NSString *bash = @"/bin/bash";
    NSString *sshd =@"/usr/sbin/sshd";
    NSString *sd = @"/etc/apt";
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]
        || [[NSFileManager defaultManager] fileExistsAtPath:aptPath]
        || [[NSFileManager defaultManager] fileExistsAtPath:applications]
        || [[NSFileManager defaultManager] fileExistsAtPath:mobile]
        || [[NSFileManager defaultManager] fileExistsAtPath:bash]
        || [[NSFileManager defaultManager] fileExistsAtPath:sshd]
        || [[NSFileManager defaultManager] fileExistsAtPath:sd]) {
        jailbroken = YES;
    }
    //使用stat系列函数检测Cydia等工具
    struct stat stat_info;
    if (0 == stat("/Applications/Cydia.app", &stat_info)) {
        jailbroken = YES;
    }
    
    int ret;
    Dl_info dylib_info;
    int (*func_stat)(const char *, struct stat *) = stat;
    if ((ret = dladdr(func_stat, &dylib_info))) {
        NSString *str = [NSString stringWithFormat:@"%s",dylib_info.dli_fname];
        if (![str isEqualToString:@"/usr/lib/system/libsystem_kernel.dylib"]) {
            jailbroken = YES;
        }
    }
    
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if(env){
        jailbroken = YES;
    }
    return jailbroken;
}

+ (CGFloat)brightness {
    return [UIScreen mainScreen].brightness;
}

//获取本地的DNS IP
//+ (NSString *)localSystemIp {
//    res_state res = (res_state)malloc(sizeof(struct __res_state));
//    __uint32_t dwDNSIP = 0;
//    int result = res_ninit(res);
//    if (result == 0) {
//        dwDNSIP = res->nsaddr_list[0].sin_addr.s_addr;
//    }
//    free(res);
//    NSString *dns = [NSString stringWithUTF8String:inet_ntoa(res->nsaddr_list[0].sin_addr)];
//    return dns;
//}

+ (NSString *)networkType {
    NSString *netconnType = @"";
    // 获取手机网络类型
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSDictionary <NSString *, NSString *> *statusDic = info.serviceCurrentRadioAccessTechnology;
    if (statusDic.allKeys.count == 0) {
        return netconnType;
    }
    NSString *currentStatus = statusDic[statusDic.allKeys.firstObject];
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        netconnType = @"GPRS";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        netconnType = @"2.75G EDGE";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]) {
        netconnType = @"3G";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]) {
        netconnType = @"3.5G HSDPA";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]) {
        netconnType = @"3.5G HSUPA";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]) {
        netconnType = @"2G";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]) {
        netconnType = @"3G";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]) {
        netconnType = @"3G";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]) {
        netconnType = @"3G";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]) {
        netconnType = @"HRPD";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]) {
        netconnType = @"4G";
    }
    return netconnType;
}

// 获取设备型号
//https://www.theiphonewiki.com/wiki/Models
+ (NSString *)deviceName {   // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString hasPrefix:@"iPhone"]) {
        if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone";
        if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
        if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
        if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
        if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
        if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
        if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
        if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
        if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
        if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
        if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
        if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
        if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
        if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
        if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
        if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
        if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
        if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
        if ([deviceString isEqualToString:@"iPhone9,1"]
            || [deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
        if ([deviceString isEqualToString:@"iPhone9,2"]
            || [deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
        if ([deviceString isEqualToString:@"iPhone10,1"]
            || [deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
        if ([deviceString isEqualToString:@"iPhone10,2"]
            || [deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
        if ([deviceString isEqualToString:@"iPhone10,3"]
            || [deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
        if ([deviceString isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
        if ([deviceString isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
        if ([deviceString isEqualToString:@"iPhone11,6"])    return @"iPhone XS Max";
        return @"iPhone";
    }
    if ([deviceString hasPrefix:@"iPod"]) {
        if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
        if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
        if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
        if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
        if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
        if ([deviceString isEqualToString:@"iPod7,1"])      return @"iPod Touch (6 Gen)";
        if ([deviceString isEqualToString:@"iPod9,1"])      return @"iPod Touch (7 Gen)";

        return @"iPod";
    }
    if ([deviceString hasPrefix:@"iPad"]) {
        if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
        if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
        if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2";
        if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
        if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2";
        if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
        if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad (3 Gen)";
        if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad (3 Gen)";
        if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad (3 Gen)";
        if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad (4 Gen)";
        if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad (4 Gen)";
        if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad (4 Gen)";
        if ([deviceString isEqualToString:@"iPad6,11"])     return @"iPad (5 Gen)";
        if ([deviceString isEqualToString:@"iPad6,12"])     return @"iPad (5 Gen)";
        if ([deviceString isEqualToString:@"iPad7,5"])     return @"iPad (6 Gen)";
        if ([deviceString isEqualToString:@"iPad7,6"])     return @"iPad (6 Gen)";

        if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
        if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
        if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";

        if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
        if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
        if ([deviceString isEqualToString:@"iPad11,3"])  return @"iPad Air (3 Gen)";
        if ([deviceString isEqualToString:@"iPad11,4"])  return @"iPad Air (3 Gen)";
        
        if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
        if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
        if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
        if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
        if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
        if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
        if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
        if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
        if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
        if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
        if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
        if ([deviceString isEqualToString:@"iPad11,1"])  return @"iPad mini (5 Gen)";
        if ([deviceString isEqualToString:@"iPad11,2"])  return @"iPad mini (5 Gen)";
        
        if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
        if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
        if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
        if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
        if ([deviceString isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9 (2 Gen)";
        if ([deviceString isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9 (2 Gen)";
        if ([deviceString isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5";
        if ([deviceString isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5";
        if ([deviceString isEqualToString:@"iPad8,3"])      return @"iPad Pro 11.0";
        if ([deviceString isEqualToString:@"iPad8,4"])      return @"iPad Pro 11.0";
        if ([deviceString isEqualToString:@"iPad8,5"])      return @"iPad Pro 12.9 (3 Gen)";
        if ([deviceString isEqualToString:@"iPad8,6"])      return @"iPad Pro 12.9 (3 Gen)";
        if ([deviceString isEqualToString:@"iPad8,7"])      return @"iPad Pro 12.9 (3 Gen)";
        if ([deviceString isEqualToString:@"iPad8,8"])      return @"iPad Pro 12.9 (3 Gen)";
        return @"iPad Pro";
    }
    if ([deviceString isEqualToString:@"i386"])             return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])           return @"Simulator";
    
    return deviceString;
}

+ (NSString *)localCountryCode {
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

/**
 将空间大小转化为字符串
 @param fileSize 空间大小
 @return 字符串
 */
+ (NSString *)fileSizeToString:(unsigned long long)fileSize
{
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10)
    {
        return @"0 B";
    } else if (fileSize < KB) {
        return @"< 1 KB";
    } else if (fileSize < MB) {
        return [NSString stringWithFormat:@"%.1f KB", ((CGFloat)fileSize)/KB];
        
    } else if (fileSize < GB) {
        return [NSString stringWithFormat:@"%.1f MB", ((CGFloat)fileSize)/MB];
        
    } else {
        return [NSString stringWithFormat:@"%.1f GB", ((CGFloat)fileSize)/GB];
    }
}

@end
