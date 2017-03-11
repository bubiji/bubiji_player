//
//  MusicSectionList2ViewController.h
//  Enesco
//
//  Created by wangjie on 16/6/4.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicListViewController.h"
#import "FileService.h"

@interface MusicSectionList2ViewController : UITableViewController<FileServiceDelegate>
{
    MBProgressHUD *HUD;

}
@property (nonatomic, weak) id <MusicListViewControllerDelegate> delegate;
@end
