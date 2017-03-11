//
//  PlanViewCell.m
//  JokePlayer
//
//  Created by apple on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlanViewCell.h"
#import "BaseCell.h"

@implementation PlanViewCell
@synthesize cellButton,soundflag;

-(void)setClassName:(NSString *)newclassName
{
    
    [super setClassName:newclassName];
    classNameLable.text =newclassName;
}

//-(void)setRecomDays:(NSString *)newrecomDays
//{
//    [super setRecomDays:newrecomDays];
//    recomDaysLable.text =newrecomDays;
//}

-(void)setMusicType:(NSString *)newrecomTimes
{
    [super setMusicType:newrecomTimes];
    musicTypeLable.text =newrecomTimes;
}

//-(void)setDidDays:(NSString *)newdidDays
//{
//    [super setDidDays:newdidDays];
//    didDaysLable.text =newdidDays;
//}

-(void)setDidTimes:(NSString *)newdidTimes
{
    [super setDidTimes:newdidTimes];
    
    TimesDaysLable.text =newdidTimes;
}
-(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

- (PlanViewCell*)initCell //:(NSInteger)musicIndex
{
    NSString *cellID =@"PlanView";
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];  
    //view2
    TimesDaysLable = [[UILabel alloc] initWithFrame: CGRectMake( 15, 5, 320, 30)]; 
    TimesDaysLable.backgroundColor =[UIColor clearColor];

    musicTypeLable = [[UILabel alloc] initWithFrame: CGRectMake( 270, 5, 40, 30)];  
    musicTypeLable.backgroundColor =[UIColor clearColor];
 
    //view1
    classNameLable = [[UILabel alloc] initWithFrame: CGRectMake( 0, 0, 320, 40)];
    classNameLable.backgroundColor =[UIColor clearColor];
    cellButton =[[[UIButton alloc]initWithFrame:CGRectMake( 5, 0, 320, 40)]retain];
file://localhost/Users/apple/Dean/0WSI%20ADI/Plan/PlanViewCell.m: error: Semantic Issue: Setter method is needed to assign to object using property assignment syntax

    //cellButton.UserInteractionEnabled =NO ;
    cellButton.titleLabel.text =TimesDaysLable .text;
    cellButton.showsTouchWhenHighlighted = YES;
    [cellButton addSubview:classNameLable];
    
     soundflag =[[UIImageView  alloc ] initWithFrame:CGRectMake(280, 10, 20, 20)];
    soundflag.image=[UIImage imageNamed:@"Icon_speaker.png"];
    soundflag.hidden = YES ;
    AppDelegate *app=    [self getAppDelegate];
    [cellButton addTarget:app.RootDelegate action:@selector(selectAndPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cellButton.titleLabel.backgroundColor =[UIColor clearColor];
    cellButton.titleLabel.shadowColor = [UIColor whiteColor];

    //view1
    UIScrollView  *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 40)];
    mainView.directionalLockEnabled = YES;
    mainView.pagingEnabled = YES;
    mainView.backgroundColor = [UIColor clearColor];//最后面的背景
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    //mainView.delegate = self;
    
    CGSize newSize = CGSizeMake(320 * 2,  40);
    [mainView setContentSize:newSize];
    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 50)];
    //view1.backgroundColor=[[UIColor alloc ]initWithPatternImage:[UIImage imageNamed:@"Rookie1.jpg"]];
    
    //[view1 addSubview:didTimesLable];
    [view1 addSubview:cellButton];
    [view1 addSubview:soundflag];
    [mainView addSubview:view1];
    [view1 release];
    
    UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(320, 0.0, 320, 50)];
 
    [view2 addSubview:TimesDaysLable];
    [TimesDaysLable release];
    [view2 addSubview:musicTypeLable];
    [musicTypeLable release];
    [mainView addSubview:view2];
    [view2 release];
    //mainView.UserInteractionEnabled =NO ;

    [self.contentView addSubview:mainView];
    [mainView release];
    return  self;
}
@end
