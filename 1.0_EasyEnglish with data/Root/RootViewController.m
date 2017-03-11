//
//  RootViewController.m
//  JokePlayer
//
//  Created by apple on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController
//@synthesize ArrayGroup,ArrayJoke;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
-(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

// left button
- (UIBarButtonItem*)initWithLeftButton:(UIResponder *)owner{
    UIButton *playNowButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 40, 40)];
    [playNowButton setBackgroundImage:[UIImage imageNamed:@"help.png"] forState:UIControlStateNormal];
    [playNowButton addTarget:self action:@selector(AboutClick:)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *bar =[[UIBarButtonItem alloc] initWithCustomView:playNowButton];
    [playNowButton release];
    //self.buttonOwner = owner;
    return bar;
}
// right button
- (UIBarButtonItem*)initWithRightButton:(UIResponder *)owner{
    //NSLog(@"gogo");
    UIButton *playNowButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 40, 50)];
    [playNowButton setBackgroundImage:[UIImage imageNamed:@"Btn_playing.png"] forState:UIControlStateNormal];
    [playNowButton addTarget:self action:@selector(PlayClick:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *bar =[[UIBarButtonItem alloc] initWithCustomView:playNowButton];
    [playNowButton release];
    //self.buttonOwner = owner;
    return bar;
}
//init
- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate=[self getAppDelegate];
    appDelegate.RootDelegate=self;
    
    //init 
    CGRect rect = CGRectMake(0.0f, 44.0f, 320.0f, 410.0f);
    musicListTableView =[[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    musicListTableView.delegate =self;
    musicListTableView.dataSource=self;
    musicListTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //tvGroupList.separatorStyle = UITableViewCellSeparatorStyleNone;
    musicListTableView.separatorColor = [UIColor grayColor]; 
    musicListTableView.backgroundColor =[UIColor clearColor];
    musicListTableView.rowHeight =40;
    musicListTableView.sectionHeaderHeight =30;
    //search bar
    //    searchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    //    [[searchBar.subviews objectAtIndex:0]removeFromSuperview];
    //    musicListTableView.tableHeaderView =searchBar;
    //logo
    logoLable =[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 320, 44)];
    logoLable.text = [NSString stringWithFormat: @"%lu Number Of Item",(unsigned long)[appDelegate.musiclist count ]] ;//课程总数量
    logoLable.backgroundColor =[UIColor clearColor];
    //musicListTableView.tableFooterView =logoLable;
    musicListTableView.tag=100;
    
    [self.view addSubview:musicListTableView];
    UIColor *back =[[UIColor alloc ]initWithPatternImage:[UIImage imageNamed:@"macbg.png"]];
    self.view.backgroundColor=back;
    [back release];
    [musicListTableView release];
    
    
    UIBarButtonItem *leftButtonItem = [self initWithLeftButton:self];
    UIBarButtonItem *rightButtonItem = [self initWithRightButton:self];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
        NSLog(@"%@",@"root页面");
}

-(void)AboutClick:(id)sender
{
    AboutViewController *mpView =[[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil]autorelease];
    
    [self  presentModalViewController:mpView animated:YES];
}


//play and continue 
-(void)PlayClick:(id)sender
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    if (appDelegate.PlayController==nil) {
        appDelegate.PlayController = [[MusicPlayerViewController alloc] initWithNibName:@"MusicPlayerViewController" bundle:nil] ;
        appDelegate.PlayController.playerdelegate = self;
        appDelegate.PlayController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    [self presentModalViewController:appDelegate.PlayController animated:YES];
    
    
}
-(void)rootReloadData
{
    AppDelegate *appDelegate=[self getAppDelegate];
    [appDelegate.dal initMusicLit];
    [musicListTableView reloadData];
    
}
-(void)listReloadData
{
    [musicListTableView reloadData];
}
#pragma mark - my event

//section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    AppDelegate *appDelegate=[self getAppDelegate];
    
    return [appDelegate.appSectionList count] ;
}
//section view
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *sectionLable =[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 30)];
    //group name
    AppDelegate *appDelegate=[self getAppDelegate];
    NSString *Name =  [appDelegate.appSectionList objectAtIndex:section] ;
    sectionLable.text =Name;
    //NSLog(@"secition :%@",Name);
    UIImageView  *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0.0,0,320,30)]; 
    
    imageView.image = [UIImage imageNamed:@"touming.png"] ;
    
    sectionLable.backgroundColor=[UIColor clearColor];
    
    [imageView addSubview:sectionLable];
    [sectionLable release];
    UIView *view =[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)]autorelease];
    
    [view addSubview:imageView ];//这里是不是也该去
    [imageView release];
    return view;
}

//row count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    AppDelegate *appDelegate=[self getAppDelegate];
    return [[appDelegate.appSectionNumList objectAtIndex:section]intValue];
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellID =@"PlanView";
    AppDelegate *appDelegate=[self getAppDelegate];
    
    PlanViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell ==nil) {
        cell=   [[[PlanViewCell alloc]initCell]autorelease];
    }
    
    //cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;  //附件按钮
    NSMutableArray *lessionList= [appDelegate.lessonSectionlist objectAtIndex:indexPath.section] ;
    Music *music=   [lessionList objectAtIndex:indexPath.row];
    cell.className=music.title;
    //NSLog(@"title :%@",music.title);
    cell.musicType =music.type;
    cell.didTimes =[NSString stringWithFormat:@"Times : %d / %d   Days : %d / %d",music.DidTimes,music.BestTimes,music.DidDays,music.BestDays] ;
//    

    cell.cellButton.tag =music.tag;
    cell.soundflag.hidden =YES;
    
    if (appDelegate.currentMusic.isPlaying&& appDelegate.currentMusic.tag ==cell.cellButton.tag) {
        cell.soundflag.hidden =NO;
    }
    UILabel *typeLable =[[UILabel alloc]initWithFrame:CGRectMake(300, 30, 10, 10)];
    typeLable.backgroundColor =[UIColor clearColor];
    typeLable.text = music.type;
    return cell ;
    
}
// PlanViewCell Call back
-(void)selectAndPlay:(id)sender
{
    AppDelegate *appDelegate=[self getAppDelegate];   
    UIButton *button =(UIButton*)sender;

    Music *music=[appDelegate.musiclist objectAtIndex:button.tag];
    NSLog(@"~~~~music :%@  num:%d",music.title,button.tag);
    if ([music.type isEqualToString:@"none"]) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat: @"Required Import!",appDelegate.currentMusic.title,appDelegate.currentMusic.DidTimes,appDelegate.currentMusic.DidDays] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        //这里可以加上 如果不想再次提醒 就点取消提醒
        // optional - add more buttons:
        //[alert addButtonWithTitle:@"Yes"];
        [alert show];
        return;
    }
    music.isPlaying =YES;
    if (appDelegate.PlayController==nil) {
        appDelegate.PlayController = [[[MusicPlayerViewController alloc] initWithNibName:@"MusicPlayerViewController" bundle:nil] autorelease];
        appDelegate.PlayController.playerdelegate = self;//翻页面用的
        appDelegate.PlayController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    
    [appDelegate.PlayController newPlay:music];
    //NSLog(@"current music %@",appDelegate.currentMusic);
    
    // }
    [self presentModalViewController:appDelegate.PlayController animated:YES];
    
    appDelegate.currentMusic = music;
    
    
    //appSectionMusicList 初始化gropu循环
    
}
//selected and play
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
 
    [musicListTableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  
}
//-(BOOL)canBecomeFirstResponder
//{
//    return YES;
//    
//}
//课程完成
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appDelegate=[self getAppDelegate];
    NSMutableArray *lessionList= [appDelegate.lessonSectionlist objectAtIndex:indexPath.section] ;
    Music *music=   [lessionList objectAtIndex:indexPath.row];        
    //NSLog(@"music.type :%@",music.type); 在这显示类型
   
    // NSLog(@"did %d  --best %d",music.DidTimes,music.BestTimes);if
    
    if (music.DidTimes >= music.BestTimes)//||music.DidDays >= music.BestDays)
    {
        //cell.contentView.backgroundColor =[UIColor orangeColor];
        [cell setBackgroundColor:[UIColor orangeColor]];  //设置背景橘黄色 完成besttime
        cell.alpha =0.5;
    }else if ([music.type isEqualToString:@"none"]) {
        //cell.contentView.backgroundColor =[UIColor orangeColor];
        [cell setBackgroundColor:[UIColor grayColor]];  //设置背景灰色 没导入
        cell.alpha =0.5;     
    }
}

//翻页
- (void)playerViewControllerDidFinish:(MusicPlayerViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma -
#pragma mark - Search & Index
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView ==self.searchDisplayController.searchResultsTableView) {
        return  nil;
    }
    NSMutableArray *array =[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    //[array addObject:UITableViewIndexSearch];
    AppDelegate *appDelegate=[self getAppDelegate];
    for (int i=0; i<[appDelegate.appSectionList count]; i++) {
        NSString *str =[NSString stringWithFormat:@"%d",i];
        [array addObject:str];
    }
    //[array addObject:@"end"];
    
    return array;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //    if (title ==UISearchBarIconSearch) {
    //        [tableView scrollRectToVisible:searchBar.frame animated:YES];        
    //        return -1;
    //    }
    //    if ([title isEqualToString:@"end"]) {
    //        [tableView scrollRectToVisible:logoLable.frame animated:YES];       
    //        return -1;
    //    }
    return index;
    
}
#pragma -
#pragma mark - Unload

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //[DataSource release];
    //[detailViewController release]; 
    //[searchBar release];
    [logoLable release];
    //[AllDataSourceForSearch release];
    //[SearchDisplay release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
