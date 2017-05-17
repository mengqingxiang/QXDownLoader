//
//  QXDownLoader.m
//  QXDownLoader
//
//  Created by 孟庆祥 on 2017/5/16.
//  Copyright © 2017年 mengqingxiang. All rights reserved.
//

#import "QXDownLoader.h"
#import "QXFileCache.h"


@interface QXDownLoader()<NSURLSessionDataDelegate>
{
    long long _dowloadSize;
     long long _totalSize;
}
@property(nonatomic,strong)NSURLSession *session;
@property(nonatomic,strong)NSOutputStream *outStream;
@property(nonatomic,strong)NSURLSessionDataTask *task;
@property(nonatomic,strong)NSURL *url;
@end

@implementation QXDownLoader




-(void)downloadWithUrl:(NSURL*)downUrl
{
    self.url = downUrl;
    
    NSLog(@"%@",[QXFileCache cachePathWithUrl:downUrl]);
    
    //检测是否有下载好的文件
    if ([QXFileCache cachedWithUrl:downUrl]) {
        if (self.totalBlock) {
            self.totalBlock([QXFileCache fileSizeWithPath:[QXFileCache cachePathWithUrl:downUrl]]);
        }
        
        self.state = QXDownStateFinish;
        
        if (self.successBlock) {
            self.successBlock([QXFileCache cachePathWithUrl:downUrl]);
        }
        return;
    }

    
    
    //当前任务正在进行
    if ([downUrl isEqual:self.task.originalRequest.URL]) {
        
        if (self.state == QXDownStateLoading) {
            return;
        }
        
        if (self.state == QXDownStatePause) {
            [self resumCurrentTask];
            return;
        }
    }
    
    
    //  重新下载或者接着下载
    if ([QXFileCache tempWithUrl:downUrl]) {
        long long fileSize = [QXFileCache fileSizeWithPath:[QXFileCache tempPathWithUrl:downUrl]];
        [self downloadWithUrl:self.url offset:fileSize];
    }
    
     [self downloadWithUrl:self.url offset:0];
    return;
    
}

-(void)downloadWithUrl:(NSURL*)downUrl  totalSizeBlock:(totalSizeBlock)totalSizeBlock successBlock:(downSuccessBlock)successBlock failedBlock:(downFailedBlock)failedBlock
{
    self.totalBlock = totalSizeBlock;
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    [self downloadWithUrl:downUrl];
}

-(void)downloadWithUrl:(NSURL*)downUrl offset:(long long)offset
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:downUrl];
    self.task = [self.session dataTaskWithRequest:request];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-",offset] forHTTPHeaderField:@"Range"];
    [self resumCurrentTask];
}




-(void)setState:(QXDownState)state
{
    if (_state == state) {
        return;
    }
    _state = state;
    
    if (self.stateChangeBlock) {
        self.stateChangeBlock(state);
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:KQXDownLoaderNotificationStateChange object:nil userInfo:@{@"Url":self.url,@"state":@(self.state)}];
}

#pragma mark - 接口方法

-(void)resumCurrentTask
{
    if (self.task && self.state == QXDownStatePause) {
        [self.task resume];
        self.state = QXDownStateLoading;
    }
}

-(void)pauseCurrentTask
{
    if (self.state == QXDownStateLoading) {
        self.state = QXDownStatePause;
        [self.task suspend];
    }
}


-(void)cacelCurrentTask
{
    [self.session invalidateAndCancel];
    self.session = nil;

}


-(void)cacelAndClear
{
    [self cacelCurrentTask];
    [QXFileCache removeWithUrl:self.url];
}

#pragma mark - 懒加载
-(NSURLSession *)session
{
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

#pragma mark - downLoad

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    //获得文件的下载文件的大小
    _totalSize = [response.allHeaderFields[@"Content-Length"] longLongValue];
    long long fileSize = [QXFileCache fileSizeWithPath:[QXFileCache cachePathWithUrl:response.URL]];
    
    NSString *contentRange = response.allHeaderFields[@"Content-Range"];
    if (contentRange.length>0) {
        _totalSize = [[[contentRange componentsSeparatedByString:@"/"] lastObject] longLongValue];
    }
    
    if (self.totalBlock) {
        self.totalBlock(_totalSize);
    }
    
    
    //相等的话不用下载直接移动带下载好的位置去
    if (_totalSize == fileSize) {
        [QXFileCache movePatchWithUrl:response.URL];
        self.state = QXDownStateFinish;
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    
    //出错,删除临时文件，重新下载
    if (fileSize > _totalSize) {
        [QXFileCache removeWithUrl:response.URL];
        [self downloadWithUrl:response.URL];
        completionHandler(NSURLSessionResponseCancel);
        [self downloadWithUrl:response.URL offset:0];
        return;
    }

    self.state = QXDownStateLoading;
    self.outStream = [NSOutputStream outputStreamToFileAtPath:[QXFileCache tempPathWithUrl:response.URL] append:YES];
    [self.outStream open];
    completionHandler(NSURLSessionResponseAllow);
    
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask  didReceiveData:(NSData *)data
{
    [self.outStream write:data.bytes maxLength:data.length];
    _dowloadSize  += data.length;
    self.progress = 1.0* _dowloadSize/_totalSize;

}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (!error) {
        //验证大小
        if (_dowloadSize == [QXFileCache fileSizeWithPath:[QXFileCache tempPathWithUrl:task.currentRequest.URL]]) {
            [QXFileCache movePatchWithUrl:task.currentRequest.URL];
            self.state = QXDownStateFinish;
            if (self.successBlock) {
                self.successBlock([QXFileCache cachePathWithUrl:self.url]);
            }
        }
    }else{

        self.state = QXDownStateFailed;
        if (self.failedBlock) {
            self.failedBlock(error);
        }
        
    }
    [self.outStream close];
}


-(void)setProgress:(float)progress
{
    _progress = progress;
    if (self.progressBlock) {
        self.progressBlock(progress);
    }
}
@end
