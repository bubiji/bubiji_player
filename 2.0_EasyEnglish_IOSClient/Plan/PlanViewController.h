//
//  ExampleWKWebViewController.h
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MusicPlayerViewController.h"
#import "RecordClass.h"



@interface PlanViewController : UINavigationController<WKNavigationDelegate,MusicPlayerViewController_Delegate>

@property(nonatomic,retain) MusicPlayerViewController *PlayController;
@property(nonatomic,retain) NSMutableArray *planlist;


@end