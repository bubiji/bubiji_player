//
//  PlanViewController.h
//  JokePlayer
//
//  Created by apple on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIApplicationDelegate,PlayerViewControllerDelegate,UITabBarControllerDelegate>
{
    UISearchBar *searchBar;
    UILabel *logoLable;
    NSMutableArray *AllDataSourceForSearch;  //cell 遍历的时候添加的数据
    UISearchDisplayController *SearchDisplay;
   // AVAudioSession *audioSession;
    int flag[1000];

    UITableView *planTableViewList;

}
@end
