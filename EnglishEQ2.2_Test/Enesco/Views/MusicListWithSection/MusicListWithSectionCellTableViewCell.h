//
//  MusicListWithSectionCellTableViewCell.h
//  Enesco
//
//  Created by wangjie on 16/6/2.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicListCell.h"
#import "RecordClass.h"

@interface MusicListWithSectionCellTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger musicNumber;
@property (nonatomic, strong) MusicEntity *musicEntity;
@property (nonatomic, strong) RecordClass *record;
@property (nonatomic, weak) id<MusicListCellDelegate> delegate;
@property (nonatomic, assign) NAKPlaybackIndicatorViewState state;
@end
