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

@protocol MusicViewControllerDelegate <NSObject>
@optional
- (void)updatePlaybackIndicatorOfVisisbleCells;
@end

@interface MusicViewController : UIViewController<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableArray *musicEntities;
@property (nonatomic, strong) NSMutableArray *sectionlist;

@property (nonatomic, copy) NSString *musicTitle;
@property (nonatomic, assign) BOOL dontReloadMusic;
@property (nonatomic, assign) NSInteger specialIndex;
@property (nonatomic, copy) NSNumber *parentId;
@property (nonatomic, weak) id<MusicViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isNotPresenting;
@property (nonatomic, assign) MusicCycleType musicCycleType;
@property (nonatomic) NSTimeInterval AlreadyTime ;




+ (instancetype)sharedInstance;

- (IBAction)didTouchMusicToggleButton:(id)sender;
- (IBAction)playPreviousMusic:(id)sender;
- (IBAction)playNextMusic:(id)sender;
- (MusicEntity *)currentPlayingMusic;
@end
