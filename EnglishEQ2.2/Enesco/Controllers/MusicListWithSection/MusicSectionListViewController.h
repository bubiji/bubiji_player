//
//  MusicListViewController.h
//  Enesco
//
//  Created by Aufree on 11/30/15.
//  Copyright © 2015 The EST Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicListViewController.h"

@interface MusicSectionListViewController : UITableViewController
@property (nonatomic, weak) id <MusicListViewControllerDelegate> delegate;
@end
