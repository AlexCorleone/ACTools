//
//  ViewController.m
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import "ACViewController.h"
#import "ACSecurityManager.h"
#import "ACDeviceInfo.h"
#import "NSDate+ACDate.h"
#import "UIColor+ACColor.h"
#import "ACFileManager.h"
#import "ACZoomImageView.h"
#import "ACLogoAnimationView.h"
#import "ACWangYiMusicAnimationView.h"

@interface ACViewController ()

/** <#注释#> */
@property (nonatomic,strong) ACZoomImageView *zoomImageView;

@end

@implementation ACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSString *string = @"1r2w3xx4d5w6cc-=-=-";
//    NSData *encrypt = [ACSecurityManager AC_AES256CryptWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
//                                                    securityKey:@"securityKey" isEncrypt:YES];
//    NSString *encryptRESULT = [[NSString alloc] initWithData:encrypt encoding:NSUTF8StringEncoding];
//
//    NSData *decrypt = [ACSecurityManager AC_AES256CryptWithData:encrypt securityKey:@"securityKey" isEncrypt:NO];
//
//    NSString *RESULT = [[NSString alloc] initWithData:decrypt encoding:NSUTF8StringEncoding];
//    NSString *MD5String = [ACSecurityManager AC_MD5StringWithString:@"1r2w3xx4d5w6cc-=-="];
//    MD5String = [ACSecurityManager AC_MD5StringWithData:decrypt];
//    NSLog(@"%@", [ACDeviceInfo telephonyCarrier]);
//    NSLog(@"%@", [ACDeviceInfo wifiName]);
//    NSLog(@"%@", [ACDeviceInfo totalDiskSizeString]);
//    NSLog(@"%@", [ACDeviceInfo phoneModel]);
//    NSLog(@"%@", [ACDeviceInfo deviceName]);
//    NSLog(@"%@", [ACDeviceInfo deviceIpAddress]);
//    NSLog(@"%@", [ACDeviceInfo phoneSystemName]);
//    NSLog(@"%@", [ACDeviceInfo phoneSystemVersion]);
//    NSLog(@"%@", [ACDeviceInfo advertisingIdentifier]);
//    NSLog(@"%@", [ACDeviceInfo identifierForVendor]);
    NSDate *date = [NSDate AC_localeDate];//[NSDate AC_dateWithString:@"2018-07-15 15:34:23" format:kDateFormatter_AC_YMDHMS];
    NSLog(@"日期:%ld", (long)[NSDate AC_dayValueWithDate:date]);
    NSLog(@"月份:%ld", (long)[NSDate AC_monthValueWithDate:date]);
    NSLog(@"年份:%ld", (long)[NSDate AC_yearValueWithDate:date]);
    NSLog(@"日期当天周几:%ld", (long)[NSDate AC_weekDayWithDate:date]);
    NSLog(@"日期月份第一天周几:%ld", (long)[NSDate AC_weekDayForFirstDayOfMonthWithDate:date]);
    NSLog(@"日期月份总天数:%ld", (long)[NSDate AC_daysOfMonthWithDate:date]);
    NSLog(@"偏移天数后的日期:%@", [NSDate AC_stringWithDate:[NSDate AC_offsetDaysDateWithDate:date offset:-7]
                                             format:kDateFormatter_AC_YMDHMS]);
    NSLog(@"偏移月份后的日期:%@", [NSDate AC_stringWithDate:[NSDate AC_offsetMonthsDateWithDate:date offset:-7]
                                             format:kDateFormatter_AC_YMDHMS]);
    NSLog(@"偏移年份后的日期:%@", [NSDate AC_stringWithDate:[NSDate AC_offsetYearsDateWithDate:date offset:-7]
                                             format:kDateFormatter_AC_YMDHMS]);

    [self.view addSubview:self.self.zoomImageView];
    
    //TODO:Alex -> Alex测试Logo动画
//    CGFloat logoX = 20;
//    CGFloat logoY = 20;
//    ACLogoAnimationView *animationLogo = [[ACLogoAnimationView alloc] initWithFrame:CGRectMake(logoX, logoY , 67, 67)];
//    animationLogo.layer.cornerRadius = 14;
//    animationLogo.clipsToBounds = YES;
//    [self.view addSubview:animationLogo];
//    [animationLogo startAnimation];
    //TODO:Alex -> END

    //TODO:Alex -> Alex测试网易云动画
//    ACWangYiMusicAnimationView *wangYiAnimation = [[ACWangYiMusicAnimationView alloc] init];
//    [wangYiAnimation setFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width - 300) / 2.0, 100, 300, 300)];
//    [self.view addSubview:wangYiAnimation];
//    [wangYiAnimation startMusicAnimation];
    //TODO:Alex -> END
    
}


#pragma mark - Setter && Getter

- (ACZoomImageView *)zoomImageView {
    if (!_zoomImageView) {
        CGRect imageFrame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
        self.zoomImageView = [[ACZoomImageView alloc] init];
        _zoomImageView.image = [UIImage imageNamed:@"zoom_image"];
        _zoomImageView.frame = imageFrame;
    }
    return _zoomImageView;
}
@end
