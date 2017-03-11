//
//  Helper.m
//  Enesco
//
//  Created by wangjie on 16/6/2.
//  Copyright © 2016年 aufree. All rights reserved.
//

#define loginFile @"login.archiver"

#import "Helper.h"

@implementation Helper

+(NSString *)getTimeStringFromSecond:(NSInteger)seconds{
    //NSLog(@"time %@",time);
    NSMutableString *result=[[NSMutableString alloc] initWithFormat:@""];
    //NSLog(@"time m%@",time);
    //NSLog(@"miao %d",[time integerValue]);
    
    NSInteger minute= seconds/60%60;
    //NSLog(@"minute %d",[time integerValue]/60);
    NSInteger hour = seconds/60/60;
    //NSLog(@"hour %d",[time integerValue]/60/60);
    
    //NSLog(@"time m%d",minute);
    
    NSInteger second= seconds%60;
    //NSLog(@"time s%d",second);
    if(hour >=0 && hour < 10)
    {
        [result appendFormat:@"0%ld:",(long)hour];
    }
    else if(hour >9)
    {
        [result appendFormat:@"%ld:",(long)hour];
    }
    
    if(minute >=0 && minute < 10)
    {
        [result appendFormat:@"0%ld:",(long)minute];
    }
    else if(minute >9)
    {
        [result appendFormat:@"%ld:",(long)minute];
    }
    if(second<10)
    {
        [result appendFormat:@"0%ld",(long)second];
    }
    else if(second>=10)
    {
        [result appendFormat:@"%ld",(long)second];
    }
    return result;

}

+(NSString *)getMinFromSecond:(NSInteger)seconds{
    
    NSInteger minute= seconds/60;
    
    return [NSString stringWithFormat:@"%ld",(long)minute];
    
}

+(void)writeFile:(NSString*)file data:(NSString*)data

{
    //获得应用程序沙盒的Documents目录，官方推荐数据文件保存在此
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* doc_path = [path objectAtIndex:0];
    
    NSString* _filename = [doc_path stringByAppendingPathComponent:file];
    
    NSError *error=nil;
    [data writeToFile:_filename atomically:NO encoding:NSUTF8StringEncoding error:&error];
    
}

+(NSString *)readFile:(NSString*)file

{
    //获得应用程序沙盒的Documents目录，官方推荐数据文件保存在此
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* doc_path = [path objectAtIndex:0];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString* _filename = [doc_path stringByAppendingPathComponent:file];
    
    if([fm fileExistsAtPath:_filename]){
        NSError *error=nil;
        NSString *result = [NSString stringWithContentsOfFile:_filename encoding:NSUTF8StringEncoding error:&error];
        if(error){
            return nil;
        }
        return result;
    }
    
    return nil;
}

+(NSInteger)getLastStudyTime:(NSString *)lession{
    NSString *time = [self readFile:lession];
    if(time){
        return [time integerValue];
    }
    return 0;
}

+(void)endStudy:(NSString *)lession{
    
    NSString *time = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    
    [self writeFile:lession data:time];
    
    if(![self isToadyStudy]){
        [self writeFile:@"allclass" data:time];
    }
    
}

+(BOOL)isToadyStudy:(NSString *) lession{
    NSInteger last = [self getLastStudyTime:lession];
    if(0== last){
        return NO;
    }
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:last];
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    if (
        (int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(24*3600)) -
        (int)(([lastDate timeIntervalSince1970] + timezoneFix)/(24*3600))
        == 0)
    {
        return YES;
    }
    return NO;
}

+(BOOL)isToadyStudy{
    NSInteger last = [self getLastStudyTime:@"allclass"];
    if(0== last){
        return NO;
    }
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:last];
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    if (
        (int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(24*3600)) -
        (int)(([lastDate timeIntervalSince1970] + timezoneFix)/(24*3600))
        == 0)
    {
        return YES;
    }
    return NO;
}

+(NSInteger)getTodayStudyTimeWith:(NSString *) lession{
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    NSString *key = [NSString stringWithFormat:@"%@-%d",lession,(int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(24*3600)) ];
    NSString *result = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if(result){
        return [result integerValue];
    }
    return 0;
}

+(NSInteger)addTodayStudyTimeTo:(NSString *) lession{
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    NSInteger currentStudyTime = [self getTodayStudyTimeWith:lession];
    NSString *key = [NSString stringWithFormat:@"%@-%d",lession,(int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(24*3600)) ];
    NSInteger newStudyTime = currentStudyTime + 1;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)newStudyTime] forKey:key];
    
    return newStudyTime;
    
}

+(BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+(BOOL)loginWith:(NSString *)name wechat:(NSString *)wechat phoneNum:(NSString *)phoneNum{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:wechat forKey:@"wechat"];
    [[NSUserDefaults standardUserDefaults] setObject:phoneNum forKey:@"phoneNum"];
    return true;
}

+(BOOL)isLogin{
    
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    NSString *wechat = [[NSUserDefaults standardUserDefaults] stringForKey:@"wechat"];
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] stringForKey:@"phoneNum"];
    
    return name && wechat && phoneNum;
}

+(NSDictionary *)getUserInfo{
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    NSString *wechat = [[NSUserDefaults standardUserDefaults] stringForKey:@"wechat"];
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] stringForKey:@"phoneNum"];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",wechat,@"wechat",phoneNum,@"phoneNum", nil];
}

+(BOOL)isPhoneNum:(NSString *)phoneNum{
    if (phoneNum.length < 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:phoneNum];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:phoneNum];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:phoneNum];
        
        
        return  isMatch1 || isMatch2 || isMatch3;
    }
}

+(NSString *)getDateForamt:(NSDate *)date{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    //输出格式为：2010-10-27 10:22:13
    return currentDateStr;
}
@end
