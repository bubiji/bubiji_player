//
//  StopTomeViewController.m
//  JokePlayer
//
//  Created by apple on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StopTomeViewController.h"

@implementation StopTomeViewController
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
    
    [self initTimeList]; 
    CGRect rect =CGRectMake(0, 80, 320, 460);
    StopTimeTableView =[[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    StopTimeTableView.delegate =self;
    StopTimeTableView.dataSource =self;
    StopTimeTableView.backgroundColor =[UIColor clearColor];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Style1.jpg"]];

    
    [self.view addSubview:StopTimeTableView];
    [StopTimeTableView release];
    
    NSLog(@"%@",@"stop页面");

    
}
#pragma  mark -
#pragma mark init menu
-(void)initTimeList
{
    
    //    [menuDic setObject: @"sky"  anObjectforKey: @"Change Skin"];
    timeList  =[[NSMutableArray alloc]initWithCapacity:0];
    [timeList addObject:@"Close Play"];
    //[timeList addObject:@"After One Class"];//可选
    [timeList addObject:@"After 15 minute"];
    [timeList addObject:@"After 20 minute"];
    [timeList addObject:@"After 30 minute"];
    [timeList addObject:@"After 60 minute"];
    [timeList addObject:@"After 120 minute"];
    //[timeList addObject:@"After 1 minute"];

    minList  =[[NSMutableArray alloc]initWithCapacity:0];

    [minList addObject:@"0"];
    //[minList addObject:@"1"];
    [minList addObject:@"15"];
    [minList addObject:@"20"];
    [minList addObject:@"30"];
    [minList addObject:@"60"];
    [minList addObject:@"120"];

//    secondList[0]=0; 
//    secondList[1]=15; 
//    secondList[2]=20; 
//    secondList[3]=30; 
//    secondList[4]=60; 
//    secondList[5]=120; 
//    secondList[5]=1; 

    
}

#pragma  mark -
#pragma mark init table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"count %d",[menuDic count]);
    return [timeList count];
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"timecell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID]; 
    if (cell ==Nil) {
        
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID]autorelease];
    }
   //NSLog(@"flag %d",flag[indexPath.row]);
    if (flag[indexPath.row]) {
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
    }else
    {
        cell.accessoryType =UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text =[timeList objectAtIndex:indexPath.row];
    return cell;
    
}
-(AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i=0; i< 10; i++) {
        flag[i]=0;
    }
    flag[indexPath.row] =! flag[indexPath.row];
//    StopTime
    AppDelegate *app =[self getAppDelegate];
    app.StopTime = [[minList objectAtIndex:indexPath.row]doubleValue]*600;//secondList[indexPath.row] *60;
    //NSLog(@"stop time %f", app.StopTime);
    [StopTimeTableView reloadData];
    
    [self dismissModalViewControllerAnimated:YES];

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //    switch (indexPath.row) {
    //        case 0:
    //            //
    //            break;
    //            
    //        default:
    //            break;
    //    }   
    //    DetailViewController *dvc =[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    //    dvc.title=@"Detail"; 
    //    
    //    // UIApplication  *delegate=[[UIApplication sharedApplication] delegate]; 
    //    
    //    [self.navigationController pushViewController:dvc animated:YES];
    //    //[self.navigationController pushViewController:svc animated:YES];
    //    
    //    NSLog(@"little btn %d clicked",[indexPath row]);
    //dvc.de
    
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
