//
//  AppDelegate.m
//  JokePlayer
//
//  Created by apple on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "BackgroundTask.h"
#import "Zhuge.h"

//@implementation UINavigationBar (CustomImage)
//- (void)drawRect:(CGRect)rect {
//    UIImage *image = [UIImage imageNamed: @"4.png"];
//    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    //NSLog(@"high %f",self.frame.size.height);
//}
//@end
@implementation AppDelegate

@synthesize window = _window;

//@synthesize tabViewController=_viewController;

@synthesize currentMusic;
@synthesize avAudioPlayer;
@synthesize avPlayer,timer,appSectionList,appSectionMusicList,PlayModel,PlayController,rootBar,StopTime,RootDelegate,AlreadyTime;
@synthesize musiclist;
@synthesize appSectionNumList;
//@synthesize iPodMediaCollection;
@synthesize iPodPlayer;
@synthesize everything;
@synthesize musicPlayer;
@synthesize lessonSectionlist;
@synthesize dal;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    
    [[Zhuge sharedInstance].config setChannel:@"蒲公英"]; // 默认是@"App Store"
    [[Zhuge sharedInstance].config setAppVersion:@"2.1-beta"]; // 默认是info.plist中CFBundleShortVersionString值
    [[Zhuge sharedInstance] startWithAppKey:@"37bd31642a974d79b51a572e57dcd8b3" launchOptions:launchOptions];
    [[Zhuge sharedInstance].config setDebug : NO];
    
//    NSString *userId = @"e9dec8568278d3028b70ffeb1e6195c961aadedf";//[user getUserId]
//    
//    //定义属性
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    userInfo[@"name"] = @"Dean";
//    userInfo[@"gender"] = @"男";
//    //userInfo[@"birthday"] = @"2015/1/11";
//    //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
//    //userInfo[@"email"] = @"support@zhugeio.com";
//    userInfo[@"mobile"] = @"13811060827";
//    //        userInfo[@"weixin"] = @"121212";
//    //        userInfo[@"weibo"] = @"122222";
//    userInfo[@"location"] = @"北京";
//    // userInfo[@"公司"] = @"37degree";
//    
//    //跟踪用户
//    [[Zhuge sharedInstance] identify:userId properties:userInfo];
    
    //初始化数据库 很重要啊
    dal =  [[DAL alloc]init];
    [dal initappDB];
    //[dal readFileList];
    
    //[ds copydb];
    [dal initSectionListAndSectionNum];
    [dal initMusicLit];
    [dal checkEveryLesson];
    //初始化模式
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    appDelegate.PlayModel =PlayNormal ;
    
    //这里面 我们初始化了 musiclist  而appdata 可以换更新方式的
    [self initRootPage];
    
    //也许暂时不用往数据库中写 
    //检查每个课程 是否存在
    // [self checkEveryLesson];
    //manager的 初始化 但是不知道该何时初始化更好
    //appDelegate.musicPlayer = [[iPodMusicManager alloc]initWithPlayerType:1 LoadSong:nil];
    
    //[self initNavBar];
    self.window.rootViewController =rootBar;
    
    //    UIStatusBarStyleDefault,
    //    UIStatusBarStyleBlackTranslucent,
    //    UIStatusBarStyleBlackOpaque
    everything = [[MPMediaQuery alloc] init];
    
    
    
    //    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    //    [ud synchronize];
    //    NSString *name =[ud stringForKey:@"name_preference"];
    //    float sliderValue =[ud floatForKey:@"slider_preference"];
    //    BOOL enableValue =[ud boolForKey:@"enable_preference"];
    //    [ud setObject:@"nihao" forKey:@"name_preference"];
    //    [ud setFloat:0.8 forKey:@"slider_preference"];
    //    [ud setBool:NO forKey:@"enable_preference"];
    //    [ud synchronize];
    
     [[[BackgroundTask alloc]init] startHeartbeat:application];
    
    //当前驱动设备版本
    NSLog(@"current_device:%@",[UIDevice currentDevice].model);
     UIDevice* device = [UIDevice currentDevice];
     BOOL backgroundSupported = NO;
     if ([device respondsToSelector:@selector(isMultitaskingSupported)])
         backgroundSupported = device.multitaskingSupported;
    NSLog(@"VALUE IS : %@", backgroundSupported ? @"YES" : @"NO");


    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark -
#pragma mark check input

#pragma mark -
#pragma mark initRoot
-(void)initRootPage
{
    RootViewController *groupView =[[RootViewController alloc]
                                    initWithNibName:@"RootViewController" bundle:nil];
    //以下这只nav
    UITabBarItem *tabBarItem=   [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:102];
    groupView.tabBarItem =tabBarItem;
    [tabBarItem release];
    //设置tabBar
    
    CGRect rect =CGRectMake(0, 0, 320, 44);
    customNavBar =[[CustomNavgationBar alloc]initWithFrame:rect];
    [customNavBar drawRect:rect];
    [customNavBar pushNavigationItem:groupView.navigationItem animated:YES];
    //customNavBar.tag =100;
    [groupView.view addSubview:customNavBar];
    
    
    //system setting 
    //NSLog(@"------------ %@",groupView);
    
    settingTableView =[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    //settingTableView.tabBarItem.image =[UIImage imageNamed:@"chat.png"];
    settingTableView.tabBarItem =[[[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemMore tag:101]autorelease];
    
    //bar   最下面的bar
    rootBar =[[[UITabBarController alloc]init]autorelease];
    NSArray *ArrayControllers =[NSArray arrayWithObjects:groupView,settingTableView,nil];
    //NSLog(@"arrar %@",ArrayControllers);
    rootBar.viewControllers =ArrayControllers;
    //[ArrayControllers  release];
    rootBar.delegate =settingTableView;//click bar event
    
    
}

#pragma mark -
#pragma mark page




//翻页

- (void)playerViewControllerDidFinish:(MusicPlayerViewController *)controller
{
    [self.window.rootViewController dismissModalViewControllerAnimated:YES];
}



#pragma mark - 

#pragma mark - no idear

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    [[[BackgroundTask alloc]init] startBackgroundTask:application];
//
//    UIBackgroundTaskIdentifier * backTask =[[HaierSDK_BackgroundTask alloc]init];
//    [backTask startBackgroundTask];
//    [[[BackgroundTask alloc]init]startBackgroundTask];
    
}

//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    
//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    dal =  [[DAL alloc]init];
    [dal initappDB];    
    [dal initMusicLit];
    [dal checkEveryLesson];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}



//
#pragma mark -

#pragma mark - token

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    
    NSLog(@"Receive DeviceToken: %@", newDeviceToken);
    
    NSString *deviceToken = [NSString stringWithFormat:@"%@", newDeviceToken];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    [userDefaultes setObject:deviceToken forKey:@"newDeviceToken"];
    
    NSString *userId =  deviceToken ;//[user getUserId]
    
    //定义属性
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"name"] = @"zhuge";
    userInfo[@"gender"] = @"男";
    userInfo[@"birthday"] = @"2015/1/11";
    userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
    userInfo[@"email"] = @"support@zhugeio.com";
    userInfo[@"mobile"] = @"18901010101";
    userInfo[@"qq"] = @"91919";
    userInfo[@"weixin"] = @"121212";
    userInfo[@"weibo"] = @"122222";
    userInfo[@"location"] = @"北京朝阳区";
    userInfo[@"公司"] = @"37degree";
    
    //跟踪用户
    [[Zhuge sharedInstance] identify:userId properties:userInfo];
    
}
-(NSString*)getUserInofByKey:(NSString*)key
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    return[userDefaultes stringForKey:key];
    
}
-(void)setUserInfoValue:(NSString*)value ByKey:(NSString*)key
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    [userDefaultes setObject:value forKey:key];
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败，无法获取设备ID, 具体错误: %@", error);
    
    NSString *userId = @"11";//[user getUserId]
    
    //定义属性
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"name"] = @"zhuge";
    userInfo[@"gender"] = @"男";
    userInfo[@"birthday"] = @"2015/1/11";
    userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
    userInfo[@"email"] = @"support@zhugeio.com";
    userInfo[@"mobile"] = @"18901010101";
    userInfo[@"qq"] = @"91919";
    userInfo[@"weixin"] = @"121212";
    userInfo[@"weibo"] = @"122222";
    userInfo[@"location"] = @"北京朝阳区";
    userInfo[@"公司"] = @"37degree";
    
    //跟踪用户
    [[Zhuge sharedInstance] identify:userId properties:userInfo];
}

//receive notify
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo

{
    
    
    if (application.applicationState == UIApplicationStateActive) {
        // 转换成一个本地通知，显示到通知栏，你也可以直接显示出一个alertView，只是那样稍显aggressive
        
        NSLog(@"apns消息到达 %s:%d - %@", __func__, __LINE__, [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        //localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    } else {
        UIAlertView * alert =  [[UIAlertView alloc]initWithTitle:@"tet" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

@end
