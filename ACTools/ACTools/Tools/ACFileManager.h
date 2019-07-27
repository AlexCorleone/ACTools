//
//  ACFileManager.h
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//沙盒
#define kACTmpPath        NSTemporaryDirectory()
#define kACCachePath      UserDomainPath(NSCachesDirectory, NSUserDomainMask)
#define kACLibraryPath    UserDomainPath(NSLibraryDirectory, NSUserDomainMask)
#define kACDocumentPath   UserDomainPath(NSDocumentDirectory, NSUserDomainMask)
#define kACPreferencePath UserDomainPath(NSPreferencePanesDirectory, NSUserDomainMask)
#define kACUserDomainPath(searchPath, domain) [NSSearchPathForDirectoriesInDomains(searchPath, domain, YES) firstObject]

@interface ACFileManager : NSObject

/*!
 * @breif 获取文件的部分数据
 *
 *  @param filePath 文件路径
 *  @param range    子数据范围
 *
 *  @return 返回的子数据
 */
+ (NSData *)AC_subdataInPath:(NSString *)filePath
                   WithRange:(NSRange)range;

/*!
 * @breif 计算指定路径的文件大小  /包含路径下子文件夹中的大小
 * @discussion filePath 计算大小的路径
 * @return 返回计算的字节大小
 */
+ (size_t)AC_fileSizeWithFilePath:(NSString *)filePath;

/*!
 * @breif 创建文件夹， 默认在 domain 是 NSUserDomainMask
 * @discussion <#注释内容#>
 */
+ (BOOL)AC_createDirectoryWithName:(NSString *)directoryName
                        searchPath:(NSSearchPathDirectory)searchPath;
/*!
 * @breif 创建文件夹
 * @discussion <#注释内容#>
 */
+ (BOOL)AC_createDirectoryWithName:(NSString *)directoryName
                        searchPath:(NSSearchPathDirectory)searchPath
                        domainMask:(NSSearchPathDomainMask)domainMask;

/*!
 * @breif 创建文件， 不传NSData 默认创建一个空文件
 */
+ (BOOL)AC_createFileWithName:(NSString *)fileName
                  path:(NSString *)filePath;
/*!
 * @breif 创建文件
 */
+ (BOOL)AC_createFileWithName:(NSString *)fileName
                  path:(NSString *)filePath
                   content:(NSData *)content;

/*!
 * @breif 移除文件
 */
+ (BOOL)AC_deleteFileWithFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
