//
//  QXDownLoadManager.m
//  QXDownLoader
//
//  Created by 孟庆祥 on 2017/5/17.
//  Copyright © 2017年 mengqingxiang. All rights reserved.
//

#import "QXDownLoadManager.h"
#import "NSString+QX.h"
@interface QXDownLoadManager()<NSCopying,NSMutableCopying>
@property(nonatomic,strong)NSMutableDictionary *loaderDic;
@end
static QXDownLoadManager* _shareInstance = nil;
@implementation QXDownLoadManager



-(NSMutableDictionary *)loaderDic
{
    if (_loaderDic==nil) {
        _loaderDic = [NSMutableDictionary dictionary];
    }
    return _loaderDic;
}

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[QXDownLoadManager alloc]init];
    });
    return _shareInstance;
}


-(QXDownLoader*)downloadWithUrl:(NSURL*)downUrl
{
    return [self downloadWithUrl:downUrl totalSizeBlock:nil successBlock:nil failedBlock:nil];
}


-(QXDownLoader*)downloadWithUrl:(NSURL*)downUrl  totalSizeBlock:(totalSizeBlock)totalSizeBlock successBlock:(downSuccessBlock)successBlock failedBlock:(downFailedBlock)failedBlock
{
    __weak typeof (self) weakself = self;
    QXDownLoader *loader = [self getDownLoadWithUrl:downUrl];
    [loader downloadWithUrl:downUrl totalSizeBlock:totalSizeBlock successBlock:^(NSString *cachePath) {
        [weakself.loaderDic removeObjectForKey:[downUrl.absoluteString md5]];
        if (successBlock) {
            successBlock(cachePath);
        }
    } failedBlock:failedBlock];
    return loader;
}


-(QXDownLoader*)checkDownLoadWithUrl:(NSURL*)url
{
    NSString *mdUrl = [url.absoluteString md5];
    QXDownLoader *loader = self.loaderDic[mdUrl];
    return loader;
}

-(QXDownLoader*)getLoaderWithUrl:(NSURL*)Url
{
    return [self checkDownLoadWithUrl:Url];
}

-(QXDownLoader*)getDownLoadWithUrl:(NSURL*)url
{
    NSString *mdUrl = [url.absoluteString md5];
    QXDownLoader *loader = self.loaderDic[mdUrl];
    if (loader) {
        return loader;
    }
    loader = [[QXDownLoader alloc]init];
    self.loaderDic[mdUrl] = loader;
    return loader;
}



-(void)pauseWithUrl:(NSURL*)Url
{
    QXDownLoader *loader = [self checkDownLoadWithUrl:Url];
    if (loader) {
        [loader pauseCurrentTask];
    }
}

-(void)cacelWithUrl:(NSURL*)Url
{
    QXDownLoader *loader = [self checkDownLoadWithUrl:Url];
    if (loader) {
        [loader cacelCurrentTask];
    }
}

-(void)cacelAndClearWithUrl:(NSURL*)Url
{
    QXDownLoader *loader = [self checkDownLoadWithUrl:Url];
    if (loader) {
        [loader cacelAndClear];
    }
}


-(void)pauseAll
{
    NSArray *keyArray = self.loaderDic.allKeys;
    for (NSString*key in keyArray) {
        QXDownLoader *loader = self.loaderDic[key];
        if (loader) {
            [loader pauseCurrentTask];
        }
    }
}


-(void)cacelAll
{
    NSArray *keyArray = self.loaderDic.allKeys;
    for (NSString*key in keyArray) {
        QXDownLoader *loader = self.loaderDic[key];
        if (loader) {
            [loader cacelCurrentTask];
        }
    }
}


-(void)cacelAndClearAll
{
    NSArray *keyArray = self.loaderDic.allKeys;
    for (NSString*key in keyArray) {
        QXDownLoader *loader = self.loaderDic[key];
        if (loader) {
            [loader cacelAndClear];
        }
    }
}


-(id)copyWithZone:(NSZone *)zone
{
    return _shareInstance;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _shareInstance;
}
@end
