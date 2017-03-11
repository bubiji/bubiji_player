//
//  DAL.m
//  JokePlayer
//
//  Created by apple on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DAL.h"

@implementation DAL
@synthesize appDB=_appDB;


-(id)init{
    
    [super init];
    if (self) {
        
    }
    return self;
}
-(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
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
#pragma -
#pragma update
//这里可能需要构造函数 初始化下appdb

-(void)updateClassTime:(Music*)music
{
    NSString *dbsql =[NSString stringWithFormat:@"update %@ set ClassTime = %f where ClassID = %ld",tableName,music.ClassTime,(long)music.classID]; 
    //NSLog(@"sql time :%@",dbsql);
    [_appDB executeUpdate:dbsql]; 
}
-(void)updateDidTimes:(Music*)music
{
    NSString *dbsql =[NSString stringWithFormat:@"update %@ set DidTimes = '%ld' where ClassID =%ld",tableName,(long)music.DidTimes,(long)music.classID];
    [_appDB executeUpdate:dbsql];  
    
}
-(void)updateDidDays:(Music*)music
{
    NSString *dbsql =[NSString stringWithFormat:@"update %@ set TodayTime = '%@',DidDays =%ld where ClassID =%ld",tableName,music.TodayTime,(long)music.DidDays,(long)music.classID]; 
    [_appDB executeUpdate:dbsql];
}
-(void)updateMusics:(Music*)music
{
    NSString *dbsql =[NSString stringWithFormat:@"update %@ set Type = '%@',ClassTime = %f ,iPodNum = %ld,Path = '%@'  where ClassID =%ld",tableName,music.type,music.ClassTime,(long)music.iPodNum,music.path,(long)music.classID]; 
    //NSLog(@"sql %@",dbsql);

    [_appDB executeUpdate:dbsql];
}

-(void)updateAllDaysofConfigTable:(Music*)music
{
    NSInteger days=[_appDB intForQuery: @"SELECT AllDays FROM ConfigTable where id =0"]; 
    days+=1;
    //更新今天的时间 
    NSString *dbsql =[NSString stringWithFormat:@"update ConfigTable set AllDays = %ld where id =0",(long)days];
    //NSLog(@"sql %@",dbsql);
    [_appDB executeUpdate:dbsql];
    
}

#pragma-
#pragma initList
//重新加载root的时候 需要重新加载这个
-(void)initMusicLit
{
    ////////// 在初始化的时候 恐怕每次都要 去找一下pod的集合 然后把没有的编程灰色 要在cell 上显示一个音乐取得路径
    // 删除的时候询问是完全删除还是只删除文件 为了方便节省空间
    
    FMResultSet *rs=[_appDB executeQuery: [NSString stringWithFormat: @"SELECT * FROM %@ order by classid asc",tableName]];  
    //初始化music list
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    appDelegate.musiclist=[[NSMutableArray alloc] init];
    
    //NSLog(@"documentsDirectory-- %@",documentsDirectory1);
    
    
    while ([rs next]){  
        //NSLog(@"name: %@  id: %@",[rs stringForColumn:@"ClassName"],[rs stringForColumn:@"ClassID"]);  
        Music *music=[[Music alloc] init];
        music.title=[rs stringForColumn:@"ClassName"];
        music.type=[rs stringForColumn:@"Type"];
        if (music.path == nil) {
            music.path=[NSURL URLWithString:[rs stringForColumn:@"Path"]];
        }

        //NSLog(@"-----path :%@",[rs stringForColumn:@"Path"]);

        //[self   checkEveryLesson:music];
        //path 赋值该地方了
        music.classID=[rs intForColumn:@"ClassID"];
        //music.size=[NSString stringWithFormat:@"%d",[fileInfo fileSize]];
        music.tag=[appDelegate.musiclist count]; //标号
        music.ClassTime=[rs longForColumn:@"ClassTime"];      //一共听了多少次

        music.DidTimes=[rs intForColumn:@"DidTimes"];      //一共听了多少次
        music.DidDays=[rs intForColumn:@"DidDays"];      //多少天
        music.BestTimes=[rs intForColumn:@"BestTimes"];      //多少天
        music.BestDays=[rs intForColumn:@"BestDays"];      //多少天
        music.iPodNum=[rs intForColumn:@"iPodNum"];      //多少天

        //NSLog(@"days :%d",music.DidDays);
        //NSLog(@"bestdays :%d",music.BestTimes);
        
        music.section =[rs stringForColumn:@"Section"];
        music.TodayTime=[rs stringForColumn:@"TodayTime"];  
        //music.ClassTime = [ [rs stringForColumn:@"ClassTime"]doubleValue];
        //NSLog(@"class time double :%f",music.ClassTime);
        //今天听过没有
        [appDelegate.musiclist addObject:music] ; //装入数组
        //[music release];
    }  
    [rs close];  
    
    appDelegate.lessonSectionlist=[[NSMutableArray alloc] init];
    
    for (NSString* section in appDelegate.appSectionList) {
        NSMutableArray *newSection =[[NSMutableArray alloc]init];
        for (Music *m in appDelegate.musiclist) {
            //NSLog(@"m.section:%@ == %@ " ,m.section,section);
            if ([m.section  isEqualToString: section])
            {
                [newSection addObject:m];
            }
        }
        // NSLog(@"newSection~~~~~~~~~~~~~%d",[newSection count ]);
        
        [appDelegate.lessonSectionlist addObject:newSection];
    }
    //appDelegate.musicPlayer = [[MusicManager alloc]initWithPlayerType:1 LoadSong:appDelegate.musiclist];
    
    //    [appDelegate.musicPlayer stop]; //一定要先停止, 不然會有問題
    //    [appDelegate.musicPlayer reload:appDelegate.musiclist];
    //    [appDelegate.musicPlayer saveToData];
    //NSLog(@"count~~~~~~~~~~~~~%d",[appDelegate.musiclist count ]);
    //    for (int i=0; i< [musiclist count]; i++) {
    //        Music *m = [musiclist objectAtIndex:i] ;
    //        
    //        NSLog(@"pppp  : %@",m.path);
    //        NSLog(@"export: %i",m.isExport);
    //
    //    }
}


#pragma-
#pragma check every class type
-(void)checkEveryLesson
{
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    for (int i= 0; i<[appDelegate.musiclist count]; i++) {
        Music* m =[appDelegate.musiclist objectAtIndex:i];
        
        if([self checkApp:m])
        {
            m.type =@"App";
        }
        else if ([self checkFile:m]) 
        {
            m.type =@"local";
        }
        else if([self checkiPod:m])
        {
            m.type =@"iPod";
        }
        else 
        {
            m.type =@"none";
            m.path =nil;

        } 
        [self updateMusics:m];
    }
}
-(BOOL)checkApp:(Music*)m   //检查存在 并写入 路径
{
    NSArray *appArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:nil];
    int ipodNum =0;
    for (NSString *song in appArray) {
        NSRange range =[song rangeOfString:m.title]; 
        // NSLog(@"song: %@",song);
        NSString *path =nil;
        
        if (range.location!=NSNotFound) 
        {     
            //NSLog(@"NSBundle: %@",[[NSBundle mainBundle]pathForResource:m.title ofType:@"mp3"]);
            NSRange range=[m.title rangeOfString:@".mp3"];
            if (range.location!=NSNotFound) 
            {
                NSMutableString* stringTemp=[NSMutableString stringWithFormat:m.title];
                [stringTemp deleteCharactersInRange:range];
                path=  [[NSBundle mainBundle]pathForResource:stringTemp ofType:@"mp3"];
                NSURL *url= [NSURL fileURLWithPath:path];
                m.path =url;
                m.iPodNum =ipodNum;
            }
            else 
            {
                return NO;
            }
            return YES;
        }
        ipodNum++;
        
    }
    
    return NO;
}
-(BOOL)checkiPod:(Music*)m   //检查存在 并写入 路径
{
    MPMediaQuery  *iPodQueryItems = [[MPMediaQuery alloc] init];
    
    NSArray *itemsFromGenericQuery = [iPodQueryItems items];
    // NSLog(@"count m:%d", [itemsFromGenericQuery count]);
    int ipodNum =0;
    for (MPMediaItem *song in itemsFromGenericQuery) {
        NSString *songTitle = [NSString stringWithFormat:@"%@.mp3",[song valueForProperty: MPMediaItemPropertyTitle]];
        //        NSLog(@"songTitle:%@",songTitle);
        //        NSLog(@"m.title:%@",m.title);
        
        if ([songTitle isEqualToString:m.title]) {
            NSURL *anUrl = [song valueForProperty:MPMediaItemPropertyAssetURL];
            m.path =anUrl;
            m.iPodNum =ipodNum;
            //m.type=@"iPod";
            m.ClassTime =  [[song valueForProperty:MPMediaItemPropertyPlaybackDuration]doubleValue];
            //NSLog(@"m.ClassTime:%@",m.ClassTime);
            
            return YES;
        }
        ipodNum++;
        
    }
    
    return NO;
}
-(BOOL)checkFile:(Music*)m //检查存在 并写入 路径 并给类型
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    // NSLog(@"file path%@",documentDir);
    
    for (NSString *filename in [fileManager enumeratorAtPath:documentDir]) {
        //NSLog(@"file name%@",filename);
        //NSLog(@"title %@",[NSString stringWithFormat:@"%@.mp3", m.title]);
        //如果从ipod取出来的歌曲 都是这样 那只能统一没有歌曲名了
        if ([filename isEqual: [NSString stringWithFormat:@"%@", m.title]]) {
            // NSLog(@"yes");
            
            NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
            NSString *yourLessonPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", m.title]];
            //NSLog(@"path %@",yourLessonPath);
            m.path=[NSURL fileURLWithPath:yourLessonPath];
            //m.type=@"local";
            
            return YES;
        }
        
    }
    return NO;
}


#pragma -
#pragma section
-(void)initSectionListAndSectionNum
{    
    FMResultSet *rs=[_appDB executeQuery:[NSString stringWithFormat: @"SELECT distinct Section FROM %@",tableName]];  
    //初始化music list
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSMutableArray *items=[[NSMutableArray alloc] init];
    while ([rs next]){  
        
        [items addObject:[rs stringForColumn:@"Section"]] ; //装入数组
        //NSLog(@"section :%@",[rs stringForColumn:@"Section"]);
    }  
    [rs close];  
    
    appDelegate.appSectionList =items;
    //NSLog(@"appSectionList---- num:%d",[appDelegate.appSectionList count]);

    
    //[items release];
    //NSLog(@"%@",appSectionList);
    appDelegate.appSectionNumList =[[NSMutableArray alloc] init];
    
    FMResultSet *numrs=[_appDB executeQuery:[NSString stringWithFormat: @"SELECT  count(0)  as SectionNum FROM  %@ group by Section",tableName]];  
    //NSLog(@"----sql :%@",[NSString stringWithFormat: @"SELECT  count(0)  as SectionNum FROM  @% group by Section",tableName]);
    while ([numrs next]){  
        
        [appDelegate.appSectionNumList addObject:[numrs stringForColumnIndex:0]];
        //        NSLog(@"section string :%@",[numrs stringForColumnIndex:0]);
        //        NSLog(@"sectionint :%d",[numrs intForColumn:@"SectionNum"]);
        //        NSLog(@"secton num :%d",[appSectionNumList count]);
    }  
    [numrs close];  
    //NSLog(@"appSectionNumList---- num:%d",[appDelegate.appSectionNumList count]);

    
}


//把db拷过去
-(void)initappDB
{
    
    // Get the path to the main bundle resource directory.
    
    NSString *pathsToReources = [[NSBundle mainBundle] resourcePath];
    //NSLog(@"pathsToReources-- %@",pathsToReources);
    
    NSString *yourOriginalDatabasePath = [pathsToReources stringByAppendingPathComponent:@"ClassDB.sqlite3"];
    // NSLog(@"yourOriginalDatabasePath-- %@",yourOriginalDatabasePath);
    
    // Create the path to the database in the Documents directory.
    
    NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
    
    //NSLog(@"documentsDirectory-- %@",documentsDirectory1);
    
    NSString *yourNewDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"ClassDB.sqlite3"];
    NSLog(@"yourNewDatabasePath --%@",yourNewDatabasePath);//这是新的数据库路径
    
    if (![[NSFileManager defaultManager] isReadableFileAtPath:yourNewDatabasePath]) {
        
        if ([[NSFileManager defaultManager] copyItemAtPath:yourOriginalDatabasePath toPath:yourNewDatabasePath error:NULL] != YES)
            
            NSAssert2(0, @"Fail to copy database from %@ to %@", yourOriginalDatabasePath, yourNewDatabasePath);
        
    } 
    //dbPath： 数据库路径，在Document中。  
    //NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"ClassDB" ofType:@"sqlite3"];
    
    //[documentDirectory stringByAppendingPathComponent:@"ClassDB.sqlite3"];
    //NSLog(@"path %@",dbPath);
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"  
    FMDatabase *db= [FMDatabase databaseWithPath:yourNewDatabasePath] ;  
    _appDB =[db retain];//这里retain 是不是永远不能释放拉 ？？？
    //这里把代码给委托 然后随时可以操作
    if (![db open]) {  
        NSLog(@"Could not open db.");  
        return ;  
    }  
    //
    //    FMResultSet *rs=[db executeQuery:@"SELECT * FROM ClassTable"];  
    //    while ([rs next]){  
    //        NSLog(@"name: %@  id: %@",[rs stringForColumn:@"ClassName"],[rs stringForColumn:@"ClassID"]);  
    //   
    //    }  
    //    [rs close];  
    //[self readFileList ];
    
}

-(void)readFileList
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    //    NSLog(@"a")
    NSError *error = nil;
    //NSArray *fileList = [[[NSArray alloc] init]autorelease];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    
    
    
    
    //以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    
    [_appDB executeUpdate:[NSString stringWithFormat: @"DELETE FROM @%",tableName]]; 
    
    
    NSMutableArray *dirArray = [[[NSMutableArray alloc] init]autorelease];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *path = [documentDir stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) { //并且判断 他是否包含text 包含就不读取
            [dirArray addObject:file];
            //只要是文件 就进去读他的所有文件
            
            //NSLog(@"file path :%@",path);
            
            for (NSString *filename in [fileManager enumeratorAtPath:path]) {
                
                if ([[filename pathExtension]isEqual: @"mp3"]) {
                    
                    //[files addObject: filename];
                    
                    //                    [db executeUpdate:@"INSERT INTO User (Name,Age) VALUES (?,?)",@"老婆",[NSNumber numberWithInt:20]] 
                    NSString *dbsql =[NSString stringWithFormat:@"INSERT INTO %@ (ClassName,Section,DidTimes,DidDays,BestTimes,BestDays ) VALUES ('%@','%@',0,0,30,10)",tableName,filename,file];
                    
                    NSLog(@"sql name :%@",dbsql);
                    NSLog(@"path :%@",_appDB.databasePath);

                     
                    [_appDB executeUpdate:dbsql]; 
                   
                }
                
            }            
        }
        isDir = NO;
    }
    //    NSLog(@"Every Thing in the dir:%@",fileList);
    //    NSLog(@"All folders:%@",dirArray);
    
    ////days+1  这里要加一个  如果播放时间超过歌曲的总长度80% 才算播放一次
    //    appDelegate.currentMusic.DidTimes+=1;
    //    NSInteger ClassID=   appDelegate.currentMusic.classID;
    //    //NSLog(@"didTime =1111---%d ",appDelegate.currentMusic.DidTimes);
    //    
    //    NSString *dbsql =[NSString stringWithFormat:@"update ClassTable set DidTimes = '%d' where ClassID =%d",appDelegate.currentMusic.DidTimes,ClassID]; 
    //    [appDelegate.appDB executeUpdate:dbsql];  
    //[fileList release ];//这里释放资源不知道 是否有问题
}
@end
