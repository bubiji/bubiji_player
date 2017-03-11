//
//  Music.h
//  MusicPlayer
//
//  Created by 韩国翔 on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RecordClass : NSObject {

}

//id recorddata = @{@"recordId": @"123",@"classId":@"123",@"duration":@"800.631",@"isMove":@"0",@"location":@"123",@"startTime":@"12:12:14",@"endTime":@"12:12:14"};

@property(nonatomic,retain)NSString *recordId;        //歌曲名，30个字节
@property(nonatomic,retain)NSString *classId;       //歌手名，30个字节
@property(nonatomic,retain)NSString *studyduration;        //学习时长
@property(nonatomic,retain)NSString *isMove;         //年份，4个字节
@property(nonatomic,retain)NSString *location;      //注释，28个字节
@property(nonatomic,retain)NSString *startTime;      //歌曲类型
@property(nonatomic,retain)NSString *endTime;   //根据章节 也就是文件夹
@end
