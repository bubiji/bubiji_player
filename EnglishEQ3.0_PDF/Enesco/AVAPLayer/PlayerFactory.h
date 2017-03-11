//
//  PlayerManager.h
//  JokePlayer
//
//  Created by apple on 12-2-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AVAudioPlayerManager.h"
//#import "iPodMusicManager.h"
//#import "AVPlayerManager.h"
//#import "BasicPlayer.h"

@protocol MusicManagerDelegate;

@interface PlayerFactory : NSObject//<MusicManagerDelegate>
{

    BasicPlayer *Manager;

}
+(id)getPlayManagerWith:(Music*)music;
//-(void)playofManager:(Music*)music;

@end


