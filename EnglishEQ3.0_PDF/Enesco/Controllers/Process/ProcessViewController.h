//
//  ProcessViewController.h
//  Enesco
//
//  Created by wangjie on 16/6/7.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessViewController : UIViewController
@property(nonatomic,strong) IBOutlet UILabel * lblMin;
@property(nonatomic,strong) IBOutlet UILabel * lblTimes;
@property(nonatomic,strong) IBOutlet UILabel * lblChapters;
@property(nonatomic,strong) IBOutlet UILabel * lblDays;
@property(nonatomic,strong) IBOutlet UILabel * lblVersionBuild;
@property(nonatomic,strong) IBOutlet UIProgressView * pgsMoney;
@property(nonatomic,strong) IBOutlet UILabel * lblProcess;

@end
