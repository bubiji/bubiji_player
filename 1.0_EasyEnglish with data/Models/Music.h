//
//  Music.h
//  MusicPlayer
//
//  Created by 韩国翔 on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Music : NSObject {

}
@property(nonatomic,retain)NSString *title;        //歌曲名，30个字节
@property(nonatomic,retain)NSString *teather;       //歌手名，30个字节
@property(nonatomic,retain)NSString *album;        //原属唱片集，30个字节
@property(nonatomic,retain)NSString *year;         //年份，4个字节
@property(nonatomic,retain)NSString *comment;      //注释，28个字节
@property(nonatomic,retain)NSString *type;      //歌曲类型

@property(nonatomic,retain)NSString *section;//根据章节 也就是文件夹
/* 可以得到当前播放的 章节  遍历出一个数组 在这个数组中 如果是最大 那么就从头循环如果不是最大 就+1 */
@property(nonatomic,retain)NSURL *path;//本地歌曲路径
@property(nonatomic,retain)NSString *size;//歌曲大小
@property(nonatomic,retain)NSString *lyric;//歌词
@property(nonatomic)BOOL isPlaying;  //是否正在播放
@property(nonatomic)NSInteger tag;      //歌曲所在列表的索引位置
@property(nonatomic)NSInteger classID;      //数据库唯一id
@property(nonatomic)NSInteger DidTimes;      //一共听了多少次
@property(nonatomic)NSInteger DidDays;      //多少天
@property(nonatomic)NSInteger BestTimes;     
@property(nonatomic)NSInteger BestDays;      
@property(nonatomic,retain)NSString *TodayTime;      //今天听过没有
@property(nonatomic)NSTimeInterval ClassTime; //课程时常
@property(nonatomic)NSInteger iPodNum;
//@property (nonatomic) BOOL isExport;

@end
