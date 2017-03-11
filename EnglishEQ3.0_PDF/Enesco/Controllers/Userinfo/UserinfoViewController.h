//
//  UserinfoViewController.h
//  Enesco
//
//  Created by lidian on 16/6/2.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserinfoViewController : UIViewController<UITextFieldDelegate>
{
    //列表数据
    NSMutableArray *menuList;
    // NSMutableDictionary *menuDic;
    NSMutableArray *keysArray;
    
    NSMutableArray *valueArray;
    UITableView *SettingTableView;
    
    UITextField *_txtPhoneNum;
    
    IBOutlet UILabel *lblStudyDuration;
    //IBOutlet UILabel *recomDaysLable;
    IBOutlet UILabel *lblDidDays;
    //IBOutlet UILabel *didDaysLable;
    IBOutlet UILabel *lblDidTimes;
    IBOutlet UITextField *txtPhoneNum;
    //IBOutlet UIButton *txtl;
    IBOutlet UIButton *btnLogin;



}
-(void)initMenuDic;

- (IBAction)btnloginClick:(id)sender;
- (IBAction)btngoBackClick:(id)sender;


@end
