//
//  LoginViewController.m
//  Enesco
//
//  Created by wangjie on 16/6/7.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import "LoginViewController.h"
#import "Helper.h"
#import "OldUser.h"
#import "Zhuge.h"
#import "MBProgressHUD.h"
@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.delegate =self;
    //self.txtPhoneNum.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_phone"]];
   // self.txtPhoneNum.leftViewMode = UITextFieldViewModeAlways;
    
    //self.txtName.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_name"]];
   // self.txtName.leftViewMode = UITextFieldViewModeAlways;
    
    //self.txtWechat.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_wechat"]];
    //self.txtWechat.leftViewMode = UITextFieldViewModeAlways;
}

- (IBAction)btnloginClick:(id)sender{
    NSString *message = nil;
    
    NSString *name = [self.txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *wechat = [self.txtWechat.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *phoneNum = [self.txtPhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if([Helper isBlankString: phoneNum]){
        message = @"PhoneNum is Empty!";
    }
    else if([Helper isBlankString: name]){
        message = @"Name is Empty!";
    }
    else if([Helper isBlankString: wechat]){
        message = @"Wechat is Empty!";
    }
    else if(![Helper isPhoneNum:phoneNum]){
        message = @"PhoneNum is Wrong!";
    }
    else{
        message = nil;
    }
    if(message){
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alter show];
        
        [self showMiddleHint:message];

    }
    else{
        [Helper loginWith:self.txtName.text wechat:self.txtWechat.text phoneNum:self.txtPhoneNum.text];
        if(![OldUser handleOldUser:phoneNum]){
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[@"name"] = name;
            userInfo[@"gender"] = @"-";
            userInfo[@"mobile"] = phoneNum;
            userInfo[@"location"] = @"-";
            [[Zhuge sharedInstance] identify:phoneNum properties:userInfo];
        }

        if(self.delegate){
            [self.delegate loginWith:name wechat:wechat phoneNum:phoneNum];
        }
        UIAlertView * alert =  [[UIAlertView alloc]initWithTitle:@"成功" message:@"加油吧"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil ];
        [alert show];
    }
}
# pragma mark - HUD

- (void)showMiddleHint:(NSString *)hint {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.margin = 10.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtName resignFirstResponder];
    [self.txtPhoneNum resignFirstResponder];
    [self.txtWechat resignFirstResponder];

}

@end
