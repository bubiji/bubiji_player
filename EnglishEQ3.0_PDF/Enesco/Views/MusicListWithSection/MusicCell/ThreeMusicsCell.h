//
//  ThreeMusicsCell.h
//  Enesco
//
//  Created by wangjie on 16/6/5.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionClass.h"
#import "NAKPlaybackIndicatorView.h"

@protocol SectionListJumpDelegate <NSObject>
@optional
- (void)jumpTo:(SectionClass *)section index:(NSInteger)index;
@end

@interface ThreeMusicsCell : UITableViewCell
@property (nonatomic, strong) SectionClass *section;
@property (nonatomic, weak) id<SectionListJumpDelegate> delegate;
-(void)change:(RecordClass *)record to:(NAKPlaybackIndicatorViewState)state;
-(void)changeStateWith:(RecordClass*)record;
-(void)showTodayStudyTime;
@end
