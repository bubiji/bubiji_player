//
//  LessionInfoView.h
//  Enesco
//
//  Created by wangjie on 16/6/5.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicListCell.h"
#import "RecordClass.h"

@interface LessionInfoView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *cover;
@property (nonatomic, assign) NSInteger musicNumber;
@property (nonatomic, strong) MusicEntity *musicEntity;
@property (nonatomic, strong) RecordClass *record;
@property (nonatomic, assign) NAKPlaybackIndicatorViewState state;
-(void)startStudyLableAnimate;
-(void)stopStudyLableAnimate;
@end
