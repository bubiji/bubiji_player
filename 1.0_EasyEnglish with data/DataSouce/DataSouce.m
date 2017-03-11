//
//  DataSouce.m
//  JokePlayer
//
//  Created by apple on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DataSouce.h"
#import "/usr/include/sqlite3.h"
#import "FMDatabase.h"
#import "AppDelegate.h"
@implementation DataSouce



//-(void)test
//{
//    int countnum = 0;
//    
//    if(sqlite3_open([[[NSBundle mainBundle] pathForResource:@"ClassDB" ofType:@"sqlite3"] UTF8String], &database) != SQLITE_OK)//打开数据库，如果打开失败给出提示
//	{
//		sqlite3_close(database);
//		NSAssert(0,@"Failed to open database");
//	}
//    
//    sqlite3_stmt *statement = nil;
//    char *sql = "SELECT * FROM ClassTable";
//    if (sqlite3_prepare_v2(database, sql, -1, &statement, nil) != SQLITE_OK) {
//        NSLog(@"Error: failed to prepare statement with message:get channels.");
//    }else{
//        //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
//        while (sqlite3_step(statement) == SQLITE_ROW) {
//            countnum++;
//            int cid = sqlite3_column_int(statement, 0);
//            char* title = (char*)sqlite3_column_text(statement, 1);
//            char* content = (char*)sqlite3_column_text(statement, 2);
//            
//            
//            NSLog(@"id:%d",cid);
//            if (title != nil) {
//                NSString *titlevalue = [[NSString alloc] initWithUTF8String:title];
//                
//                NSLog(@"title:%@",titlevalue);
//            }
//            if (content != nil) {
//                NSString *contentvalue = [[NSString alloc] initWithUTF8String:content];
//             //   NSLog(@"content:%@",contentvalue);
//            }
//            
//            
//        }
//        sqlite3_finalize(statement);
//        //count.text = [NSString stringWithFormat:@"%d", countnum];
//    }
//    
//    
//    
//}






@end
