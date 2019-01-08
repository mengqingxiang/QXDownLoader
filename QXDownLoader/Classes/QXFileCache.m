//
//  QXFileCache.m
//  QXDownLoader
//
//  Created by 孟庆祥 on 2017/5/16.
//  Copyright © 2017年 mengqingxiang. All rights reserved.
//

#import "QXFileCache.h"

#define chcheDirectory NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define tmpDirectory NSTemporaryDirectory()

@implementation QXFileCache


+(NSString *)cachePathWithUrl:(NSURL*)Url
{
    return [chcheDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",Url.pathComponents.lastObject]];
}


+(BOOL)cachedWithUrl:(NSURL*)Url
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[QXFileCache cachePathWithUrl:Url]]) {
        
        return true;
    }
    return false;
}

+(NSString *)tempPathWithUrl:(NSURL*)Url
{
    return [tmpDirectory stringByAppendingString:Url.pathComponents.lastObject];
}


+(BOOL)tempWithUrl:(NSURL*)Url
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[QXFileCache tempPathWithUrl:Url]]) {
        
        return true;
    }
    return false;
}

+(long long)fileSizeWithPath:(NSString*)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSDictionary *info = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        return [info[NSFileSize] longLongValue];
    }
    return 0;
}

+(void)movePatchWithUrl:(NSURL*)Url
{
    if ([self tempWithUrl:Url]) {
        [[NSFileManager defaultManager] moveItemAtPath:[self tempPathWithUrl:Url] toPath:[self cachePathWithUrl:Url] error:nil];
    }
}

+(void)removeWithUrl:(NSURL*)Url
{
    if ([self tempWithUrl:Url]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self tempPathWithUrl:Url] error:nil];
    }
}
@end
