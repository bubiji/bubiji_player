//
//  AppDelegate.h
//  EasyEnglish
//
//  Created by lidian on 5/17/16.
//  Copyright © 2016 lidian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Music.h"

//模式
typedef enum {
    PlayNormal,
    RepeatOne ,
    RepeatGroup
} PlayModelItems;
//音乐类型  包括 本地 ipod    document:net/itunes //放在不同文件夹内
typedef enum {
    none,
    local,
    ipod
    
    //net,
    // itunes
} MusicTypeItems;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    //single mode
    NSMutableArray *lessonSectionlist;//分section的列表
    NSMutableArray *musiclist;//主要用于显示 判断 type  和上一首下一首
    
    // 建立一个词典  用于cell 定位选取
    AVAudioPlayer *avAudioPlayer;
    NSTimer *timer;
    AVAudioSession *audioSession;
    //FMDatabase *appDB;
    NSMutableArray *appSectionList; //所有sectionname
    NSMutableArray *appSectionNumList; //每个sectionNum
    NSMutableArray *appSectionMusicList; //相同section的歌曲
    //MusicPlayerViewController *PlayController;
    //iPodPlayerViewController *iPodPlayController;
    /* 可以得到当前播放的 章节  遍历出一个数组 在这个数组中 如果是最大 那么就从头循环如果不是最大 就+1 */
    UITabBarController *rootBar;
    NSTimeInterval StopTime;
    NSTimeInterval AlreadyTime;
    
//    CustomNavgationBar *customNavBar;
//    
//    SettingViewController *settingTableView;
//    
//    RootViewController *RootDelegate;
//    
//    iPodMusicManager *musicPlayer;
//    MPMusicPlayerController *iPodPlayer;//播放器
//    //MPMediaItemCollection *iPodMediaCollection;//放置音樂的容器
//    //IBOutlet UITableView *musicList;
//    MPMediaQuery *everything;
//    DAL *dal;
    //PlayModelItems

}
@property (nonatomic, strong) NSMutableDictionary* launchOptions;

@property (strong, nonatomic) UIWindow *window;

//@property (nonatomic, retain) RootViewController *RootDelegate;
@property (nonatomic, retain) MPMediaQuery *everything;

@property(nonatomic,retain)NSMutableArray *musiclist;
@property(nonatomic,retain)NSMutableArray *lessonSectionlist;//lessonSectionlist

@property(nonatomic,retain)Music *currentMusic;
@property(nonatomic,retain)AVAudioPlayer *avAudioPlayer;
@property(nonatomic,retain)AVPlayer *avPlayer;

@property(nonatomic,retain)NSTimer *timer;
//@property(nonatomic,retain)DAL *dal;
@property(nonatomic,retain)NSMutableArray *appSectionList;
@property(nonatomic,retain)NSMutableArray *appSectionMusicList;
@property(nonatomic,retain)NSMutableArray *appSectionNumList;

@property(nonatomic)PlayModelItems PlayModel;
//@property(nonatomic,retain)MusicPlayerViewController *PlayController; //player view
//@property(nonatomic,retain)iPodPlayerViewController *iPodPlayController; //player view


@property(nonatomic,retain)UITabBarController *rootBar;

//@property(nonatomic, retain)iPodMusicManager *musicPlayer;

@property(nonatomic, retain)MPMusicPlayerController *iPodPlayer;
//@property(nonatomic, retain)MPMediaItemCollection *iPodMediaCollection;
//@property(nonatomic, retain)UITableView *musicList;


-(void)initRootPage;
-(void)corp3LessonToLibrary;
//-(void)checkEveryLesson;
//-(BOOL)checkiPod:(Music*)m;
//-(BOOL)checkFile:(Music*)m;
//-(BOOL)checkApp:(Music*)m;   //检查存在 并写入 路径
//-(void)checkEveryLesson;

@end

