//
//  OldUser.m
//  Enesco
//
//  Created by wangjie on 16/6/7.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import "OldUser.h"
#import "Zhuge.h"
#import "DAL.h"
#import "RecordClass.h"
@implementation OldUser
+(BOOL)handleOldUser:(NSString *)phoneNum{
    //1 Scarlett
    if([phoneNum isEqualToString:@"18976285583"])
    {
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"Scarlett";
        userInfo[@"gender"] = @"女";
        userInfo[@"mobile"] = @"18976285583";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"海南";
        // userInfo[@"公司"] = @"37degree";
        
//        第一课 35   16
//        第二课 35  16
//        第三课 35 16
//        第四课 55  12
//        第五课 54  12
//        第六课 53 12
//        RecordClass * record =[[RecordClass alloc]init];
//        record.classId =@"1";
//        record.DidTimes =35;
//        record.DidDays =16;
//        record.classDuation = 42000;
//
//        [[DAL shareInstance] updateRecord:record];
//        record.classId =@"2";
//        record.DidTimes =35;
//        record.DidDays =16;
//        record.classDuation = 22000;
//
//        [[DAL shareInstance] updateRecord:record];
//        record.classId =@"3";
//        record.DidTimes =35;
//        record.DidDays =16;
//        record.classDuation = 32000;
//
//        [[DAL shareInstance] updateRecord:record];
//        
//        record.classId =@"4";
//        record.DidTimes =55;
//        record.DidDays =12;
//        record.classDuation = 52000;
//
//        [[DAL shareInstance] updateRecord:record];
//        record.classId =@"5";
//        record.DidTimes =54;
//        record.DidDays =12;
//        record.classDuation = 38000;
//
//        [[DAL shareInstance] updateRecord:record];
//        record.classId =@"6";
//        record.DidTimes =53;
//        record.DidDays =12;
//        record.classDuation = 58000;
//
//        [[DAL shareInstance] updateRecord:record];
//        
        [self registerUserInfo:userInfo ];
        
        return YES;
    }
    
    //2
    if([phoneNum isEqualToString:@"18982225358"])
    {
        //NSString *userId = @"C6CB5EB18686F2C0269DAC1B7C3CB5E6579C2E1A";//[user getUserId]
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"Jane";
        userInfo[@"gender"] = @"女";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"18982225358";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"北京";
        // userInfo[@"公司"] = @"37degree";
        [self registerUserInfo:userInfo ];
        
        RecordClass * record =[[RecordClass alloc]init];
        record.classId =@"1";
        record.DidTimes =23;
        record.DidDays =13;
        record.classDuation = 42000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"2";
        record.DidTimes =18;
        record.DidDays =11;
        record.classDuation = 22000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"3";
        record.DidTimes =18;
        record.DidDays =13;
        record.classDuation = 32000;
        
        [[DAL shareInstance] updateRecord:record];
        
        record.classId =@"4";
        record.DidTimes =4;
        record.DidDays =4;
        record.classDuation = 52000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"5";
        record.DidTimes =5;
        record.DidDays =5;
        record.classDuation = 38000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"6";
        record.DidTimes =5;
        record.DidDays =4;
        record.classDuation = 58000;
        
        [[DAL shareInstance] updateRecord:record];
        

        
        return YES;
    }
    //3
    if([phoneNum isEqualToString:@"18899162506"]) //felix
    {
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"felix";
        userInfo[@"gender"] = @"男";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"18899162506";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"新疆";
        // userInfo[@"公司"] = @"37degree";
        [self registerUserInfo:userInfo ];
        
        RecordClass * record =[[RecordClass alloc]init];
        record.classId =@"1";
        record.DidTimes =23;
        record.DidDays =13;
        record.classDuation = 42000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"2";
        record.DidTimes =18;
        record.DidDays =11;
        record.classDuation = 22000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"3";
        record.DidTimes =18;
        record.DidDays =13;
        record.classDuation = 32000;
        
        [[DAL shareInstance] updateRecord:record];
        
        record.classId =@"4";
        record.DidTimes =2;
        record.DidDays =3;
        record.classDuation = 52000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"5";
        record.DidTimes =3;
        record.DidDays =3;
        record.classDuation = 38000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"6";
        record.DidTimes =10;
        record.DidDays =6;
        record.classDuation = 58000;
        
        [[DAL shareInstance] updateRecord:record];
        
        return YES;
    }
    //4
    if([phoneNum isEqualToString:@"18665802030"]) //felix
    {
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"gaoyiming";
        userInfo[@"gender"] = @"男";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"18665802030";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"北京";
        // userInfo[@"公司"] = @"37degree";
        [self registerUserInfo:userInfo ];
        
        RecordClass * record =[[RecordClass alloc]init];
        record.classId =@"1";
        record.DidTimes =20;
        record.DidDays =15;
        record.classDuation = 42000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"2";
        record.DidTimes =20;
        record.DidDays =14;
        record.classDuation = 22000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"3";
        record.DidTimes =19;
        record.DidDays =15;
        record.classDuation = 32000;
        
        [[DAL shareInstance] updateRecord:record];
        
        record.classId =@"4";
        record.DidTimes =5;
        record.DidDays =5;
        record.classDuation = 52000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"5";
        record.DidTimes =5;
        record.DidDays =5;
        record.classDuation = 38000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"6";
        record.DidTimes =5;
        record.DidDays =3;
        record.classDuation = 58000;
        
        [[DAL shareInstance] updateRecord:record];
        
        return YES;
    }
    //5 Molly
    if([phoneNum isEqualToString:@"13971446228"])
    {
        NSString *userId = @"C6CB5EB18686F2C0269DAC1B7C3CB5E6579C2E1A";//[user getUserId]
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"Molly";
        userInfo[@"gender"] = @"女";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"1";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"南方";
        // userInfo[@"公司"] = @"37degree";
        
        [self registerUserInfo:userInfo ];
        
        RecordClass * record =[[RecordClass alloc]init];
        record.classId =@"1";
        record.DidTimes =21;
        record.DidDays =14;
        record.classDuation = 42000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"2";
        record.DidTimes =26;
        record.DidDays =13;
        record.classDuation = 22000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"3";
        record.DidTimes =19;
        record.DidDays =15;
        record.classDuation = 32000;
        
        [[DAL shareInstance] updateRecord:record];
        
        record.classId =@"4";
        record.DidTimes =20;
        record.DidDays =8;
        record.classDuation = 52000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"5";
        record.DidTimes =40;
        record.DidDays =7;
        record.classDuation = 38000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"6";
        record.DidTimes =12;
        record.DidDays =6;
        record.classDuation = 58000;
        
        [[DAL shareInstance] updateRecord:record];
        
        return YES;
    }
    //6
    if([phoneNum isEqualToString:@"13735200057"])
    {
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"Tina";
        userInfo[@"gender"] = @"女";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"13735200057";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"北京";
        // userInfo[@"公司"] = @"37degree";
        
        [self registerUserInfo:userInfo ];
        
        
        RecordClass * record =[[RecordClass alloc]init];
        record.classId =@"1";
        record.DidTimes =27;
        record.DidDays =12;
        record.classDuation = 42000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"2";
        record.DidTimes =29;
        record.DidDays =12;
        record.classDuation = 22000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"3";
        record.DidTimes =28;
        record.DidDays =12;
        record.classDuation = 32000;
        
        [[DAL shareInstance] updateRecord:record];
        
        record.classId =@"4";
        record.DidTimes =38;
        record.DidDays =18;
        record.classDuation = 52000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"5";
        record.DidTimes =28;
        record.DidDays =13;
        record.classDuation = 38000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"6";
        record.DidTimes =34;
        record.DidDays =15;
        record.classDuation = 58000;
        
        [[DAL shareInstance] updateRecord:record];
        return YES;
    }
    
    //7
    if([phoneNum isEqualToString:@"13501122876"])
    {
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"cedar";
        userInfo[@"gender"] = @"男";
        userInfo[@"mobile"] = @"13501122876";
        userInfo[@"location"] = @"北京";
        [self registerUserInfo:userInfo ];
        
        
        RecordClass * record =[[RecordClass alloc]init];
        record.classId =@"1";
        record.DidTimes =23;
        record.DidDays =19;
        record.classDuation = 42000;
        [[DAL shareInstance] updateRecord:record];
        
        record.classId =@"2";
        record.DidTimes =27;
        record.DidDays =16;
        record.classDuation = 22000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"3";
        record.DidTimes =18;
        record.DidDays =16;
        record.classDuation = 32000;
        
        [[DAL shareInstance] updateRecord:record];
        
        record.classId =@"4";
        record.DidTimes =17;
        record.DidDays =8;
        record.classDuation = 52000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"5";
        record.DidTimes =18;
        record.DidDays =8;
        record.classDuation = 38000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"6";
        record.DidTimes =9;
        record.DidDays =7;
        record.classDuation = 58000;
        
        [[DAL shareInstance] updateRecord:record];
        
        
        record.classId =@"7";
        record.DidTimes =12;
        record.DidDays =9;
        record.classDuation = 52000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"8";
        record.DidTimes =12;
        record.DidDays =8;
        record.classDuation = 38000;
        
        [[DAL shareInstance] updateRecord:record];
        record.classId =@"9";
        record.DidTimes =5;
        record.DidDays =4;
        record.classDuation = 58000;
        
        [[DAL shareInstance] updateRecord:record];
        
        
        
        return YES;
    }
    
    // 8 dean
    if([phoneNum isEqualToString:@"13811060827"])
    {
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"Dean";
        userInfo[@"gender"] = @"男";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"13811060827";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"北京";
        // userInfo[@"公司"] = @"37degree";
        [self registerUserInfo:userInfo ];
        
        return YES;
    }
    // 9 fuheng
//    if([phoneNum isEqualToString:@"18722696866"])
//    {
//        
//        //定义属性
//        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//        userInfo[@"name"] = @"fuheng";
//        userInfo[@"gender"] = @"男";
//        //userInfo[@"birthday"] = @"2015/1/11";
//        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
//        //userInfo[@"email"] = @"support@zhugeio.com";
//        userInfo[@"mobile"] = @"18722696866";
//        //        userInfo[@"weixin"] = @"121212";
//        //        userInfo[@"weibo"] = @"122222";
//        userInfo[@"location"] = @"北京";
//        // userInfo[@"公司"] = @"37degree";
//        [self registerUserInfo:userInfo ];
//        
//        return YES;
//    }
    
    return NO;

}

+(void)registerUserInfo:(NSMutableDictionary*)userInfo //userId:(NSString*)userId
{
    NSUserDefaults* userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.bubiji"];

    NSString *mobile =userInfo[@"mobile"];
    [userDefault setObject:mobile forKey:@"mobile"];
    
    NSString * newDeviceToken =  [userDefault objectForKey:@"newDeviceToken"];
    [userDefault setObject:newDeviceToken forKey:@"newDeviceToken"];

    //跟踪用户
    [[Zhuge sharedInstance] identify:mobile properties:userInfo];
}
@end
