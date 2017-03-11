//
//  HaierSDK_FileService.m
//  FileService_Simple
//
//  Created by Dean on 14-7-28.
//  Copyright (c) 2014年 IBM. All rights reserved.
//

#import "FileService.h"
#import "AFNetworking.h"
@implementation FileService

NSString * const upLoadServerUri =@"/mobile_sdk/rest/file/upload";
NSString * const downLoadServerUri = @"/mobile_sdk/rest/file/download";
NSString * const queryFizeSizeUri =@"/mobile_sdk/rest/file/querysize";
NSString * const upLoadFilesServerUri =@"/mobile_sdk/rest/file/multiUpload";


-(id)init
{
    self = [super init];
    if (self) {
        
     //   self.appInfo = [[UIApplication alloc]initWithSDKName:SDKPlist];
//        _IP_Port =  [self.appInfo getSDKConfigValueByKey:SDK_URL];
//        _AppName =self.appInfo.HaierAPPName;
    }
    return self;

}

+ (id)sharedInstance
{
    static FileService *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });

    return  shared;
}

- (void)download:(NSString*)FileUR//L FileName:(NSString*)fileName Directory:(NSString*)dic
{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURL *URL = [NSURL URLWithString:FileUR];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        // NSLog(@"File downloaded to: %@", filePath);
        [_delegate downloadPathCallback:filePath  Error:error];
    }];
    [downloadTask resume];
    
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
       // NSLog(@"Progress… %lld", totalBytesWritten);
        [_delegate downloadBlockCallback: totalBytesWritten total:totalBytesExpectedToWrite];

    }];
    
    
    
}
-(void)upload:(NSInteger)expireDay files:(NSString *)files,...
{
    _filesArray  =[[NSMutableArray alloc]init];
    
    va_list params;//定义一个指向个数可变的参数列表指针
    va_start(params, files);//va_start 得到第一个可变参数地址
    NSString *arg;
    
    if (files) {
        //将第一个参数添加到array
        NSString *prev = files;
        [_filesArray addObject:prev];
        
        //va_arg 指向下一个参数地址
        //
        while ((arg = va_arg(params, NSString *))) {
            if (arg) {
                NSLog(@"%@",arg);
                [_filesArray addObject:arg];
                
            }
        }
        //置空
        va_end(params);
    }
    
    [self uploadFiles:_filesArray ExpireDay:expireDay];
}
-(void)upload:(NSString*)File ExpireDay:(NSInteger)expireDay

{
    
    NSString *APIUrl =[NSString stringWithFormat:@"http://%@%@",_IP_Port,upLoadServerUri];
    NSData * filedata = [self applicationDataFromFile:File];

    
    // 1. Create `AFHTTPRequestSerializer` which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    //[headers setValue:@"2014-07-31" forKey:@"expiredTime"];
    [headers setValue:[self getExpireDay:expireDay] forKey:@"expiredTime"];
    [headers setValue:_AppName forKey:@"appName"];
    
    // 2. Create an `NSMutableURLRequest`.
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:APIUrl
                                    parameters:headers
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         
                         [formData appendPartWithFileData:filedata
                                                     name:@"file"
                                                 fileName:File
                                                 mimeType:@"application/octet-stream"];
                     }];
    
    
    // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         
                                         NSDictionary *dic =   [[NSDictionary alloc]initWithDictionary:responseObject];
                                         [_delegate uploadStatusCallback:[dic objectForKey:@"fileUUID" ] Error:nil];
                                         NSLog(@"Success %@", responseObject);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         
                                         [_delegate uploadStatusCallback:nil  Error:error];
                                         
                                         NSLog(@"Failure %@", error.description);
                                     }];
    
    // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    // 5. Begin!
    [operation start];
}


-(void)uploadFiles:(NSMutableArray*)Files ExpireDay:(NSInteger)expireDay

{

    NSString *APIUrl =[NSString stringWithFormat:@"http://%@%@",_IP_Port,upLoadServerUri];

   
    // 1. Create `AFHTTPRequestSerializer` which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    //[headers setValue:@"2014-07-31" forKey:@"expiredTime"];
    [headers setValue:[self getExpireDay:expireDay] forKey:@"expiredTime"];
    [headers setValue:_AppName forKey:@"appName"];
    
    // 2. Create an `NSMutableURLRequest`.
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:APIUrl
                                    parameters:headers
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         
                         int i=0;
                         for (NSString *fileNameItem in Files) {
                             
                             i++;

                             NSData * filedata = [self applicationDataFromFile:fileNameItem];
                             [_filesDataArray addObject:filedata];
                             [formData appendPartWithFileData:filedata
                                                         name:[NSString stringWithFormat:@"File%d",i]
                                                     fileName:fileNameItem
                                                     mimeType:@"application/octet-stream"];
                         }
                         
                         
                     }];
    
    
    // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         
                                         NSDictionary *dic =   [[NSDictionary alloc]initWithDictionary:responseObject];
                                         [_delegate uploadStatusCallback:[dic objectForKey:@"fileUUID" ] Error:nil];
                                         NSLog(@"Success %@", responseObject);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         
                                         [_delegate uploadStatusCallback:nil  Error:error];
                                         
                                         NSLog(@"Failure %@", error.description);
                                     }];
    
    // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    // 5. Begin!
    [operation start];
}


- (void)getLengthOfServerFile:(NSString*)FileID {

    NSString *APIUrl =[NSString stringWithFormat:@"http://%@%@?fileUUID=%@&appName=%@",_IP_Port,queryFizeSizeUri,FileID,_AppName];

    NSLog(@" urlStr %@",APIUrl);
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:APIUrl parameters:nil  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic =   [[NSDictionary alloc]initWithDictionary:responseObject];
        
        NSInteger fileLength =   [[dic objectForKey:@"size" ]integerValue];
        [_delegate downloadFileLengthCallback : fileLength Error:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate downloadFileLengthCallback : 0 Error:error];
        
    }];
    
}



#pragma mark - commom
-(NSData *)documentDataFromFile:(NSString *)fileName
{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *appFile =[documentsDirectory stringByAppendingPathComponent:fileName];
    NSData *data =[[NSData alloc]initWithContentsOfFile:appFile];
    return data;
}

-(NSData *)applicationDataFromFile:(NSString *)fileName
{
    NSString *appFile = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSData *data =[[NSData alloc]initWithContentsOfFile:appFile];
    return data;
}

-(NSString*)getExpireDay:(NSInteger)expireDay
{
    //获得系统时间
    NSDate *  senddate=[NSDate date];
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    
    
    //通过NSCALENDAR类来创建日期
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    [comp setMonth:month];
    [comp setDay:day+expireDay];
    [comp setYear:year];
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *expireDate = [myCal dateFromComponents:comp];
    
    
    // NSLog(@"expireDate = %@",expireDate);
    //NSDateFormatter实现日期的输出
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterFullStyle];//直接输出的话是机器码
    //或者是手动设置样式
    [formatter setDateFormat:@"yyyy-MM-dd"];
    // NSString *dateString = [formatter stringFromDate:expireDate ];
    
    NSString *dateString = [NSString stringWithFormat:@"%d-%d-%d",year,month,day ];
    
    return dateString;
    
}

#pragma mark ASIHTTPRequestDelegate



-(NetworkStatus)checkNetworkStatus
{
    
    AFNetworkReachabilityManager *manager= [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    
    AFNetworkReachabilityStatus Status=  [manager networkReachabilityStatus];
    
    switch (Status) {
        case AFNetworkReachabilityStatusUnknown:
            return Unknown;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            return Nonetwork;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return WAN;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return WiFi;
            break;
        default:
            break;
    }
    return Unknown;
}

@end
