//
//  LoginViewController.h
//  Enesco
//
//  Created by wangjie on 16/6/7.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginViewControllerDelegate <NSObject>
@optional
-(BOOL)loginWith:(NSString *)name wechat:(NSString *)wechat phoneNum:(NSString *)phoneNum;
@end

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property(nonatomic,strong) IBOutlet UITextField *txtName;
@property(nonatomic,strong) IBOutlet UITextField *txtWechat;
@property(nonatomic,strong) IBOutlet UITextField *txtPhoneNum;

- (IBAction)btnloginClick:(id)sender;

@property(nonatomic,weak)  id<LoginViewControllerDelegate> delegate;
@end
