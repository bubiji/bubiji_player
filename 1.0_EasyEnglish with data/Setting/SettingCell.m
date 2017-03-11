//
//  SettingCell.m
//  JokePlayer
//
//  Created by apple on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

-(void)setSettingName:(NSString *)newsettingName
{
    [super setSettingName:newsettingName];
   // NSLog(@"%@",newsettingName);
    settingNameLable.text =newsettingName;

}

-(void)setSettingValue:(NSString *)newsettingValue
{
    [super setSettingValue:newsettingValue];
    settingValueLable.text =newsettingValue;
}

@end
