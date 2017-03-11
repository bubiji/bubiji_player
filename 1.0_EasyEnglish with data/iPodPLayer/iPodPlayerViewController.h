//
//  MusicPlayerViewController.h
//  MusicPlayer
//
//  Created by 韩国翔 on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicManager.h"

typedef enum {
    PlayNormal1,
    RepeatOne1,//模式
    RepeatGroup1
} PlayModelItems1;

@class iPodPlayerViewController;
@protocol iPodPlayerViewControllerDelegate
- (void)playerViewControllerDidFinish:(iPodPlayerViewController *)controller;
@end

@interface iPodPlayerViewController : UIViewController<AVAudioPlayerDelegate,UIAccelerometerDelegate> {
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
    id<iPodPlayerViewControllerDelegate> playerdelegate;
    
    AVAudioSession *audioSession;

	//MusicManager *musicPlayer;
	//IBOutlet UITableView *musicList;

}
@property(nonatomic,retain)IBOutlet UISlider *currentSlider;
@property(nonatomic,retain)IBOutlet UISlider *volumeSlider;
@property(nonatomic,retain) UIButton *prevButton;
@property(nonatomic,retain) UIButton *nextButton;
@property(nonatomic,retain)IBOutlet UILabel *currentLabel;
@property(nonatomic,retain)IBOutlet UILabel *durationLabel;
@property(nonatomic,retain) UIButton  *playerController;
@property(nonatomic,retain)IBOutlet UILabel *currentTitleLabel;
@property(nonatomic,retain) UIButton *playModelButton;
@property(nonatomic,assign) id<iPodPlayerViewControllerDelegate> playerdelegate;
@property(nonatomic,retain)IBOutlet UILabel *didTimeLable;
@property(nonatomic,retain)IBOutlet UILabel *didDaysLable;

//-(IBAction) addMusic:(id)sender;

-(IBAction)setVolume:(id)sender;
-(IBAction)playPreviousMusic:(id)sender;
-(IBAction)playOrPause:(id)sender;
-(IBAction)playNextMusic:(id)sender;
-(IBAction)setCurrent:(id)sender;
-(void)initButton;

-(void)newPlay :(Music*) music; //放下一首歌
-(void)UpdateDaysTimesLable; //更新 times days lables
-(void)initAppSectionMusicList;

@end
