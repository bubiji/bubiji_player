//
//  PlanViewController.m
//  JokePlayer
//
//  Created by apple on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlanViewController.h"
#import "PlanViewCell.h"
@implementation PlanViewController
 

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //init 
    CGRect rect = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
    planTableViewList =[[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    planTableViewList.delegate =self;
    planTableViewList.dataSource=self;
    planTableViewList.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //search
    //searchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    //planTableViewList.tableHeaderView =searchBar;
    //logo
    //    logoLable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    //    logoLable.text =@"%dNumber Of Item";//课程总数量
    //    planTableViewList.tableFooterView =logoLable;
    //    planTableViewList.tag=100;
    planTableViewList.rowHeight =300;
    planTableViewList.sectionHeaderHeight =200;
    planTableViewList.backgroundColor =[UIColor clearColor];
    //planTableViewList.separatorColor = [UIColor grayColor];

    //Style15.jpg
    [self.view addSubview:planTableViewList];
    UIColor *bak =[[UIColor alloc ]initWithPatternImage:[UIImage imageNamed:@"Style15.jpg"]];
    self.view.backgroundColor=bak;
    [bak release];
    [planTableViewList release];
  
//  ---- 后台播放  
//    audioSession = [AVAudioSession sharedInstance];
//    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [audioSession setActive:YES error:nil];

    NSLog(@"%@",@"plan页面");

}
//bar select
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{  
    
    //当前destionname 和list比较 得到几 flag 就反向复制
    AppDelegate *appDelegate=[self getAppDelegate];
    
    //听到哪 哪的setion open
    int sectionOpenIndex =0;
    for (NSString *m in appDelegate.appSectionList) {
//        NSLog(@"1: %@",appDelegate.currentMusic.section);
//        NSLog(@"2: %@",m);

        if ([appDelegate.currentMusic.section isEqualToString: m]) {
            
            break;
        }else
        {
            sectionOpenIndex++;
        }
    }
    //NSLog(@"flag: %d",sectionOpenIndex);  //有bug啊 有bug
    flag[sectionOpenIndex] =! flag[sectionOpenIndex];
    //sectionOpenIndex =0;

    [planTableViewList reloadData];
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
    AppDelegate *appDelegate=[self getAppDelegate];
    
    //最底层？
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.tag =section;
    
    //section name
    //backgroudImage
    [button setBackgroundImage:[UIImage imageNamed: @"touming.png"] forState:UIControlStateNormal];
    button.backgroundColor =[UIColor clearColor];
    button.frame =CGRectMake(0 , 0, 320, 35);
    //event
    [button addTarget:self action:@selector(btnSectionClick:) forControlEvents:UIControlEventTouchUpInside];
    //flag image control
    UIImageView *imageFlag =[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 20, 20)];
    //变换图
    if (!flag[section]) 
    {
        imageFlag.image =[UIImage imageNamed:@"normal.png"];
    }else
    {
        imageFlag.image =[UIImage imageNamed:@"pressed.png"];
    }
    CGFloat size =16;
    //自适应大小
    
    //    CGFloat width =[self]
    
    UILabel *sectionLable =[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200, 31)];
    sectionLable.backgroundColor =[UIColor clearColor];
    sectionLable.textColor =[UIColor blackColor]; //字体的颜色
    sectionLable.font =[UIFont boldSystemFontOfSize:size];
    //NSString *sectionIndex =[NSString stringWithFormat:@"%d",section];
    //每组有几个人
    //NSInteger peopleNum=  [[[DataSource objectForKey:sectionIndex]objectForKey:@"peopleList" ] count];
    //group name
    NSString *Name = [appDelegate.appSectionList objectAtIndex:section];
    
    
    sectionLable.text =[NSString stringWithFormat:@"%@",Name];
    //sectionLable.font
    UIView *view =[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)]autorelease];
    [view addSubview:button];
    [view addSubview:imageFlag ];
    [imageFlag release];
    [view addSubview:sectionLable ];
        [sectionLable release];
    //    [button release];
    //    [imageFlag release];
    return view;
}

-(void)btnSectionClick:(id)sender
{
    int sectionIndex =((UIButton*)sender).tag;
    flag[sectionIndex] =! flag[sectionIndex];
    //NSLog( @"row count %d",flag[sectionIndex] );
    [planTableViewList beginUpdates];
    [planTableViewList reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
    [planTableViewList endUpdates];
}


//row count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //AppDelegate *appDelegate=[self getAppDelegate];
    NSInteger sectionNum;
    if (!flag[section]) {
        sectionNum=0;
    }else
    {
        // NSString *sectionIndex =[NSString stringWithFormat:@"%d",section];
        //这里其实应该count 每组多大
        sectionNum  =3;
    }
    
    return  sectionNum; //yes
    //return 3 ;
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *cellID =@"PlanView";
    PlanViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil]lastObject];
    }
    //cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;  //附件按钮

    
    AppDelegate *appDelegate=[self getAppDelegate];
    NSInteger index = indexPath.row + 3*indexPath.section;

    Music *music= [appDelegate.musiclist objectAtIndex:index] ;
    cell.className=music.title;
    cell.didTimes =[NSString stringWithFormat:@"%d",music.DidTimes] ;
    cell.didDays =[NSString stringWithFormat:@"%d",music.DidDays] ;
    cell.backgroundColor =[UIColor clearColor];//字体的颜色 应该暗一点点
    //cell.recomDays =[NSString stringWithFormat:@"%d",music.] ;    
    //cell.didTimes=music.DidTimes;
    
    //CGFloat size =13;
    
    //cell.textLabel.font =[UIFont boldSystemFontOfSize:size];
    //just for search
    //[AllDataSourceForSearch addObject:cell.textLabel.text];
    return cell;
}
//selected and play
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{    
//    //skip page
//    MusicPlayerViewController *controller = [[MusicPlayerViewController alloc] initWithNibName:@"MusicPlayerViewController" bundle:nil] ;
//    controller.playerdelegate = self;
//    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    
//    [self presentModalViewController:controller animated:YES];
//    //cancel selected
//    [(UITableView*)[self.view viewWithTag:100] deselectRowAtIndexPath:indexPath animated:YES];
//    //play
//    AppDelegate *appDelegate=[self getAppDelegate];
//    
//    NSInteger selectedIndex =indexPath.section*3 +indexPath.row; 
//    Music *music=[appDelegate.musiclist objectAtIndex:selectedIndex];
//    
//    audioSession = [AVAudioSession sharedInstance];
//    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [audioSession setActive:YES error:nil];
//    ///后台播放的关键  不知道能不能写在什么关键的地方
//    if (appDelegate.player.isPlaying==NO ||appDelegate.currentMusic.title !=music.title)
//    {
//        
//        [appDelegate.player release];
//        appDelegate.player=nil;
//        
//        AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: music.path error:nil];
//        appDelegate.player=newPlayer;
//        [appDelegate.player setVolume:0.5f];
//        [appDelegate.player setNumberOfLoops:9999];
//        [appDelegate.player prepareToPlay];
//        [appDelegate.player play];
//        appDelegate.player.delegate =self;
//        appDelegate.currentMusic=music;
//        // NSLog(@"list :%@",[appDelegate.musiclist objectAtIndex:indexPath.row]);
//        
//        appDelegate.currentMusic.isPlaying=YES;
//        //NSLog(@"name :%@",appDelegate.currentMusic.title);
//    }
//    //NSLog(@"newPlayer %@",newPlayer);
//    
//    
//}
//music finish
//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
//{
//    if (flag) {
//        //数据库插入记录
//        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//        //根据歌名和id名 给听取数加一
//        //appDelegate.currentMusic.classID
//        //        NSString *aa=[appDelegate.appDB stringForQuery:@"SELECT ClassName FROM ClassTable WHERE ClassID = ?",        appDelegate.currentMusic.classID];  
//        //NSLog(@"aaa %@",aa);
//        //今天时间
//        NSDate* date = [NSDate date];
//        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];            
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        NSString* time = [formatter stringFromDate:date];
//        NSString *ClassID=    (NSString*)appDelegate.currentMusic.classID;
//        NSLog(@"ddidididid %d",appDelegate.currentMusic.classID);
//        //NSLog(@"ddidididid %@",ClassID);
//        
//        appDelegate.currentMusic.DidTimes+=1;
//        if (appDelegate.currentMusic.TodayTime==nil) {
//            appDelegate.currentMusic.TodayTime =time;
//            NSLog(@"bbbb %@",appDelegate.currentMusic.TodayTime);
//            appDelegate.currentMusic.DidDays+=1;
//            
//            BOOL aaa= [appDelegate.appDB executeUpdate:@"UPDATE ClassTable SET TodayTime = ? WHERE ClassID = ? ",time,@"1"];  
//            NSLog(@"adsad %@", aaa);
//        }
//        //NSString 
//        [appDelegate.appDB executeUpdate:@"UPDATE ClassTable SET DidTimes = ? WHERE ClassID = ? ",appDelegate.currentMusic.DidTimes,ClassID];  
//        
//        //如果日期日期不是今天的日期 还要给天数加一
//    }
//    
//}

- (void)playerViewControllerDidFinish:(MusicPlayerViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

//accessoryButton  should show text   
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
//    DetailViewController *dvc =[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
//    dvc.title=@"Detail"; 
//    
//    // UIApplication  *delegate=[[UIApplication sharedApplication] delegate]; 
//    
//    [self.navigationController pushViewController:dvc animated:YES];
//    //[self.navigationController pushViewController:svc animated:YES];
//    
//    NSLog(@"little btn %d clicked",[indexPath row]);
//    //dvc.de
//    
}
#pragma -
#pragma mark - Search & Index
//-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    NSMutableArray *array =[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
//    //[array addObject:UITableViewIndexSearch];
//    AppDelegate *appDelegate=[self getAppDelegate];
//    for (int i=0; i<[appDelegate.appSectionList count]; i++) {
//        NSString *str =[NSString stringWithFormat:@"%d",i];
//        [array addObject:str];
//    }
//    //[array addObject:@"end"];
//    
//    return array;
//}
//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    
//    //    if (title ==UISearchBarIconSearch) {
//    //        [tableView scrollRectToVisible:searchBar.frame animated:YES];
//    //        
//    //        return -1;
//    //    }
//    //    if ([title isEqualToString:@"end"]) {
//    //        [tableView scrollRectToVisible:logoLable.frame animated:YES];
//    //        
//    //        return -1;
//    //    }
//    return index-1;
//    
//}
#pragma -
#pragma mark - Unload

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //[DataSource release];
    //[detailViewController release]; 
    [searchBar release];
    [logoLable release];
    [AllDataSourceForSearch release];
    [SearchDisplay release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
