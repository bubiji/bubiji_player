//
//  SettingViewController.h
//  JokePlayer
//
//  Created by apple on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingCell.h"
#import "StopTomeViewController.h"
//#import "AboutViewController.h"
#import "AboutViewController.h"

@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,UITextFieldDelegate>
{
//列表数据
    NSMutableArray *menuList;
   // NSMutableDictionary *menuDic;
    NSMutableArray *keysArray;

    NSMutableArray *valueArray;
    UITableView *SettingTableView;
    
    UITextField *_txtPhoneNum;
}
-(void)initMenuDic;

@end
