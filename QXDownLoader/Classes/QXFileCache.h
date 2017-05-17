//
//  QXFileCache.h
//  QXDownLoader
//
//  Created by 孟庆祥 on 2017/5/16.
//  Copyright © 2017年 mengqingxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QXFileCache : NSObject

+(NSString *)cachePathWithUrl:(NSURL*)Url;
+(BOOL)cachedWithUrl:(NSURL*)Url;


+(NSString *)tempPathWithUrl:(NSURL*)Url;
+(BOOL)tempWithUrl:(NSURL*)Url;

+(long long)fileSizeWithPath:(NSString*)path;
+(void)movePatchWithUrl:(NSURL*)Url;
+(void)removeWithUrl:(NSURL*)Url;
@end
