//
//  AVAudioPlayerManager.m
//  JokePlayer
//
//  Created by apple on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AVAudioPlayerManager.h"

@implementation AVAudioPlayerManager


-(id)initAVAudioPlayerwithMusic:(Music*)music
{
    self =[super init];
    if (self) {
        ava_player = [[AVAudioPlayer alloc] initWithContentsOfURL: music.path error:nil];
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

-(double)getClassTime
{
    return [ava_player duration];
}
-(double)getCurrentTime
{
    
    return [ava_player currentTime];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    
   [self.ava_player_delegate AVAudioPlayerManageDidFinishPlaying];

}
@end
