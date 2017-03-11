//
//  AppDelegate.m
//  Enesco
//
//  Created by Aufree on 11/30/15.
//  Copyright © 2015 The EST Group. All rights reserved.
//

#import "AppDelegate.h"
#import "MusicSectionListViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MusicViewController.h"
#import "Zhuge.h"
#import "UserinfoViewController.h"
#import "LoginViewController.h"
#import "Helper.h"
#import "ProcessViewController.h"

@interface AppDelegate ()<LoginViewControllerDelegate>
@property (nonatomic, strong) MusicSectionListViewController *musicListVC;
@property (nonatomic, strong) MusicSectionListViewController *userinfoVC;
@property (nonatomic, strong) ProcessViewController *processVC;
@property (nonatomic, strong) LoginViewController *loginVC;
@property (nonatomic, strong) UITabBarController *tabBarVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[Zhuge sharedInstance].config setChannel:@"蒲公英"]; // 默认是@"App Store"
    [[Zhuge sharedInstance].config setAppVersion:@"Bubiji 2.3-beta"]; // 默认是info.plist中CFBundleShortVersionString值
    [[Zhuge sharedInstance] startWithAppKey:@"37bd31642a974d79b51a572e57dcd8b3" launchOptions:launchOptions];
    [[Zhuge sharedInstance].config setDebug : NO];
    
    

    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }  else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    
    
    // Showing the App
    [self makeWindowVisible:launchOptions];
    
    // Basic setup
    [self basicSetup];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString* prefix = @"iOSWidgetApp://action=";
    if ([[url absoluteString] rangeOfString:prefix].location != NSNotFound) {
        NSString* action = [[url absoluteString] substringFromIndex:prefix.length];
        if ([action isEqualToString:@"Content"]) {
            
//            NSUserDefaults* userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.bubiji"];
//            [userDefault setObject:@"Dean" forKey:@"group.bubiji.name"];
//            
            NSMutableDictionary *eventObject = [NSMutableDictionary dictionary];
//            eventObject[@"ClassID"] =  [NSString stringWithFormat:@"%ld",(long)record.classId ];;
//            eventObject[@"endTime"] = [self generateTimeIntervalWithTimeZone];
//            eventObject[@"isCount"] =@"0";
//            eventObject[@"location"] = @"0";
//            eventObject[@"studyduration"] = [NSString stringWithFormat:@"%f",studyduration ];
//            eventObject[@"ClassName"] = record.title;
//            eventObject[@"interactCount"] = @"0";
//            eventObject[@"isMove"] = @"0";
           // [[Zhuge sharedInstance] track:@"TodayClickContent" properties:eventObject];
        }
        else if([action isEqualToString:@"Progress"]) {
//            BasicHomeViewController *vc = (BasicHomeViewController*)self.window.rootViewController;
//            [vc.tabbar selectAtIndex:2];
            NSMutableDictionary *eventObject = [NSMutableDictionary dictionary];

            //[[Zhuge sharedInstance] track:@"TodayClickProgress" properties:eventObject];

            
        }
    }
    
    //NSMutableDictionary *eventObject = [NSMutableDictionary dictionary];

    //[[Zhuge sharedInstance] track:@"TodayClick" properties:eventObject];

    return  YES;
}

- (void)makeWindowVisible:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    if (!_musicListVC){
        _musicListVC = [[UIStoryboard storyboardWithName:@"MusicListWithSection2" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    }
    
    if(!_processVC){
        _processVC = [[UIStoryboard storyboardWithName:@"ProcessStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"processView"];
    }
    
    if(!_loginVC){
        _loginVC = [[UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"loginView"];
        _loginVC.delegate = self;
    }
    
    if(!_tabBarVC){
        _tabBarVC=[[UITabBarController alloc]init];
    }
    
    self.window.rootViewController=_tabBarVC;
    
    //_musicListVC.tabBarItem.image = TODO;
    
    _musicListVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"label_content_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"label_content_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _musicListVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);
    _musicListVC.tabBarItem.tag = 0;
    [_musicListVC.tabBarItem setTitlePositionAdjustment: UIOffsetMake(0,-3)];
    
    if([Helper isLogin]){
        
        _processVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"label_progress_normal"] selectedImage:[UIImage imageNamed:@"label_progress_active"]];
        
        _processVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);
        _processVC.tabBarItem.tag = 1;
        [_processVC.tabBarItem setTitlePositionAdjustment: UIOffsetMake(0,-3)];
        
        _tabBarVC.viewControllers = @[_musicListVC,_processVC];
        self.window.rootViewController=_tabBarVC;
    }
    else{
        
        _loginVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"label_progress_normal"] selectedImage:[UIImage imageNamed:@"label_progress_active"]];
        
        _loginVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);
        _loginVC.tabBarItem.tag = 1;
        [_loginVC.tabBarItem setTitlePositionAdjustment: UIOffsetMake(0,-3)];
        
        _processVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"label_progress_normal"] selectedImage:[UIImage imageNamed:@"label_progress_active"]];
        
        _processVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);
        _processVC.tabBarItem.tag = 1;
        [_processVC.tabBarItem setTitlePositionAdjustment: UIOffsetMake(0,-3)];
        
        
        self.window.rootViewController = _loginVC;
    }
    
    [self.window makeKeyAndVisible];
}


- (void)basicSetup {
    // Remove control
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

# pragma mark - Remote control

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPause:
                [[MusicViewController sharedInstance] didTouchMusicToggleButton:nil];
                break;
            case UIEventSubtypeRemoteControlStop:
                [[MusicViewController sharedInstance] didTouchMusicToggleButton:nil];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [[MusicViewController sharedInstance] didTouchMusicToggleButton:nil];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [[MusicViewController sharedInstance] didTouchMusicToggleButton:nil];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [[MusicViewController sharedInstance] playNextMusic:nil];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [[MusicViewController sharedInstance] playPreviousMusic:nil];
                break;
            default:
                break;
        }
    }
}

#pragma mark -

#pragma mark - token

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    
    NSLog(@"Receive DeviceToken: %@", newDeviceToken);
    
//    NSString *deviceToken = [NSString stringWithFormat:@"%@", newDeviceToken];
//    
//    NSUserDefaults* userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.bubiji"];
//    
//    [userDefault setObject:deviceToken forKey:@"newDeviceToken"];
//    
//    NSString *userId =  deviceToken ;//[user getUserId]
//    
//    //定义属性
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    userInfo[@"name"] = @"未注册用户";
//    userInfo[@"gender"] = @"男";
//    userInfo[@"birthday"] = @"2015/1/11";
//    userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
//    userInfo[@"email"] = @"support@zhugeio.com";
//    userInfo[@"mobile"] = @"18901010101";
//    userInfo[@"qq"] = @"91919";
//    userInfo[@"weixin"] = @"121212";
//    userInfo[@"weibo"] = @"122222";
//    userInfo[@"location"] = @"北京朝阳区";
//    userInfo[@"公司"] = @"37degree";
//    
    //跟踪用户
   // [[Zhuge sharedInstance] identify:userId properties:userInfo];
    
}
//-(NSString*)getUserInofByKey:(NSString*)key
//{
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    
//    return[userDefaultes stringForKey:key];
//    
//}
//-(void)setUserInfoValue:(NSString*)value ByKey:(NSString*)key
//{
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    
//    [userDefaultes setObject:value forKey:key];
//    
//    
//}

-(BOOL)loginWith:(NSString *)name wechat:(NSString *)wechat phoneNum:(NSString *)phoneNum{
    if([Helper isLogin]){
      

        _processVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"label_progress_normal"] selectedImage:[UIImage imageNamed:@"label_progress_active"]];
        _processVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);
        _processVC.tabBarItem.tag = 1;
        [_processVC.tabBarItem setTitlePositionAdjustment: UIOffsetMake(0,-3)];
        _tabBarVC.viewControllers = @[_musicListVC,_processVC];
        self.window.rootViewController=_tabBarVC;
        
        
        NSUserDefaults* userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.bubiji"];
        [userDefault setObject:@"userID" forKey:phoneNum];
        [userDefault setObject:@"username" forKey:name];

        
    }
   
    return YES;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败，无法获取设备ID, 具体错误: %@", error);
    
//    NSString *userId = @"11";//[user getUserId]
//    
//    //定义属性
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    userInfo[@"name"] = @"模拟器用户";
//    userInfo[@"gender"] = @"男";
//    userInfo[@"birthday"] = @"2015/1/11";
//    userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
//    userInfo[@"email"] = @"support@zhugeio.com";
//    userInfo[@"mobile"] = @"18901010101";
//    userInfo[@"qq"] = @"91919";
//    userInfo[@"weixin"] = @"121212";
//    userInfo[@"weibo"] = @"122222";
//    userInfo[@"location"] = @"北京朝阳区";
//    userInfo[@"公司"] = @"37degree";
//    
//    //跟踪用户
//    [[Zhuge sharedInstance] identify:userId properties:userInfo];
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
