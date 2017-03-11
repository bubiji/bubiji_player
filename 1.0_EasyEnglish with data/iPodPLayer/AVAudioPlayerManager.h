//
//  AVAudioPlayerManager.h
//  JokePlayer
//
//  Created by apple on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerFactory.h"
#import "BasicPlayer.h"
//#import "FMDatabase.h"
@interface AVAudioPlayerManager : BasicPlayer<AVAudioPlayerDelegate>
{
//MPMusicPlayerController *player;//播放器
//MPMediaItemCollection *mediaCollection;//放置音樂的容器
//BOOL isPlay;
}
//@property(nonatomic, retain)MPMusicPlayerController *player;
//@property(nonatomic, retain)MPMediaItemCollection *mediaCollection;
//@property(nonatomic, assign)BOOL isPlay;
//-(id)initWithPlayerType:(NSInteger)PlayerType LoadSong:(NSArray *)SongList;
-(id)initAVAudioPlayer;
//- (void)AVplay:(NSURL*)path;//播放
//-(void)play:(Music*)music;

//- (void)mangerpause;//暫停
//- (void)mangerstop;//停止
//- (void)mangerprev;//下一首
//- (void)mangernext;//上一首
//- (void)clearMusicPlayer;//清空播放容器
//- (void)saveToData;//儲存
//- (void)reload:(NSArray *)SongList;//重置播放容器
@end