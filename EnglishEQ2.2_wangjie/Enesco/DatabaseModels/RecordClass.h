//
//  Music.h
//  MusicPlayer
//
//  Created by  on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicEntity.h"


@interface RecordClass : NSObject {

}

//id recorddata = @{@"recordId": @"123",@"classId":@"123",@"duration":@"800.631",@"isMove":@"0",@"location":@"123",@"startTime":@"12:12:14",@"endTime":@"12:12:14"};

//@property(nonatomic,retain)NSString *recordId;        //歌曲名，30个字节
@property(nonatomic,retain)NSString *classId;       //歌手名，30个字节
@property(nonatomic,retain)NSString *studyduration;        //学习时长
@property(nonatomic,retain)NSString *isMove;         //年份，4个字节
@property(nonatomic,retain)NSString *location;      //注释，28个字节
@property(nonatomic,retain)NSString *startTime;      //歌曲类型
@property(nonatomic,retain)NSString *endTime;   //根据章节 也就是文件夹


@property(nonatomic,retain)NSString *title;        //歌曲名，30个字节
//@property(nonatomic,retain)NSMutableString *teather;       //歌手名，30个字节
//@property(nonatomic,retain)NSMutableString *album;        //原属唱片集，30个字节
//@property(nonatomic,retain)NSMutableString *year;         //年份，4个字节
//@property(nonatomic,retain)NSMutableString *comment;      //注释，28个字节
//@property(nonatomic,retain)NSMutableString *type;      //歌曲类型

@property(nonatomic,retain)NSMutableString *section;//根据章节 也就是文件夹
@property(nonatomic)NSInteger *sectionID;//章节ID

/* 可以得到当前播放的 章节  遍历出一个数组 在这个数组中 如果是最大 那么就从头循环如果不是最大 就+1 */
//@property(nonatomic,retain)NSURL *path;//本地歌曲路径
//@property(nonatomic,retain)NSMutableString *size;//歌曲大小
//@property(nonatomic,retain)NSMutableString *lyric;//歌词
//@property(nonatomic)BOOL isPlaying;  //是否正在播放
@property(nonatomic)NSInteger tag;      //歌曲所在列表的索引位置
//@property(nonatomic,retain)NSMutableString* classID;      //数据库唯一id
@property(nonatomic)NSInteger DidTimes;      //一共听了多少次
@property(nonatomic)NSInteger DidDays;      //多少天
@property(nonatomic)NSInteger BestTimes;
@property(nonatomic)NSInteger BestDays;
@property(nonatomic)NSInteger TodayTimes;      //今天听过没有
@property(nonatomic)double TodayDuation;      //今天这个课程听了多久
@property(nonatomic)double classDuation;      //课程听了多久

@property(nonatomic)NSInteger ClassTime; //单节课程时常
//@property(nonatomic)NSInteger iPodNum;

@property(nonatomic)NSInteger isCount;
@property(nonatomic,retain) MusicEntity *music;
@property(nonatomic,assign) BOOL isCache;
@property(nonatomic,assign) NSInteger AllStudyTime;
@property(nonatomic,assign) NSInteger AllStudyDays;
@property(nonatomic,assign) double Reward;
@end
