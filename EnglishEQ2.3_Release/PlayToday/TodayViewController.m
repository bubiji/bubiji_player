//
//  TodayViewController.m
//  PlayToday
//
//  Created by lidian on 16/6/5.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    //http://www.jianshu.com/p/ab268a1ae000
//    NSUserDefaults* userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.bubiji"];
//    NSString* nickName = [userDefault objectForKey:@"group.bubiji.name"];
//    if (nickName) {
//        NSString* message = @"M 1/3 ;S 2/3 ;V3/3";
//        self->lblShow.text = [NSString stringWithFormat:@"%@,%@",nickName,message];
//    }
//    
   // self->lblShow.text =@"M 1/3 ;S 2/3 ;V3/3";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}
- (IBAction)menuPressed:(id)sender
{
    
    [self.extensionContext openURL:[NSURL URLWithString:@"Bubiji://action=Content"] completionHandler:^(BOOL success) {
        NSLog(@"open url result:%d",success);
    }];
    
    UIButton* button = (UIButton*)sender;

    if (button.tag == 1) {
        [self.extensionContext openURL:[NSURL URLWithString:@"Bubiji://action=Content"] completionHandler:^(BOOL success) {
            NSLog(@"open url result:%d",success);
        }];
    }
    else if(button.tag == 2) {
        [self.extensionContext openURL:[NSURL URLWithString:@"Bubiji://action=Progress"] completionHandler:^(BOOL success) {
            NSLog(@"open url result:%d",success);
        }];
    }
    
    
    
}
//缩进问题
//- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
//{
//    return UIEdgeInsetsZero;
//}
@end
