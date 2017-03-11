//
//  MusicPlayerViewController.m
//  MusicPlayer
//
//  Created by 韩国翔 on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "iPodPlayerViewController.h"
//#import "MusicPlayerAppDelegate.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
//CONSTANTS:

#define kPaletteHeight					30
#define kPaletteSize				    5
#define kAccelerometerFrequency			25 //Hz
#define kFilteringFactor				0.1
#define kMinEraseInterval				0.5
#define kEraseAccelerationThreshold		2.0

@implementation iPodPlayerViewController
@synthesize currentSlider,volumeSlider,durationLabel,currentLabel,playerController,currentTitleLabel,playModelButton,prevButton,nextButton,didDaysLable,didTimeLable;
@synthesize playerdelegate;

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
//获取代理 
-(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

#pragma mark button event


//choose play model
- (void)playModelChoose:(id)sender
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    //playModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //playModelButton.frame =CGRectMake(30, 45, 80, 80);
    switch (appDelegate.PlayModel) {
        case PlayNormal:
            [playModelButton setBackgroundImage:[UIImage imageNamed: @"newrepeatone.png"] forState:UIControlStateNormal];
            appDelegate.PlayModel =RepeatOne;
            break;
        case RepeatOne:
            [playModelButton setBackgroundImage:[UIImage imageNamed: @"newcycle.png"] forState:UIControlStateNormal];
            appDelegate.PlayModel =RepeatGroup;
            break;
            
        case RepeatGroup:
            [playModelButton setBackgroundImage:[UIImage imageNamed: @"newplaynormal.png"] forState:UIControlStateNormal];
            appDelegate.PlayModel =PlayNormal;
            break; 
        default:
            [playModelButton setBackgroundImage:[UIImage imageNamed: @"newplaynormal.png"] forState:UIControlStateNormal];
            appDelegate.PlayModel =PlayNormal;
            break;
    }
    
    //    playModelButton.showsTouchWhenHighlighted = YES;
    //    [playModelButton addTarget:self action:@selector(choosePlayModel:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:playModelButton];
    
}

//播放之前的音乐
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
//同上
-(IBAction)playNextMusic:(id)sender
{
    AppDelegate *appDelegate=[self getAppDelegate];
    if(appDelegate.currentMusic!=nil)
    {
        if(appDelegate.currentMusic.tag<[appDelegate.musiclist count]-1)
        {
            Music *music=[appDelegate.musiclist objectAtIndex:appDelegate.currentMusic.tag+1];
            //            NSLog(@"next %d",appDelegate.currentMusic.tag+1);
            //            NSLog(@"current music %@",appDelegate.currentMusic);
            //            NSLog(@"count~~~~~~~~~~~~~%d",[appDelegate.musiclist count ]);
            
            [self newPlay:music];
        }
    }
}


//设置音量 
-(IBAction)setVolume:(id)sender
{
    //就是把前台传来的值 给得带的代理   问题始终围绕在代理上
    Volume =[(UISlider*)sender value];
    [[self getAppDelegate] player].volume=[(UISlider*)sender value];
}
//得到时间格式。。。。
-(NSString *)getTimeFormat:(NSString *)time
{
    //NSLog(@"time %@",time);
    NSMutableString *result=[[[NSMutableString alloc] initWithFormat:@""]autorelease];
    
    NSInteger minute=[time integerValue]/60;
    //NSLog(@"time m%d",minute);
    
    NSInteger second=[time integerValue]%60;
    //NSLog(@"time s%d",second);
    
    
    if(minute >=0 && minute < 10)
    {
        [result appendFormat:@"0%d:",minute];
    }
    else if(minute >9)
    {
        [result appendFormat:@"%d:",minute];
    }
    if(second<10)
    {
        [result appendFormat:@"0%d",second];
    }
    else if(second>=10)
    {
        [result appendFormat:@"%d",second];
    }
    return result;
}
//更新当前的什么我靠。。。好像是动态更新 播放进度
-(void)updateCurrent
{
    AppDelegate *appDelegate=[self getAppDelegate];
    if(appDelegate.currentMusic!=nil)
    {
        AVAudioPlayer *player=[appDelegate player];
        //显然 player 的currenttime 不是很准 但是还需要这个方法更新
        self.currentLabel.text=[self getTimeFormat:[NSString stringWithFormat:@"%f",[player currentTime]]];
        //NSLog(@"current time %@" ,self.currentLabel.text);
        
        self.durationLabel.text=[self getTimeFormat:[NSString stringWithFormat:@"%f",[player duration]]];
        //NSLog(@"duration time %@" ,self.durationLabel.text);
        //电影一共多长
        self.currentSlider.maximumValue=[appDelegate.player duration];
        
        self.currentSlider.value=[player currentTime];
        self.currentTitleLabel.text=appDelegate.currentMusic.title;
        
    }
    // NSLog(@"second %f", appDelegate.StopTime);
    if (appDelegate.AlreadyTime>0) {
        appDelegate.AlreadyTime--;
    }
    //每次减一秒 直到减完 激发暂停事件
    if (appDelegate.StopTime!=0) {
        if( appDelegate.StopTime >1)
        {
            appDelegate.StopTime--;
        }
        if (appDelegate.StopTime==1) {
            [appDelegate.player pause];
            appDelegate.StopTime =0;
        }
    }
    
    // NSLog(@"timeer:%@",appDelegate.timer);
}

-(void)updateCurrentTimeLabel
{
    AppDelegate *appDelegate=[self getAppDelegate];
    if(appDelegate.currentMusic!=nil)
    {
        self.currentLabel.text=[self getTimeFormat:[NSString stringWithFormat:@"%f",self.currentSlider.value]];
        //这个数值可能还是有点问题打印 plays currnttime 和当前text比较一下才好
    }
}

//控制播放进度
-(IBAction)setCurrent:(id)sender
{
    AppDelegate *appDelegate=[self getAppDelegate];
    [appDelegate.player pause]; //暂停音乐
    //NSLog(@"执行");
    if(appDelegate.currentMusic!=nil) //音乐非空
    {
        //UISlider *currentSlider=(UISlider *)sender; //init slider
        // 就是这个事件
        //[appDelegate.timer invalidate];
        [appDelegate.player setCurrentTime:[self.currentSlider value]]; //拿到slider的 value
        //[appDelegate.timer fire];
        
        //NSLog(@"current value :%f",[self.currentSlider value]);
        //        //设置当前时间 在最后 然后播放
    }    
    if(appDelegate.currentMusic.isPlaying)
    {
        [appDelegate.player play];
    }
}

//开始或者暂停
-(IBAction)playOrPause:(id)sender
{
    AppDelegate *appDelegate=[self getAppDelegate];
    if(appDelegate.currentMusic!=nil)
    {
        if(appDelegate.currentMusic.isPlaying)
        {
            //[self.playerController setTitle:@"播放" forState:UIControlStateNormal];
            
            [self.playerController setBackgroundImage:[UIImage imageNamed: @"newplay.png"]  
                                             forState:UIControlStateNormal];
            appDelegate.currentMusic.isPlaying=NO;
            [appDelegate.player pause];
            
            //为什么不能控制timer呢
            //[appDelegate.timer invalidate];
            //[appDelegate.timer release];
            //appDelegate.timer=nil;
        }
        else
        {
            [self.playerController setBackgroundImage:[UIImage imageNamed: @"newpasue.png"] 
                                             forState:UIControlStateNormal];
            appDelegate.currentMusic.isPlaying=YES;
            [appDelegate.player play];
            //appDelegate.timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateCurrent) userInfo:nil repeats:YES];
            
        }
    }
}
#pragma mark Remote Control Events
/* The iPod controls will send these events when the app is in the background */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    AppDelegate *appDelegate=[self getAppDelegate];
    
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
            if (appDelegate.player.isPlaying==YES) {
                [appDelegate.player pause];
            }else
            {
                [appDelegate.player play];

            }
			break;
		case UIEventSubtypeRemoteControlPlay: //执行不到
			[appDelegate.player play];
			break;
		case UIEventSubtypeRemoteControlPause://执行不到
			[appDelegate.player pause];
			break;
		case UIEventSubtypeRemoteControlStop: //执行不到
			[appDelegate.player stop];
			break;
            //增加上一首和下一首
		default:
			break;
	}
}
- (BOOL)canBecomeFirstResponder {
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
#pragma mark - View lifecycle

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
    
    //new player
    //AppDelegate *appDelegate=[self getAppDelegate];

    //[self.view addSubview:musicPlayer];
	//[self performSelector:@selector(initialMusicList)];
    
}
#pragma  mark -
#pragma  mark  init newplayer

//判斷是否有儲存過音樂
- (void)initialMusicList
{
    AppDelegate *appDelegate=[self getAppDelegate];

    //不太明白干什么的 估计就是找当前列表 是否有歌曲 
    //估计 要修改一下 让他加载一下数据库中的内容
	if([[NSUserDefaults standardUserDefaults]objectForKey:@"songList"])
		[appDelegate.musicPlayer reload:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"songList"]]];
	//[appDelegate.musicList reloadData];
}
#pragma  mark -
#pragma  mark  init button

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
    
    UIButton *topBackButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    //插入一个imageview
    topBackButton.showsTouchWhenHighlighted = YES;
    
    UIImageView *imageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navtopbtn.png"]];
    
    [topBackButton insertSubview:imageView atIndex:0];
    [imageView release];
    imageView.frame =CGRectMake(0, 0, 320, 45);
    
    [topBackButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playerController];
    [self.view addSubview:topBackButton];
    [topBackButton release];
    //[playerController release]; 不能release
    
}

//返回
- (void)done:(id)sender
{
    [self.playerdelegate playerViewControllerDidFinish:self];
    //self.dep
}

#pragma  mark -
#pragma  mark  times days
//更新lables  :times and days
-(void)UpdateDaysTimesLable
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    //200  time
    //UILabel  *timeLable =  (UILabel*) [self.view viewWithTag:200];
    didTimeLable.text =[NSString stringWithFormat:@"Times : %d/%d",  appDelegate.currentMusic.DidTimes,appDelegate.currentMusic.BestTimes];
    //100 days
    //UILabel  *dayLable =  (UILabel*) [self.view viewWithTag:100];
    didDaysLable.text =[NSString  stringWithFormat:@"Days : %d/%d" ,appDelegate.currentMusic.DidDays,appDelegate.currentMusic.BestDays];
    
}

-(void)UpdateDaysTimes
{
    AppDelegate *appDelegate=[self getAppDelegate];
    ////days+1  这里要加一个  如果播放时间超过歌曲的总长度80% 才算播放一次
    
    //写入数据库
    appDelegate.currentMusic.DidTimes+=1;
    NSInteger ClassID=   appDelegate.currentMusic.classID;
    //NSLog(@"didTime =1111---%d ",appDelegate.currentMusic.DidTimes);
    
    NSString *dbsql =[NSString stringWithFormat:@"update ClassTable set DidTimes = '%d' where ClassID =%d",appDelegate.currentMusic.DidTimes,ClassID]; 
    [appDelegate.appDB executeUpdate:dbsql];  
    
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
        NSInteger days=[appDelegate.appDB intForQuery:@"SELECT AllDays FROM ConfigTable where id =0"]; 
        days+=1;
        //更新今天的时间 
        NSString *dbsql =[NSString stringWithFormat:@"update ConfigTable set AllDays = %d where id =0",days];
        NSLog(@"sql %@",dbsql);
        [appDelegate.appDB executeUpdate:dbsql]; 
    }
    //判断当前时间 是否为空 今天是否播放
    
    if (![appDelegate.currentMusic.TodayTime isEqualToString: time]) {
        appDelegate.currentMusic.DidDays+=1;
        appDelegate.currentMusic.TodayTime=time;
        
        //更新今天的时间 
        NSString *dbsql =[NSString stringWithFormat:@"update ClassTable set TodayTime = '%@',DidDays =%d where ClassID =%d",time,appDelegate.currentMusic.DidDays,ClassID]; 
        [appDelegate.appDB executeUpdate:dbsql];
    }
    
    //更新集合内信息
    
    [formatter release];
    
}
//统计总天数

//歌曲结束后 写入数据库
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    self.currentSlider.value= 0;
    
    if (flag) { 
        //这里判断是否超过85% 
        //数据库插入记录
        AppDelegate *appDelegate=[self getAppDelegate];
        ////days+1  这里要加一个  如果播放时间超过歌曲的总长度80% 才算播放一次
        //        NSLog(@"alradytime :%f",appDelegate.AlreadyTime);
        //        NSLog(@"ClassTime :%f",appDelegate.currentMusic.ClassTime);
        //        NSLog(@"result: %f",appDelegate.AlreadyTime*0.1/appDelegate.currentMusic.ClassTime);
        if (appDelegate.AlreadyTime*0.1/appDelegate.currentMusic.ClassTime< 0.1) {
            [self UpdateDaysTimes];
            
        }
        else
        {
            //没有听的部分 要小于10% 才可以记录如数据库 否则 执行这里  考虑是否提示用户
            //            UIAlertView *alertUnfnish = [[[UIAlertView alloc] initWithTitle:@"Great!" message:[NSString stringWithFormat: @"You have listened '%@' %dTimes and %dDays!",appDelegate.currentMusic.title,appDelegate.currentMusic.DidTimes,appDelegate.currentMusic.DidDays] delegate:self cancelButtonTitle:nil otherButtonTitles:nil] autorelease];
            //            [alertUnfnish show];
            
        }
        
        didTimeLable.text =[NSString stringWithFormat:@"Times : %d",  appDelegate.currentMusic.DidTimes];
        //如果次数到了 该课程进入下一课程了 you already can enter to the next lesson!
        //NSLog(@"times %d" ,appDelegate.currentMusic.DidTimes);
        //100 days
        //UILabel  *dayLable =  (UILabel*) [self.view viewWithTag:100];
        didDaysLable.text =[NSString  stringWithFormat:@"Days : %d" ,appDelegate.currentMusic.DidDays];
        if (appDelegate.currentMusic.DidTimes >= appDelegate.currentMusic.BestTimes||appDelegate.currentMusic.DidDays >= appDelegate.currentMusic.BestDays) {
            //放置课程名 我觉得你这课已经听够了You have learned the 'aaa' for 10 Times and 10 days
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Great!" message:[NSString stringWithFormat: @"You have learned the '%@' for %d Times and %d Days!",appDelegate.currentMusic.title,appDelegate.currentMusic.DidTimes,appDelegate.currentMusic.DidDays] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            //这里可以加上 如果不想再次提醒 就点取消提醒
            // optional - add more buttons:
            //[alert addButtonWithTitle:@"Yes"];
            [alert show];
        }
        
        //play rule by playmodel
        int Index =0;
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
        [appDelegate.RootDelegate reloadData];
    }
}


//播放新歌曲
-(void)newPlay :(Music*) music
{
    AppDelegate *appDelegate=[self getAppDelegate];
    //NSLog(@"count~~~~~~~~~~~~~%d",[appDelegate.musiclist count ]);
    
    //NSLog(@"要播放的音乐名 %@",music.title);
    appDelegate.timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateCurrent) userInfo:nil repeats:YES];
    
    //if (appDelegate.player.isPlaying== NO ||appDelegate.currentMusic.title !=music.title)
    //{
        [appDelegate.iPodPlayer setNowPlayingItem:[[appDelegate.iPodMediaCollection items]objectAtIndex:0]];
        [appDelegate.musicPlayer play];

//        [appDelegate.player release];
//        appDelegate.player=nil;
//        
//        AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: music.path error:nil];
//        appDelegate.player=newPlayer;
//        [appDelegate.player setVolume:0.5f];//有问题。。。。每次都需要重新赋值
//        [appDelegate.player setNumberOfLoops:0];
//        [appDelegate.player prepareToPlay];
//        [appDelegate.player play];
//        appDelegate.player.delegate =self;//这里的self 和new的不一样
        
        appDelegate.currentMusic=music;
        // 总时长
        appDelegate.currentMusic.ClassTime =[appDelegate.player duration];
        appDelegate.AlreadyTime =[appDelegate.player duration]*10;
        //NSLog(@"new alradytime :%f",appDelegate.AlreadyTime);
        //NSLog(@"new ClassTime :%f",appDelegate.currentMusic.ClassTime);
        //当前已经播放时长
        //每次 上一首下一首 或者自动切换 都会重置这两个时长
        NSInteger ClassID=   appDelegate.currentMusic.classID;
        
        NSString *dbsql =[NSString stringWithFormat:@"update ClassTable set ClassTime = %f where ClassID = %d",appDelegate.currentMusic.ClassTime,ClassID]; 
        [appDelegate.appDB executeUpdate:dbsql]; 
        //NSLog(@"update time %@----%d---%d----%f",dbsql,music.classID,ClassID,appDelegate.currentMusic.ClassTime);
        
        // NSLog(@"list :%@",[appDelegate.musiclist objectAtIndex:indexPath.row]);
        
        appDelegate.currentMusic.isPlaying=YES;
        //NSLog(@"name :%@",appDelegate.currentMusic.title);
    //}
    
    [self UpdateDaysTimesLable];
    [self initAppSectionMusicList];
    
    
}

//init same section music
-(void)initAppSectionMusicList
{
    AppDelegate *appDelegate=[self getAppDelegate];
    [appDelegate.appSectionMusicList  release];
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
    //需要重构 auto release appSectionMusicList
    
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
        //[appDelegate.player pause]; //暂停音乐
        if(appDelegate.currentMusic!=nil) //音乐非空
        {
            //UISlider *currentSlider=(UISlider *)sender; //init slider
            //这里要么是控制三种模式 晃动一下 退后多少
            //要么就是 自己设定倒退时间
            //
            float nowtime =appDelegate.player.currentTime;
            NSLog(@"huang le qian %f ",nowtime);
            
            [appDelegate.player setCurrentTime:nowtime-3]; //拿到slider的 value
            
            //设置当前时间 在最后 然后播放
        }    
        if(appDelegate.currentMusic.isPlaying)
        {
            [appDelegate.player play];
        }        
        NSLog(@"huang le xia %f ",appDelegate.player.currentTime );
        
		lastTime = CFAbsoluteTimeGetCurrent();
	}
}
@end
