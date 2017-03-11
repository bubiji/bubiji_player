//
//  MusicPlayerViewController.m
//  MusicPlayer
//
//  Created by lidian on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MusicPlayerViewController.h"

//CONSTANTS:

#define kPaletteHeight					30
#define kPaletteSize				    5
#define kAccelerometerFrequency			25 //Hz
#define kFilteringFactor				0.1
#define kMinEraseInterval				0.5
#define kEraseAccelerationThreshold		4.3

@implementation MusicPlayerViewController
@synthesize volumeSlider,durationLabel,currentLabel,playerController,currentTitleLabel,playModelButton,prevButton,nextButton,didDaysLable,didTimeLable;
@synthesize avaPlayer;

#pragma mark - View lifecycle
//获取代理 
-(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
-(id)init
{
    self = [super init];
    if(self)
    {
        _musiclist = [[NSMutableArray alloc] init];

        return self;
    }
    return self;

}
//一下没看懂 如果播放中 改位暂停 什么时候调用呢？  这是初始化用的。。。
-(void)viewWillAppear:(BOOL)animated
{
    if([avaPlayer isplaying])
    {
        playerController.showsTouchWhenHighlighted = YES;
        [self.playerController setImage:[UIImage imageNamed: @"newpasue.png"]
                               forState:UIControlStateNormal];
    }
}

//控制晃动

-(void)initAccelerometer
{

    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = 1.0/60.0;

}
- (void)viewDidLoad
{
    //每秒都更新slider   拖动不流畅与这个事件无关
    //    appDelegate.timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateCurrent) userInfo:nil repeats:YES];
    
    [super viewDidLoad];
    
    self.currentTitleLabel.text=currentMusic.title;
    
    [self UpdateDaysTimesLable];
    //初始化学习时间
    _AlreadyTime= [avaPlayer getClassTime];//*10;
    
    //抬起的时候触发事件UIControlEventTouchUpInside 这个是为了抬手的时候 设置播放器时间
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    _currentnewSlider =[[UISlider alloc]initWithFrame:CGRectMake(0, 150, width, 8)];
    [_currentnewSlider addTarget:self action:@selector(setCurrent:) forControlEvents:UIControlEventTouchUpInside];
    [_currentnewSlider setContinuous:NO];// value change 会触发
    //updateCurrent 这是为了改变silder值时候 同步label时间
    [_currentnewSlider addTarget:self action:@selector(updateCurrentTimeLabel) forControlEvents:UIControlEventValueChanged];
    
//    NSLog(@"[basePlayer getClassTime] %f",[avaPlayer getClassTime]);
//    NSLog(@"[basePlayer getCurrentTime] %f",[avaPlayer getCurrentTime]);
    _currentnewSlider.maximumValue=[avaPlayer getClassTime];
    _currentnewSlider.value=0;//[avaPlayer getCurrentTime];
    [self.view addSubview:_currentnewSlider];

    //后台播放的
    audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    //听歌时被打断
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(backToHomeScreen:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(backToApp:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //背景
    UIColor *back =[[UIColor alloc ]initWithPatternImage:[UIImage imageNamed:@"macbg.png"]];
    self.view.backgroundColor=back;

    

    
}
#pragma 打断进入后台 和back to app
//打断
-(void)backToHomeScreen:(NSNotification*)notify
{    
    //AppDelegate *appDelegate=[self getAppDelegate];
    //    if(currentMusic.isPlaying)
    //    {        
    //        [self.playerController setBackgroundImage:[UIImage imageNamed: @"newplay.png"]  
    //                                         forState:UIControlStateNormal];
    //        //currentMusic.isPlaying=NO;        
    //        [basePlayer playsPause];
    //        
    //    }
    
}
//恢复打断
-(void)backToApp:(NSNotification*)notify
{
    if([avaPlayer isplaying])
    {
        [self.playerController setImage:[UIImage imageNamed: @"newpasue.png"]
                                         forState:UIControlStateNormal];
        [avaPlayer playsPause];
    }
    
}

#pragma mark button event
//播放新歌曲
-(void)newPlay :(Music*) music
{
    //如果和现在听得一样 不切换
    if ([music.title isEqualToString: currentMusic.title])
    {
        return;
    }
    
    self.currentTitleLabel.text=currentMusic.title;

  
    [self startTimer];
   
    
    avaPlayer = [[AVAudioPlayerManager alloc] initAVAudioPlayerwithMusic:music];
    avaPlayer.ava_player_delegate=self;
    [avaPlayer playsPlay];
    
    currentMusic=music;
    currentMusic.ClassTime =0; //有吗？
    currentMusic.ClassTime = [avaPlayer getClassTime];    //获取时长 顺序不能变
    
    //服务端验证
    //    AppDelegate *appDelegate=[self getAppDelegate];
    //    NSLog(@"type %@ --name %@",music.type,music.title);
    //    //NSLog(@"list %@",_musiclist);
    //
    //    if ([music.type isEqualToString:@"none"]) {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat: @"Required Import!",currentMusic.title,currentMusic.DidTimes,currentMusic.DidDays] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
    //        //这里可以加上 如果不想再次提醒 就点取消提醒
    //        // optional - add more buttons:
    //        //[alert addButtonWithTitle:@"Yes"];
    //        [alert show];
    //        return;
    //    }
    //    
    //
    
    //要设置时间再播放
    //NSLog(@"time %f",currentMusic.ClassTime);
    //当前class播放时长
    
    //[appDelegate.dal updateClassTime:music];
//    currentMusic.isPlaying=YES;
//    [self UpdateDaysTimesLable];
//    [self initAppSectionMusicList];
    
    // [appDelegate.RootDelegate listReloadData]; 原先是为了通知 其他页面 更新页面。
    
}


//choose play model  --button 1
- (void)playModelChoose:(id)sender
{
    switch (_PlayModel) {
        case PlayNormal:
            [playModelButton setImage:[UIImage imageNamed: @"newrepeatone.png"] forState:UIControlStateNormal];
            _PlayModel =RepeatOne;
            break;
        case RepeatOne:
            [playModelButton setImage:[UIImage imageNamed: @"newcycle.png"] forState:UIControlStateNormal];
            _PlayModel =RepeatGroup;
            break;
        case RepeatGroup:
            [playModelButton setImage:[UIImage imageNamed: @"newplaynormal.png"] forState:UIControlStateNormal];
            _PlayModel =PlayNormal;
            break; 
        default:
            [playModelButton setImage:[UIImage imageNamed: @"newplaynormal.png"] forState:UIControlStateNormal];
            _PlayModel =PlayNormal;
            break;
    }
    
}
//播放之前的音乐  --button 2
-(IBAction)playPreviousMusic:(id)sender
{
    if(currentMusic==nil)
    {
        return;
    }

    if(currentMusic.tag!=0)
    { //根据编号找到之前的 音乐
            Music *music=[_musiclist objectAtIndex:currentMusic.tag-1];
            [self newPlay:music];
        NSLog(@"class :%@ ~~~ currentMusic.tag:%ld",music,currentMusic.tag-1);
            
    }
}
//播放下一首歌曲  --button 4
-(IBAction)playNextMusic:(id)sender
{
    [self AVAudioPlayerManageDidFinishPlaying];
    return;
    if(currentMusic==nil)
    {
        return;
    }
    NSInteger index =currentMusic.tag;
    
    if(index<[_musiclist count]-1)
    {
      index= index+1;
      Music *music=[_musiclist objectAtIndex:index];
      NSLog(@"class :%@ ~~~ currentMusic.tag:%ld",music.title,index+1);

      [self newPlay:music];


    }
}

//开始或者暂停
-(IBAction)playOrPause:(id)sender
{
        if(![avaPlayer isplaying])
        {
            [avaPlayer playsPlay];
            [playerController setImage:[UIImage imageNamed: @"newpasue.png"]forState:UIControlStateNormal];

            //为什么不能控制timer呢
            //[appDelegate.timer invalidate];
            //appDelegate.timer=nil;
        }
        else
        {

            [avaPlayer playsPause];
            [playerController setImage:[UIImage imageNamed: @"newplay.png"]  forState:UIControlStateNormal];


        }
}

#pragma mark  每秒更新的事件和 拖动silder更改的事件
-(void)startTimer
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(realTimeUpdateCurrentProcess) userInfo:nil repeats:YES];
}
//每秒钟都要更新的 event 应该 总时间也相应减少
-(void)realTimeUpdateCurrentProcess
{
    self.currentTitleLabel.text=currentMusic.title;//不知道为什么一定要在这里刷新才可以。

        //显然 player 的currenttime 不是很准 但是还需要这个方法更新
        currentLabel.text=[self getTimeFormat:[NSString stringWithFormat:@"%f",[avaPlayer getCurrentTime]]];
        durationLabel.text=[self getTimeFormat:[NSString stringWithFormat:@"%f",[avaPlayer getClassTime]]];
        //self.currentSlider.maximumValue=[basePlayer getClassTime];
        _currentnewSlider.value=[avaPlayer getCurrentTime];
    NSLog(@"[basePlayer getClassTime] %f",[avaPlayer getClassTime]);
    NSLog(@"[basePlayer getCurrentTime] %f",[avaPlayer getCurrentTime]);
    
  //  }
    
    
    if (_AlreadyTime>0) {
        _AlreadyTime--;
    }
    
    //每次减一秒 直到减完 激发暂停事件  //暂停功能基本没用
    //    if (appDelegate.StopTime!=0) {
    //        if( appDelegate.StopTime >1)
    //        {
    //            appDelegate.StopTime--;
    //        }
    //        if (appDelegate.StopTime==1) {
    //            [appDelegate.AVPlayer pause];
    //            appDelegate.StopTime =0;
    //        }
    //    }
    //    
    // NSLog(@"timeer:%@",appDelegate.timer);
}

//更新播放了的时间  这个是根据value change事件更改的 
-(void)updateCurrentTimeLabel
{
    if(currentMusic!=nil)
    {
        self.currentLabel.text=[self getTimeFormat:[NSString stringWithFormat:@"%f",_currentnewSlider.value]];
        //这个数值可能还是有点问题打印 plays currnttime 和当前text比较一下才好
    }
}
#pragma mark  和进度条有关的
//设置音量 
-(IBAction)setVolume:(id)sender
{
    //就是把前台传来的值 给得带的代理   问题始终围绕在代理上
    //Volume =[(UISlider*)sender value];
    
    [avaPlayer setVolume:[(UISlider*)sender value]];
    
}

//控制播放进度
-(IBAction)setCurrent:(id)sender
{
    //暂停音乐
    [avaPlayer playsPause];
    
    //NSLog(@"执行");
    
     [avaPlayer setCurrent:[_currentnewSlider value]];
        
    [avaPlayer playsPause];
}


#pragma mark Remote Control Events
- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
	UIApplication *application = [UIApplication sharedApplication];
	if([application respondsToSelector:@selector(beginReceivingRemoteControlEvents)])
		[application beginReceivingRemoteControlEvents];
	[self becomeFirstResponder]; // this enables listening for events
	// update the UI in case we were in the background
	//NSNotification *notification = [NSNotification	 notificationWithName:ASStatusChangedNotification	 object:self];
	//[[NSNotificationCenter defaultCenter] postNotification:notification];
}
/* The iPod controls will send these events when the app is in the background */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
            if ( currentMusic.isPlaying==YES) {
                [avaPlayer playsPause];
                currentMusic.isPlaying=NO;
                
            }else
            {
                [avaPlayer playsPause];
                currentMusic.isPlaying=YES;
                
                //[appDelegate.iPodPlayer play];
                
            }
			break;
            //		case UIEventSubtypeRemoteControlPlay: //执行不到
            //            [basePlayer playsPlay];            
            //            //[appDelegate.iPodPlayer play];
            //            
            //			break;
            //		case UIEventSubtypeRemoteControlPause://执行不到
            //            [basePlayer playsPause];            
            //            //[appDelegate.iPodPlayer pause];
            //            
            //			break;
            //		case UIEventSubtypeRemoteControlStop: //执行不到
            //            [basePlayer playsstop];            
            //            
            //			break;
            //            //增加上一首和下一首
		default:
			break;
	}
}




#pragma  mark -
#pragma  mark  每次播放结束 新歌曲 并且更新times 和days


//更新lables  :times and days
-(void)UpdateDaysTimesLable
{
    //****从服务器获取数据更新界面    这里应该统计出来 今天学了多久。
    
    //200  time
    //UILabel  *timeLable =  (UILabel*) [self.view viewWithTag:200];
    didTimeLable.text =[NSString stringWithFormat:@"Times : %ld/%ld",  (long)currentMusic.DidTimes,(long)currentMusic.BestTimes];
    //100 days
    //UILabel  *dayLable =  (UILabel*) [self.view viewWithTag:100];
    didDaysLable.text =[NSString  stringWithFormat:@"Days : %ld/%ld" ,(long)currentMusic.DidDays,(long)currentMusic.BestDays];
    
}

- (NSString*)generateTimeIntervalWithTimeZone
{
//    //得到当前时间
//    NSDate* date = [NSDate date];
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString* time = [formatter stringFromDate:date];
    
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * result = [df stringFromDate:currentDate];
    
    NSLog(@"系统当前时间为：%@",result);
    
    return result;
}
#pragma  mark -
#pragma  mark  记录操作
//歌曲结束后 写入数据库 FinishPlaying
-(void)AVAudioPlayerManageDidFinishPlaying
{
    RecordClass* record =[[RecordClass alloc]init];
    record.classId =currentMusic.classID;
    double studyduration =[avaPlayer getClassTime] -_AlreadyTime;
    record.studyduration =[NSString stringWithFormat:@"%f",studyduration];
    NSLog(@"_AlreadyTime：%f",_AlreadyTime);

    record.isMove =@"0";
    record.location =@"0";
    record.startTime =[self generateTimeIntervalWithTimeZone];
    record.endTime =[self generateTimeIntervalWithTimeZone];
    
    if (_AlreadyTime/currentMusic.ClassTime< 0.1)
    {
    //回传调用
    [self.player_delegate MusicPlayerViewController_DidFinishPlaying:record];
    }

    //currentSlider.value= 0;
    
    //判断是否入库的标准。
    //以后要提取出来//这里判断是否超过85%
    
   
    
    //更新显示数据 今天的学习时常 保留在音乐播放界面
    didTimeLable.text =[NSString stringWithFormat:@"Times : %ld",  (long)currentMusic.DidTimes];
    didDaysLable.text =[NSString  stringWithFormat:@"Days : %ld" ,(long)currentMusic.DidDays];
    
    //如果你已经超过了推荐次数， 在当时alert一下
    if (currentMusic.DidTimes >= currentMusic.BestTimes)
        //||currentMusic.DidDays >= currentMusic.BestDays)
    {
        //放置课程名 我觉得你这课已经听够了You have learned the 'aaa' for 10 Times and 10 days
        //UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:@"这个是UIAlertController的默认样式" preferredStyle:UIAlertControllerStyleAlert];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Great!" message:[NSString stringWithFormat: @"You have learned the '%@' for %ld Times and %ld Days!",currentMusic.title,(long)currentMusic.DidTimes,(long)currentMusic.DidDays] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
//        [alert show];
    }
    
    //play rule by playmodel
    long Index =0;
    switch (_PlayModel) {
        case PlayNormal:
            //下一首
            Index= currentMusic.tag;
            if ([_musiclist count ]-1 >Index) {
                Index+=1;
                [self newPlay:[_musiclist objectAtIndex:Index]];
            }
            break;
        case RepeatOne:
            //重复播放音乐
            [self newPlay:currentMusic];
            break;
        case RepeatGroup:
            //******* group播放

            //NSLog(@"总 数量 %d",[appDelegate.appSectionMusicList count ]-1);
            Index= currentMusic.tag%3 ;
            //NSLog(@"当前音乐 顺序 %d",Index);
            //NSLog(@"index :%d",Index);
            //NSLog(@"count :%d",[appDelegate.appSectionMusicList count]);
            
            if ([_musiclist count]-1==Index  ) {
                Index=0;
            }else
            {
                Index+=1;
            }
            //NSLog(@"要播放的 顺序 %d",Index);
            
            [self newPlay:[_musiclist objectAtIndex:Index]];
            
            break;
    }
   
}


#pragma mark ---end----

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
//得到时间格式。。。。
-(NSString *)getTimeFormat:(NSString *)time
{
    //NSLog(@"time %@",time);
    NSMutableString *result=[[NSMutableString alloc] initWithFormat:@""];
    
    NSInteger minute=[time integerValue]/60;
    //NSLog(@"time m%d",minute);
    
    NSInteger second=[time integerValue]%60;
    //NSLog(@"time s%d",second);
    
    
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
    return result ;
}
//返回
- (IBAction)topbuttonBack:(id)sender
{
    //self.dep
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
// 可以记录运动次数
#pragma  mark accelerometer
//- (void) accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
//{
//    UIAccelerationValue				length,
//    x,
//    y,
//    z;
//	
//	//Use a basic high-pass filter to remove the influence of the gravity
//	myAccelerometer[0] = acceleration.x * kFilteringFactor + myAccelerometer[0] * (1.0 - kFilteringFactor);
//	myAccelerometer[1] = acceleration.y * kFilteringFactor + myAccelerometer[1] * (1.0 - kFilteringFactor);
//	myAccelerometer[2] = acceleration.z * kFilteringFactor + myAccelerometer[2] * (1.0 - kFilteringFactor);
//	// Compute values for the three axes of the acceleromater
//	x = acceleration.x - myAccelerometer[0];
//	y = acceleration.y - myAccelerometer[0];
//	z = acceleration.z - myAccelerometer[0];
//	
//	//Compute the intensity of the current acceleration 
//	length = sqrt(x * x + y * y + z * z);
//	// If above a given threshold, play the erase sounds and erase the drawing view
//	if((length >= kEraseAccelerationThreshold) && (CFAbsoluteTimeGetCurrent() > lastTime + kMinEraseInterval)) {
//        AppDelegate *appDelegate=[self getAppDelegate];
//        if(currentMusic!=nil) //音乐非空
//        {
//            //UISlider *currentSlider=(UISlider *)sender; //init slider
//            //这里要么是控制三种模式 晃动一下 退后多少
//            float nowtime = [basePlayer getCurrentTime];            
//            [basePlayer setCurrent:nowtime-3];
//            NSLog(@"摇晃 %f ",nowtime);
//            
//            
//            //设置当前时间 在最后 然后播放
//        }    
//		lastTime = CFAbsoluteTimeGetCurrent();
//	}
//}
@end
