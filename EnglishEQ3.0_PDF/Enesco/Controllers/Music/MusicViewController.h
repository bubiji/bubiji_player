//
//  MusicViewController.h
//  Enesco
//
//  Created by Aufree on 11/30/15.
//  Copyright © 2015 The EST Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOUAudioStreamer.h"
#import "GVUserDefaults+Properties.h"
#import "MusicEntity.h"
#import "AVAudioPlayerManager.h"
#import "RecordClass.h"

#import "RDFileTableController.h"
#import "BookMarkViewController.h"
#import "SettingViewController.h"
#import "MoreViewController.h"
#import "PDFVGlobal.h"

@protocol MusicViewControllerDelegate <NSObject>
@optional
- (void)updatePlaybackIndicatorOfVisisbleCells;
@end

@interface MusicViewController : UIViewController<AVAudioPlayerDelegate>
{

}
@property (nonatomic, strong) NSMutableArray *musicEntities;
@property (nonatomic, strong) NSMutableArray *sectionlist;

@property (nonatomic, copy) NSString *musicTitle;
@property (nonatomic, strong) DOUAudioStreamer *streamer;
@property (nonatomic, assign) BOOL dontReloadMusic;
@property (nonatomic, assign) NSInteger specialIndex;
@property (nonatomic, copy) NSNumber *parentId;
@property (nonatomic, weak) id<MusicViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isNotPresenting;
@property (nonatomic, assign) MusicCycleType musicCycleType;

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) RDFileTableController *viewController;
@property (strong, nonatomic) UITabBarController *tabBarController;

- (IBAction)didTouchMusicToggleButton:(id)sender;

+ (instancetype)sharedInstance;
- (IBAction)playPreviousMusic:(id)sender;
- (IBAction)playNextMusic:(id)sender;
- (MusicEntity *)currentPlayingMusic;
-(RecordClass*)currentPlayRecord;
-(BOOL)isClassCompleted:(NSString *)classId;
- (IBAction)didTouchMusicToggleButton:(id)sender ;

//下载
- (void)downloadPathCallback:(NSURL*)path Error:(NSError*)error;
- (void)downloadFileLengthCallback:(NSInteger)fileLength Error:(NSError*)error;

@end
