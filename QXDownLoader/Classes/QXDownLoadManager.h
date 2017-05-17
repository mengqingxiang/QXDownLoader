//
//  QXDownLoadManager.h
//  QXDownLoader
//
//  Created by 孟庆祥 on 2017/5/17.
//  Copyright © 2017年 mengqingxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXDownLoader.h"
@interface QXDownLoadManager : NSObject
+(instancetype)shareInstance;


-(QXDownLoader*)getLoaderWithUrl:(NSURL*)Url;

-(QXDownLoader*)downloadWithUrl:(NSURL*)downUrl;
-(QXDownLoader*)downloadWithUrl:(NSURL*)downUrl  totalSizeBlock:(totalSizeBlock)totalSizeBlock successBlock:(downSuccessBlock)successBlock failedBlock:(downFailedBlock)failedBlock;

-(void)pauseWithUrl:(NSURL*)Url;
-(void)cacelWithUrl:(NSURL*)Url;
-(void)cacelAndClearWithUrl:(NSURL*)Url;


-(void)pauseAll;
-(void)cacelAll;
-(void)cacelAndClearAll;
@end
