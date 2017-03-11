//
//  AVAudioPlayerManager.m
//  JokePlayer
//
//  Created by apple on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AVAudioPlayerManager.h"

@implementation AVAudioPlayerManager


-(id)initAVAudioPlayerwithMusic:(MusicEntity*)music
{
    self =[super init];
    if (self) {
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:music.fileName ofType: @"mp3"];
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        
        ava_player = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error:nil];
        [ava_player setVolume:0.5f];//有问题。。。。每次都需要重新赋值
        [ava_player setNumberOfLoops:0];
        [ava_player prepareToPlay];
        ava_player.delegate =self;//这里的self 和new的不一样

    }
    return self;
}


-(BOOL)isplaying
{
  return ava_player.playing;
}


-(void)playsPlay
{

    [ava_player play];
}
-(void)playsPause
{

    [ava_player pause];
}
- (void)playsstop{

    [ava_player stop];
}

-(void)setCurrent:(float)value
{    
    
    [ava_player setCurrentTime:value]; 
}
-(void)setVolume:(float)value
{
    
    ava_player.volume=value;
}

-(double)getDuration
{
    return [ava_player duration];
}
-(double)getCurrentTime
{
    
    return [ava_player currentTime];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    
   [self.ava_player_delegate didFinishPlaying];

}
@end
