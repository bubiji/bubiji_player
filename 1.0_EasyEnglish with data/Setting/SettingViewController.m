//
//  SettingViewController.m
//  JokePlayer
//
//  Created by apple on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "Zhuge.h"
@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    keysArray =[[NSMutableArray alloc]initWithCapacity:0];
    valueArray =[[NSMutableArray alloc]initWithCapacity:0];

    //menuDic  =[[NSMutableDictionary alloc ]initWithCapacity:0] ;
    [self initMenuDic]; 
    CGRect rect =CGRectMake(0, 70, 320, 460);
    SettingTableView =[[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    SettingTableView.delegate =self;
    SettingTableView.dataSource =self;
    SettingTableView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:SettingTableView];
    [SettingTableView release];
    UIColor *back =[[UIColor alloc ]initWithPatternImage:[UIImage imageNamed:@"Style1.jpg"]];
    self.view.backgroundColor=back;
    [back release];
    
    //最底层？
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    
    //section name
    //backgroudImage
    [button setBackgroundImage:[UIImage imageNamed: @"zhuce.png"] forState:UIControlStateNormal];
    button.backgroundColor =[UIColor clearColor];
    button.frame =CGRectMake(200 , 300, 60, 35);
    //event
    [button addTarget:self action:@selector(btnSectionClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _txtPhoneNum = [[UITextField alloc] init];
    _txtPhoneNum.frame =CGRectMake(50 , 300, 150, 35);
    [_txtPhoneNum setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    
    //_txtPhoneNum.keyboardType = UIKeyboardTypePhonePad;//键盘显示类型
    _txtPhoneNum.backgroundColor= [UIColor whiteColor];

    _txtPhoneNum.placeholder = @"phone"; //默认显示的字
    //[_txtPhoneNum resignFirstResponder];//键盘回收代码


    _txtPhoneNum.delegate=self;
    [self.view addSubview:_txtPhoneNum];


}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
//{
//    // [_txtPhoneNum becomeFirstResponder];
//
//
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];//键盘回收代码
    
    
    return YES;
}


-(void)btnSectionClick:(id)sender
{
    [_txtPhoneNum resignFirstResponder];//键盘回收代码
 
    NSString * phonenNum =  _txtPhoneNum.text;
    if([phonenNum isEqualToString:@"13735200057"])
    {
        NSString *userId = @"cc8c2c0e5e7824b372217610b8ab0814648c9931";//[user getUserId]

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
        
        //跟踪用户
        [[Zhuge sharedInstance] identify:userId properties:userInfo];
//        UIAlertView * alert =  [[UIAlertView alloc]initWithTitle:@"tet" message: delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert show];
//        
        UIAlertView * alert =  [[UIAlertView alloc]initWithTitle:@"成功" message:@"加油吧"  delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil,nil ];
        [alert show];
        return;
    }
    if([phonenNum isEqualToString:@"18976285583"])
    {
        NSString *userId = @"cc8c2c0e5e7824b372217610b8ab0814648c9931";//[user getUserId]
        
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
        
        //跟踪用户
        [[Zhuge sharedInstance] identify:userId properties:userInfo];
        
        UIAlertView * alert =  [[UIAlertView alloc]initWithTitle:@"成功" message:@"加油吧"  delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil,nil ];
        [alert show];
        return;
    }
    
    
    if([phonenNum isEqualToString:@"13811060827"])
    {
        NSString *userId = @"e9dec8568278d3028b70ffeb1e6195c961aadedf";//[user getUserId]
        
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
        
        //跟踪用户
        [[Zhuge sharedInstance] identify:userId properties:userInfo];
        
        UIAlertView * alert =  [[UIAlertView alloc]initWithTitle:@"成功" message:@"加油吧"  delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil,nil ];
        [alert show];
        return;
    }
    if([phonenNum isEqualToString:@"18899162506"])
    {
        NSString *userId = @"d4b70ee294350bc447395f5c34cbf7f93c63f231";//[user getUserId]
        
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
        
        //跟踪用户
        [[Zhuge sharedInstance] identify:userId properties:userInfo];
        UIAlertView * alert =  [[UIAlertView alloc]initWithTitle:@"成功" message:@"加油吧"  delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil,nil ];
        [alert show];
        return;
    }
    
    
    UIAlertView * alert =  [[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入你提供的手机号"  delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [SettingTableView release];
    [valueArray release];
    [valueArray release];
    NSLog(@"SettingViewController release");
    // e.g. self.myOutlet = nil;
}
#pragma  mark -
#pragma mark init menu
-(NSString *)getTimeFormat:(NSString *)time
{
    //NSLog(@"time %@",time);
    NSMutableString *result=[[[NSMutableString alloc] initWithFormat:@""]autorelease];
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

-(void)initMenuDic
{
    AppDelegate *appDelegate=[self getAppDelegate];

    //sql 出来所有的时间
    //算法应该是课程时间长度 乘以听取次数 然后count 所有时间
    NSLog(@"used time:%@",[appDelegate.dal getUsedTime]);
    NSString *dictime=  [self getTimeFormat:[appDelegate.dal getUsedTime]];
    
    [keysArray addObject:@"Duration"];
    [valueArray addObject:dictime];

    //count times
    [keysArray addObject:@"Times"];
    [valueArray addObject:[appDelegate.dal getAllTimes]];
    //[menuDic setObject:alltimes forKey:@"All  Times"];
    
    //count days
    //NSString *alldays=[appDelegate.appDB stringForQuery:@"SELECT sum(DidDays) FROM ClassTable "]; 

    [keysArray addObject:@"Days"];
    [valueArray addObject: [NSString stringWithFormat:@"%ld", (long)[appDelegate.dal getAllDays] ]  ];

    [keysArray addObject:@"About"];
    [valueArray addObject:@""];
    
    //[keysArray addObject:@"Stop Play After Time"];
    //[valueArray addObject:@""];
    
    //设置一个枚举 根据appdelegate 判断时常
    //根据图片名称切换名称
//    [keysArray addObject:@"Change Skin"];
//    [valueArray addObject:@"sky"];
}

-(void)reSetMenuDic
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    //sql 出来所有的时间
    //算法应该是课程时间长度 乘以听取次数 然后count 所有时间
    NSString *dictime=  [self getTimeFormat:[appDelegate.dal getUsedTime]];
    NSLog(@"rused time:%@",[appDelegate.dal getUsedTime]);

    [valueArray replaceObjectAtIndex:0 withObject:dictime];
    
    //count times
    //[valueArray addObject:alltimes];
    [valueArray replaceObjectAtIndex:1 withObject:[appDelegate.dal getAllTimes]];

    //[menuDic setObject:alltimes forKey:@"All  Times"];
    
    //count days
    [valueArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%ld", (long)[appDelegate.dal getAllDays] ]];

//    [keysArray addObject:@"About"];
//    [valueArray addObject:@""];
//    
//    [keysArray addObject:@"Stop Play After Time"];
//    [valueArray addObject:@""];
    
    //设置一个枚举 根据appdelegate 判断时常
    //根据图片名称切换名称
    //    [keysArray addObject:@"Change Skin"];
    //    [valueArray addObject:@"sky"];
}
#pragma  mark -
#pragma mark init table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"SettingView";
    SettingCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID]; 
    if (cell ==Nil) {
        
        cell =[[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil]lastObject];
    }
    //NSLog(@"keys%@",menuDic);
    if (indexPath.row <3) {
        cell.accessoryType =UITableViewCellAccessoryNone;

    }else
    {
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;

    }
    cell.settingName = [keysArray objectAtIndex:indexPath.row];

    cell.settingValue = [valueArray objectAtIndex:indexPath.row];
    return cell;
    
}

//没用
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    
    StopTomeViewController *stvc  =nil;
     AboutViewController *mpView =[[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil]autorelease];
    stvc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    switch (indexPath.row) {
        case 3:
            [self.view.window.rootViewController  presentModalViewController:mpView animated:YES];
            break;
        case 4:
            stvc  =[[[StopTomeViewController alloc]initWithNibName:@"StopTomeViewController" bundle:nil]autorelease];
              //  StopTomeViewController *stv =[StopTomeViewController alloc]init
            //self.view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            StopTomeViewController *view =[StopTomeViewController alloc]
           [self presentModalViewController:stvc animated:YES];
            break;
            
        default:
            break;
    }   
    //    DetailViewController *dvc =[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    //    dvc.title=@"Detail"; 
    //    
    //    // UIApplication  *delegate=[[UIApplication sharedApplication] delegate]; 
    //    
    //    [self.navigationController pushViewController:dvc animated:YES];
    //    //[self.navigationController pushViewController:svc animated:YES];
    //    
    //    NSLog(@"little btn %d clicked",[indexPath row]);
    //dvc.de
    
}

//为了美观 还是用这个
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StopTomeViewController *stvc  =nil;
    AboutViewController *mpView =[[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil]autorelease];
    stvc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    switch (indexPath.row) {
        case 3:
            [self.view.window.rootViewController  presentModalViewController:mpView animated:YES];
            break;
        case 4:
            stvc  =[[[StopTomeViewController alloc]initWithNibName:@"StopTomeViewController" bundle:nil]autorelease];
            //  StopTomeViewController *stv =[StopTomeViewController alloc]init
            //self.view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            //            StopTomeViewController *view =[StopTomeViewController alloc]
            [self presentModalViewController:stvc animated:YES];
            break;
            
        default:
            break;
    }   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{  
    
    [self reSetMenuDic];
    [SettingTableView reloadData];

 
    }


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
