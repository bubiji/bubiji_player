//
//  MusicPlayerAppDelegate.h
//  MusicPlayer
//
//  Created by 韩国翔 on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Music.h"

@class MusicPlayerViewController;

@interface MusicPlayerAppDelegate : NSObject <UIApplicationDelegate> {
    NSMutableArray *musiclist;
    AVAudioPlayer *player;
    NSTimer *timer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabViewController;

@property(nonatomic,retain)NSMutableArray *musiclist;
@property(nonatomic,retain)Music *currentMusic;
@property(nonatomic,retain)AVAudioPlayer *player;
@property(nonatomic,retain)NSTimer *timer;

@end
