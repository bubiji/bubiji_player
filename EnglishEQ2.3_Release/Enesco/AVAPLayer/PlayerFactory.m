//
//  PlayerManager.m
//  JokePlayer
//
//  Created by apple on 12-2-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlayerFactory.h"

@implementation PlayerFactory

+(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
+(id)getPlayManagerWith:(Music*)music
{
   //self= [super init];
    BasicPlayer *  player =nil;
   //AppDelegate *appDelegate=[self getAppDelegate];

//        NSLog(@"type %@:",music.type);
        if ([music.type isEqualToString:@"iPod"])
        {
            player = [iPodMusicManager initWithPlayerType:1 LoadSong:nil];
           //通知重复问题 长时间会crash 可能跟写的位置有关系
            
        }else
            //Class method '+initWithPlayerType:LoadSong:' not found (return type defaults to 'id')
        {
            player = [[AVAudioPlayerManager alloc] initAVAudioPlayer];
            
        }
    
    /*没解决问题  
     1. 当前时间返回
     2。 设置当前时间
     3。 通知没测试过
     4。无法调节音量  据说可以获取ipod音量进行设置 可以让ipod对象长期驻留
     else if ([music.type isEqualToString:@"iPod"])
     {
     //player = [[AVPlayerManager alloc] initavPlayer];
      }
     */
    
    
    return player ;
}



@end
