//
//  DAL.h
//  JokePlayer
//
//  Created by apple on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Music.h"
#import "FMdatabase.h"

static const NSString *tableName=@"PETable";

@interface DAL : NSObject
{
    FMDatabase *_appDB;
}
@property (nonatomic, retain) FMDatabase *appDB;
-(void)initappDB;

//更新课长时间
-(void)updateClassTime:(Music*)music;
//update class didtimes & didDays
-(void)updateDidTimes:(Music*)music;
-(void)updateDidDays:(Music*)music;

//更新配置表中的全部天数
-(void)updateAllDaysofConfigTable:(Music*)music;

//////////////////////////////init
//每个section num
-(void)initMusicLit;
-(void)checkEveryLesson;
-(BOOL)checkApp:(Music*)m;   //检查存在 并写入 路径
-(BOOL)checkiPod:(Music*)m;   //检查存在 并写入 路径
-(BOOL)checkFile:(Music*)m; //检查存在 并写入 路径 并给类型

-(void)initSectionListAndSectionNum;
-(void)readFileList;

//get
-(NSString*)getUsedTime;
-(NSString*)getAllTimes;
-(NSInteger)getAllDays;
@end
