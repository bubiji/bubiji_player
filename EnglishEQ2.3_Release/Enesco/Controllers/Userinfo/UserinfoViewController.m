//
//  UserinfoViewController.m
//  Enesco
//
//  Created by lidian on 16/6/2.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import "UserinfoViewController.h"
#import "DAL.h"
#import "Zhuge.h"
@implementation UserinfoViewController


#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];

//    //backgroudImage
//    [button setBackgroundImage:[UIImage imageNamed: @"zhuce.png"] forState:UIControlStateNormal];
//    button.backgroundColor =[UIColor clearColor];
//    button.frame =CGRectMake(200 , 300, 60, 35);
//    //event/Users/DeanLee/bubiji/ESTMusicPlayer-master/Podfile
//    [button addTarget:self action:@selector(btnSectionClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    
//    _txtPhoneNum = [[UITextField alloc] init];
//    _txtPhoneNum.frame =CGRectMake(50 , 300, 150, 35);
//    [_txtPhoneNum setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
//    
//    //_txtPhoneNum.keyboardType = UIKeyboardTypePhonePad;//键盘显示类型
//    _txtPhoneNum.backgroundColor= [UIColor whiteColor];
//    
//    _txtPhoneNum.placeholder = @"phone"; //默认显示的字
//    //[_txtPhoneNum resignFirstResponder];//键盘回收代码
//    

    
    [self initUserInfo];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];//键盘回收代码
    
    
    return YES;
}

- (IBAction)btngoBackClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
 
}


-(void)registerUserInfo:(NSMutableDictionary*)userInfo //userId:(NSString*)userId
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    　　NSString *mobile =userInfo[@"mobile"];
    　　[defaults setObject:mobile forKey:@"mobile"];

      NSString * userId =  [defaults objectForKey:@"newDeviceToken"];

    //跟踪用户
    [[Zhuge sharedInstance] identify:userId properties:userInfo];
    
    UIAlertView * alert =  [[UIAlertView alloc]initWithTitle:@"成功" message:@"加油吧"  delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil,nil ];
    [alert show];
    _txtPhoneNum.text= userInfo[@"mobile"];
    [_txtPhoneNum setUserInteractionEnabled:NO] ;
    btnLogin.hidden=YES;
}

- (IBAction)btnloginClick:(id)sender
{
    [_txtPhoneNum resignFirstResponder];//键盘回收代码
    
    NSString * phonenNum =  _txtPhoneNum.text;
    //1 Scarlett
    if([phonenNum isEqualToString:@"18976285583"])
    {
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"Scarlett";
        userInfo[@"gender"] = @"女";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"18976285583";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"海南";
        // userInfo[@"公司"] = @"37degree";
        
        [self registerUserInfo:userInfo ];
        
        return;
    }
    
    //2
    if([phonenNum isEqualToString:@"18982225358"])
    {
        NSString *userId = @"C6CB5EB18686F2C0269DAC1B7C3CB5E6579C2E1A";//[user getUserId]
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"Jane";
        userInfo[@"gender"] = @"女";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"18982225358";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"北京";
        // userInfo[@"公司"] = @"37degree";
        
        [self registerUserInfo:userInfo ];
        
        return;
    }
    //3
    if([phonenNum isEqualToString:@"18899162506"]) //felix
    {
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"felix";
        userInfo[@"gender"] = @"男";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"18899162506";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"新疆";
        // userInfo[@"公司"] = @"37degree";
        [self registerUserInfo:userInfo ];
        
        return;
    }
    //4
    if([phonenNum isEqualToString:@"18665802030"]) //felix
    {
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"gaoyiming";
        userInfo[@"gender"] = @"男";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"18665802030";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"北京";
        // userInfo[@"公司"] = @"37degree";
        [self registerUserInfo:userInfo ];
        
        return;
    }
    //5 Molly
    if([phonenNum isEqualToString:@"13971446228"])
    {
        NSString *userId = @"C6CB5EB18686F2C0269DAC1B7C3CB5E6579C2E1A";//[user getUserId]
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"Molly";
        userInfo[@"gender"] = @"女";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"13971446228";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"海南";
        // userInfo[@"公司"] = @"37degree";
        
        [self registerUserInfo:userInfo ];
        
        return;
    }
    //6
    if([phonenNum isEqualToString:@"13971446228"])
    {
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"Tina";
        userInfo[@"gender"] = @"女";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"18901010101";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"北京";
        // userInfo[@"公司"] = @"37degree";
        
        [self registerUserInfo:userInfo ];
        return;
    }
    
    //7
    if([phonenNum isEqualToString:@"13501122876"])
    {
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"cedar";
        userInfo[@"gender"] = @"男";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"13501122876";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"北京";
        // userInfo[@"公司"] = @"37degree";
        [self registerUserInfo:userInfo ];
        
        return;
    }
    
    // 8 dean
    if([phonenNum isEqualToString:@"13811060827"])
    {
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"Dean";
        userInfo[@"gender"] = @"男";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"13811060827";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"北京";
        // userInfo[@"公司"] = @"37degree";
        [self registerUserInfo:userInfo ];

        return;
    }
    // 9 fuheng
    if([phonenNum isEqualToString:@"18722696866"])
    {
        
        //定义属性
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[@"name"] = @"fuheng";
        userInfo[@"gender"] = @"男";
        //userInfo[@"birthday"] = @"2015/1/11";
        //userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/180/5637236139/1";
        //userInfo[@"email"] = @"support@zhugeio.com";
        userInfo[@"mobile"] = @"18722696866";
        //        userInfo[@"weixin"] = @"121212";
        //        userInfo[@"weibo"] = @"122222";
        userInfo[@"location"] = @"北京";
        // userInfo[@"公司"] = @"37degree";
        [self registerUserInfo:userInfo ];
        
        return;
    }
    
    
    UIAlertView * alert =  [[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入你提供的手机号"  delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
    
}


#pragma  mark -
#pragma mark init menu

-(void)initUserInfo
{
    DAL *dal =[DAL shareInstance];

    //sql 出来所有的时间
    //算法应该是课程时间长度 乘以听取次数 然后count 所有时间
    NSLog(@"used time:%@",[dal getUsedTime]);
    NSString *dictime=  [self getTimeFormat:[dal getUsedTime]];
    
    
    NSString * studyDuration = dictime;
    lblStudyDuration.text =studyDuration;
    //count times
    NSString * Times =[dal getAllTimes];
    lblDidTimes.text =Times;

    NSString * Days =[NSString stringWithFormat:@"%ld", (long)[dal getAllDays] ]  ;
    lblDidDays.text =Days;

    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *mobile = [defaults objectForKey:@"mobile"];
    if(mobile !=nil)
    {
        _txtPhoneNum.text=mobile;
        [_txtPhoneNum setUserInteractionEnabled:NO] ;
        btnLogin.hidden=YES;
    }
    
    
    //count days
    //NSString *alldays=[appDelegate.appDB stringForQuery:@"SELECT sum(DidDays) FROM ClassTable "];
    

    
    
    //[keysArray addObject:@"Stop Play After Time"];
    //[valueArray addObject:@""];
    
    //设置一个枚举 根据appdelegate 判断时常
    //根据图片名称切换名称
    //    [keysArray addObject:@"Change Skin"];
    //    [valueArray addObject:@"sky"];
}




-(NSString *)getTimeFormat:(NSString *)time
{
    //NSLog(@"time %@",time);
    NSMutableString *result=[[NSMutableString alloc] initWithFormat:@""];
    //NSLog(@"time m%@",time);
    //NSLog(@"miao %d",[time integerValue]);
    
    NSInteger minute=[time integerValue]/60%60;
    //NSLog(@"minute %d",[time integerValue]/60);
    NSInteger hour =[time integerValue]/60/60;
    //NSLog(@"hour %d",[time integerValue]/60/60);
    
    //NSLog(@"time m%d",minute);
    
    NSInteger second=[time integerValue]%60;
    //NSLog(@"time s%d",second);
    if(hour >=0 && hour < 10)
    {
        [result appendFormat:@"0%ld:",(long)hour];
    }
    else if(hour >9)
    {
        [result appendFormat:@"%ld:",(long)hour];
    }
    
    if(minute >=0 && minute < 10)
    {
        [result appendFormat:@"0%ld:",(long)minute];
    }
    else if(minute >9)
    {
        [result appendFormat:@"%ld:",(long)minute];
    }
    if(second<10)
    {
        [result appendFormat:@"0%ld",(long)second];
    }
    else if(second>=10)
    {
        [result appendFormat:@"%ld",(long)second];
    }
    return result;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end
