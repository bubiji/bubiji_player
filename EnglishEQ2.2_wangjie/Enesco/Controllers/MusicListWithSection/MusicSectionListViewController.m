//
//  MusicListViewController.m
//  Enesco
//
//  Created by Aufree on 11/30/15.
//  Copyright © 2015 The EST Group. All rights reserved.
//

#import "MusicSectionListViewController.h"
#import "MusicViewController.h"
#import "MusicListViewController.h"
#import "MusicListWithSectionCellTableViewCell.h"
#import "MusicIndicator.h"
#import "MBProgressHUD.h"
#import "DAL.h"
#import "SectionClass.h"
#import "Helper.h"

@interface MusicSectionListViewController () <MusicViewControllerDelegate, MusicListCellDelegate>
@property (nonatomic, strong) NSMutableArray *musicEntities;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *sectionList;
@end

@implementation MusicSectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.title = @"Course List";
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userName = (NSString *)[[Helper getUserInfo] objectForKey:@"name"];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",userName,[Helper getDateForamt:[NSDate new]]];
    if ([userDefaultes stringForKey:@"username"]!= NULL)
    {
        self.navigationItem.title = [userDefaultes stringForKey:@"username"];

    
    }
    [userDefaultes stringForKey:@"username"];
    
    //[self headerRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self headerRefreshing];
    [self createIndicatorView];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    if ([userDefaultes stringForKey:@"username"]!= NULL)
    {
        self.navigationItem.title = [userDefaultes stringForKey:@"username"];
        
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
        [self showMiddleHint:@"no playing"];
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
    if (_delegate && [_delegate respondsToSelector:@selector(playMusicWithSpecialIndex:)]) {
        [_delegate playMusicWithSpecialIndex:indexPath.row];
    } else {
        NSInteger index = 0;
        for (int i = 0; i < indexPath.section; i++) {
            index += ((SectionClass *)[self.sectionList objectAtIndex:i]).records.count;
        }
        index += indexPath.row;
        MusicEntity *to = [_musicEntities objectAtIndex:index];
        MusicViewController *musicVC = [MusicViewController sharedInstance];
        if(musicVC.currentPlayingMusic){
            if(![musicVC.currentPlayingMusic.fileName isEqualToString: to.fileName]){
                musicVC.musicTitle = self.navigationItem.title;
                musicVC.musicEntities = _musicEntities;
                musicVC.specialIndex = index;
            }
            else{
                musicVC.dontReloadMusic = YES;
            }
        }
        else{
            musicVC.musicTitle = self.navigationItem.title;
            musicVC.musicEntities = _musicEntities;
            musicVC.specialIndex = index;
        }

        musicVC.delegate = self;
        [self presentToMusicViewWithMusicVC:musicVC];
    }
    [self updatePlaybackIndicatorWithIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark - Jump to music view

- (void)presentToMusicViewWithMusicVC:(MusicViewController *)musicVC {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:musicVC];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

# pragma mark - Update music indicator state

- (void)updatePlaybackIndicatorWithIndexPath:(NSIndexPath *)indexPath {
    for (MusicListWithSectionCellTableViewCell *cell in self.tableView.visibleCells) {
        cell.state = NAKPlaybackIndicatorViewStateStopped;
    }
    MusicListWithSectionCellTableViewCell *musicsCell = [self.tableView cellForRowAtIndexPath:indexPath];
    musicsCell.state = NAKPlaybackIndicatorViewStatePlaying;
}

- (void)updatePlaybackIndicatorOfCell:(MusicListWithSectionCellTableViewCell *)cell {
    MusicEntity *music = cell.musicEntity;
    if (music.musicId == [[MusicViewController sharedInstance] currentPlayingMusic].musicId) {
        cell.state = NAKPlaybackIndicatorViewStateStopped;
        cell.state = [MusicIndicator sharedInstance].state;
    } else {
        cell.state = NAKPlaybackIndicatorViewStateStopped;
    }
    
}

- (void)updatePlaybackIndicatorOfVisisbleCells {
    for (MusicListWithSectionCellTableViewCell *cell in self.tableView.visibleCells) {
        [self updatePlaybackIndicatorOfCell:cell];
    }
    [self headerRefreshing];
}

# pragma mark - Tableview datasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    SectionClass *musics = [self.sectionList objectAtIndex:section];
    return musics.sectionName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionClass *musics = [self.sectionList objectAtIndex:section];
    return musics.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *musicListCell = @"musicListCell";
    SectionClass *section = [self.sectionList objectAtIndex:indexPath.section];
    RecordClass *record = [section.records objectAtIndex:indexPath.row];
    MusicListWithSectionCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:musicListCell];
    
    if(!cell){
        cell = [[MusicListWithSectionCellTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:musicListCell];
    }
    
    cell.record = record;
    cell.musicNumber = indexPath.row + 1;
    if(!record.music){
        record.music = [[MusicEntity alloc] init];
        record.music.name = record.title;
        record.music.artistName = @"Bubiji";
    }
    [cell setUserInteractionEnabled:record.isCache];
    if(!record.isCache){
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.musicEntity = record.music;
    cell.delegate = self;
    [self updatePlaybackIndicatorOfCell:cell];
    return cell;
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
