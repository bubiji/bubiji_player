//
//  DAL.h
//  JokePlayer
//
//  Created by apple on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordClass.h"
#import "FMdatabase.h"

static const NSString *tableName=@"PETable";

@interface DAL : NSObject
{
    FMDatabase *_appDB;
}
@property (nonatomic, retain) FMDatabase *appDB;

//单例模式
+ (instancetype)shareInstance;

//更新课长时间

-(void)updateRecord:(RecordClass*)record;

-(void)updateClassTime:(RecordClass*)music;
//update class didtimes & didDays
-(void)updateDidTimes:(RecordClass*)music;
-(void)updateDidDays:(RecordClass*)music;

//更新配置表中的全部天数
-(void)updateAllDaysofConfigTable:(RecordClass*)music;

//获取音乐列表
-(NSMutableArray *)getMusicList;

//获取章节列表
-(NSMutableArray *)getMusicSessionList;

-(RecordClass *)getRecrodWith:(NSString*)recordID;

//get
-(NSString*)getUsedTime;
-(NSString*)getAllTimes;
-(NSInteger)getAllDays;
-(NSInteger)getListenChapterCount;
-(NSInteger)getStudyTime:(NSString*)recordID;
-(NSInteger)AddStudyTime:(NSInteger)second to:(NSString *)recordID;
-(double)getRewardWith:(NSString*) recordID;
-(void)addReward:(double)money to:(NSString*)recordID;
-(double)getAllReward;
@end
