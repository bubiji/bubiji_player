//
//  HaierSDK_BackgroundTask.m
//  iOS-MQTT-Push-Simple
//
//  Created by Dean on 14-7-8.
//  Copyright (c) 2014年 Bryan Boyd. All rights reserved.
//

#import "BackgroundTask.h"
//#import "HaierSDK_MQTT_PushService.h"
#import "AppDelegate.h"
@implementation BackgroundTask


-(void)startHeartbeat:(UIApplication *)application
{
    [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
        [self backgroundHeartbeat];
        NSLog(@"~~ requestServerHowManyUnreadMessages  handler ");
        
    }];
    
}
-(void)startBackgroundTask:(UIApplication *)application
{
    // for time
    myTimer =NULL;
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                    target:self
                                                  selector:@selector(timerMethod:) userInfo:nil
                                                   repeats:YES];
    
    self.backgroundIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void) {
        [self endBackgroundTask];
    }];
    
}
-(void)reconnect{
  
//[[HaierSDK_MQTT_PushService sharedMessenger] reconnect];
    
}




- (void) endBackgroundTask{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //__weak
    AppDelegate *weakSelf = self;
    dispatch_async(mainQueue, ^(void) {
        AppDelegate *strongSelf = weakSelf;
        if (strongSelf != nil){
            NSLog(@"app endBackgroundTask start  ");
            AppDelegate  *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

            [self reconnect];
            
            [myTimer invalidate];
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundIdentifier];
            UIBackgroundTaskIdentifier backgroundIdentifier = UIBackgroundTaskInvalid;
            //connect
            
        }
    });
}

- (void)backgroundHeartbeat
{
    NSLog(@"app into background start Heartbeat  ");
    
    UIApplication* app = [UIApplication sharedApplication];
    
    if([app applicationState] == UIApplicationStateBackground)
    {
        myTimer =NULL;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                        target:self
                                                      selector:@selector(timerMethod:) userInfo:nil
                                                       repeats:YES];
        self.backgroundIdentifier = [app beginBackgroundTaskWithExpirationHandler:^(void) {
            [self endBackgroundTask];
        }];
        
        
        NSLog(@"app into background UIApplicationStateBackground  ");
    }
    else if([app applicationState] == UIApplicationStateActive)
    {
        NSLog(@"app into background UIApplicationStateActive  ");
        
    }
}

// check divice is multitaskingSupported
- (BOOL)isMultitaskingSupported
{
    BOOL result = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        result = [[UIDevice currentDevice] isMultitaskingSupported];
    }
    return result;
}

- (void)timerMethod:(NSTimer *)paramSender{
    //获取后台任务可执行时间，单位
    //秒，若应用未能在此时间内完成任务，则应用将被终止
    NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
    
    //应用处于前台时，backgroundTimeRemaining值weiDBL_MAX
    if (backgroundTimeRemaining == DBL_MAX) {
        NSLog(@"Background time remaining = Undetermined");
    } else {
        NSLog(@"Background time remaining = %.02f seconds", backgroundTimeRemaining);
    }
}

@end
