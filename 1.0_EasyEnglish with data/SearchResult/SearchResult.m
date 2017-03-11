//
//  SearchResult.m
//  JokePlayer
//
//  Created by apple on 11-12-20.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SearchResult.h"
#import "MediaPlayer/MediaPlayer.h"

@implementation SearchResult

-(id)initWihtSearchBar:(UISearchBar*) sb WithDataSource:(NSMutableArray*) ds
{
    self=[super init];
    if (self) {
        allDataSource =[ds retain];
        SearchBarOfSR = [sb retain];
        resultDataSource =[[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
    
}
-(void)fillResultDataSource:(NSArray*)datasource
{
    if (datasource ==nil) {
        return;
    }
    [resultDataSource removeAllObjects];
    NSLog(@"clear all data %d",[resultDataSource count] );
    [resultDataSource addObjectsFromArray:datasource];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *searchText =SearchBarOfSR.text;
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@" SELF contains [cd] %@",searchText];
    NSArray *array= [allDataSource filteredArrayUsingPredicate:predicate];
    
    [self fillResultDataSource:array];
    return [resultDataSource count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  @"Result";
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellID =@"CellResult";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID]autorelease];
    
    }
    cell.textLabel.text =[resultDataSource objectAtIndex:indexPath.row];
    CGFloat size =13;
    cell.textLabel.font =[UIFont boldSystemFontOfSize:size];
    return cell;
    
}
//播放有点问题 应该统一一个播放类 控制播放 与暂停
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath ];
    NSString *fileName =cell.textLabel.text;
    NSRange rang = [fileName rangeOfString:@".mp3"];
    
    NSString *str = [fileName stringByReplacingCharactersInRange:rang withString:@""]; 
    
    NSURL *url= [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:str ofType:@"mp3"]];
    MPMoviePlayerController  *player = [[MPMoviePlayerController alloc]initWithContentURL:url];
    //player.movieControlMode =MPMovieControlModeDefault;
    player.scalingMode = MPMovieScalingModeAspectFill; //full screen
    
    
    
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MovieFinishCallBack:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];  这部分 没有用到 不知道什么意思
    
    [player setFullscreen:YES];
    //    [player ]
   // NSLog(@"beforeplay");
    [player play];
    [self.view addSubview:player.view];
    [player release];
   // NSLog(@"play");
}
//不知道有什么用
//- (void)MovieFinishCallBack:(NSNotification*)aNotification
//{
//	MPMoviePlayerController *thePlayer = [aNotification object];
//	//从通告中导入这个播放器对象，如果播放器是单独的类成员，那就不用这步咯。
//    
//	[[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:MPMoviePlayerPlaybackDidFinishNotification 
//                                                  object:thePlayer];
//	//这步非常非常重要，一定要将被监听对象卸载，
//	//否则本地对象卸载后，监听对象为nil，软件会崩溃的
//    NSLog(@"call back");
//    
//	[thePlayer release]; 
//}
@end
