//
//  QXDownLoader.h
//  QXDownLoader
//
//  Created by 孟庆祥 on 2017/5/16.
//  Copyright © 2017年 mengqingxiang. All rights reserved.
//

#import <Foundation/Foundation.h>


#define  KQXDownLoaderNotificationStateChange  @"DownLoaderNotificationStateChange"

typedef NS_ENUM(NSInteger,QXDownState) {
    QXDownStatePause = 0,
    QXDownStateLoading = 1,
    QXDownStateFinish = 2,
    QXDownStateFailed = 3,
};


typedef void(^totalSizeBlock)(long long size);
typedef void(^downSuccessBlock)(NSString*cachePath);
typedef void(^downFailedBlock)(NSError* error);


@interface QXDownLoader : NSObject


-(void)downloadWithUrl:(NSURL*)downUrl;
-(void)downloadWithUrl:(NSURL*)downUrl  totalSizeBlock:(totalSizeBlock)totalSizeBlock successBlock:(downSuccessBlock)successBlock failedBlock:(downFailedBlock)failedBlock;

-(void)pauseCurrentTask;
-(void)cacelCurrentTask;
-(void)cacelAndClear;


#pragma mark - 数据
@property(nonatomic,assign)QXDownState state;
@property(nonatomic,assign,readonly)float progress;

@property(nonatomic,copy)void (^stateChangeBlock)(QXDownState state);
@property(nonatomic,copy)void (^progressBlock)(float progress);

@property(nonatomic,copy)totalSizeBlock totalBlock;
@property(nonatomic,copy)downSuccessBlock successBlock;
@property(nonatomic,copy)downFailedBlock failedBlock;
@end
