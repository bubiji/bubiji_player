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

@protocol MusicViewControllerDelegate <NSObject>
@optional
- (void)updatePlaybackIndicatorOfVisisbleCells;
@end

@interface MusicViewController : UIViewController<AVAudioPlayerDelegate>

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
- (IBAction)didTouchMusicToggleButton:(id)sender;

+ (instancetype)sharedInstance;
- (IBAction)playPreviousMusic:(id)sender;
- (IBAction)playNextMusic:(id)sender;
- (MusicEntity *)currentPlayingMusic;
-(RecordClass*)currentPlayRecord;
-(BOOL)isClassCompleted:(NSString *)classId;
- (IBAction)didTouchMusicToggleButton:(id)sender ;

@end
