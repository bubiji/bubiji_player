//
//  AVAudioPlayerManager.m
//  JokePlayer
//
//  Created by apple on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AVAudioPlayerManager.h"

@implementation AVAudioPlayerManager

-(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
-(id)initAVAudioPlayer
{
    [super init];
    if (self) {
    }
    return self;
}
//- (void)AVplay:(NSURL*)path
-(void)play:(Music*)music

{
    AppDelegate *appDelegate=[self getAppDelegate];

    [appDelegate.avAudioPlayer release];
    appDelegate.avAudioPlayer=nil;
//    AVPlayer *newPlayer1 = [[AVPlayer alloc]initWithURL:path ];
//    [newPlayer1 play ];
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: music.path error:nil];
    NSLog(@"path%@",music.path);
    //NSLog(@"ClassTime :%f",music.ClassTime);

    appDelegate.avAudioPlayer=newPlayer;
    [appDelegate.avAudioPlayer setVolume:0.5f];//有问题。。。。每次都需要重新赋值
    [appDelegate.avAudioPlayer setNumberOfLoops:0];
    [appDelegate.avAudioPlayer prepareToPlay];
    [appDelegate.avAudioPlayer play];
    appDelegate.avAudioPlayer.delegate =self;//这里的self 和new的不一样
    
    appDelegate.currentMusic.ClassTime =[appDelegate.avAudioPlayer duration];
    appDelegate.AlreadyTime =[appDelegate.avAudioPlayer duration]*10;

}

-(void)playsPlay{
    AppDelegate *appDelegate=[self getAppDelegate];

    [appDelegate.avAudioPlayer play];

}
-(void)playsPause
{
    AppDelegate *appDelegate=[self getAppDelegate];

    [appDelegate.avAudioPlayer pause];
}
- (void)playsstop{
    AppDelegate *appDelegate=[self getAppDelegate];

    [appDelegate.avAudioPlayer stop];
}

-(void)setCurrent:(float)value
{    
    AppDelegate *appDelegate=[self getAppDelegate];
    
    [appDelegate.avAudioPlayer setCurrentTime:value]; 
}
-(void)setVolume:(float)value
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    appDelegate.avAudioPlayer.volume=value;
}

-(double)getClassTime
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    return [appDelegate.avAudioPlayer duration];
    
}
-(double)getCurrentTime
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    return [appDelegate.avAudioPlayer currentTime];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    AppDelegate *appDelegate=[self getAppDelegate];
    [appDelegate.PlayController FinishPlaying];

}
@end
