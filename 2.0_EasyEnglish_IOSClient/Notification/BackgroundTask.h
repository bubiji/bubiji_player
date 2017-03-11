//
//  HaierSDK_BackgroundTask.h
//  iOS-MQTT-Push-Simple
//
//  Created by Dean on 14-7-8.
//  Copyright (c) 2014年 Bryan Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BackgroundTask : NSObject
{
    //@property (nonatomic, strong)
    NSTimer *myTimer;

}
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundIdentifier;

-(void)startHeartbeat:(UIApplication *)application;

-(void)startBackgroundTask:(UIApplication *)application;

-(void)reconnect;

@end
