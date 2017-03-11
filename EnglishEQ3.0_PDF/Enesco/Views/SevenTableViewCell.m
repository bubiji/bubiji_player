//
//  SevenTableViewCell.m
//  Enesco2.2
//
//  Created by wangjie on 16/6/28.
//  Copyright © 2016年 aufree. All rights reserved.
//

#define UIScreenWidth [UIScreen mainScreen ].bounds.size.width
#define UIScreenHeight [UIScreen mainScreen ].bounds.size.height
#import "SevenTableViewCell.h"
#import "ThreeMusicsCell.h"
#import "LessionInfoView.h"

@interface SevenTableViewCell()
@property (nonatomic, strong) LessionInfoView * lession1;
@property (nonatomic, strong) LessionInfoView * lession2;
@property (nonatomic, strong) LessionInfoView * lession3;
@property (nonatomic, strong) LessionInfoView * lession4;
@property (nonatomic, strong) LessionInfoView * lession5;
@property (nonatomic, strong) LessionInfoView * lession6;
@property (nonatomic, strong) LessionInfoView * lession7;
@property (nonatomic, assign) BOOL isCache;
@property (nonatomic, strong) UIImageView * lockImage;
@end

@implementation SevenTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setUpUI];
    }
    
    return self;
}

-(void)setUpUI{
    float l1x = (UIScreenWidth - 150) / 2;
    float l1y = 0;
    float lWidth = 150;
    float lHeight = 190;
    
    _lession1 = [[LessionInfoView alloc] initWithFrame:CGRectMake(l1x, l1y, lWidth, lHeight)];
    
    _lession1.cover.image = [UIImage imageNamed:@"percent_QA"];
    
    [self addSubview:_lession1];
    
    UITapGestureRecognizer *singleRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer1.numberOfTapsRequired = 1;
    [_lession1 addGestureRecognizer:singleRecognizer1];
    
    float l23y = 200;
    
    float l2x =  (UIScreenWidth - 150 * 2) / 3;
    
    _lession2 = [[LessionInfoView alloc] initWithFrame:CGRectMake(l2x, l23y, lWidth, lHeight)];
    
    _lession2.cover.image = [UIImage imageNamed:@"percent_sport"];
    
    [self addSubview:_lession2];
    
    UITapGestureRecognizer *singleRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer2.numberOfTapsRequired = 1;
    [_lession2 addGestureRecognizer:singleRecognizer2];
    
    float l3x = l2x * 2 + 150;
    
    _lession3 = [[LessionInfoView alloc] initWithFrame:CGRectMake(l3x, l23y, lWidth, lHeight)];
    
    _lession3.cover.image = [UIImage imageNamed:@"percent_sport"];
    
    [self addSubview:_lession3];
    
    UITapGestureRecognizer *singleRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer3.numberOfTapsRequired = 1;
    [_lession3 addGestureRecognizer:singleRecognizer3];
    
    float l45y = 400;
    
    float l4x =  (UIScreenWidth - 150 * 2) / 3;
    
    _lession4 = [[LessionInfoView alloc] initWithFrame:CGRectMake(l4x, l45y, lWidth, lHeight)];
    
    _lession4.cover.image = [UIImage imageNamed:@"percent_sport"];
    
    [self addSubview:_lession4];
    
    UITapGestureRecognizer *singleRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer4.numberOfTapsRequired = 1;
    [_lession4 addGestureRecognizer:singleRecognizer4];
    
    float l5x = l4x * 2 + 150;
    
    _lession5 = [[LessionInfoView alloc] initWithFrame:CGRectMake(l5x, l45y, lWidth, lHeight)];
    
    _lession5.cover.image = [UIImage imageNamed:@"percent_sport"];
    
    [self addSubview:_lession5];
    
    UITapGestureRecognizer *singleRecognizer5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer5.numberOfTapsRequired = 1;
    [_lession5 addGestureRecognizer:singleRecognizer5];
    
    float l67y = 600;
    
    float l6x =  (UIScreenWidth - 150 * 2) / 3;
    
    _lession6 = [[LessionInfoView alloc] initWithFrame:CGRectMake(l6x, l67y, lWidth, lHeight)];
    
    _lession6.cover.image = [UIImage imageNamed:@"percent_sport"];
    
    [self addSubview:_lession6];
    
    UITapGestureRecognizer *singleRecognizer6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer6.numberOfTapsRequired = 1;
    [_lession6 addGestureRecognizer:singleRecognizer6];
    
    
    float l7x = l6x * 2 + 150;
    
    _lession7 = [[LessionInfoView alloc] initWithFrame:CGRectMake(l7x, l67y, lWidth, lHeight)];
    
    _lession7.cover.image = [UIImage imageNamed:@"percent_sport"];
    
    [self addSubview:_lession7];
    
    UITapGestureRecognizer *singleRecognizer7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer7.numberOfTapsRequired = 1;
    [_lession7 addGestureRecognizer:singleRecognizer7];
    
    [self setUpLockImage];
}

- (void)setSection:(SectionClass *)section {
    _section = section;
    self.isCache = YES;
    RecordClass *record = (RecordClass *)[section.records objectAtIndex:0];
    if(!record.music){
        record.music = [[MusicEntity alloc] init];
        record.music.name = record.title;
        record.music.artistName = @"Bubiji";
    }
    if(!record.music.musicId){
        self.isCache = NO;
    }
    _lession1.musicEntity = record.music;
    _lession1.record = record;
    _lession1.musicNumber = 1;
    
    record = (RecordClass *)[section.records objectAtIndex:1];
    if(!record.music){
        record.music = [[MusicEntity alloc] init];
        record.music.name = record.title;
        record.music.artistName = @"Bubiji";
    }
    if(!record.music.musicId){
        self.isCache = NO;
    }
    _lession2.musicEntity = record.music;
    _lession2.record = record;
    _lession2.musicNumber = 2;
    
    record = (RecordClass *)[section.records objectAtIndex:2];
    if(!record.music){
        record.music = [[MusicEntity alloc] init];
        record.music.name = record.title;
        record.music.artistName = @"Bubiji";
    }
    if(!record.music.musicId){
        self.isCache = NO;
        
    }
    _lession3.musicEntity = record.music;
    _lession3.record = record;
    _lession3.musicNumber = 3;
    
    record = (RecordClass *)[section.records objectAtIndex:3];
    if(!record.music){
        record.music = [[MusicEntity alloc] init];
        record.music.name = record.title;
        record.music.artistName = @"Bubiji";
    }
    if(!record.music.musicId){
        self.isCache = NO;
        
    }
    _lession4.musicEntity = record.music;
    _lession4.record = record;
    _lession4.musicNumber = 4;
    
    record = (RecordClass *)[section.records objectAtIndex:4];
    if(!record.music){
        record.music = [[MusicEntity alloc] init];
        record.music.name = record.title;
        record.music.artistName = @"Bubiji";
    }
    if(!record.music.musicId){
        self.isCache = NO;
        
    }
    _lession5.musicEntity = record.music;
    _lession5.record = record;
    _lession5.musicNumber = 5;
    
    record = (RecordClass *)[section.records objectAtIndex:5];
    if(!record.music){
        record.music = [[MusicEntity alloc] init];
        record.music.name = record.title;
        record.music.artistName = @"Bubiji";
    }
    if(!record.music.musicId){
        self.isCache = NO;
        
    }
    _lession6.musicEntity = record.music;
    _lession6.record = record;
    _lession6.musicNumber = 6;
    
    record = (RecordClass *)[section.records objectAtIndex:6];
    if(!record.music){
        record.music = [[MusicEntity alloc] init];
        record.music.name = record.title;
        record.music.artistName = @"Bubiji";
    }
    if(!record.music.musicId){
        self.isCache = NO;
        
    }
    _lession7.musicEntity = record.music;
    _lession7.record = record;
    _lession7.musicNumber = 7;
    
    if(self.isCache){
        self.lockImage.hidden = YES;
    }
    else{
        self.lockImage.hidden = NO;
    }
    
}

-(void)setUpLockImage{
    self.lockImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 800)];
    self.lockImage.image = [UIImage imageNamed:@"lock.jpg"];
    [self addSubview:self.lockImage];
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    if(!self.isCache){
        return;
    }
    UIView *tmp = recognizer.view;
    NSInteger index = 0;
    if(tmp == _lession1){
        index = 0;
    }
    else if(tmp == _lession2){
        index = 1;
    }
    else if(tmp == _lession3){
        index =2;
    }
    else if(tmp == _lession4){
        index =3;
    }
    else if(tmp == _lession5){
        index =4;
    }
    else if(tmp == _lession6){
        index =5;
    }
    else if(tmp == _lession7){
        index =6;
    }
    if(self.delegate){
        [self.delegate jumpTo:self.section index:index];
    }
}

-(void)change:(RecordClass *)record to:(NAKPlaybackIndicatorViewState)state{
    [self changeStateWith:record];
}

-(void)changeStateWith:(RecordClass *)record{
    RecordClass * rc = [self.section.records objectAtIndex:0];
    
    if([rc.classId isEqualToString: record.classId]){
        _lession1.state = NAKPlaybackIndicatorViewStatePlaying;
    }
    else{
        _lession1.state = NAKPlaybackIndicatorViewStateStopped;
    }
    
    rc = [self.section.records objectAtIndex:1];
    
    if([rc.classId isEqualToString: record.classId]){
        _lession2.state = NAKPlaybackIndicatorViewStatePlaying;
    }
    else{
        _lession2.state = NAKPlaybackIndicatorViewStateStopped;
    }
    
    rc = [self.section.records objectAtIndex:2];
    
    if([rc.classId isEqualToString: record.classId]){
        _lession3.state = NAKPlaybackIndicatorViewStatePlaying;
    }
    else{
        _lession3.state = NAKPlaybackIndicatorViewStateStopped;
    }
    
    rc = [self.section.records objectAtIndex:3];
    
    if([rc.classId isEqualToString: record.classId]){
        _lession4.state = NAKPlaybackIndicatorViewStatePlaying;
    }
    else{
        _lession4.state = NAKPlaybackIndicatorViewStateStopped;
    }
    
    rc = [self.section.records objectAtIndex:4];
    
    if([rc.classId isEqualToString: record.classId]){
        _lession5.state = NAKPlaybackIndicatorViewStatePlaying;
    }
    else{
        _lession4.state = NAKPlaybackIndicatorViewStateStopped;
    }
    
    rc = [self.section.records objectAtIndex:5];
    
    if([rc.classId isEqualToString: record.classId]){
        _lession6.state = NAKPlaybackIndicatorViewStatePlaying;
    }
    else{
        _lession6.state = NAKPlaybackIndicatorViewStateStopped;
    }
    
    rc = [self.section.records objectAtIndex:6];
    
    if([rc.classId isEqualToString: record.classId]){
        _lession7.state = NAKPlaybackIndicatorViewStatePlaying;
    }
    else{
        _lession7.state = NAKPlaybackIndicatorViewStateStopped;
    }
}

-(void)showTodayStudyTime{
    [_lession1 startStudyLableAnimate];
    [_lession2 startStudyLableAnimate];
    [_lession3 startStudyLableAnimate];
    [_lession4 startStudyLableAnimate];
    [_lession5 startStudyLableAnimate];
    [_lession6 startStudyLableAnimate];
    [_lession7 startStudyLableAnimate];
}

@end
