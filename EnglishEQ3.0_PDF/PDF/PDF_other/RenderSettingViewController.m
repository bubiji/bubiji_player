//
//  RenderSettingViewController.m
//  PDFViewer
//
//  Created by Radaee on 12-12-12.
//  Copyright (c) 2012年 Radaee. All rights reserved.
//

#import "RenderSettingViewController.h"
#import "PDFIOS.h"
@interface RenderSettingViewController ()

@end

@implementation RenderSettingViewController
@synthesize partitationTableView;
@synthesize partitationTableViewCell;
@synthesize dicData;
@synthesize arrayData;
extern int g_render_quality;
extern NSUserDefaults *userDefaults;
extern PDF_RENDER_MODE renderQuality;

static int currentIndex=1;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //GEAR
    //setting moved in ViewWillAppear

    self.title = NSLocalizedString(@"Render Quality", @"Localizable");
    CGRect boundsc = [[UIScreen mainScreen]bounds];
    int cwidth = boundsc.size.width;
    int cheight = boundsc.size.height;
    
    //  self.partitationTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.partitationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,cwidth, cheight) style:UITableViewStyleGrouped];
    self.partitationTableView.delegate =self;
    self.partitationTableView.dataSource = self;
    
    self.partitationTableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.partitationTableView];
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:@"RenderList" withExtension:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    self.dicData = dictionary;
    NSArray *array = [self.dicData allKeys];
    self.arrayData = array;
}

//GEAR
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    g_render_quality = [userDefaults integerForKey:@"RenderQuality"];
    if(g_render_quality == 0)
    {
        g_render_quality =1;
    }
    currentIndex = g_render_quality;
    renderQuality = g_render_quality;
    
    [self.partitationTableView reloadData];
    
    self.partitationTableView.frame = self.view.bounds;
}
//FINE

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrayData count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *stringDataKey = [self.arrayData objectAtIndex:section];
    NSArray *arraySection = [self.dicData objectForKey:stringDataKey];
    return [arraySection count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow]animated:YES];
    if(indexPath.row == currentIndex)
    {
        return;
    }
    switch (indexPath.row) {
        case 0:
            renderQuality = 0;
            break;
        case 1:
            renderQuality = 1;
            break;
        case 2:
            renderQuality = 2;
            break;
        default:
            break;
    }
    g_render_quality = renderQuality;
    [userDefaults setInteger:g_render_quality forKey:@"RenderQuality"];
    //GEAR
    [userDefaults synchronize];
    //END
    //PDFVS_renderQuality(g_render_quality);
 
    
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType==UITableViewCellAccessoryCheckmark)
        
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    else 
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if(oldCell.accessoryType==UITableViewCellAccessoryCheckmark)
        
    {
        oldCell.accessoryType=UITableViewCellAccessoryNone;
    }
    else 
    {
        oldCell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    currentIndex = indexPath.row;
}
-(UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == currentIndex)
    {
        return UITableViewCellAccessoryCheckmark;
    }
    else{
        return UITableViewCellAccessoryNone;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
   
    NSString *key =[self.arrayData objectAtIndex:section];
    NSArray *arraySection = [self.dicData objectForKey:key];
    
    static NSString *partitation = @"partitation";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:partitation];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:partitation];
        
    }
    cell.textLabel.text = [arraySection objectAtIndex:row];
    // cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    // UISwitch *switchView = [[UISwitch alloc] init]; [switchView setOn:YES]; 
    //cell.accessoryView = switchView;
    cell.accessoryType = UITableViewCellStyleDefault;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [self.arrayData objectAtIndex:section];
    return key;
}
@end
