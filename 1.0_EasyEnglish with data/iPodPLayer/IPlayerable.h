//
//  IPlayerable.h
//  JokePlayer
//
//  Created by apple on 12-2-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IPlayerable <NSObject>

-(void)play:(Music*)music;
-(void)playsPlay;
-(void)playsPause;
- (void)playsstop;
-(void)playsPause;
//-(void)playsprev;
//-(void)playsnext;
-(double)getClassTime;
-(double)getCurrentTime;
-(void)setCurrent:(float)value;
-(void)setVolume:(float)value;

@end
