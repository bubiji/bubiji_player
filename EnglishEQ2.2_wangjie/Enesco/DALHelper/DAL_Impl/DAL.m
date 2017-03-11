//
//  DAL.m
//  JokePlayer
//
//  Created by apple on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DAL.h"
#import "RecordClass.h"
#import "SectionClass.h"
@implementation DAL{
    NSMutableArray *cacheMusicList;
}


-(id)init{
    
    self = [super init];
    if (self) {
        [self initappDB];
    }
    return self;
}

+ (instancetype)shareInstance {
    static dispatch_once_t pred;
    static DAL *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma -
#pragma get

-(NSString*)getUsedTime
{
    
    return  [_appDB stringForQuery: [NSString stringWithFormat: @"SELECT sum(ClassTime*DidTimes) as times FROM %@ where DidTimes >0 ",tableName]];
    
}
-(NSString*)getAllTimes
{
    return    [_appDB stringForQuery:[ NSString stringWithFormat: @"SELECT sum(DidTimes) FROM %@ ",tableName]];
    
}
-(NSInteger)getAllDays
{
    return     [_appDB intForQuery: @"SELECT AllDays FROM ConfigTable where id =0"];
    
}

-(NSInteger)getListenChapterCount{
    return [_appDB intForQuery:[NSString stringWithFormat: @"SELECT distinct Section FROM %@ where DidTimes > 0",tableName]];
    
}
#pragma -
#pragma update
//这里可能需要构造函数 初始化下appdb

-(void)update3class:(RecordClass*)music
{
    NSString *dbsql =[NSString stringWithFormat:@"update %@ set ClassTime = %ld where ClassID = %@",tableName,(long)music.ClassTime,music.classId];
    //NSLog(@"sql time :%@",dbsql);
    [_appDB executeUpdate:dbsql];
}


-(void)updateClassTime:(RecordClass*)music
{
    NSString *dbsql =[NSString stringWithFormat:@"update %@ set ClassTime = %ld where ClassID = %@",tableName,(long)music.ClassTime,music.classId];
    //NSLog(@"sql time :%@",dbsql);
    [_appDB executeUpdate:dbsql];
}

-(void)updateRecord:(RecordClass*)Record
{
    [self updateDidTimes:Record];
    [self updateDidDays:Record];
    [self updateRecordDurationTime:Record];
    
}
-(void)updateDidTimes:(RecordClass*)Record
{
    NSString *dbsql =[NSString stringWithFormat:@"update %@ set DidTimes = '%ld' where ClassID =%@",tableName,(long)Record.DidTimes,Record.classId];
    [_appDB executeUpdate:dbsql];
    
}

-(void)updateDidDays:(RecordClass*)Record
{
    NSString *dbsql =[NSString stringWithFormat:@"update %@ set TodayTime = '%ld',DidDays ='%ld' where ClassID =%@",tableName,(long)Record.TodayTimes,(long)Record.DidDays,Record.classId];
    [_appDB executeUpdate:dbsql];
}
-(void)updateRecordDurationTime:(RecordClass*)Record
{
    NSString *dbsql =[NSString stringWithFormat:@"update %@ set Type = '%@',ClassTime = %ld ,iPodNum = %d,Path = '%@'  where ClassID =%ld",tableName,@"",(long)Record.ClassTime,0,@"",(long)Record.classId];
    //NSLog(@"sql %@",dbsql);
    
    [_appDB executeUpdate:dbsql];
}

-(void)updateAllDaysofConfigTable:(RecordClass*)music
{
    NSInteger days=[_appDB intForQuery: @"SELECT AllDays FROM ConfigTable where id =0"];
    days+=1;
    //更新今天的时间
    NSString *dbsql =[NSString stringWithFormat:@"update ConfigTable set AllDays = %ld where id =0",(long)days];
    //NSLog(@"sql %@",dbsql);
    [_appDB executeUpdate:dbsql];
    
}

-(double)getRewardWith:(NSString*) recordID{
    NSString *sql = [NSString stringWithFormat: @"SELECT * FROM %@ where classid = %@",tableName,recordID];
    FMResultSet *rs= [_appDB executeQuery:sql];
    
    if([rs next]){
        return [rs doubleForColumn:@"Reward"];
    }
    
    return 0.0;
}

-(void)addReward:(double)money to:(NSString*)recordID
{
    double reward = [self getRewardWith:recordID];
    
    reward = reward + money;

    NSString *sql = [NSString stringWithFormat: @"update %@ set Reward = %f where classid = %@",tableName,reward,recordID];

    [_appDB executeUpdate:sql];
}

-(double)getAllReward{
    NSString *sql = [NSString stringWithFormat: @"SELECT sum(Reward) as money FROM %@",tableName];
    FMResultSet *rs= [_appDB executeQuery:sql];
    if([rs next]){
        return [rs doubleForColumn:@"money"];
    }
    
    return 0.0;
}

-(RecordClass *)getRecrodWith:(NSString*)recordID
{
    FMResultSet *rs=[_appDB executeQuery: [NSString stringWithFormat: @"SELECT * FROM %@ where classid = %@  order by classid asc",tableName,recordID]];
    RecordClass *record = nil;
    if([rs next]){
        //NSLog(@"name: %@  id: %@",[rs stringForColumn:@"ClassName"],[rs stringForColumn:@"ClassID"]);
        record=[[RecordClass alloc] init];
        record.classId=[rs stringForColumn:@"classid"];
        record.tag =[rs intForColumn:@"classid"];
        record.title=[rs stringForColumn:@"ClassName"];
        record.ClassTime=[rs longForColumn:@"ClassTime"];      //一共听了多少次
        record.DidTimes=[rs intForColumn:@"DidTimes"];      //一共听了多少次
        record.DidDays=[rs intForColumn:@"DidDays"];      //多少天
        record.BestTimes=[rs intForColumn:@"BestTimes"];      //多少天
        record.BestDays=[rs intForColumn:@"BestDays"];      //多少天
        record.section =[rs stringForColumn:@"Section"];
        record.TodayTimes=[rs stringForColumn:@"TodayTime"];
        record.AllStudyDays =[rs intForColumn:@"AllStudyDays"];
        record.AllStudyTime = [rs intForColumn:@"AllStudyTime"];
        record.Reward = [rs doubleForColumn:@"Reward"];
        
    }
    [rs close];
    return record;
}

#pragma section

//获取章节名称列表
-(NSMutableArray *)getSessionNameList
{
    FMResultSet *rs=[_appDB executeQuery:[NSString stringWithFormat: @"SELECT distinct Section FROM %@",tableName]];
    
    NSMutableArray *items=[[NSMutableArray alloc] init];
    while ([rs next]){
        
        [items addObject:[rs stringForColumn:@"Section"]] ; //装入数组
        //NSLog(@"section :%@",[rs stringForColumn:@"Section"]);
    }
    [rs close];
    
    return items;
}


-(NSInteger)getStudyTime:(NSString*)recordID{
    
    NSString *sql = [NSString stringWithFormat: @"SELECT AllStudyTime FROM %@ where classid = %@",tableName,recordID];
    
    NSInteger studyTime=[_appDB intForQuery: sql];
    
    return studyTime;
}

-(NSInteger)AddStudyTime:(NSInteger)second to:(NSString *)recordID{
    
    NSInteger currentStudyTime = [self getStudyTime:recordID];
    currentStudyTime +=second;
    NSString *sql = [NSString stringWithFormat: @"update %@ set AllStudyTime = %ld where classid = %@",tableName,currentStudyTime,recordID];
    
    [_appDB executeQuery:sql];
    
    return currentStudyTime;
}

#pragma getMusicSessionList
//获取音乐章节列表
-(NSMutableArray *)getMusicList
{
    
    FMResultSet *rs=[_appDB executeQuery: [NSString stringWithFormat: @"SELECT * FROM %@ order by classid asc",tableName]];
    
    NSMutableArray *musiclist=[[NSMutableArray alloc] init];
    
    //NSLog(@"documentsDirectory-- %@",documentsDirectory1);
    
    
    while ([rs next]){
        //NSLog(@"name: %@  id: %@",[rs stringForColumn:@"ClassName"],[rs stringForColumn:@"ClassID"]);
        RecordClass *music=[[RecordClass alloc] init];
        music.title=[rs stringForColumn:@"ClassName"];
        music.classId = [rs stringForColumn:@"classid"];
        music.tag=[musiclist count]; //标号
        music.ClassTime=[rs longForColumn:@"ClassTime"];      //一共听了多少次
        
        music.DidTimes=[rs intForColumn:@"DidTimes"];      //一共听了多少次
        music.DidDays=[rs intForColumn:@"DidDays"];      //多少天
        music.BestTimes=[rs intForColumn:@"BestTimes"];      //多少天
        music.BestDays=[rs intForColumn:@"BestDays"];      //多少天
        music.section =[rs stringForColumn:@"Section"];
        music.TodayTimes=[rs stringForColumn:@"TodayTime"];
        music.AllStudyDays =[rs intForColumn:@"AllStudyDays"];
        music.AllStudyTime = [rs intForColumn:@"AllStudyTime"];
        music.Reward = [rs doubleForColumn:@"Reward"];
        
        [musiclist addObject:music] ; //装入数组    }
        
    }
    [rs close];
    return musiclist;
    
}

#pragma -

-(NSMutableArray *)getMusicSessionList
{
    NSMutableArray *musicList = [self getMusicList];
    
    NSMutableArray *sectionNameList = [self getSessionNameList];
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:30];
    
    for (NSString *name in sectionNameList) {
        SectionClass * section = [[SectionClass alloc] init];
        section.sectionName = name;
        section.records = [NSMutableArray array];
        for (RecordClass *record in musicList) {
            if([name isEqualToString:record.section]){
                [section.records addObject:record];
            }
        }
        [result addObject:section];
    }
    
    return result;
}



//把db拷过去
-(void)initappDB
{
    
    // Get the path to the main bundle resource directory.
    
    NSString *pathsToReources = [[NSBundle mainBundle] resourcePath];
    //NSLog(@"pathsToReources-- %@",pathsToReources);
    
    NSString *yourOriginalDatabasePath = [pathsToReources stringByAppendingPathComponent:@"ClassDB.sqlite3"];
    
    NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
    
    //NSLog(@"documentsDirectory-- %@",documentsDirectory1);
    
    NSString *yourNewDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"ClassDB.sqlite3"];
    NSLog(@"yourNewDatabasePath --%@",yourNewDatabasePath);//这是新的数据库路径
    
    if (![[NSFileManager defaultManager] isReadableFileAtPath:yourNewDatabasePath]) {
        
        if ([[NSFileManager defaultManager] copyItemAtPath:yourOriginalDatabasePath toPath:yourNewDatabasePath error:NULL] != YES)
            
            NSAssert2(0, @"Fail to copy database from %@ to %@", yourOriginalDatabasePath, yourNewDatabasePath);
        
    }
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    _appDB= [FMDatabase databaseWithPath:yourNewDatabasePath] ;
    //这里把代码给委托 然后随时可以操作
    if (![_appDB open]) {
        NSLog(@"Could not open db.");
        return ;
    }  
    
    
}

@end
