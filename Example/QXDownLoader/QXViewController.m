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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    QXDownLoader *downLoad = [[QXDownLoadManager shareInstance] getLoaderWithUrl:[NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4" ]];

    
    QXDownLoader *downLoad2 = [[QXDownLoadManager shareInstance] getLoaderWithUrl:[NSURL URLWithString:@"http://audio.xmcdn.com/group23/M04/63/C5/wKgJNFg2qdLCziiYAGQxcTOSBEw402.m4a"]];
    NSLog(@"%@---%@",downLoad,downLoad2);
}

- (IBAction)download:(UIButton*)sender {

    //@"http://audio.xmcdn.com/group23/M04/63/C5/wKgJNFg2qdLCziiYAGQxcTOSBEw402.m4a"
    
    
      [[QXDownLoadManager shareInstance] downloadWithUrl:[NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"] totalSizeBlock:^(long long size) {
//        NSLog(@"%lld",size);
    } successBlock:^(NSString *cachePath) {
//        NSLog(@"%@",cachePath);
    } failedBlock:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
    

    
    [[QXDownLoadManager shareInstance] downloadWithUrl:[NSURL URLWithString:@"http://audio.xmcdn.com/group23/M04/63/C5/wKgJNFg2qdLCziiYAGQxcTOSBEw402.m4a"] totalSizeBlock:^(long long size) {
//        NSLog(@"====%lld",size);
    } successBlock:^(NSString *cachePath) {
//        NSLog(@"===%@",cachePath);
    } failedBlock:^(NSError *error) {
//        NSLog(@"====%@",error);
    }];

}


-(void)change:(NSNotification*)noif
{
    NSDictionary *userinfo = noif.userInfo;
//    NSString *url = userinfo[@"Url"];
    QXDownState state = [userinfo[@"state"] intValue];
    NSLog(@"%d",state);
}

- (IBAction)pause:(UIButton*)sender {
    [[QXDownLoadManager shareInstance] pauseAll];
}
@end
