//
//  LessionInfoView.m
//  Enesco
//
//  Created by wangjie on 16/6/5.
//  Copyright © 2016年 aufree. All rights reserved.
//

#define UIScreenWidth [UIScreen mainScreen ].bounds.size.width
#define UIScreenHeight [UIScreen mainScreen ].bounds.size.height
#define SysVersion [[UIDevice currentDevice].systemVersion floatValue]

#import "LessionInfoView.h"
#import "Helper.h"
#import "MusicViewController.h"

@interface LessionInfoView ()
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet NAKPlaybackIndicatorView *musicIndicator;

@property (strong, nonatomic) IBOutlet UILabel *timesLabel;
@property (strong, nonatomic) IBOutlet UILabel *daysLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *todayStudyTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addOneTimeLable;
@end

@implementation LessionInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUpImage];
        [self setUpDidDays];
        [self setUpDidTimes];
        [self setUpDuration];
        //[self setUpNumber];
        [self setUpTitle];
        [self setUpIndicator];
        [self setUpTodayStudy];
        [self setUpStudyOneTime];
    }
    return self;
}

-(void)setUpImage{
    
    self.cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 40)];
//    self.cover.layer.masksToBounds = YES;
//    self.cover.layer.cornerRadius = self.frame.size.width / 2;
//    self.cover.layer.borderWidth = 1.0;
    //self.cover.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self addSubview:self.cover];
}

-(void)setUpTodayStudy{
    
    self.todayStudyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 70, self.frame.size.width,20)];
    [self addSubview:self.todayStudyTimeLabel];
    self.todayStudyTimeLabel.font = [UIFont fontWithName:@"Aladdin" size:24.0];//[UIFont systemFontOfSize:30];
    
    self.todayStudyTimeLabel.textAlignment = NSTextAlignmentCenter;
}


-(void)setUpStudyOneTime{
    
    self.addOneTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 70, self.frame.size.width,20)];
    self.addOneTimeLable.text = @"+1";
    [self addSubview:self.addOneTimeLable];
    self.addOneTimeLable.font = [UIFont fontWithName:@"Aladdin" size:24.0];//[UIFont systemFontOfSize:30];
    
    self.addOneTimeLable.textAlignment = NSTextAlignmentCenter;
    [self.addOneTimeLable setAlpha: 0.0];
    self.addOneTimeLable.textColor = [UIColor redColor];
}

-(void)setUpIndicator{
    
    self.musicIndicator = [[NAKPlaybackIndicatorView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 100, self.frame.size.width,20)];
    self.musicIndicator.tintColor = [UIColor redColor];
    [self addSubview:self.musicIndicator];
    
    //self.musicIndicator.backgroundColor = [UIColor clearColor];
}

-(void)setUpTitle{
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 40)];
    [self addSubview:self.title];
    self.title.layer.masksToBounds = YES;
    self.title.layer.cornerRadius = self.frame.size.width / 2;
    self.title.layer.borderWidth = 1.0;
    self.title.layer.borderColor = [[UIColor whiteColor] CGColor];
    //self.title.font = [UIFont fontWithName:@"BravoScriptSSK" size:40];//[UIFont systemFontOfSize:30];
    self.title.font = [UIFont fontWithName:@"Aladdin" size:50.0];//[UIFont systemFontOfSize:30];
    
    self.title.textAlignment = NSTextAlignmentCenter;
}

-(void)setUpDidTimes{
    
    self.timesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height -20, self.frame.size.width /2, 20)];
    [self addSubview:self.timesLabel];
    //self.timesLabel.font =[UIFont systemFontOfSize:18];
    self.timesLabel.font = [UIFont fontWithName:@"Aladdin" size:23];//[UIFont systemFontOfSize:30];

    self.timesLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)setUpDidDays{
    
    self.daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, self.frame.size.height -20, self.frame.size.width / 2 , 20)];
    [self addSubview:self.daysLabel];
    self.daysLabel.font = [UIFont fontWithName:@"Aladdin" size:23];//[UIFont systemFontOfSize:18];
    self.daysLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)setUpDuration{
    
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width , 20)];
    [self addSubview:self.durationLabel];
    self.durationLabel.font = [UIFont fontWithName:@"Aladdin" size:25];//[UIFont systemFontOfSize:18];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setMusicEntity:(MusicEntity *)musicEntity {
    _musicEntity = musicEntity;
    //NSURL *imageUrl = [NSURL URLWithString:musicEntity.cover];
    //[self.cover sd_setImageWithURL:imageUrl];
    
    self.title.text = musicEntity.name;
}

- (void)setRecord:(RecordClass *)record{
    _record = record;
    self.timesLabel.text = [NSString stringWithFormat:@"%ld/%ld",_record.DidTimes,_record.BestTimes];
    
    self.daysLabel.text = [NSString stringWithFormat:@"%ld/%ld",_record.DidDays,_record.BestDays];
    
    self.durationLabel.text =[NSString stringWithFormat: @"%@",[Helper getTimeStringFromSecond: (long)(record.DidTimes * record.ClassTime)]];
    
    self.todayStudyTimeLabel.text =[NSString stringWithFormat: @"+%ld",[Helper getTodayStudyTimeWith:_record.classId]];
    self.todayStudyTimeLabel.textColor = [UIColor redColor];
}

- (NAKPlaybackIndicatorViewState)state {
    return self.musicIndicator.state;
}

- (void)setState:(NAKPlaybackIndicatorViewState)state {
//    if(self.musicIndicator.state == state){
//        return;
//    }
    if(state == NAKPlaybackIndicatorViewStatePlaying){
        [self startStudyLableAnimate];
    }
    else{
        [self stopStudyLableAnimate];
    }
//    if(self.musicIndicator.state == NAKPlaybackIndicatorViewStatePlaying && state == NAKPlaybackIndicatorViewStateStopped){
//        BOOL isStudyOK = [[MusicViewController sharedInstance] isClassCompleted:_record.classId];
//        if(isStudyOK){
//            [self startAddOneTimeStudyLableAnimate];
//        }
//        
//    }
    self.musicIndicator.state = state;

}

-(void)startStudyLableAnimate{
    [self.todayStudyTimeLabel setAlpha:1.0];
    [self setNeedsDisplay];
    [UIView animateWithDuration:3.0 // 动画时长
                          delay:1.0 // 动画延迟
                        options:UIViewAnimationOptionCurveEaseIn // 动画过渡效果
                     animations:^{
                         [self.todayStudyTimeLabel setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         // 动画完成后执行
                         // code...
                     }];
}

-(void)startAddOneTimeStudyLableAnimate{
    [self.addOneTimeLable setAlpha:1.0];
    [UIView animateWithDuration:3.0 // 动画时长
                          delay:1.0 // 动画延迟
                        options:UIViewAnimationOptionCurveEaseIn // 动画过渡效果
                     animations:^{
                         [self.addOneTimeLable setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         // 动画完成后执行
                         // code...
                         //[self.addOneTimeLable setAlpha:0.0];
                     }];
}

-(void)stopStudyLableAnimate{
    //[self.todayStudyTimeLabel setAlpha:0];
}

@end
