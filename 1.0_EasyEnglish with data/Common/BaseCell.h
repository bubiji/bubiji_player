//
//  BaseCell.h
//  JokePlayer
//
//  Created by apple on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseCell : UITableViewCell
{
    NSString * className;
    NSString * recomDays;
    NSString * musicType;
    NSString * didDays;
    NSString * didTimes;

    //setting
    NSString *settingName;
    NSString *settingValue;

}
@property (nonatomic,retain) NSString *className;
@property (nonatomic,retain) NSString *recomDays;
@property (nonatomic,retain) NSString *musicType;
@property (nonatomic,retain) NSString *didDays;
@property (nonatomic,retain) NSString *didTimes;
//setting
@property (nonatomic,retain) NSString *settingName;
@property (nonatomic,retain) NSString *settingValue;


@end
