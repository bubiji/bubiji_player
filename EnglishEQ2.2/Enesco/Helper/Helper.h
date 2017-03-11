//
//  Helper.h
//  Enesco
//
//  Created by wangjie on 16/6/2.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject
+(NSString *)getTimeStringFromSecond:(NSInteger)seconds;
+(NSString *)getMinFromSecond:(NSInteger)seconds;
+(NSInteger)getLastStudyTime:(NSString *)lession;
+(void)endStudy:(NSString *)lession;
+(BOOL)isToadyStudy:(NSString *) lession;
+(BOOL)isToadyStudy;
+(BOOL)isBlankString:(NSString *)string;
+(BOOL)loginWith:(NSString *)name wechat:(NSString *)wechat phoneNum:(NSString *)phoneNUm;
+(BOOL)isLogin;
+(NSDictionary *)getUserInfo;
+(BOOL)isPhoneNum:(NSString *)phoneNum;
@end
