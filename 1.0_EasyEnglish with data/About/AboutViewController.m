//
//  AboutViewController.m
//  JokePlayer
//
//  Created by apple on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "RootViewController.h"

@implementation AboutViewController

-(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

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
  
    self.navigationItem.hidesBackButton = YES;
    

    double width =self.view.frame.size.width;
    double height =self.view.frame.size.height+20;

    //NSLog(@"w :%f ",self.view.frame.size.width);
    //NSLog(@"h :%f ",height);

    UIScrollView  *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, height)];
    mainView.directionalLockEnabled = YES;
    mainView.pagingEnabled = YES;
    mainView.backgroundColor = [UIColor blackColor];//最后面的背景
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.delegate = self;
    
    CGSize newSize = CGSizeMake(width * 5,  height);
    [mainView setContentSize:newSize];
    
    //[pageControl release];
    UIView *view0=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,width, height)];
    UIColor *back0 = [[UIColor alloc ]initWithPatternImage:[UIImage imageNamed:@"Rookie1.jpg"]];
    view0.backgroundColor=back0;
    [back0 release];
    [mainView addSubview:view0];
    [view0 release];
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, -20, width, height)];
    UIColor *back1 =[[UIColor alloc ]initWithPatternImage:[UIImage imageNamed:@"view1.png"]];
    view1.backgroundColor=back1;
    [back1 release];
    [mainView addSubview:view1];
    [view1 release];
    UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*2, -20, width, height)];
    view2.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"view2.png"]];;
    
    [mainView addSubview:view2];
    [view2 release];
    
    UIView *view3=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*3, -20,width, height)];
    view3.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"view3.png"]];;
    
    [mainView addSubview:view3];
    [view3 release];
    UIView *view4=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*4, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    view4.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Rookie9.jpg"]];;
    
    [mainView addSubview:view4];
    [view4 release];
    
    [self.view addSubview:mainView];
    //给scroll 一个新size
    pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(0.0, 440, width, 20)]autorelease];
    pageControl.hidesForSinglePage = YES;
    pageControl.userInteractionEnabled = NO;
    pageControl.backgroundColor = [UIColor blackColor];
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];
    
    [mainView release];

    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    
    pageControl.currentPage = index;
    
    if (pageControl.currentPage+1 ==pageControl.numberOfPages) {
        AppDelegate *appDelegate=[self getAppDelegate];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        sleep(0.6);
        [appDelegate.rootBar dismissModalViewControllerAnimated:YES];
        
    }
    //index为当前页码
    //NSLog(@"%d",index);
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
