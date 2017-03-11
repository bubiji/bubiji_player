//
//  HaierSDK_FileService.h
//  FileService_Sample
//
//  Created by Dean on 14-7-28.
//  Copyright (c) 2014年 IBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef enum {
    Unknown ,
    Nonetwork,
    WAN,
    WiFi
}NetworkStatus;

@protocol FileServiceDelegate<NSObject>
@optional

- (void)uploadStatusCallback:(NSString*)uuid Error:(NSError*)error;
- (void)downloadPathCallback:(NSURL*)path Error:(NSError*)error;
- (void)downloadFileLengthCallback:(NSInteger)fileLength Error:(NSError*)error;
- (void) downloadBlockCallback:(int64_t) bytesWritten total:(int64_t)totalBytesWritten ;

@end

@interface FileService : NSObject

@property (retain,nonatomic) NSString* AppName;
@property (retain,nonatomic) NSString* IP_Port;
@property (retain,nonatomic) NSMutableArray* filesArray;
@property (retain,nonatomic) NSMutableArray* filesDataArray;


@property (retain,nonatomic) id <FileServiceDelegate>delegate;

/**
 * 从服务器下载文件
 * @param serverUri 服务器地址
 * @param clientUri	待下载的文件在本地保存位置
 * @param appName	应用名称
 * @param fileUUID	文件标识
 * @param autoResume 是否支持断点下载，true 表示支持
 * @param callBack    监听下载状态
 * @return
 */

+ (id)sharedInstance;
-(void)upload:(NSString*)File ExpireDay:(NSInteger)expireDay;
-(void)upload:(NSInteger)expireDay files:(NSString *)files,...;

-(void)uploadFiles:(NSMutableArray*)Files ExpireDay:(NSInteger)expireDay;



- (void)download:(NSString*)FileUR;

-(NSData *)applicationDataFromFile:(NSString *)fileName;

-(NSData *)documentDataFromFile:(NSString *)fileName;

-(void)getLengthOfServerFile:(NSString*)FileID ;

-(NetworkStatus)checkNetworkStatus;




@end
