//
//  ACFileManager.m
//  ACTools
//
//  Created by Alex on 2019/7/23.
//  Copyright © 2019年 AlexCorleone. All rights reserved.
//

#import "ACFileManager.h"

@interface ACFileManager()

@end

@implementation ACFileManager

#pragma mark - FileHandle

+ (NSData *)AC_subdataInPath:(NSString *)filePath WithRange:(NSRange)range {
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    [handle seekToFileOffset:range.location];
    return  [handle readDataOfLength:range.length];
}


#pragma mark - FileManager

+ (size_t)AC_fileSizeWithFilePath:(NSString *)filePath {
    unsigned long long size = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL exist = [manager fileExistsAtPath:filePath isDirectory:&isDir];
    if (!exist) return size;
    if (isDir)
    {
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:filePath];
        for (NSString *subPath in enumerator)
        {
            NSString *fullPath = [filePath stringByAppendingPathComponent:subPath];
            size += [manager attributesOfItemAtPath:fullPath error:nil].fileSize;
        }
    }else
    {
        size += [manager attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    return size;
}


+ (BOOL)AC_createDirectoryWithName:(NSString *)directoryName searchPath:(NSSearchPathDirectory)searchPath {
    return [ACFileManager AC_createDirectoryWithName:directoryName searchPath:searchPath domainMask:NSUserDomainMask];
}

+ (BOOL)AC_createDirectoryWithName:(NSString *)directoryName searchPath:(NSSearchPathDirectory)searchPath domainMask:(NSSearchPathDomainMask)domainMask {
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(searchPath, domainMask,YES)objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/%@",pathDocuments, directoryName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:createPath])
    {
        NSError *error = nil;
        BOOL result = [fileManager createDirectoryAtPath:createPath
                             withIntermediateDirectories:YES
                                              attributes:@{NSFileAppendOnly : @(0),
                                                           NSFilePosixPermissions : @(0)
                                                           }
                                                   error:&error];
        if (!result)
        {
            NSAssert(!result, @"文件夹创建失败");
        }
        return  result;
    }else
    {
        NSLog(@"%s 文件已存在", __FUNCTION__);
        return YES;
    }
}

+ (BOOL)AC_createFileWithName:(NSString *)fileName path:(NSString *)filePath {
    return [ACFileManager AC_createFileWithName:fileName path:filePath content:[NSData data]];
}

+ (BOOL)AC_createFileWithName:(NSString *)fileName path:(NSString *)filePath content:(NSData *)content {
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    BOOL result = [fileManager createFileAtPath:[NSString stringWithFormat:@"%@/%@", filePath, fileName] contents:content attributes:nil];
    return result;
}

+ (BOOL)AC_deleteFileWithFilePath:(NSString *)filePath
{
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager removeItemAtPath:filePath error:&error];
    if (error)
    {
        NSLog(@"文件移除失败%@", error);
    }
    return result;
}

@end
