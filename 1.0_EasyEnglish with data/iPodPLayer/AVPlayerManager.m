//
//  AVPlayerManager.m
//  JokePlayer
//
//  Created by apple on 12-2-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AVPlayerManager.h"

@implementation AVPlayerManager

-(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
-(id)initavPlayer
{
    [super init];
    if (self) {
    }
//    [[NSNotificationCenter defaultCenter]   addObserver:<self> selector:@selector(<#The selector name#>)
//     name:AVPlayerItemDidPlayToEndTimeNotification 
//     object:<#A player item#>];
   
    //[appDelegate.iPodPlayer beginGeneratingPlaybackNotifications];  
    return self;
}
//歌曲停止
- (void)musicPlaybackDidFinish:(NSNotification *)notification {
    // AppDelegate *appDelegate=[self getAppDelegate];
    //这里要判断状态 不然反复读取
    //[appDelegate.PlayController FinishPlaying];
    AppDelegate *appDelegate=[self getAppDelegate];
    
    NSLog(@"finish %f -- %f",appDelegate.AlreadyTime*0.1,appDelegate.currentMusic.ClassTime);
    
    if (appDelegate.currentMusic.ClassTime > 0 && appDelegate.currentMusic.ClassTime- appDelegate.AlreadyTime*0.1>3) {
        [appDelegate.iPodPlayer pause];
        [appDelegate.PlayController FinishPlaying];
        //NSLog(@"FinishPlaying %f",appDelegate.AlreadyTime*0.1);
        
        // [appDelegate.iPodPlayer endGeneratingPlaybackNotifications];
    }
}
//- (void)AVplay:(NSURL*)path
-(void)play:(Music*)music

{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    [appDelegate.avPlayer release];
    appDelegate.avPlayer=nil;
    //    AVPlayer *newPlayer1 = [[AVPlayer alloc]initWithURL:path ];
    //    [newPlayer1 play ];
    AVPlayerItem * item =[AVPlayerItem playerItemWithURL: music.path];

    AVPlayer *newPlayer = [AVPlayer  playerWithPlayerItem: item ];
    //NSLog(@"path%@",music.path);
    //NSLog(@"ClassTime :%f",music.ClassTime);
    
    appDelegate.avPlayer=newPlayer;
    [appDelegate.avPlayer play];
    
    [[NSNotificationCenter defaultCenter ]  removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:appDelegate.avPlayer];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self    selector:@selector(musicPlaybackDidFinish:)  name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    //appDelegate.avPlayer.delegate =self;//这里的self 和new的不一样
    
    
}

-(void)playsPlay{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    [appDelegate.avPlayer play];
    
}
-(void)playsPause
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    [appDelegate.avPlayer pause];
}
- (void)playsstop{
//    AppDelegate *appDelegate=[self getAppDelegate];
//    
//    [appDelegate.avPlayer stop];
}

-(void)setCurrent:(float)value
{    
//    AppDelegate *appDelegate=[self getAppDelegate];
//    CMTime cTime = appDelegate.avPlayer.currentTime;
//    float currentTimeSec = cTime.value / cTime.timescale;
//    [appDelegate.avPlayer seekToTime:cTime]; 
}
-(double)getCurrentTime
{
    AppDelegate *appDelegate=[self getAppDelegate];
    CMTime cTime = appDelegate.avPlayer.currentTime;
    float currentTimeSec = cTime.value / cTime.timescale;   
    //NSLog(@"value:%f , timescale:%@",currentTimeSec,1);
    //(@"cTime:%@ , timescale:",cTime);

    return currentTimeSec;
}
-(void)setVolume:(float)value
{
//    AppDelegate *appDelegate=[self getAppDelegate];
//    
//    [appDelegate.avPlayer volume]//=value;
}


-(double)getClassTime
{
    AppDelegate *appDelegate=[self getAppDelegate];
    //NSLog(@"---%f",appDelegate.currentMusic.ClassTime);
    //NSLog(@"---%@",appDelegate.currentMusic);
    
    return appDelegate.currentMusic.ClassTime;
    
}

//- (void)audioPlayerDidFinishPlaying:(avPlayer *)player successfully:(BOOL)flag;
//{
//    AppDelegate *appDelegate=[self getAppDelegate];
//    [appDelegate.PlayController FinishPlaying];
//    
//}
@end
