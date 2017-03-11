//
//  SettingViewController.m
//  PDFViewer
//
//  Created by Radaee on 12-12-9.
//  Copyright (c) 2012年 Radaee. All rights reserved.
//

#import "SettingViewController.h"
#import "PDFIOS.h"


@implementation SettingViewController

@synthesize partitationTableView;
@synthesize partitationTableViewCell;
@synthesize dicData;
@synthesize arrayData;


int g_PDF_ViewMode = 0 ;
extern float g_Ink_Width;
extern float g_rect_Width;
float g_swipe_speed = 0.15f;
float g_swipe_distance=1.0f;
int g_render_quality = 1;
bool g_CaseSensitive = false;
bool g_MatchWholeWord = false;
bool g_DarkMode =false;
bool g_sel_right=false;
bool g_ScreenAwake = false;
extern uint g_ink_color ;
extern uint g_rect_color;

uint g_ellipse_color = 0xFF0000FF;
NSUserDefaults *userDefaults;

extern int selColor;
extern int g_def_view;
extern PDF_RENDER_MODE renderQuality;
extern float zoomLevel;
extern int annotHighlightColor;
extern int annotUnderlineColor;
extern int annotStrikeoutColor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   // self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //[super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    NSString *title =[[NSString alloc]initWithFormat:NSLocalizedString(@"Setting", @"Localizable")];
    // Do any additional setup after loading the view from its nib.
    self.title =title;
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:@"view_settings_page.png"] tag:0];
    self.tabBarItem = item;
    CGRect boundsc = [[UIScreen mainScreen]bounds];
    int cwidth = boundsc.size.width;
    int cheight = boundsc.size.height;
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    g_CaseSensitive = [userDefaults boolForKey:@"CaseSensitive"];
    g_MatchWholeWord = [userDefaults boolForKey:@"MatchWholeWord"];
  //  g_DarkMode = [userDefaults boolForKey:@"DarkMode"];
    g_sel_right=[userDefaults  boolForKey:@"SelectTextRight"];
    g_ScreenAwake = [userDefaults boolForKey:@"KeepScreenAwake"];
    g_ink_color=[userDefaults  integerForKey:@"InkColor"];
    g_rect_color = [userDefaults integerForKey:@"RectColor"];
    g_def_view = [userDefaults integerForKey:@"ViewMode"];
    annotHighlightColor = [userDefaults integerForKey:@"HighlightColor"];
    annotStrikeoutColor = [userDefaults integerForKey:@"StrikeoutColor"];
    annotUnderlineColor = [userDefaults integerForKey:@"UnderlineColor"];
    renderQuality = [userDefaults integerForKey:@"RenderQuality"];
    
    self.partitationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,cwidth, cheight-110) style:UITableViewStyleGrouped];
   
    self.partitationTableView.delegate =self;
    self.partitationTableView.dataSource = self;
    
    self.partitationTableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.partitationTableView];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:@"SettingList" withExtension:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    self.dicData = dictionary;
    
    NSArray *array = [self.dicData allKeys];
    self.arrayData = [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [button addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.partitationTableView.frame = self.view.bounds;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];

    NSString *key =[self.arrayData objectAtIndex:section];

    NSArray *arraySection = [self.dicData objectForKey:key];
            
    static NSString *partitation=nil;
    partitation=[NSString stringWithFormat:@"partitation%d%d",[indexPath section],[indexPath row]];
 //   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:partitation];
  
  //  if(cell == nil)
  //  {
       UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:partitation];
        
 //   }
    
     

    NSString *label =[arraySection objectAtIndex:row];
    NSString *text;
    if([[label substringToIndex:0] isEqualToString:@"%"])
    {
        text = [label substringFromIndex:2];
    }
    else text = label;
    cell.textLabel.text = text;
     
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
 
    if(indexPath.section==0 &&indexPath.row==0 )
    {
        UISwitch *switchView4 = [[UISwitch alloc]init];
        [switchView4 setOn:g_CaseSensitive];
        [switchView4 addTarget:self action:@selector(updateCaseSensitive:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView4;
    }
    if(indexPath.section==0 &&indexPath.row==1 )
    {
        UISwitch *switchView5 = [[UISwitch alloc]init];
        [switchView5 setOn:g_MatchWholeWord];
        [switchView5 addTarget:self action:@selector(updateMatchWholeWord:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView5;
       
    }
    /*if(indexPath.section==1 &&indexPath.row==4)
    {
        UISwitch *switchView1 = [[UISwitch alloc]init];
        [switchView1 setOn:g_DarkMode];
        [switchView1 addTarget:self action:@selector(updateSwitchDarkMode:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView1;
    }*/
    
    if(indexPath.section==1 &&indexPath.row==5)
    {
        UISwitch *switchView2 = [[UISwitch alloc]init];
        [switchView2 setOn:g_sel_right];
        [switchView2 addTarget:self action:@selector(updateSwitchSelRight:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView2;
    }
    if(indexPath.section==1 &&indexPath.row==6)
    {
        UISwitch *switchView3 = [[UISwitch alloc]init];
        [switchView3 setOn:g_ScreenAwake];
        [switchView3 addTarget:self action:@selector(updateSwitchScreenAwake:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView3;
    }
   
    
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [self.arrayData objectAtIndex:section];
   
    NSString *text;
    NSString *temp=[key substringToIndex:1];
    if([temp compare:@"%"] == NSOrderedSame)
    {
        text = [key substringFromIndex:2];
    }
    else text = key;
   
    return text;
     
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow]animated:YES];
    if(indexPath.section==1 &&indexPath.row==0)
    {
        if( underlineColor == nil )
        {
       
        underlineColor = [[UnderLineViewController alloc] initWithNibName:@"UnderLineViewController" bundle:nil];
        }
        UINavigationController *nav = self.navigationController;
        underlineColor.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:underlineColor animated:YES];
    }
    if(indexPath.section==1 &&indexPath.row==1)
    {
        if( renderSet == nil )
        {
        
        renderSet = [[RenderSettingViewController alloc] initWithNibName:@"RenderSettingViewController" bundle:nil];
        }
        UINavigationController *nav = self.navigationController;
        renderSet.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:renderSet animated:YES];
    }
    if(indexPath.section==1 &&indexPath.row==4)
    {
        if( highlightColor == nil )
        {
            
            highlightColor = [[HighlightColorViewController alloc] initWithNibName:@"HighlightColorViewController" bundle:nil];
        }
        UINavigationController *nav = self.navigationController;
        highlightColor.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:highlightColor animated:YES];
    }

    if(indexPath.section==1 &&indexPath.row==2)
    {
      if( strikeColorSet == nil )
      {
        
        strikeColorSet = [[StrikeoutViewController alloc] initWithNibName:@"StrikeoutViewController" bundle:nil];
     }
    UINavigationController *nav = self.navigationController;
    strikeColorSet.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:strikeColorSet animated:YES];
    }
    if(indexPath.section==1 &&indexPath.row==8)
    {
        if( lineWidthSet == nil )
        {
            
            lineWidthSet = [[LineMarkViewController alloc] initWithNibName:@"LineMarkViewController" bundle:nil];
        }
        UINavigationController *nav = self.navigationController;
        lineWidthSet.hidesBottomBarWhenPushed = YES;
        
        [nav pushViewController:lineWidthSet animated:YES];
    }
    if(indexPath.section==1 &&indexPath.row==3)
    {
        if( viewModeSet == nil )
        {
            
            viewModeSet = [[ViewModeViewController alloc] initWithNibName:@"ViewModeViewController" bundle:nil];
        }
        UINavigationController *nav = self.navigationController;
        viewModeSet.hidesBottomBarWhenPushed = YES;
        
        [nav pushViewController:viewModeSet animated:YES];
    }
    if(indexPath.section==1 &&indexPath.row==7)
    {
        if( inkColorSet == nil )
        {
            
            inkColorSet = [[InkColorViewController alloc] initWithNibName:@"InkColorViewController" bundle:nil];
        }
        UINavigationController *nav = self.navigationController;
        inkColorSet.hidesBottomBarWhenPushed = YES;
        
        [nav pushViewController:inkColorSet animated:YES];
    }
    if(indexPath.section==1 &&indexPath.row==9)
    {
        if( rectColorSet == nil )
        {
            
            rectColorSet = [[RectColorViewController alloc] initWithNibName:@"RectColorViewController" bundle:nil];
        }
        UINavigationController *nav = self.navigationController;
        rectColorSet.hidesBottomBarWhenPushed = YES;
        
        [nav pushViewController:rectColorSet animated:YES];
    }
    if(indexPath.section==1 &&indexPath.row==10)
    {
        if( ovalColor == nil )
        {
            
            ovalColor = [[OvalColorViewController alloc] initWithNibName:@"OvalColorViewController" bundle:nil];
        }
        UINavigationController *nav = self.navigationController;
        ovalColor.hidesBottomBarWhenPushed = YES;
        
        [nav pushViewController:ovalColor animated:YES];
    }
    if(indexPath.section ==1 && indexPath.row == 11)
    {
        NSString *str1=NSLocalizedString(@"Alert", @"Localizable");
        NSString *str2=NSLocalizedString(@"Click OK to reset all properties to default", @"Localizable");
        NSString *str3=NSLocalizedString(@"OK", @"Localizable");
        NSString *str4=NSLocalizedString(@"Cancel", @"Localizable");
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:str1 message:str2 delegate:self cancelButtonTitle:str3 otherButtonTitles:str4, nil];
        [alter show];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%i",buttonIndex);
    if(buttonIndex == 0)
    {
        [userDefaults setBool:FALSE forKey:@"CaseSensitive"];
        g_CaseSensitive = FALSE;
        
        [userDefaults setBool:FALSE forKey:@"MatchWholeWord"];
        g_MatchWholeWord = FALSE;
        
        [userDefaults setFloat:0.1f forKey:@"SwipeSpeed"];
        g_swipe_speed = 0.15f;
        //PDFVS_setSwipeSpeed(g_swipe_speed);
        
        [userDefaults setInteger:1 forKey:@"RenderQuality"];
        g_render_quality =1;
        //PDFVS_renderQuality(g_render_quality);
        
        
        g_swipe_distance = 1.0f;
        [userDefaults setFloat:g_swipe_distance forKey:@"SwipeDistance"];
        //PDFVS_setSwipeDis(g_swipe_distance);
        
        [userDefaults setInteger:0 forKey:@"ViewMode"];
        g_def_view = 0;
        
        [userDefaults  setBool:FALSE forKey:@"DarkMode"];
        g_DarkMode = FALSE;
       // PDFVS_setDarkMode(g_DarkMode);
        
        [userDefaults  setBool:FALSE forKey:@"SelectTextRight"];
        g_sel_right = FALSE;
       // PDFVS_textRtol(g_sel_right);
        
        [userDefaults  setBool:FALSE forKey:@"KeepScreenAwake"];
        g_ScreenAwake = FALSE;
        [[UIApplication sharedApplication] setIdleTimerDisabled:g_ScreenAwake];
        
        [userDefaults  setInteger:0xFF000000 forKey:@"InkColor"];
        g_ink_color = 0xFF000000;
        [userDefaults  setInteger:0xFF000000 forKey:@"RectColor"];
        g_rect_color = 0xFF000000;
        g_Ink_Width = 2.0f;
        [userDefaults setFloat:g_Ink_Width forKey:@"InkWidth"];
        
       // [userDefaults  setInteger:1 forKey:@"RectColor"];
        [userDefaults synchronize];
        //[self.view setNeedsDisplay];
        [self.partitationTableView reloadData];
    }
}

- (void)btnClicked:(id)sender event:(id)event
{
    
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.partitationTableView];
    
    NSIndexPath *indexPath = [self.partitationTableView indexPathForRowAtPoint:currentTouchPosition];
    
    if(indexPath != nil)
        
    {
        
    [self tableView:self.partitationTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
        
    }
}
    
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    /*
    if( settingSpeedView == nil )
    {
        //m_pdf = [[RDPDFViewController alloc] init];
        settingSpeedView = [[SettingSpeedViewController alloc] initWithNibName:@"SettingSpeedViewController" bundle:nil];
    }
    UINavigationController *nav = self.navigationController;
    settingSpeedView.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:settingSpeedView animated:YES];
     */
   
    /*
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    UISwitch *switch1 = (UISwitch *) [cell viewWithTag:@"Night mode"] ; 
    if(indexPath.section ==1 && indexPath.row == 4)
    {
        bool b= switch1.isOn;
        PDFVS_setDarkMode(b);
    }
    */ 
   
}
- (IBAction)updateSwitchDarkMode:(id)sender
{
        UISwitch *switchView = (UISwitch *)sender;
    
         if ([switchView isOn]) 
         {
        
             g_DarkMode = true;
         } 
         else 
         {
             g_DarkMode =false;
             
         }
        //PDFVS_setDarkMode(g_DarkMode);
        [userDefaults  setBool:g_DarkMode forKey:@"DarkMode"];
        //GEAR
        [self saveSettings];
        //END
}

-(IBAction)updateSwitchSelRight:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    
    if ([switchView isOn]) 
    {
        
        g_sel_right = true;
    } 
    else 
    {
        g_sel_right =false;
        
    }
    //PDFVS_textRtol(g_sel_right);
    [userDefaults  setBool:g_sel_right forKey:@"SelectTextRight"];
    //GEAR
    [self saveSettings];
    //END
  
}
-(IBAction)updateSwitchScreenAwake:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    
    if ([switchView isOn]) 
    {
        
        g_ScreenAwake = true;
    } 
    else 
    {
        g_ScreenAwake =false;
        
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:g_ScreenAwake];
    [userDefaults  setBool:g_ScreenAwake forKey:@"KeepScreenAwake"];
    //GEAR
    [self saveSettings];
    //END
}
- (IBAction) updateCaseSensitive:(id) sender
{
   UISwitch *switchView = (UISwitch *)sender;
    
    if ([switchView isOn]) 
    {
        
        g_CaseSensitive = true;
    } 
    else 
    {
        g_CaseSensitive =false;
        
    }
    [userDefaults setBool:g_CaseSensitive forKey:@"CaseSensitive"];
    //GEAR
    [self saveSettings];
    //END
}
- (IBAction) updateMatchWholeWord:(id) sender
{
    UISwitch *switchView = (UISwitch *)sender;
    if ([switchView isOn]) 
    {
        
        g_MatchWholeWord = true;
    } 
    else 
    {
        g_MatchWholeWord =false;
        
    }
    [userDefaults setBool:g_MatchWholeWord forKey:@"MatchWholeWord"];
    //GEAR
    [self saveSettings];
    //END
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //[self.view sizeToFit];
    [self.parentViewController.view sizeToFit];
    [self.partitationTableViewCell sizeToFit];
    
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (BOOL)isPortrait
{
    return ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait ||
            [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown);
}

//GEAR
- (void)saveSettings
{
    [userDefaults synchronize];
}

-(void)performWillRotateOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect rect =[[UIScreen mainScreen]bounds];
    if ([self isPortrait])
    {
        if (rect.size.height < rect.size.width) {
            
            float height = rect.size.height;
            rect.size.height = rect.size.width;
            rect.size.width = height;
        }
    }
    else
    {
        if (rect.size.height > rect.size.width) {
            
            float height = rect.size.height;
            rect.size.height = rect.size.width;
            rect.size.width = height;
        }
    }
    
    [self.view setFrame:rect];
    [self.view sizeThatFits:rect.size];
    
}

@end
