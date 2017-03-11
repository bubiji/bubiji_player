//
//  ExampleWKWebViewController.h
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "UserInfoViewController.h"

//@protocol planViewController_Delegate <NSObject,MPPlayableContentDelegate>
//@optional
//- (void)planViewController_DidFinishPlaying;
//@end


@interface UserInfoViewController : UINavigationController<WKNavigationDelegate>

//@property(nonatomic,retain) MusicPlayerViewController *PlayController;
//@property(nonatomic, retain) id playController_delegate;


@end