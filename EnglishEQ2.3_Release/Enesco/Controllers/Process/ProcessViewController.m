//
//  ProcessViewController.m
//  Enesco
//
//  Created by wangjie on 16/6/7.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import "ProcessViewController.h"
#import "DAL.h"
#import "Helper.h"

@interface ProcessViewController ()

@end

@implementation ProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  NSString* version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString* build =   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    _lblVersionBuild.text =[NSString stringWithFormat:@"Vresion:%@ Build:%@",version,build];
    
    _lblMin.font = [UIFont fontWithName:@"Aladdin" size:20.0];
    
    _lblTimes.font = [UIFont fontWithName:@"Aladdin" size:20.0];
    
    _lblChapters.font = [UIFont fontWithName:@"Aladdin" size:20.0];
    
    _lblDays.font = [UIFont fontWithName:@"Aladdin" size:20.0];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"label_progress_normal"] selectedImage:[UIImage imageNamed:@"label_progress_active"]];
    
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);
    self.tabBarItem.tag = 1;
    [self.tabBarItem setTitlePositionAdjustment: UIOffsetMake(0,-3)];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];

    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",[userDefaultes stringForKey:@"username"],[Helper getDateForamt:[NSDate new]]];


    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadStudyInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadStudyInfo{
    DAL *dal =[DAL shareInstance];
    
    NSString *studyDuration=  [Helper getMinFromSecond:[[dal getUsedTime] integerValue]];

    NSString * Times =[dal getAllTimes];
    
    NSString * Days =[NSString stringWithFormat:@"%ld", (long)[dal getAllDays] ]  ;
    
    NSString * chapterNum =[NSString stringWithFormat:@"%ld", (long)[dal getListenChapterCount] ]  ;
    
    _lblMin.text = studyDuration;
    
    _lblTimes.text = Times;
    
    _lblChapters.text = chapterNum;
    
    _lblDays.text = Days;
    
    NSDictionary *userInfo = [Helper getUserInfo];
    
    NSString *phase = [userInfo objectForKey:@"phase"];
    NSInteger whichPhase = 1;
    if(phase){
        whichPhase = [phase doubleValue];
    }
    double money = [[DAL shareInstance] getAllReward];
    double allMoney = whichPhase * 900;  //这里应该是说每个人的金额不一样
    
    self.pgsMoney.progress = money / allMoney;
    
    self.lblProcess.font = [UIFont fontWithName:@"Aladdin" size:20.0];
    self.lblProcess.text = [NSString stringWithFormat:@"%d / %d RMB",(int)money,(int)allMoney];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
