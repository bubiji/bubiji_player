//
//  StopTomeViewController.h
//  JokePlayer
//
//  Created by apple on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StopTomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    //列表数据
    NSMutableArray *timeList; //把谁被选中 放在APP中 看怎么用枚举
    int secondList[10]; //描述
    NSMutableArray *minList; //把谁被选中 放在APP中 看怎么用枚举

    UITableView *StopTimeTableView;
    int flag[10];

}
-(void)initTimeList;
@end
