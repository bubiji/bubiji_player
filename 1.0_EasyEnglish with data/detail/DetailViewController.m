//
//  DetailViewController.m
//  JokePlayer
//
//  Created by apple on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "MediaPlayer/MediaPlayer.h"

@implementation DetailViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Data
  //  ArrayGroup =[[NSMutableArray alloc]initWithObjects:@"播放 ", nil] ;
    NSLog(@"detail show!");

    ArrayList =[[NSMutableArray alloc]init] ;
    for (int i=0; i< 20; i++) {
        NSString *temp =[NSString stringWithFormat:@"%d",i];
        [ArrayList addObject:temp];
    }
    //NSLog(@"detail show!");

    //initTable
    CGRect rect = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
    UITableView *DetailTableView = [[UITableView alloc]initWithFrame:rect 
                                                       style:UITableViewStylePlain];
    //NSLog(@"detail show!");

    DetailTableView.delegate=self;
    DetailTableView.dataSource =self;
    
    [self.view addSubview:DetailTableView];
    [DetailTableView release];
    //NSLog(@"detail show!");
    
}
//row count
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ArrayList count];
}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellName =@"CellName";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellName];
    if (cell ==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName]autorelease];
    }
    cell.textLabel.text =[ArrayList objectAtIndex:[indexPath row]];
    
    return cell;
}
//select and play
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     //how to get file name
    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath ];
    NSString *fileName =cell.textLabel.text;
    NSURL *url= [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:fileName ofType:@"m4v"]];
    MPMoviePlayerController  *player = [[MPMoviePlayerController alloc]initWithContentURL:url];
    //player.movieControlMode =MPMovieControlModeDefault;
    	player.scalingMode = MPMovieScalingModeAspectFill; //full screen
    
  
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MovieFinishCallBack:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [self.view addSubview:player.view];
    [player setFullscreen:YES];
    //    [player ]
    NSLog(@"beforeplay");
    [player play];
    NSLog(@"play");
}

//finish call back
- (void)MovieFinishCallBack:(NSNotification*)aNotification
{
	MPMoviePlayerController *thePlayer = [aNotification object];
	//从通告中导入这个播放器对象，如果播放器是单独的类成员，那就不用这步咯。
    
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification 
                                                  object:thePlayer];
	//这步非常非常重要，一定要将被监听对象卸载，
	//否则本地对象卸载后，监听对象为nil，软件会崩溃的
    NSLog(@"call back");

	[thePlayer release]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
