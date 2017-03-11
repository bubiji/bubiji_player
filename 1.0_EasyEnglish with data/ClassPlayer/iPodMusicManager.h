//
//  MusicManager.h
//  iPodLibraryDemo
//
//  Created by shinren Pan on 2011/1/4.
//  Copyright 2011 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BasicPlayer.h"

@interface iPodMusicManager : BasicPlayer
{
	//MPMusicPlayerController *player;//播放器
	//MPMediaItemCollection *mediaCollection;//放置音樂的容器
	BOOL isPlay;
   //Cannot find interface declaration for 'PlayerManager', superclass of 'iPodMusicManager' 
}
//@property(nonatomic, retain)MPMusicPlayerController *player;
//@property(nonatomic, retain)MPMediaItemCollection *mediaCollection;
@property(nonatomic, assign)BOOL isPlay;

//还是要留下他们初始化用
+(id)initWithPlayerType:(NSInteger)PlayerType LoadSong:(NSArray *)SongList;
-(id)initPlayerType:(NSInteger)PlayerType LoadSong:(NSArray *)SongList;
//-(void)play:(Music*)music;

//- (void)play;//播放
//- (void)pause;//暫停
//- (void)stop;//停止
//- (void)prev;//下一首
//- (void)next;//上一首
//- (void)clearMusicPlayer;//清空播放容器
//- (void)saveToData;//儲存
//- (void)reload:(NSArray *)SongList;//重置播放容器
@end
