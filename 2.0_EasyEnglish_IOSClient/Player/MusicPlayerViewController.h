//
//  MusicPlayerViewController.h
//  MusicPlayer
//
//  Created by 韩国翔 on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//#import "FMDatabase.h"
#import "AVAudioPlayerManager.h"
//#import "MusicPlayerAppDelegate.h"
//#import "PlayerFactory.h"
#import "RecordClass.h"
@class MusicPlayerViewController;

@protocol MusicPlayerViewController_Delegate <NSObject,MPPlayableContentDelegate>
@optional
- (void)MusicPlayerViewController_DidFinishPlaying:(RecordClass*)record;
@end


@interface MusicPlayerViewController : UIViewController<UIAccelerometerDelegate,AVAudioPlayerManager_Delegate> {
  //  IBOutlet UISlider *Events;
   // IBOutlet UISlider *volumeSlider;
    IBOutlet UIButton *prevButton;
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *playerController;
    IBOutlet UIButton *playModelButton;

    IBOutlet UILabel *currentLabel;
    IBOutlet UILabel *durationLabel;
    IBOutlet UILabel *currentTitleLabel;
    double Volume;
    IBOutlet UILabel *didTimeLable;
    IBOutlet UILabel *didDaysLable;
    //晃动
    UIAccelerationValue	myAccelerometer[3];
    CFTimeInterval		lastTime;
    
    AVAudioSession *audioSession;
    NSTimer *timer;
	//MusicManager *musicPlayer;
	//IBOutlet UITableView *musicList;
    //AVAudioPlayerManager *basePlayer;
    Music* currentMusic;
}

@property(nonatomic, retain) id player_delegate;

@property(nonatomic,retain)NSMutableArray *musiclist;

@property(nonatomic,retain)IBOutlet UIButton *topBackButton;

@property(nonatomic,retain)IBOutlet UISlider *currentnewSlider;
@property(nonatomic,retain)IBOutlet UISlider *volumeSlider;

@property(nonatomic,retain)IBOutlet UILabel *currentLabel;
@property(nonatomic,retain)IBOutlet UILabel *durationLabel;
@property(nonatomic,retain)IBOutlet UILabel *currentTitleLabel;
@property(nonatomic,retain)IBOutlet UILabel *didTimeLable;
@property(nonatomic,retain)IBOutlet UILabel *didDaysLable;

@property(nonatomic,retain) UIButton *prevButton;
@property(nonatomic,retain) UIButton *nextButton;

@property(nonatomic,retain) UIButton  *playerController;
@property(nonatomic,retain) UIButton *playModelButton;
@property(nonatomic,retain) AVAudioPlayerManager *avaPlayer;
@property(nonatomic)PlayModelItems PlayModel;

@property(nonatomic)NSTimeInterval AlreadyTime ;


//-(IBAction) addMusic:(id)sender;
-(IBAction)playModelChoose:(id)sender;

-(IBAction)setVolume:(id)sender;
-(IBAction)playPreviousMusic:(id)sender;
-(IBAction)playOrPause:(id)sender;
-(IBAction)playNextMusic:(id)sender;
-(IBAction)setCurrent:(id)sender;
-(IBAction)topbuttonBack:(id)sender;


-(void)newPlay :(Music*) music; //放下一首歌

-(void)UpdateDaysTimesLable; //更新 times days lables
-(void)initAppSectionMusicList;
-(NSString *)getTimeFormat:(NSString *)time;
-(void)UpdateDataBaseDaysAndTimes;


@end
