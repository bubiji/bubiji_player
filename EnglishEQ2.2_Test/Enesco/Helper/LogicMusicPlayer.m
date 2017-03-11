//
//  LogicMusicPlayer.m
//  Enesco
//
//  Created by wangjie on 16/6/6.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import "LogicMusicPlayer.h"

@implementation LogicMusicPlayer{
    Watch *watcher;
}
+(LogicMusicPlayer *)createLogicMusicPlayer{
    return [[[self class] alloc] init];
}
-(instancetype)init{
    self = [super init];
    if(self){
        watcher = [[Watch alloc] init];
    }
    return self;
}
-(void)play{
    [watcher start];
}
-(void)pause{
    [watcher pause];
}
-(void)stop{
    [watcher stop];
}
-(void)seekTo:(NSTimeInterval)time{
    [watcher pause];
}
-(void)buffer{
    [watcher pause];
}
-(NSTimeInterval)getPlayDuration{
    return [watcher getTime];
}
@end

@implementation Watch{
    BOOL isStart;
    BOOL isPause;
    BOOL isStop;
    NSTimeInterval startTime;
    NSTimeInterval duration;
}
-(void)start{
    if(isStop){
        [self reSet];
    }
    if(isStart && isPause){
        startTime = [[NSDate date] timeIntervalSince1970];
        isPause = NO;
        return;
    }
    else if(isStart){
        return ;
    }
    isStart = YES;
    startTime = [[NSDate date] timeIntervalSince1970];
}
-(void)pause{
    if(isStop){
        return;
    }
    if(!isStart || isPause){
        return;
    }
    isPause = YES;
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    duration += now - startTime;
    startTime = now;
}
-(void)stop{
    if(isStop){
        return;
    }
    if(!isPause){
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        duration += now - startTime;
        startTime = now;
    }
    isStop = YES;
    isStart = NO;
    isPause = NO;
}
-(void)reSet{
    isStart = NO;
    isStop = NO;
    isPause = NO;
    duration =0;
    startTime =0;
}
-(NSTimeInterval)getTime{
    if(isStop || isPause){
        return duration;
    }
    else if(isStart){
        return duration + [[NSDate date] timeIntervalSince1970] - startTime;
    }
    return 0;
}
@end
