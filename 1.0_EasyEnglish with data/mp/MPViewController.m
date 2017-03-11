//
//  MPViewController.m
//  JokePlayer
//
//  Created by apple on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MPViewController.h"
#import "MediaPlayer/MediaPlayer.h"

@implementation MPViewController

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
    CGRect rect = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    
    playButton =[[UIButton alloc]initWithFrame:rect];
    //playButton.titleLabel.text =@"play";
    [playButton setTitle:@"play" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playvideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:playButton];
    
    //这个页面总体来说是不需要了。可是我不明白 为什么这个button 不出来
    
    UIButton *myButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];

    myButton.frame =CGRectMake(100, 200, 100, 44);//在父亲view中的坐标位置 都是相对的。
    myButton.showsTouchWhenHighlighted= YES;
    [myButton setTitle:@"normall" forState:UIControlStateNormal];
    [myButton setTitle:@"hightlight" forState:UIControlStateHighlighted];
    [myButton setTitle:@"asad" forState:UIControlStateReserved];
    [myButton addTarget:self action:@selector(PlayVideo) forControlEvents:UIControlEventTouchUpInside];
    [myButton setTag:100];
    
    [self.view addSubview:myButton]; //把mybutton 加入的父亲中

}

//play
-(void)PlayVideo
{
    NSURL *url= [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"1" ofType:@"m4v"]];
    MPMoviePlayerController  *player = [[MPMoviePlayerController alloc]initWithContentURL:url];
    //player.movieControlMode =MPMovieControlModeDefault;
    [self.view addSubview:player.view];
    [player setFullscreen:YES];
//    [player ]
     NSLog(@"beforeplay");
    [player play];
    NSLog(@"play");
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
