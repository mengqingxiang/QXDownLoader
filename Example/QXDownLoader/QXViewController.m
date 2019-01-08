//
//  QXViewController.m
//  QXDownLoader
//
//  Created by mengqingxiang on 05/16/2017.
//  Copyright (c) 2017 mengqingxiang. All rights reserved.
//

#import "QXViewController.h"
#import "QXDownLoadManager.h"
@interface QXViewController ()
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation QXViewController



-(NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];\
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}


-(void)update
{
//    NSLog(@"==================%ld",(long)[QXDownLoader shareInstance].state);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.timer fire];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:KQXDownLoaderNotificationStateChange object:nil];
}


- (IBAction)clear:(UIButton*)sender {
    [[QXDownLoadManager shareInstance] cacelAndClearAll];
}


- (IBAction)cancel:(UIButton*)sender {
    [[QXDownLoadManager shareInstance] cacelAll];
}


- (IBAction)download:(UIButton*)sender {

    //@"http://audio.xmcdn.com/group23/M04/63/C5/wKgJNFg2qdLCziiYAGQxcTOSBEw402.m4a"
    
    QXDownLoader *downLoad = [[QXDownLoadManager shareInstance] downloadWithUrl:[NSURL URLWithString:@"https://mengqingxiang.cn/api/downLoadBook/5Zu+6KejSFRUUA==.pdf"]];
    
//    QXDownLoader *downLoad = [[QXDownLoadManager shareInstance] downloadWithUrl:[NSURL URLWithString:@"https://mengqingxiang.cn/api/downLoadBook/5Zu+6KejSFRUUA==.pdf"] totalSizeBlock:^(long long size) {
//        NSLog(@"%lld",size);
//    } successBlock:^(NSString *cachePath) {
//        NSLog(@"%@",cachePath);
//    } failedBlock:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//
    downLoad.progressBlock = ^(float progress) {
        NSLog(@"%f",progress);
    };
    
}


-(void)change:(NSNotification*)noif
{
    NSDictionary *userinfo = noif.userInfo;
//    NSString *url = userinfo[@"Url"];
    QXDownState state = [userinfo[@"state"] intValue];
    NSLog(@"%ld",(long)state);
}

- (IBAction)pause:(UIButton*)sender {
    [[QXDownLoadManager shareInstance] pauseAll];
}
@end
