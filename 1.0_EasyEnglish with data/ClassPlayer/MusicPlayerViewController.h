//
//  MusicPlayerViewController.h
//  MusicPlayer
//
//  Created by 韩国翔 on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "AVAudioPlayerManager.h"
//#import "MusicPlayerAppDelegate.h"
#import "PlayerFactory.h"

@class MusicPlayerViewController;
@protocol PlayerViewControllerDelegate
- (void)playerViewControllerDidFinish:(MusicPlayerViewController *)controller;
@end

@interface MusicPlayerViewController : UIViewController<UIAccelerometerDelegate> {
    IBOutlet UISlider *Events;
    IBOutlet UISlider *volumeSlider;
    IBOutlet UIButton *prevButton;
    IBOutlet UIButton *nextButton;
    IBOutlet UILabel *currentLabel;
    IBOutlet UILabel *durationLabel;
    IBOutlet UIButton *playerController;
    IBOutlet UILabel *currentTitleLabel;
    IBOutlet UIButton *playModelButton;
    double Volume;
    IBOutlet UILabel *didTimeLable;
    IBOutlet UILabel *didDaysLable;
    //晃动
    UIAccelerationValue	myAccelerometer[3];
    CFTimeInterval		lastTime;
    id<PlayerViewControllerDelegate> playerdelegate;
    
    AVAudioSession *audioSession;

	//MusicManager *musicPlayer;
	//IBOutlet UITableView *musicList;
    BasicPlayer *basePlayer;
}
@property(nonatomic,retain) UISlider *currentSlider;
@property(nonatomic,retain)IBOutlet UISlider *volumeSlider;
@property(nonatomic,retain) UIButton *prevButton;
@property(nonatomic,retain) UIButton *nextButton;
@property(nonatomic,retain)IBOutlet UILabel *currentLabel;
@property(nonatomic,retain)IBOutlet UILabel *durationLabel;
@property(nonatomic,retain) UIButton  *playerController;
@property(nonatomic,retain)IBOutlet UILabel *currentTitleLabel;
@property(nonatomic,retain) UIButton *playModelButton;
@property(nonatomic,assign) id<PlayerViewControllerDelegate> playerdelegate;
@property(nonatomic,retain)IBOutlet UILabel *didTimeLable;
@property(nonatomic,retain)IBOutlet UILabel *didDaysLable;
@property(nonatomic,retain) BasicPlayer *basePlayer;

//-(IBAction) addMusic:(id)sender;

-(IBAction)setVolume:(id)sender;
-(IBAction)playPreviousMusic:(id)sender;
-(IBAction)playOrPause:(id)sender;
-(IBAction)playNextMusic:(id)sender;
-(IBAction)setCurrent:(id)sender;
-(void)initButton;
-(void)FinishPlaying;

-(void)newPlay :(Music*) music; //放下一首歌
-(void)UpdateDaysTimesLable; //更新 times days lables
-(void)initAppSectionMusicList;
-(NSString *)getTimeFormat:(NSString *)time;
-(void)UpdateDataBaseDaysAndTimes;


@end
