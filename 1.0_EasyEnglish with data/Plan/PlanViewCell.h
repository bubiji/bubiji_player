//
//  PlanViewCell.h
//  JokePlayer
//
//  Created by apple on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCell.h"
@interface PlanViewCell : BaseCell
{
IBOutlet UILabel *classNameLable;
//IBOutlet UILabel *recomDaysLable;
IBOutlet UILabel *musicTypeLable;
//IBOutlet UILabel *didDaysLable;
IBOutlet UILabel *TimesDaysLable;
    UIButton *cellButton;
    UIImageView * soundflag;
}

@property (nonatomic,retain) UIButton *cellButton;
@property (nonatomic,retain) UIImageView *soundflag;

//- (PlanViewCell*)viewDidLoad;
- (PlanViewCell*)initCell;// :(NSInteger)musicIndex;
@end
