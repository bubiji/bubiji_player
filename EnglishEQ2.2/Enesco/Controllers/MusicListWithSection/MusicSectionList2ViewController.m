//
//  MusicSectionList2ViewController.m
//  Enesco
//
//  Created by wangjie on 16/6/4.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import "MusicSectionList2ViewController.h"
#import "MusicViewController.h"
#import "MusicListViewController.h"
#import "MusicListWithSectionCellTableViewCell.h"
#import "MusicIndicator.h"
#import "MBProgressHUD.h"
#import "DAL.h"
#import "SectionClass.h"
#import "ThreeMusicsCell.h"
#import "FourTableViewCell.h"

@interface MusicSectionList2ViewController () <MusicViewControllerDelegate, MusicListCellDelegate,SectionListJumpDelegate>
@property (nonatomic, strong) NSMutableArray *musicEntities;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *sectionList;
@end

@implementation MusicSectionList2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.title = @"Course List";
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    if ([userDefaultes stringForKey:@"username"]!= NULL)
    {
        self.navigationItem.title = [userDefaultes stringForKey:@"username"];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self headerRefreshing];
    [self createIndicatorView];
    NSUserDefaults* userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.bubiji"];
    if ([userDefault stringForKey:@"username"]!= NULL)
    {
        self.navigationItem.title = [userDefault stringForKey:@"username"];
        
    }
}

# pragma mark - Custom right bar button item

- (void)createIndicatorView {
    MusicIndicator *indicator = [MusicIndicator sharedInstance];
    indicator.hidesWhenStopped = NO;
    indicator.tintColor = [UIColor redColor];
    
    if (indicator.state != NAKPlaybackIndicatorViewStatePlaying) {
        indicator.state = NAKPlaybackIndicatorViewStatePlaying;
        indicator.state = NAKPlaybackIndicatorViewStateStopped;
    } else {
        indicator.state = NAKPlaybackIndicatorViewStatePlaying;
    }
    
    [self.navigationController.navigationBar addSubview:indicator];
    
    UITapGestureRecognizer *tapInditator = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapIndicator)];
    tapInditator.numberOfTapsRequired = 1;
    [indicator addGestureRecognizer:tapInditator];
}

- (void)handleTapIndicator {
    MusicViewController *musicVC = [MusicViewController sharedInstance];
    if (musicVC.musicEntities.count == 0) {
        [self showMiddleHint:@"No Playing"];
        return;
    }
    musicVC.dontReloadMusic = YES;
    [self presentToMusicViewWithMusicVC:musicVC];
}


# pragma mark - Load data from server

- (void)headerRefreshing {
    NSDictionary *musicsDict = [self dictionaryWithContentsOfJSONString:@"music_list.json"];
    self.musicEntities = [MusicEntity arrayOfEntitiesFromArray:musicsDict[@"data"]].mutableCopy;
    self.sectionList = [[DAL shareInstance] getMusicSessionList];
    
    for (SectionClass *section in self.sectionList) {
        for (RecordClass *record in section.records) {
            for (MusicEntity *m in _musicEntities) {
                if(m.musicId.integerValue == [record.classId integerValue]){
                    record.music = m;
                    record.isCache = YES;
                    break;
                }
            }
        }
    }
    
    
    [self.tableView reloadData];
}

- (NSDictionary *)dictionaryWithContentsOfJSONString:(NSString *)fileLocation {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

# pragma mark - Tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

# pragma mark - Jump to music view

- (void)presentToMusicViewWithMusicVC:(MusicViewController *)musicVC {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:musicVC];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

# pragma mark - Update music indicator state

- (void)updatePlaybackIndicatorWith:(SectionClass *)section index:(NSInteger)index {
    RecordClass *rc = [section.records objectAtIndex:index];
    
    for (id cell in self.tableView.visibleCells) {
        if([cell respondsToSelector:@selector(change:to:)]){
            [cell change:rc to:NAKPlaybackIndicatorViewStatePlaying];
        }
    }
}

- (void)updatePlaybackIndicatorWithCell:(id)cell{
    
    NSNumber * musicid = [[MusicViewController sharedInstance] currentPlayingMusic].musicId;

    if([cell respondsToSelector:@selector(changeStateWith:)]){
        [cell changeStateWith:musicid];
    }
}

- (void)updatePlaybackIndicatorOfVisisbleCells {
    NSNumber *musicid =[[MusicViewController sharedInstance] currentPlayingMusic].musicId;
    for (id cell in self.tableView.visibleCells) {
        if([cell respondsToSelector:@selector(changeStateWith:)]){
            [cell changeStateWith:musicid];
        }
    }
    [self headerRefreshing];
}

# pragma mark - Tableview datasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    SectionClass *sc = [self.sectionList objectAtIndex:section];
    return sc.sectionName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *threemusicListCell = @"threemusicListCell";
    static NSString *fourmusicListCell = @"fourmusicListCell";
    SectionClass *section = [self.sectionList objectAtIndex:indexPath.section];
    if(section.records.count == 3){
        ThreeMusicsCell *cell = [tableView dequeueReusableCellWithIdentifier:threemusicListCell];
        
        if(!cell){
            cell = [[ThreeMusicsCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:threemusicListCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.section = section;
        
        cell.delegate = self;
        [self updatePlaybackIndicatorWithCell:cell];
        return cell;
    }
    else if(section.records.count == 4){
        FourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fourmusicListCell];
        
        if(!cell){
            cell = [[FourTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:fourmusicListCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.section = section;
        
        cell.delegate = self;
        [self updatePlaybackIndicatorWithCell:cell];
        return cell;
    }
    return nil;
}

- (void)jumpTo:(SectionClass *)section index:(NSInteger)index{
    MusicViewController *musicVC = [MusicViewController sharedInstance];
    RecordClass * record = [section.records objectAtIndex:index];
    if(musicVC.currentPlayingMusic){
        if(!(musicVC.currentPlayingMusic.musicId.integerValue == [record.classId integerValue])){
            musicVC.musicTitle = self.navigationItem.title;
            NSMutableArray *musics = [NSMutableArray array];
            for (RecordClass *rc in section.records) {
                [musics addObject:rc.music];
            }
            musicVC.musicEntities = musics;
            musicVC.specialIndex = index;
            musicVC.delegate = self;
        }
        else{
            musicVC.dontReloadMusic = YES;
        }
    }
    else{
        musicVC.musicTitle = self.navigationItem.title;
        NSMutableArray *musics = [NSMutableArray array];
        for (RecordClass *rc in section.records) {
            [musics addObject:rc.music];
        }
        musicVC.musicEntities = musics;
        musicVC.specialIndex = index;
        musicVC.delegate = self;
    }
    
    [self presentToMusicViewWithMusicVC:musicVC];
    [self updatePlaybackIndicatorWith:section index:index];
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
@end
