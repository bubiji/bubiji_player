//
//  DataSouce.h
//  JokePlayer
//
//  Created by apple on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"
@interface DataSouce : NSObject
{
    NSMutableArray *ArraryGroup;
    sqlite3 *database;
}
//-(void)test;
//-(void)initappDB;
////@property (nonatomic,retain) NSMutableArray *ArrayGroup;
//-(void)readFileList;

@end
