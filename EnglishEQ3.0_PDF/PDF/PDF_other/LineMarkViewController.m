//
//  LineMarkViewController.m
//  PDFViewer
//
//  Created by Radaee on 13-1-5.
//  Copyright (c) 2013年 Radaee. All rights reserved.
//

#import "LineMarkViewController.h"
#import "PDFIOS.h"
@interface LineMarkViewController ()

@end

@implementation LineMarkViewController
@synthesize partitationTableView;
@synthesize partitationTableViewCell;
@synthesize dicData;
@synthesize arrayData;

static int  currentIndex=1;
extern float g_Ink_Width;
extern NSUserDefaults *userDefaults;

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
    self.title = NSLocalizedString(@"Ink Width", @"Localizable");
    CGRect boundsc = [[UIScreen mainScreen]bounds];
    int cwidth = boundsc.size.width;
    int cheight = boundsc.size.height;
    self.partitationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,cwidth, cheight) style:UITableViewStyleGrouped];
    self.partitationTableView.delegate =self;
    self.partitationTableView.dataSource = self;
    self.partitationTableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.partitationTableView];
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:@"LineMarkWidth" withExtension:@"plist"];
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
    g_Ink_Width = [userDefaults floatForKey:@"InkWidth"];
    if (g_Ink_Width == 1.0f)
        currentIndex =0;
    else if (g_Ink_Width == 2.0f)
        currentIndex =1;
    else if (g_Ink_Width == 4.0f)
        currentIndex =2;
    else if (g_Ink_Width == 8.0f)
        currentIndex =3;
    
    [self.partitationTableView reloadData];
    
    self.partitationTableView.frame = self.view.bounds;
}
//END

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow]animated:YES];
    if(indexPath.row == currentIndex)
    {
        return;
    }
    switch (indexPath.row) {
        case 0:
            g_Ink_Width =1.0f;
            break;
            
        case 1:
            g_Ink_Width =2.0f;
            break;
            
        case 2:
            g_Ink_Width =4.0f;
            break;
            
        case 3:
            g_Ink_Width =8.0f;
            break;
            
        default:
            g_Ink_Width =2.0f;
            break;
    }
    //GEAR
    [userDefaults setFloat:g_Ink_Width forKey:@"InkWidth"];
    [userDefaults synchronize];
    //END
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
    cell.accessoryType = UITableViewCellStyleDefault;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [self.arrayData objectAtIndex:section];
    return key;
}
@end
