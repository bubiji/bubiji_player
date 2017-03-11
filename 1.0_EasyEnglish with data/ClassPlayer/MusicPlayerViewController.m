//
//  MusicPlayerViewController.m
//  MusicPlayer
//
//  Created by 韩国翔 on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "Zhuge.h"
//CONSTANTS:

#define kPaletteHeight					30
#define kPaletteSize				    5
#define kAccelerometerFrequency			25 //Hz
#define kFilteringFactor				0.1
#define kMinEraseInterval				0.5
#define kEraseAccelerationThreshold		4.3

@implementation MusicPlayerViewController
@synthesize currentSlider,volumeSlider,durationLabel,currentLabel,playerController,currentTitleLabel,playModelButton,prevButton,nextButton,didDaysLable,didTimeLable;
@synthesize playerdelegate;
@synthesize basePlayer;

#pragma mark - View lifecycle
//获取代理 
-(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
//一下没看懂 如果播放中 改位暂停 什么时候调用呢？  这是初始化用的。。。
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate=[self getAppDelegate];
    if(appDelegate.currentMusic.isPlaying)
    {
        // playerController.showsTouchWhenHighlighted = YES;
        
        [playerController setBackgroundImage:[UIImage imageNamed: @"newpasue.png"] forState:UIControlStateNormal];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //AppDelegate *appDelegate=[self getAppDelegate];
    //每秒都更新slider   拖动不流畅与这个事件无关
    //    appDelegate.timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateCurrent) userInfo:nil repeats:YES];
    
    [super viewDidLoad];
    
    //初始化所有按钮
    [self initButton];
    
    //控制晃动
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = 1.0/60.0;
    
    [self UpdateDaysTimesLable];
    //抬起的时候触发事件UIControlEventTouchUpInside 这个是为了抬手的时候 设置播放器时间
    [currentSlider addTarget:self action:@selector(setCurrent:) forControlEvents:UIControlEventTouchUpInside];
    
    //[currentSlider setContinuous:NO];
    //updateCurrent 这是为了改变silder值时候 同步label时间
    [currentSlider addTarget:self action:@selector(updateCurrentTimeLabel) forControlEvents:UIControlEventValueChanged];
    
    
    audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    //听歌时被打断
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(backToHomeScreen:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(backToApp:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    UIColor *back =[[UIColor alloc ]initWithPatternImage:[UIImage imageNamed:@"macbg.png"]];
    self.view.backgroundColor=back;

    //new player
    //AppDelegate *appDelegate=[self getAppDelegate];
    
    //[self.view addSubview:musicPlayer];
	//[self performSelector:@selector(initialMusicList)];
    
    NSLog(@"%@",@"播放器页面");

    
}
#pragma 打断进入后台 和back to app
//打断
-(void)backToHomeScreen:(NSNotification*)notify
{    
    //AppDelegate *appDelegate=[self getAppDelegate];
    //    if(appDelegate.currentMusic.isPlaying)
    //    {        
    //        [self.playerController setBackgroundImage:[UIImage imageNamed: @"newplay.png"]  
    //                                         forState:UIControlStateNormal];
    //        //appDelegate.currentMusic.isPlaying=NO;        
    //        [basePlayer playsPause];
    //        
    //    }
    
    NSMutableDictionary *eventObject = [NSMutableDictionary dictionary];
    eventObject[@"Model"] = @"backToHomeScreen";
    [[Zhuge sharedInstance] track:@"Pause" properties:eventObject];
    
}
//恢复打断
-(void)backToApp:(NSNotification*)notify
{
    NSMutableDictionary *eventObject = [NSMutableDictionary dictionary];
    eventObject[@"Model"] = @"backToApp";
    [[Zhuge sharedInstance] track:@"Pause" properties:eventObject];

    AppDelegate *appDelegate=[self getAppDelegate];
    
    if(appDelegate.currentMusic.isPlaying)
    {
        
        [self.playerController setBackgroundImage:[UIImage imageNamed: @"newpasue.png"] 
                                         forState:UIControlStateNormal];
        [basePlayer playsPlay];            
    }
    
}
- (void)dealloc
{
    [currentTitleLabel release];
    [playerController release];
    [durationLabel release];
    [currentLabel release];
    [currentSlider release];
    [volumeSlider release];
    //[prevButton release];
    //[nextButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark button event


//choose play model  --button 1
- (void)playModelChoose:(id)sender
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    NSMutableDictionary *eventObject = [NSMutableDictionary dictionary];

    //playModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //playModelButton.frame =CGRectMake(30, 45, 80, 80);
    switch (appDelegate.PlayModel) {
        case PlayNormal:
            [playModelButton setBackgroundImage:[UIImage imageNamed: @"newrepeatone.png"] forState:UIControlStateNormal];
            appDelegate.PlayModel =RepeatOne;
            eventObject[@"playModel"] = @"RepeatOne";

            break;
        case RepeatOne:
            [playModelButton setBackgroundImage:[UIImage imageNamed: @"newcycle.png"] forState:UIControlStateNormal];
            appDelegate.PlayModel =RepeatGroup;
            eventObject[@"playModel"] = @"RepeatGroup";

            break;
            
        case RepeatGroup:
            [playModelButton setBackgroundImage:[UIImage imageNamed: @"newplaynormal.png"] forState:UIControlStateNormal];
            appDelegate.PlayModel =PlayNormal;
            eventObject[@"playModel"] = @"PlayNormal";

            break;
        default:
            [playModelButton setBackgroundImage:[UIImage imageNamed: @"newplaynormal.png"] forState:UIControlStateNormal];
            appDelegate.PlayModel =PlayNormal;
            eventObject[@"playModel"] = @"PlayNormal";

            break;
    }
    
    //    playModelButton.showsTouchWhenHighlighted = YES;
    //    [playModelButton addTarget:self action:@selector(choosePlayModel:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:playModelButton];
    
    
    
  
    [[Zhuge sharedInstance] track:@"playModelChoose" properties:eventObject];
    
    
}
//播放之前的音乐  --button 2
-(IBAction)playPreviousMusic:(id)sender
{
    AppDelegate *appDelegate=[self getAppDelegate];
    if(appDelegate.currentMusic!=nil)
    {
        if(appDelegate.currentMusic.tag!=0)
        { //根据编号找到之前的 音乐
            Music *music=[appDelegate.musiclist objectAtIndex:appDelegate.currentMusic.tag-1];
            
            [self newPlay:music];
        }
    }
}
//播放下一首歌曲  --button 4
-(IBAction)playNextMusic:(id)sender
{
    AppDelegate *appDelegate=[self getAppDelegate];
    if(appDelegate.currentMusic!=nil)
    {
        if(appDelegate.currentMusic.tag<[appDelegate.musiclist count]-1)
        {
            Music *music=[appDelegate.musiclist objectAtIndex:appDelegate.currentMusic.tag+1];
            
            [self newPlay:music];
        }
    }
}

//开始或者暂停
-(IBAction)playOrPause:(id)sender
{
    NSMutableDictionary *eventObject = [NSMutableDictionary dictionary];
    eventObject[@"Model"] = @"playOrPause";
    [[Zhuge sharedInstance] track:@"Pause" properties:eventObject];
    
    
    AppDelegate *appDelegate=[self getAppDelegate];
    if(appDelegate.currentMusic!=nil)
    {
        if(appDelegate.currentMusic.isPlaying)
        {
            //[self.playerController setTitle:@"播放" forState:UIControlStateNormal];
            
            [self.playerController setBackgroundImage:[UIImage imageNamed: @"newplay.png"]  
                                             forState:UIControlStateNormal];
            appDelegate.currentMusic.isPlaying=NO;
            //[appDelegate.AVPlayer pause];
            
            [basePlayer playsPause];
            //为什么不能控制timer呢
            //[appDelegate.timer invalidate];
            //appDelegate.timer=nil;
        }
        else
        {
            [self.playerController setBackgroundImage:[UIImage imageNamed: @"newpasue.png"] 
                                             forState:UIControlStateNormal];
            appDelegate.currentMusic.isPlaying=YES;
            [basePlayer playsPlay];            
        }
    }
}

#pragma mark  每秒更新的事件和 拖动silder更改的事件

//每秒钟都要更新的 event 应该 总时间也相应减少
-(void)updateCurrent
{
    AppDelegate *appDelegate=[self getAppDelegate];
    if(appDelegate.currentMusic!=nil)
    {
        //显然 player 的currenttime 不是很准 但是还需要这个方法更新
        self.currentLabel.text=[self getTimeFormat:[NSString stringWithFormat:@"%f",[basePlayer getCurrentTime]]];        
        self.durationLabel.text=[self getTimeFormat:[NSString stringWithFormat:@"%f",[basePlayer getClassTime]]];
        self.currentSlider.maximumValue=[basePlayer getClassTime];
        self.currentSlider.value=[basePlayer getCurrentTime];
        self.currentTitleLabel.text=appDelegate.currentMusic.title;
        //NSLog(@"time :%f",appDelegate.currentMusic.ClassTime);
    }
    if (appDelegate.AlreadyTime>0) {
        appDelegate.AlreadyTime--;
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
    AppDelegate *appDelegate=[self getAppDelegate];
    if(appDelegate.currentMusic!=nil)
    {
        self.currentLabel.text=[self getTimeFormat:[NSString stringWithFormat:@"%f",self.currentSlider.value]];
        //这个数值可能还是有点问题打印 plays currnttime 和当前text比较一下才好
    }
}
#pragma mark  和进度条有关的
//设置音量 
-(IBAction)setVolume:(id)sender
{
    //就是把前台传来的值 给得带的代理   问题始终围绕在代理上
    //Volume =[(UISlider*)sender value];
    
    [basePlayer setVolume:[(UISlider*)sender value]];
    
}

//控制播放进度
-(IBAction)setCurrent:(id)sender
{
    AppDelegate *appDelegate=[self getAppDelegate];
    //暂停音乐
    [basePlayer playsPause];
    
    //NSLog(@"执行");
    if(appDelegate.currentMusic!=nil) //音乐非空
    {
        [basePlayer setCurrent:[self.currentSlider value]];
        
    }    
    [basePlayer playsPlay];
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
    AppDelegate *appDelegate=[self getAppDelegate];
    
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
            if ( appDelegate.currentMusic.isPlaying==YES) {
                [basePlayer playsPause];            
                appDelegate.currentMusic.isPlaying=NO;
                
            }else
            {
                [basePlayer playsPlay];            
                appDelegate.currentMusic.isPlaying=YES;
                
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
#pragma  mark  init button


//init button
-(void)initButton
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    //model
    playModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playModelButton.frame =CGRectMake(15, 360, 60, 60);
    [playModelButton setBackgroundImage:[UIImage imageNamed: @"newplaynormal.png"] forState:UIControlStateNormal];
    playModelButton.showsTouchWhenHighlighted = YES;
    [playModelButton addTarget:self action:@selector(playModelChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playModelButton];
    
    //pre
    prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.frame =CGRectMake(92, 360, 60, 60);
    [prevButton setBackgroundImage:[UIImage imageNamed: @"newpre.png"] forState:UIControlStateNormal];
    prevButton.showsTouchWhenHighlighted = YES;
    [prevButton addTarget:self action:@selector(playPreviousMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:prevButton];
    //play button
    playerController = [UIButton buttonWithType:UIButtonTypeCustom];
    playerController.frame =CGRectMake(170, 360, 60, 60);
    
    if (appDelegate.currentMusic.isPlaying) {
        [playerController setBackgroundImage:[UIImage imageNamed: @"newpasue.png"] forState:UIControlStateNormal];
    }else
    {
        [playerController setBackgroundImage:[UIImage imageNamed: @"newplay.png"] forState:UIControlStateNormal];
    }
    //next
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame =CGRectMake(245, 360, 60, 60);
    [nextButton setBackgroundImage:[UIImage imageNamed: @"newnext.png"] forState:UIControlStateNormal];
    nextButton.showsTouchWhenHighlighted = YES;
    [nextButton addTarget:self action:@selector(playNextMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    playerController.showsTouchWhenHighlighted = YES;
    
    [playerController addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    //顶部退回按钮
    
    UIButton *topBackButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 65)];
    //插入一个imageview
    topBackButton.showsTouchWhenHighlighted = YES;
    
    UIImageView *imageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navtopbtn.png"]];
    
    [topBackButton insertSubview:imageView atIndex:0];
    [imageView release];
    imageView.frame =CGRectMake(0, 0, 320, 45);
    
    [topBackButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    
    
    currentSlider =[[UISlider alloc]initWithFrame:CGRectMake(0, 100, 320, 12)];
    [self.view addSubview:currentSlider];

    [self.view addSubview:playerController];
    [self.view addSubview:topBackButton];
    [topBackButton release];
    
}




#pragma  mark -
#pragma  mark  每次播放结束 新歌曲 并且更新times 和days
//播放新歌曲
-(void)newPlay :(Music*) music
{
    
    AppDelegate *appDelegate=[self getAppDelegate];
    NSLog(@"type %@ --name %@",music.type,music.title);
    //NSLog(@"list %@",appDelegate.musiclist);
    //appDelegate.currentMusic.ClassTime =0;
    if ([music.type isEqualToString:@"none"]) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat: @"Required Import!",appDelegate.currentMusic.title,appDelegate.currentMusic.DidTimes,appDelegate.currentMusic.DidDays] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        //这里可以加上 如果不想再次提醒 就点取消提醒
        // optional - add more buttons:
        //[alert addButtonWithTitle:@"Yes"];
        [alert show];
        return;
    }
    
    
    NSMutableDictionary *eventObject = [NSMutableDictionary dictionary];
   
    eventObject[@"ClassID"] =  [NSString stringWithFormat:@"%ld",(long)appDelegate.currentMusic.classID ];;
    eventObject[@"ClassName"] = appDelegate.currentMusic.title;
    eventObject[@"startTime"] = [self generateTimeIntervalWithTimeZone];

    [[Zhuge sharedInstance] track:@"StartStudy" properties:eventObject];
    
    
    //timer start
    appDelegate.timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateCurrent) userInfo:nil repeats:YES];
    
    basePlayer = [PlayerFactory getPlayManagerWith:music];
    
    //获取时长 顺序不能变
    
    appDelegate.currentMusic=music;
    music.ClassTime = [basePlayer getClassTime];
    
    //要设置时间再播放
    //NSLog(@"time %f",appDelegate.currentMusic.ClassTime);
    [basePlayer play:music];
    //当前class播放时长
    [appDelegate.dal updateClassTime:music];
    
    appDelegate.currentMusic.isPlaying=YES;
    
    [self UpdateDaysTimesLable];
    [self initAppSectionMusicList];
    [appDelegate.RootDelegate listReloadData];
    
}
//更新lables  :times and days
-(void)UpdateDaysTimesLable
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    //200  time
    //UILabel  *timeLable =  (UILabel*) [self.view viewWithTag:200];
    didTimeLable.text =[NSString stringWithFormat:@"Times : %ld/%ld",  (long)appDelegate.currentMusic.DidTimes,(long)appDelegate.currentMusic.BestTimes];
    //100 days
    //UILabel  *dayLable =  (UILabel*) [self.view viewWithTag:100];
    didDaysLable.text =[NSString  stringWithFormat:@"Days : %ld/%ld" ,(long)appDelegate.currentMusic.DidDays,(long)appDelegate.currentMusic.BestDays];
    
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
//歌曲结束后 写入数据库
-(void)FinishPlaying
{
    self.currentSlider.value= 0;

    AppDelegate *appDelegate=[self getAppDelegate];
      
    if (appDelegate.AlreadyTime*0.1/appDelegate.currentMusic.ClassTime< 0.1) //以后要提取出来//这里判断是否超过85%
    {
        [self UpdateDataBaseDaysAndTimes];
        
        NSMutableDictionary *eventObject = [NSMutableDictionary dictionary];
        eventObject[@"ClassID"] =  [NSString stringWithFormat:@"%ld",(long)appDelegate.currentMusic.classID ];;
        eventObject[@"endTime"] = [self generateTimeIntervalWithTimeZone];
        eventObject[@"isCount"] =@"1";
        eventObject[@"location"] = @"0";
        eventObject[@"studyduration"] = [NSString stringWithFormat:@"%f",appDelegate.AlreadyTime ];
        eventObject[@"ClassName"] = appDelegate.currentMusic.title;
        eventObject[@"interactCount"] = @"0";
        eventObject[@"isMove"] = @"0";

        //eventObject[@"startTime"] = [self generateTimeIntervalWithTimeZone];


        [[Zhuge sharedInstance] track:@"EndStudy" properties:eventObject];
        
    }else{
    
        NSMutableDictionary *eventObject = [NSMutableDictionary dictionary];
        eventObject[@"ClassID"] =  [NSString stringWithFormat:@"%ld",(long)appDelegate.currentMusic.classID ];;
        eventObject[@"endTime"] = [self generateTimeIntervalWithTimeZone];
        eventObject[@"isCount"] =@"0";
        eventObject[@"location"] = @"0";
        eventObject[@"studyduration"] = [NSString stringWithFormat:@"%f",appDelegate.AlreadyTime ];
        eventObject[@"ClassName"] = appDelegate.currentMusic.title;
        eventObject[@"interactCount"] = @"0";
        eventObject[@"isMove"] = @"0";
        [[Zhuge sharedInstance] track:@"EndStudy" properties:eventObject];
    }
   
    
    didTimeLable.text =[NSString stringWithFormat:@"Times : %ld",  (long)appDelegate.currentMusic.DidTimes];
 
    didDaysLable.text =[NSString  stringWithFormat:@"Days : %ld" ,(long)appDelegate.currentMusic.DidDays];
    if (appDelegate.currentMusic.DidTimes >= appDelegate.currentMusic.BestTimes)//||appDelegate.currentMusic.DidDays >= appDelegate.currentMusic.BestDays)
    {
        //放置课程名 我觉得你这课已经听够了You have learned the 'aaa' for 10 Times and 10 days
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Great!" message:[NSString stringWithFormat: @"You have learned the '%@' for %ld Times and %ld Days!",appDelegate.currentMusic.title,(long)appDelegate.currentMusic.DidTimes,(long)appDelegate.currentMusic.DidDays] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
    }
    
    //play rule by playmodel
    long Index =0;
    switch (appDelegate.PlayModel) {
        case PlayNormal:
            //下一首
            Index= appDelegate.currentMusic.tag;
            if ([appDelegate.musiclist count ]-1 >Index) {
                Index+=1;
                [self newPlay:[appDelegate.musiclist objectAtIndex:Index]];
            }
            break;
        case RepeatOne:
            //重复播放音乐
            [self newPlay:appDelegate.currentMusic];
            break;
        case RepeatGroup:
            //NSLog(@"总 数量 %d",[appDelegate.appSectionMusicList count ]-1);
            Index= appDelegate.currentMusic.tag%3 ;
            //NSLog(@"当前音乐 顺序 %d",Index);
            //NSLog(@"index :%d",Index);
            //NSLog(@"count :%d",[appDelegate.appSectionMusicList count]);
            
            if ([appDelegate.appSectionMusicList count]-1==Index  ) {
                Index=0;
            }else
            {
                Index+=1;
            }
            //NSLog(@"要播放的 顺序 %d",Index);
            
            [self newPlay:[appDelegate.appSectionMusicList objectAtIndex:Index]];
            
            break;
    }
    
    //更改了didtimes 和diddays  或者想高亮 都需要重新加载misiclist和root的cell
    [appDelegate.RootDelegate rootReloadData]; //为什么每次都要reload
    //}
}
//数据库写入新的times这个应该放在dal层吧
//统计总天数

-(void)UpdateDataBaseDaysAndTimes
{
    AppDelegate *appDelegate=[self getAppDelegate];
    ////days+1  这里要加一个  如果播放时间超过歌曲的总长度80% 才算播放一次
    
    //写入数据库 didtimes
    appDelegate.currentMusic.DidTimes+=1;
    
    [appDelegate.dal updateDidTimes:appDelegate.currentMusic];
    
    //得到当前时间
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;            
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* time = [formatter stringFromDate:date];
    
    
    //判断总天数
    bool isToday=NO;
    for (Music *m in appDelegate.musiclist) {
        if ([m.TodayTime isEqualToString:time]) {
            // NSLog(@"today %@  ",time);
            
            isToday =YES;
        }
    }
    if (!isToday) {
        
        [appDelegate.dal updateAllDaysofConfigTable:appDelegate.currentMusic];
        
    }
    //判断当前时间 是否为空 今天是否播放
    
    if (![appDelegate.currentMusic.TodayTime isEqualToString: time]) {
        appDelegate.currentMusic.DidDays+=1;
        appDelegate.currentMusic.TodayTime=time;
        
        //更新今天的时间 
        [appDelegate.dal updateDidDays:appDelegate.currentMusic];
        
    }
}



//init same section music
-(void)initAppSectionMusicList
{
    AppDelegate *appDelegate=[self getAppDelegate];
    appDelegate.appSectionMusicList=nil ;
    NSMutableArray *items=[[NSMutableArray alloc] init];//这里不能autorelease
    //为什么一定要这样 不然直接赋值给appSectionMusicList 不行呢
    for (Music *m in appDelegate.musiclist) {
        //        NSLog(@"m %@",m.section);
        //        NSLog(@"l %@",appDelegate.currentMusic.section);
        if ([m.section isEqualToString: appDelegate.currentMusic.section]) {
            //NSLog(@"yes %@",appDelegate.currentMusic.section);
            [items addObject:m];
        }
    }
    
    appDelegate.appSectionMusicList =items;
}
#pragma mark ---end----

- (void)viewDidUnload
{
    self.currentTitleLabel=nil;
    self.playerController=nil;
    self.currentLabel=nil;
    self.durationLabel=nil;
    [super viewDidUnload];
    self.currentSlider=nil;
    self.volumeSlider=nil;
    // self.prevButton=nil;
    // self.nextButton=nil;
}



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
- (void)done:(id)sender
{
    [self.playerdelegate playerViewControllerDidFinish:self];
    //self.dep
}

#pragma  mark accelerometer
- (void) accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
    UIAccelerationValue				length,
    x,
    y,
    z;
	
	//Use a basic high-pass filter to remove the influence of the gravity
	myAccelerometer[0] = acceleration.x * kFilteringFactor + myAccelerometer[0] * (1.0 - kFilteringFactor);
	myAccelerometer[1] = acceleration.y * kFilteringFactor + myAccelerometer[1] * (1.0 - kFilteringFactor);
	myAccelerometer[2] = acceleration.z * kFilteringFactor + myAccelerometer[2] * (1.0 - kFilteringFactor);
	// Compute values for the three axes of the acceleromater
	x = acceleration.x - myAccelerometer[0];
	y = acceleration.y - myAccelerometer[0];
	z = acceleration.z - myAccelerometer[0];
	
	//Compute the intensity of the current acceleration 
	length = sqrt(x * x + y * y + z * z);
	// If above a given threshold, play the erase sounds and erase the drawing view
	if((length >= kEraseAccelerationThreshold) && (CFAbsoluteTimeGetCurrent() > lastTime + kMinEraseInterval)) {
        AppDelegate *appDelegate=[self getAppDelegate];
        if(appDelegate.currentMusic!=nil) //音乐非空
        {
            //UISlider *currentSlider=(UISlider *)sender; //init slider
            //这里要么是控制三种模式 晃动一下 退后多少
//            float nowtime = [basePlayer getCurrentTime];            
//            [basePlayer setCurrent:nowtime-3];
//            NSLog(@"摇晃 %f ",nowtime);
//            
            
            //设置当前时间 在最后 然后播放
            
            if(appDelegate.currentMusic.isPlaying)
            {
            
            
            }
        }
		lastTime = CFAbsoluteTimeGetCurrent();
	}
}
@end
