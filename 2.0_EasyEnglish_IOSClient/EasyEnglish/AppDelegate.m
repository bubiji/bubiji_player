//
//  AppDelegate.m
//  EasyEnglish
//
//  Created by lidian on 5/17/16.
//  Copyright © 2016 lidian. All rights reserved.
//

#import "AppDelegate.h"
//#import "ExampleUIWebViewController.h"
#import "MusicPlayerViewController.h"
#import "PlanViewController.h"
#import "UserInfoViewController.h"
#import "BackgroundTask.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize currentMusic;
@synthesize avAudioPlayer;
//@synthesize avPlayer,timer,appSectionList,appSectionMusicList,PlayModel,PlayController,rootBar,StopTime,RootDelegate,AlreadyTime;
@synthesize musiclist;
@synthesize appSectionNumList;
//@synthesize iPodMediaCollection;
@synthesize iPodPlayer;
@synthesize everything;
@synthesize lessonSectionlist;
//@synthesize dal;
//@synthesize musicPlayer;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1. Create the UIWebView example
//    ExampleUIWebViewController* UIWebViewExampleController = [[ExampleUIWebViewController alloc] init];
//    UIWebViewExampleController.tabBarItem.title             = @"UIWebView";
    
    // 2. Create the tab footer and add the UIWebView example
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
   // [tabBarController addChildViewController:UIWebViewExampleController];
    
    // 3. Create the  WKWebView example for devices >= iOS 8
    PlanViewController * Plan_Controller = [[PlanViewController alloc] init];
    Plan_Controller.tabBarItem.title             = @"Plan";
    [tabBarController addChildViewController:Plan_Controller];
    
    //UserInfoViewController
    UserInfoViewController * UserInfo_Controller = [[UserInfoViewController alloc] init];
    UserInfo_Controller.tabBarItem.title             = @"UserInfo";
    [tabBarController addChildViewController:UserInfo_Controller];


    //    if([WKWebView class]) {}



    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    //推送
    NSMutableDictionary *launchOpts = self.launchOptions;
    @synchronized(launchOpts) {
        NSDictionary *userInfo = [launchOpts objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            [self application:application didReceiveRemoteNotification:userInfo];
            
            // Remove remote notifications info from the launch options to prevent WL push function
            [launchOpts removeObjectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        }
    }
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }  else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
    
    NSLog(@"applicationDidEnterBackground");
    [[[BackgroundTask alloc]init] startBackgroundTask:application];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//token
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    
    NSLog(@"Receive DeviceToken: %@", newDeviceToken);
    
    NSString *deviceToken = [NSString stringWithFormat:@"%@", newDeviceToken];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    [userDefaultes setObject:deviceToken forKey:@"newDeviceToken"];
    
    
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
