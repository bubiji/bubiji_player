//
//  MusicManager.m
//  iPodLibraryDemo
//
//  Created by shinren Pan on 2011/1/4.
//  Copyright 2011 home. All rights reserved.
//



@implementation iPodMusicManager
@synthesize  isPlay;//player, mediaCollection,
-(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
+(id)initWithPlayerType:(NSInteger)PlayerType LoadSong:(NSArray *)SongList
{
    return [[self alloc] initPlayerType:PlayerType LoadSong:SongList]; 
    
}
-(id)initPlayerType:(NSInteger)PlayerType LoadSong:(NSArray *)SongList
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
	self = [super init];
	if(self)
	{
		switch (PlayerType) 
		{
			case 0:
				appDelegate.iPodPlayer = [MPMusicPlayerController applicationMusicPlayer];
				if([SongList count] > 0)
				{
					//MPMediaItemCollection *_mediaCollection = [[MPMediaItemCollection alloc]initWithItems:SongList];
					//appDelegate.iPodMediaCollection = _mediaCollection;
					//[_mediaCollection release];
					
					//[appDelegate.iPodPlayer setQueueWithItemCollection:appDelegate.iPodMediaCollection];
					[appDelegate.iPodPlayer setRepeatMode:MPMusicRepeatModeAll];
					
				}
				else
				{
					[appDelegate.iPodPlayer setQueueWithItemCollection:nil];
					[appDelegate.iPodPlayer setRepeatMode:MPMusicRepeatModeAll];
				}
				break;
				
			case 1:
                //初始化之前 加通知中心
                appDelegate.iPodPlayer = [MPMusicPlayerController iPodMusicPlayer];
				if([SongList count] > 0)
				{
					//MPMediaItemCollection *_mediaCollection = [[MPMediaItemCollection alloc]initWithItems:SongList];
					//appDelegate.iPodMediaCollection = _mediaCollection;
					//[_mediaCollection release];
					
					//[appDelegate.iPodPlayer setQueueWithItemCollection:appDelegate.iPodMediaCollection];
                    // [appDelegate.iPodPlayer setQueueWithItemCollection:[MPMediaQuery songsQuery]];
                    [appDelegate.iPodPlayer setQueueWithQuery: [MPMediaQuery songsQuery]];
                    
					[appDelegate.iPodPlayer setRepeatMode:MPMusicRepeatModeAll];
                    
					
				}
				else
				{
                    //  appDelegate.iPodPlayer
					//[appDelegate.iPodPlayer setQueueWithItemCollection:appDelegate.iPodMediaCollection];
                    [appDelegate.iPodPlayer setQueueWithQuery: [MPMediaQuery songsQuery]];

                    [appDelegate.iPodPlayer setRepeatMode:MPMusicRepeatModeAll];

                    
				}
				break;
		}
        
        //只扑捉下面的就可以了  应该放在初始化的位置 就可以
        //先注销event 再注册。。   操他妈的。。。。
        [[NSNotificationCenter defaultCenter ]  removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:appDelegate.iPodPlayer];

        [[NSNotificationCenter defaultCenter ] addObserver:self    selector:@selector(musicPlaybackDidFinish:)  name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:appDelegate.iPodPlayer];
        [appDelegate.iPodPlayer beginGeneratingPlaybackNotifications];  

        // MP_EXTERN NSString *const MPMusicPlayerControllerPlaybackStateDidChangeNotification;
        
        appDelegate.iPodPlayer.repeatMode =MPMusicRepeatModeNone;
        appDelegate.iPodPlayer.shuffleMode =MPMusicShuffleModeOff;
	}
	return self;
}
//歌曲停止
- (void)musicPlaybackDidFinish:(NSNotification *)notification {
    // AppDelegate *appDelegate=[self getAppDelegate];
    //这里要判断状态 不然反复读取
    //[appDelegate.PlayController FinishPlaying];
    AppDelegate *appDelegate=[self getAppDelegate];

    //NSLog(@"finish %f -- %f",appDelegate.AlreadyTime*0.1,appDelegate.currentMusic.ClassTime);
    //appDelegate.currentMusic.ClassTime > 0 && 
    if (appDelegate.currentMusic.ClassTime- appDelegate.AlreadyTime*0.1>3) {
        [appDelegate.iPodPlayer pause];
        [appDelegate.PlayController FinishPlaying];
        //NSLog(@"FinishPlaying %f",appDelegate.AlreadyTime*0.1);

        // [appDelegate.iPodPlayer endGeneratingPlaybackNotifications];
    }
}


-(void)play:(Music*)music
{
    AppDelegate *appDelegate=[self getAppDelegate];
    //music.iPodNum =1;
    //NSLog(@"%@  -- %@--count: %d  ,num %d",appDelegate.iPodPlayer,music.title,[[[MPMediaQuery songsQuery]items] count] ,music.iPodNum);
    //[appDelegate.iPodPlayer setQueueWithQuery: [MPMediaQuery songsQuery]];
    
    //[appDelegate.iPodPlayer setNowPlayingItem:[[appDelegate.iPodMediaCollection items]objectAtIndex:music.iPodNum]];
    [appDelegate.iPodPlayer setNowPlayingItem:[[[MPMediaQuery songsQuery] items]objectAtIndex:music.iPodNum]];
    appDelegate.AlreadyTime =music.ClassTime*10;
    
	[appDelegate.iPodPlayer play];
    
    
}

-(void)playsPlay{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    [appDelegate.iPodPlayer play];    
}


-(void)playsPause
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
	[appDelegate.iPodPlayer pause];
}
- (void)playsstop
{
    AppDelegate *appDelegate=[self getAppDelegate];
	[appDelegate.iPodPlayer stop];
	isPlay = NO;
}


-(double)getClassTime
{
    AppDelegate *appDelegate=[self getAppDelegate];
    //NSLog(@"---%f",appDelegate.currentMusic.ClassTime);
    //NSLog(@"---%@",appDelegate.currentMusic);
    
    return appDelegate.currentMusic.ClassTime;
    
}
-(double)getCurrentTime
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    return [appDelegate.iPodPlayer currentPlaybackTime];
}
-(void)setCurrent:(float)value
{    
    AppDelegate *appDelegate=[self getAppDelegate];
    
    appDelegate.iPodPlayer.currentPlaybackTime= value; 
}
-(void)setVolume:(float)value
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    appDelegate.iPodPlayer.volume=value;
}

@end
