//
//  MusicViewController.m
//  Enesco
//
//  Created by Aufree on 11/30/15.
//  Copyright © 2015 The EST Group. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicSlider.h"
#import "MusicHandler.h"

#import "Track.h"
#import "MusicIndicator.h"
#include <stdlib.h>

#import "UIView+Animations.h"
#import "NSString+Additions.h"
#import "MBProgressHUD.h"

#import "RecordClass.h"
#import "MusicEntity.h"

#import "UserinfoViewController.h"
#import "DAL.h"
#import "Zhuge.h"
#import "Helper.h"
#import "LogicMusicPlayer.h"




static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface MusicViewController ()
@property (nonatomic, strong) MusicEntity *musicEntity;
@property (nonatomic, strong) LogicMusicPlayer *logicPlayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *albumImageLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *albumImageRightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *musicMenuButton;
@property (weak, nonatomic) IBOutlet MusicSlider *musicSlider;
@property (weak, nonatomic) IBOutlet UIImageView *backgroudImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroudView;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *previousMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *nextMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *musicToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *musicCycleButton;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;
@property (strong, nonatomic) MusicIndicator *musicIndicator;
@property (strong, nonatomic) NSMutableArray *originArray;
@property (strong, nonatomic) NSMutableArray *randomArray;
@property (strong, nonatomic) NSMutableString *lastMusicUrl;
@property (nonatomic) NSTimer *musicDurationTimer;
@property (nonatomic) BOOL musicIsPlaying;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation MusicViewController

+ (instancetype)sharedInstance {
    static MusicViewController *_sharedMusicVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMusicVC = [[UIStoryboard storyboardWithName:@"Music" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"music"];
        _sharedMusicVC.streamer = [[DOUAudioStreamer alloc] init];
    });
    
    return _sharedMusicVC;
}

# pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adapterIphone4];
    _musicDurationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSliderValue:) userInfo:nil repeats:YES];
    _currentIndex = 0;
    _musicIndicator = [MusicIndicator sharedInstance];
    _originArray = @[].mutableCopy;
    _randomArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self addPanRecognizer];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(backToHomeScreen:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(backToApp:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}
#pragma 打断进入后台 和back to app
//打断
-(void)backToHomeScreen:(NSNotification*)notify
{
    //[_streamer pause];
    
    
}
//恢复打断
-(void)backToApp:(NSNotification*)notify
{
    [_streamer play];
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    _musicCycleType = [GVUserDefaults standardUserDefaults].musicCycleType;
    [self setupRadioMusicIfNeeded];
    
    if (_dontReloadMusic && _streamer) {
        return;
    }
    _currentIndex = 0;
    
    [_originArray removeAllObjects];
    [self loadOriginArrayIfNeeded];
    
    [self createStreamer];
}

# pragma mark - update class time
-(void)endStudy{
    MusicEntity* entity =[self currentPlayingMusic];
    RecordClass* record = [[DAL shareInstance] getRecrodWith:[NSString stringWithFormat:@"%@", entity.musicId]];
    
    if(![Helper isToadyStudy]){
        [[DAL shareInstance] updateAllDaysofConfigTable:record];
    }
    
    if(![Helper isToadyStudy:entity.name]){
        record.DidDays +=1;
        [[DAL shareInstance] updateDidDays:record];
    }
    record.DidTimes += 1;
    [[DAL shareInstance] updateDidTimes:record];
    
    [Helper addTodayStudyTimeTo:record.classId];
    [[DAL shareInstance] addReward:1.0 to:record.classId];
    
    [[DAL shareInstance] AddStudyTime:[_logicPlayer getPlayDuration] to:record.classId];
    
    [Helper endStudy:entity.name];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    _dontReloadMusic = YES;
}

- (void)loadOriginArrayIfNeeded {
    if (_originArray.count == 0) {
        for (int i = 0; i < _musicEntities.count; i++) {
            [_originArray addObject:[NSNumber numberWithInt:i]];
        }
        NSNumber *currentNum = [NSNumber numberWithInteger:_currentIndex];
        if ([_originArray containsObject:currentNum]) {
            [_originArray removeObject:currentNum];
        }
    }
}

# pragma mark - Basic setup

- (void)adapterIphone4 {
    if (IS_IPHONE_4_OR_LESS) {
        CGFloat margin = 65;
        _albumImageLeftConstraint.constant = margin;
        _albumImageRightConstraint.constant = margin;
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self setupMusicViewWithMusicEntity:_musicEntities[currentIndex]];
}

- (void)setupMusicViewWithMusicEntity:(MusicEntity *)entity {
    _musicEntity = entity;
    _musicNameLabel.text = _musicEntity.name;
    _singerLabel.text = _musicEntity.artistName;
    _musicTitleLabel.text = _musicTitle;
    [self setupBackgroudImage];
    [self checkMusicFavoritedIcon];
}

- (void)setMusicCycleType:(MusicCycleType)musicCycleType {
    _musicCycleType = musicCycleType;
    [self updateMusicCycleButton];
}

- (void)updateMusicCycleButton {
    switch (_musicCycleType) {
        case MusicCycleTypeLoopAll:
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_all_icon"] forState:UIControlStateNormal];
            break;
        case MusicCycleTypeShuffle:
            [_musicCycleButton setImage:[UIImage imageNamed:@"shuffle_icon"] forState:UIControlStateNormal];
            break;
        case MusicCycleTypeLoopSingle:
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_single_icon"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)setupRadioMusicIfNeeded {
    _musicMenuButton.hidden = NO;
    [self updateMusicCycleButton];
    [self checkCurrentIndex];
}

- (void)checkMusicFavoritedIcon {
    if ([self hasBeenFavoriteMusic]) {
        [_favoriteButton setImage:[UIImage imageNamed:@"red_heart"] forState:UIControlStateNormal];
    } else {
        [_favoriteButton setImage:[UIImage imageNamed:@"empty_heart"] forState:UIControlStateNormal];
    }
}

- (void)setupBackgroudImage {
    _albumImageView.layer.cornerRadius = 7;
    _albumImageView.layer.masksToBounds = YES;
    
    NSString *imageWidth = [NSString stringWithFormat:@"%.f", (SCREEN_WIDTH - 70) * 2];
    NSURL *imageUrl = [BaseHelper qiniuImageCenter:_musicEntity.cover withWidth:imageWidth withHeight:imageWidth];
    [_backgroudImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"music_placeholder"]];
    [_albumImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"music_placeholder"]];
    
    if(![_visualEffectView isDescendantOfView:_backgroudView]) {
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _visualEffectView.frame = self.view.bounds;
        [_backgroudView addSubview:_visualEffectView];
        [_backgroudView addSubview:self.visualEffectView];
    }
    
    [_backgroudImageView startTransitionAnimation];
    [_albumImageView startTransitionAnimation];
}

- (void)addPanRecognizer {
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchDismissButton:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeRecognizer];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

# pragma mark - Music Action

- (IBAction)didTouchMenuButton:(id)sender {
    //    _dontReloadMusic = YES;
    //
    //    UserinfoViewController *userInfo =   [[UIStoryboard storyboardWithName:@"UserInfoStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"UseInfoSB"] ;
    //
    //    [self presentViewController:userInfo animated:YES completion:nil];
    //[self  dismissViewControllerAnimated:<#(BOOL)#> completion:<#^(void)completion#>];
    
   // [self showMiddleHint:@"请注意卡片学习。"];
    NSMutableArray *localControllesArray = [[NSMutableArray alloc]initWithCapacity:4];
    RDFileTableController *ctl = [[RDFileTableController alloc] initWithNibName:@"RDFileTableController" bundle:nil];
    _navController = [[UINavigationController alloc] initWithRootViewController:ctl];
    _navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [localControllesArray addObject:_navController];
    
    BookMarkViewController *bmctl=[[BookMarkViewController alloc]initWithNibName:@"BookMarkViewController" bundle:nil];
    _navController = [[UINavigationController alloc]initWithRootViewController:bmctl];
    _navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    NSString *title1 =[[NSString alloc]initWithFormat:NSLocalizedString(@"Marks", @"Localizable")];
    
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTitle:title1 image:[UIImage imageNamed:@"manage_mark.png"] tag:1 ];
    bmctl.tabBarItem = item1;
    [localControllesArray addObject:_navController];
    
    SettingViewController *settingCtl = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    _navController = [[UINavigationController alloc]initWithRootViewController:settingCtl];
    _navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    NSString *title2 =[[NSString alloc]initWithFormat:NSLocalizedString(@"Setting", @"Localizable")];
    
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:title2 image:[UIImage imageNamed:@"view_settings_page.png"] tag:2 ];
    settingCtl.tabBarItem = item2;
    [localControllesArray addObject:_navController];
    
    
    NSString *title4 =[[NSString alloc]initWithFormat:NSLocalizedString(@"More", @"Localizable")];
    // Do any additional setup after loading the view from its nib.
    
    
    
    MoreViewController *moreCtl = [[MoreViewController alloc]initWithNibName:@"MoreViewController" bundle:nil];
    _navController = [[UINavigationController alloc]initWithRootViewController:moreCtl];
    _navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:title4 image:[UIImage imageNamed:@"view_about.png"] tag:3 ];
    moreCtl.tabBarItem = item3;
    [localControllesArray addObject:_navController];
    
    _tabBarController = [[UITabBarController alloc]init];
    _tabBarController.viewControllers =localControllesArray;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ctl];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    /*
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
     {
     self.viewController = [[RDFileTableController alloc] initWithNibName:@"RDFileTableController" bundle:nil];
     } else
     {
     self.viewController = [[RDFileTableController alloc] initWithNibName:@"RDFileTableController" bundle:nil];
     }
     */
    
    // Preloads keyboard so there's no lag on initial keyboard appearance.
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.view addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];

    
}

- (IBAction)didTouchDismissButton:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        weakSelf.dontReloadMusic = NO;
        weakSelf.lastMusicUrl = [weakSelf currentPlayingMusic].musicUrl.mutableCopy;
    }];
}

- (IBAction)didTouchFavoriteButton:(id)sender {
    [_favoriteButton startDuangAnimation];
    if ([self hasBeenFavoriteMusic]) {
        [self unfavoriteMusic];
    } else {
        [self favoriteMusic];
    }
}

- (IBAction)didTouchMusicCycleButton:(id)sender {
    switch (_musicCycleType) {
        case MusicCycleTypeLoopAll: {
            self.musicCycleType = MusicCycleTypeShuffle;
            [self showMiddleHint:@"random play"]; } break;
        case MusicCycleTypeShuffle: {
            self.musicCycleType = MusicCycleTypeLoopSingle;
            [self showMiddleHint:@"single loop"]; } break;
        case MusicCycleTypeLoopSingle: {
            self.musicCycleType = MusicCycleTypeLoopAll;
            [self showMiddleHint:@"list Loop"]; } break;
            
        default:
            break;
    }
    
    [GVUserDefaults standardUserDefaults].musicCycleType = self.musicCycleType;
}

- (void)setMusicIsPlaying:(BOOL)musicIsPlaying {
    _musicIsPlaying = musicIsPlaying;
    
    if ( _streamer.status ==DOUAudioStreamerPlaying) {
        [_musicToggleButton setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
    } else {
        [_musicToggleButton setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
    }
}

- (IBAction)didTouchMoreButton:(id)sender {
    
    
    [self showMiddleHint:@"back 3 sec"];
    [_streamer setCurrentTime:[_streamer currentTime] -3];
    
}

# pragma mark - Musics delegate

- (void)playMusicWithSpecialIndex:(NSInteger)index {
    _currentIndex = index;
    [self createStreamer];
}

# pragma mark - Music Controls


- (IBAction)didTouchMusicToggleButton:(id)sender {
    if (_streamer.status ==DOUAudioStreamerPlaying) {
        [_streamer pause];
        [_musicToggleButton setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
        
    } else {
        [_streamer play];
        
        [_musicToggleButton setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)didChangeMusicSliderValue:(id)sender {
    if (_streamer.status == DOUAudioStreamerFinished) {
        if(_streamer){
            @try {
                [self removeStreamerObserver];
            } @catch(id anException){
            }
        }
        _streamer = nil;
        [self createStreamer];
    }
    
    [_streamer setCurrentTime:[_streamer duration] * _musicSlider.value];
    [self updateProgressLabelValue];
}

- (IBAction)playPreviousMusic:(id)sender {
    
    if (_musicEntities.count == 1) {
        [self showMiddleHint:@"no more"];
        return;
    }
    [self endPlay];
    if (_musicCycleType == MusicCycleTypeShuffle && _musicEntities.count > 2) {
        [self setupRandomMusicIfNeed];
    } else {
        NSInteger firstIndex = 0;
        if (_currentIndex == firstIndex || [self currentIndexIsInvalid]) {
            self.currentIndex = _musicEntities.count - 1;
        } else {
            self.currentIndex--;
        }
    }
    
    [self setupStreamer];
}

- (IBAction)playNextMusic:(id)sender {
    
    if (_musicEntities.count == 1) {
        [self showMiddleHint:@"last one"];
        return;
    }
    [self endPlay];
    if (_musicCycleType == MusicCycleTypeShuffle && _musicEntities.count > 2) {
        [self setupRandomMusicIfNeed];
    } else {
        [self checkNextIndexValue];
    }
    [self setupStreamer];
}

- (void)checkNextIndexValue {
    NSInteger lastIndex = _musicEntities.count - 1;
    if (_currentIndex == lastIndex || [self currentIndexIsInvalid]) {
        self.currentIndex = 0;
    } else {
        self.currentIndex++;
    }
}

# pragma mark - Setup streamer

- (void)setupRandomMusicIfNeed {
    [self loadOriginArrayIfNeeded];
    int t = arc4random()%_originArray.count;
    _randomArray[0] = _originArray[t];
    _originArray[t] = _originArray.lastObject;
    [_originArray removeLastObject];
    self.currentIndex = [_randomArray[0] integerValue];
}

- (void)setupStreamer {
    [self createStreamer];
}

# pragma mark - Check Current Index

- (BOOL)currentIndexIsInvalid {
    return _currentIndex >= _musicEntities.count;
}

- (void)checkCurrentIndex {
    if ([self currentIndexIsInvalid]) {
        _currentIndex = 0;
    }
}

# pragma mark - Handle Music Slider

- (void)updateSliderValue:(id)timer {
    
    if (!_streamer) {
        return;
    }
    if (_streamer.status == DOUAudioStreamerFinished) {
        [_streamer play];
    }
    
    if ([_streamer duration] == 0.0) {
        [_musicSlider setValue:0.0f animated:NO];
    } else {
        if (_streamer.currentTime >= _streamer.duration) {
            
            self.musicIsPlaying = NO;
            
            if (_musicCycleType == MusicCycleTypeLoopSingle) {
                [self endPlay];
                _logicPlayer = [LogicMusicPlayer createLogicMusicPlayer];
                _streamer.currentTime -= _streamer.duration;
                [_streamer play];
            } else {
                _streamer.currentTime -= _streamer.duration;
                [self playNextMusic:nil];
            }
        }
        
        [_musicSlider setValue:[_streamer currentTime] / [_streamer duration] animated:YES];
        [self updateProgressLabelValue];
    }
    
}

-(void)endPlay{
    
    if(_logicPlayer){
        [_logicPlayer stop];
    }
    
    [self didFinishPlaying];
    _logicPlayer = nil;
}

- (void)updateProgressLabelValue {
    _beginTimeLabel.text = [NSString timeIntervalToMMSSFormat:_streamer.currentTime];
    _endTimeLabel.text = [NSString timeIntervalToMMSSFormat:_streamer.duration];
}

- (void)updateBufferingStatus {
    
}

- (void)invalidMusicDurationTimer {
    if ([_musicDurationTimer isValid]) {
        [_musicDurationTimer invalidate];
    }
    _musicDurationTimer = nil;
}



# pragma mark - Audio Handle
-(BOOL)isFileInDocument:(NSString*)url

{
    
    NSString *filename =[url substringWithRange:NSMakeRange(url.length-34,34)];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths        objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return  [fileManager fileExistsAtPath:filepath];
}

-(BOOL)isFileInBundle:(NSString*)filename
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"mp3"];
    if(path==NULL)
    {
        return NO;
    }
    
    return YES;
}


//音乐播放路径
- (void)createStreamer {
  
    if (_specialIndex > 0) {
        _currentIndex = _specialIndex;
        _specialIndex = 0;
    }
    //检查本地和doc中是否有。本地有播放，本地没有提示下载
    
    
    [self setupMusicViewWithMusicEntity:_musicEntities[_currentIndex]];
    [self loadPreviousAndNextMusicImage];
    [MusicHandler configNowPlayingInfoCenter];
    
    Track *track = [[Track alloc] init];
    
    //优化成 非二次判断 总有io操作 费电。
    BOOL isbundlefiel =[self isFileInBundle:_musicEntity.fileName];
    BOOL isFileInDocument =[self isFileInDocument:_musicEntity.musicUrl];
    
    if(!isbundlefiel&&!isFileInDocument)
    {
        [self showMiddleHint:@"back to list to download this lesson"];
        return;
    }
    
    if(isbundlefiel)
    {
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:_musicEntity.fileName ofType: @"mp3"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        track.audioFileURL = fileURL;
    }
    if(isFileInDocument)
    {
        NSString *url =_musicEntity.musicUrl;
        NSString *filename =[url substringWithRange:NSMakeRange(url.length-34,34)];
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths        objectAtIndex:0];
        NSString *filepath=[path stringByAppendingPathComponent:filename];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filepath];
        track.audioFileURL = fileURL;
    }
    
   
    
    @try {
        [self removeStreamerObserver];
    } @catch(id anException){
    }
    
    _streamer = nil;
    _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
    _logicPlayer = [LogicMusicPlayer createLogicMusicPlayer];
    [self addStreamerObserver];
    [self.streamer play];
}

- (void)removeStreamerObserver {
    [_streamer removeObserver:self forKeyPath:@"status"];
    [_streamer removeObserver:self forKeyPath:@"duration"];
    [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
}

- (void)addStreamerObserver {
    [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    } else if (context == kDurationKVOKey) {
        [self performSelector:@selector(updateSliderValue:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    } else if (context == kBufferingRatioKVOKey) {
        [self performSelector:@selector(updateBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//
- (void)updateStatus {
    
    NSMutableDictionary *eventObject = [NSMutableDictionary dictionary];
    
    // eventObject[@"ClassID"] =  [NSString stringWithFormat:@"%ld",(long)_musicEntity.name.classID ];;
    eventObject[@"ClassName"] = _musicEntity.name;
    eventObject[@"startTime"] = [self generateTimeIntervalWithTimeZone];
    
    [[Zhuge sharedInstance] track:@"StartStudy" properties:eventObject];
    
    NSLog(@"切换状态");
    
    _musicIndicator.state = NAKPlaybackIndicatorViewStateStopped;
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            self.musicIsPlaying = YES;
            _musicIndicator.state = NAKPlaybackIndicatorViewStatePlaying;
            NSLog(@"DOUAudioStreamerPlaying播放状态");
            if(!_logicPlayer){
                _logicPlayer = [LogicMusicPlayer createLogicMusicPlayer];
            }
            [_logicPlayer play];
            break;
            
        case DOUAudioStreamerPaused:
            NSLog(@"DOUAudioStreamerPaused暂停状态");
            self.musicIsPlaying = NO;
            [_logicPlayer pause];
            break;
            
        case DOUAudioStreamerIdle:
            NSLog(@"DOUAudioStreamerIdle空状态");
            self.musicIsPlaying = NO;
            [self endPlay];
            break;
            
        case DOUAudioStreamerFinished:
            //bubiij lidian
            NSLog(@"DOUAudioStreamerFinished空状态");
            self.musicIsPlaying = NO;
            if (_musicCycleType == MusicCycleTypeLoopSingle) {
                [self endPlay];
                [_streamer play];
            } else {
                [self playNextMusic:nil];
            }
            break;
            
        case DOUAudioStreamerBuffering:
            self.musicIsPlaying = NO;
            NSLog(@"DOUAudioStreamerBuffering缓冲状态");
            _musicIndicator.state = NAKPlaybackIndicatorViewStatePlaying;
            [_logicPlayer buffer];
            break;
            
        case DOUAudioStreamerError:
            self.musicIsPlaying = NO;
            [_logicPlayer stop];
            break;
    }
    
    [self updateMusicsCellsState];
    
}

-(BOOL)isClassCompleted:(NSString *)classId{
    MusicEntity* entity =[self currentPlayingMusic];
    RecordClass* record = [[DAL shareInstance] getRecrodWith:[NSString stringWithFormat:@"%@", entity.musicId]];
    if(![record.classId isEqualToString:classId]){
        return NO;
    }
    if(!_streamer){
        return NO;
    }
    NSTimeInterval ClassTime= [_streamer duration];
    if(0.0 == ClassTime){
        return NO;
    }
    if(!_logicPlayer){
        return NO;
    }
    NSTimeInterval studyduration = _logicPlayer.getPlayDuration;
    
    return (studyduration/ClassTime >= 0.9f) ? YES : NO;
}

//bubiji
-(void)didFinishPlaying
{
    MusicEntity* entity =[self currentPlayingMusic];
    
    RecordClass* record = [[DAL shareInstance] getRecrodWith:[NSString stringWithFormat:@"%@", entity.musicId]];
    NSTimeInterval studyduration = 0;
    if(_logicPlayer){
        studyduration = _logicPlayer.getPlayDuration;
    }
    
    record.studyduration =[NSString stringWithFormat:@"%f",studyduration];
    NSLog(@"studyTime：%f", studyduration);
    
    record.isMove =@"0";
    record.location =@"0";
    
    NSTimeInterval ClassTime= [_streamer duration];
    if(0.0 == ClassTime){
        return ;
    }
    if (studyduration/ClassTime >= 0.9f)
    {
        record.isCount = 1;
        [self endStudy];
        NSMutableDictionary *eventObject = [NSMutableDictionary dictionary];
        eventObject[@"ClassID"] =  [NSString stringWithFormat:@"%ld",(long)record.classId ];;
        eventObject[@"endTime"] = [self generateTimeIntervalWithTimeZone];
        eventObject[@"isCount"] =@"1";
        eventObject[@"location"] = @"0";
        eventObject[@"studyduration"] = [NSString stringWithFormat:@"%f",studyduration ];
        eventObject[@"ClassName"] = record.title;
        eventObject[@"interactCount"] = @"0";
        eventObject[@"isMove"] = @"0";
        
        [[Zhuge sharedInstance] track:@"EndStudy" properties:eventObject];
    }
    else
    {
        record.isCount = 0;
        NSMutableDictionary *eventObject = [NSMutableDictionary dictionary];
        eventObject[@"ClassID"] =  [NSString stringWithFormat:@"%ld",(long)record.classId ];;
        eventObject[@"endTime"] = [self generateTimeIntervalWithTimeZone];
        eventObject[@"isCount"] =@"0";
        eventObject[@"location"] = @"0";
        eventObject[@"studyduration"] = [NSString stringWithFormat:@"%f",studyduration ];
        eventObject[@"ClassName"] = record.title;
        eventObject[@"interactCount"] = @"0";
        eventObject[@"isMove"] = @"0";
        [[Zhuge sharedInstance] track:@"EndStudy" properties:eventObject];
    }
    
    
    //currentSlider.value= 0;
    
    //判断是否入库的标准。
    //以后要提取出来//这里判断是否超过85%
    
    
    
    //更新显示数据 今天的学习时常 保留在音乐播放界面
    //didTimeLable.text =[NSString stringWithFormat:@"Times : %ld",  (long)currentMusic.DidTimes];
    //didDaysLable.text =[NSString  stringWithFormat:@"Days : %ld" ,(long)currentMusic.DidDays];
    
    //如果你已经超过了推荐次数， 在当时alert一下
    // if (currentMusic.DidTimes >= currentMusic.BestTimes)
    //||currentMusic.DidDays >= currentMusic.BestDays)
    //{
    //放置课程名 我觉得你这课已经听够了You have learned the 'aaa' for 10 Times and 10 days
    //UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:@"这个是UIAlertController的默认样式" preferredStyle:UIAlertControllerStyleAlert];
    
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Great!" message:[NSString stringWithFormat: @"You have learned the '%@' for %ld Times and %ld Days!",currentMusic.title,(long)currentMusic.DidTimes,(long)currentMusic.DidDays] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
    //        [alert show];
    //}
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

# pragma mark - Favorite Music

- (void)favoriteMusic {
    _musicEntity.isFavorited = YES;
    [_favoriteButton setImage:[UIImage imageNamed:@"red_heart"] forState:UIControlStateNormal];
}

- (void)unfavoriteMusic {
    _musicEntity.isFavorited = NO;
    [_favoriteButton setImage:[UIImage imageNamed:@"empty_heart"] forState:UIControlStateNormal];
}

- (BOOL)hasBeenFavoriteMusic {
    return _musicEntity.isFavorited;
}

# pragma mark - Musics Delegate

- (void)updateMusicsCellsState {
    if (_delegate && [_delegate respondsToSelector:@selector(updatePlaybackIndicatorOfVisisbleCells)]) {
        [_delegate updatePlaybackIndicatorOfVisisbleCells];
    }
}

# pragma mark - Music convenient method

- (void)loadPreviousAndNextMusicImage {
    [MusicHandler cacheMusicCovorWithMusicEntities:_musicEntities currentIndex:_currentIndex];
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

- (void)showMiddleHintcomfirm:(NSString *)hint {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.margin = 10.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    //[hud hide:YES afterDelay:2];
}




# pragma mark - Public Method

- (MusicEntity *)currentPlayingMusic {
    if (_musicEntities.count == 0) {
        _musicEntities = nil;
    }
    
    return _musicEntities[_currentIndex];
}

-(RecordClass*)currentPlayRecord{
    if (_musicEntities.count == 0) {
        _musicEntities = nil;
    }
    MusicEntity* entity =[self currentPlayingMusic];
    RecordClass* record = [[DAL shareInstance] getRecrodWith:[NSString stringWithFormat:@"%@", entity.musicId]];
    return record;
}

@end
