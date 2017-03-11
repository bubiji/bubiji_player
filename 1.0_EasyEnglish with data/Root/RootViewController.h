//
//  RootViewController.h
//  JokePlayer
//
//  Created by apple on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DetailViewController.h"
#import "MusicPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "DetailViewController.h"
#import "MediaPlayer/MediaPlayer.h"
#import "SearchResult.h"
//以下是那个播放器
#import "Music.h"
//#import "MusicPlayerAppDelegate.h"
#import "AVFoundation/AVFoundation.h"
#import "MusicPlayerViewController.h"
#import "FMDatabase.h"
//#import "iPodPlayerViewController.h"

#import <sqlite3.h>
@interface RootViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIApplicationDelegate,PlayerViewControllerDelegate,MPMediaPickerControllerDelegate>
{

    //NSDictionary *DataSource; //从plist 拿来的数据
    //UISearchBar *searchBar;
    UILabel *logoLable;
    //NSMutableArray *AllDataSourceForSearch;  //cell 遍历的时候添加的数据
    //UISearchDisplayController *SearchDisplay;
    //AVAudioSession *audioSession;
    //MusicPlayerViewController *playerController;
    UITableView *musicListTableView;
    //sqlite3 *database;
    NSInteger indexCell;
    NSInteger indexRow;

}
//@property (nonatomic,retain) NSMutableArray *ArrayGroup;
//@property (nonatomic,retain) NSMutableArray *ArrayJoke;
//-(void)checksqlexectute:(NSInteger)classid columnid :(NSInteger) cid;
//-(void)newPlay :(Music*) music; //如何挪到player 里面去
-(void)selectAndPlay:(id)sender;
-(void)rootReloadData;
-(void)listReloadData;


@end
