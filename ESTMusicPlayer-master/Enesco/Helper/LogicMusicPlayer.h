//
//  LogicMusicPlayer.h
//  Enesco
//
//  Created by wangjie on 16/6/6.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogicMusicPlayer : NSObject
+(LogicMusicPlayer *)createLogicMusicPlayer;
-(instancetype)init;
-(void)play;
-(void)pause;
-(void)stop;
-(void)seekTo:(NSTimeInterval)time;
-(void)buffer;
-(NSTimeInterval)getPlayDuration;
@end

@interface Watch : NSObject
-(void)start;
-(void)pause;
-(void)stop;
-(void)reSet;
-(NSTimeInterval)getTime;
@end

