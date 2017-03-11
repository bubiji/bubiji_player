//
//  MusicListWithSectionCellTableViewCell.m
//  Enesco
//
//  Created by wangjie on 16/6/2.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import "MusicListWithSectionCellTableViewCell.h"
#import "Helper.h"

@interface MusicListWithSectionCellTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *musicNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicArtistLabel;
@property (weak, nonatomic) IBOutlet NAKPlaybackIndicatorView *musicIndicator;

@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property (weak, nonatomic) IBOutlet UILabel *needTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *DaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *needDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@end

@implementation MusicListWithSectionCellTableViewCell

- (void)setMusicNumber:(NSInteger)musicNumber {
    _musicNumber = musicNumber;
    _musicNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)musicNumber];
    if (musicNumber > 999) {
        _musicNumberLabel.font = [UIFont systemFontOfSize:13];
    }
}

- (void)setMusicEntity:(MusicEntity *)musicEntity {
    _musicEntity = musicEntity;
    _musicTitleLabel.text = _musicEntity.name;
    _musicArtistLabel.text = _musicEntity.artistName;
}

- (void)setRecord:(RecordClass *)record{
    _record = record;
    _timesLabel.text = [NSString stringWithFormat:@"%ld",record.DidTimes];
    _needTimesLabel.text = [NSString stringWithFormat: @"/%ld",record.BestTimes];
    _DaysLabel.text = [NSString stringWithFormat:@"%ld",record.DidDays];
    _needDaysLabel.text = [NSString stringWithFormat: @"/%ld",record.BestDays];
    _durationLabel.text =[NSString stringWithFormat: @"%@",[Helper getTimeStringFromSecond: (long)(record.DidTimes * record.ClassTime)]];
}

- (NAKPlaybackIndicatorViewState)state {
    return self.musicIndicator.state;
}

- (void)setState:(NAKPlaybackIndicatorViewState)state {
    self.musicIndicator.state = state;
    self.musicNumberLabel.hidden = (state != NAKPlaybackIndicatorViewStateStopped);
}

@end

