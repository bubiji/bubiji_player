//
//  BookMarkViewController.m
//  PDFViewer
//
//  Created by Radaee on 12-12-9.
//  Copyright (c) 2012年 Radaee. All rights reserved.
//

#import "BookMarkViewController.h"

@interface BookMarkViewController ()

@end

@implementation BookMarkViewController
extern NSString *text;
NSString *otherpdfFullPath;

int bookMarkNum =0;
extern NSMutableString *pdfName;
extern NSMutableString *pdfPath;
- (void)addBookMarks:(NSString *)dpath :(NSString *)subdir :(NSFileManager *)fm :(int)level
{
   
    NSDirectoryEnumerator *fenum = [fm enumeratorAtPath:dpath];
    NSString *fName;
    while(fName = [fenum nextObject])
    {

        NSString *dst = [dpath stringByAppendingFormat:@"/%@",fName];
        NSString *tempString ;
       
        if(fName.length >10)
        {
            tempString = [fName substringFromIndex:fName.length-9];
        }
  
        if( [tempString isEqualToString:@".bookmark"] )
        {
            //add to list.
            NSFileHandle *fileHandle =[NSFileHandle fileHandleForReadingAtPath:dst];
            NSString *content = [[NSString alloc]initWithData:[fileHandle availableData] encoding:NSUTF8StringEncoding];
            NSArray *myarray =[content componentsSeparatedByString:@","];
            [myarray objectAtIndex:0];
            NSArray *arr = [[NSArray alloc] initWithObjects:[myarray objectAtIndex:0],[myarray objectAtIndex:1],[myarray objectAtIndex:2],[myarray objectAtIndex:3],[myarray objectAtIndex:4],dst,nil];
            [m_files addObject:arr];
        }
        
    }
}

- (void)delBookMarks:(NSString *)dpath :(NSString *)subdir :(NSFileManager *)fm :(int)level
{
   
    NSDirectoryEnumerator *fenum = [fm enumeratorAtPath:dpath];
    NSString *fName;
    while(fName = [fenum nextObject])
    {
        BOOL dir;
        NSString *dst = [dpath stringByAppendingFormat:@"/%@",fName];
        if( [fm fileExistsAtPath:dst isDirectory:&dir] )
        {
            if( dir )
            {
                [self addBookMarks:dpath :dst :fm :level+1];
            }
            else if( [dst hasSuffix:@".bookmark"] )
            {
                NSString *dis = [subdir stringByAppendingFormat:@"/%@",fName];//display name
                
                NSArray *arr = [[NSArray alloc] initWithObjects:dis,dst,level, nil];
                
                [m_files addObject:arr];
            }
        }
    }
    
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *title =[[NSString alloc]initWithFormat:NSLocalizedString(@"Marks", @"Localizable")];
    // Do any additional setup after loading the view from its nib.
    self.title =title;
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:@"manage_mark.png"] tag:0];
    self.tabBarItem =item;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}
-(void)viewWlllDisAppear:(BOOL)animated
{
    [self viewDidUnload];
}
-(void)viewWillAppear:(BOOL)animated 
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *dpath=[paths objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    m_files = [[NSMutableArray alloc] init];
    [self addBookMarks:dpath :@"" :fm :0];

    [self.tableView reloadData];
}
- (void)viewDidUnload
{
   
    [self.view removeFromSuperview];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookMarkCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *label = nil;
    if( cell == nil )
    {
        CGRect rc = self.view.frame;
        CGRect rect = CGRectMake(0, 0, rc.size.width, 20);
        cell = [[UITableViewCell alloc] initWithFrame:rect];
        rect.origin.x += 10;
        rect.origin.y += 10;
        rect.size.width -= 4;
        rect.size.height -= 4;
        label = [[UILabel alloc] initWithFrame:rect];
        label.tag = 1;
        label.font = [UIFont systemFontOfSize:rect.size.height - 3];
        [cell.contentView addSubview:label];
    }
    NSUInteger row = [indexPath row];
    NSArray *arr = [m_files objectAtIndex:row];
    if( label == nil )
        label = (UILabel *)[cell.contentView viewWithTag:0];
    NSString *temp1 = [arr objectAtIndex:1];
    NSString *temp2 = [arr objectAtIndex:2];
    NSString *page = NSLocalizedString(@"Page ", @"Localizable");
    int pageno = [temp2 intValue];
    pageno++;
    temp2 = [NSString stringWithFormat:@"%d",pageno];
    NSString *temp3 = [page stringByAppendingFormat:@"%@",[temp2 stringByAppendingFormat:@","]];
    NSString *text =  [temp3 stringByAppendingFormat:@"%@",temp1];
    label.text = text;
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = [indexPath row];
    if( m_pdf1 == nil )
    {
        m_pdf1 = [[RDPDFViewController alloc] initWithNibName:@"RDPDFViewController" bundle:nil];
    }
    
    NSArray *row_item = [m_files objectAtIndex:indexPath.row];
    NSString *path = [row_item objectAtIndex:5];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:nil];
    /*
     NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *dpath=[paths objectAtIndex:0];
     */
    
    [m_files removeObjectAtIndex:row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }

 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( m_pdf1 == nil )
    {
        m_pdf1 = [[RDPDFViewController alloc] initWithNibName:@"RDPDFViewController" bundle:nil];
    }
    NSString *Enterpassword =[[NSString alloc]initWithFormat:NSLocalizedString(@"Please Enter PassWord", @"Localizable")];
    NSString *ok = [[NSString alloc]initWithFormat:NSLocalizedString(@"OK", @"Localizable")];
    NSString *cancel = [[NSString alloc]initWithFormat:NSLocalizedString(@"Cancel", @"Localizable")];
    RDUPassWord* pwdDlg = [[RDUPassWord alloc]
                           initWithTitle:Enterpassword
                           message:nil
                           delegate:self
                           cancelButtonTitle:ok
                           otherButtonTitles:cancel, nil];
    
    NSString *pwd = pwdDlg.uPwd.text;
    
    NSArray *row_item = [m_files objectAtIndex:indexPath.row];
    NSString *path = [row_item objectAtIndex:0];
    NSArray *arr = [m_files objectAtIndex:indexPath.row];
    pdfName = [NSMutableString stringWithFormat:@"%@.pdf", [arr objectAtIndex:1]];
    NSString *temp2=[arr objectAtIndex:2];
    int pageno = [temp2 intValue];
    otherpdfFullPath = path;
    int result = [m_pdf1 PDFOpen:path :pwd];
    
    if(result == 1)
    {  
        UINavigationController *nav = self.navigationController;
        m_pdf1.hidesBottomBarWhenPushed = YES;
        nav.hidesBottomBarWhenPushed =NO;
        [nav pushViewController:m_pdf1 animated:YES];
        //[m_pdf1 initbar:pageno];
        [m_pdf1 PDFThumbNailinit:pageno];
        [m_pdf1 PDFGoto:pageno];

    }
    //Return value is encrypted document
    else if(result == 2)
    {
        [pwdDlg show];
    }
    else if (result == 0)
    {
        NSString *str1=NSLocalizedString(@"Alert", @"Localizable");
        NSString *str2=NSLocalizedString(@"Error Document,Can't open", @"Localizable");
        NSString *str3=NSLocalizedString(@"OK", @"Localizable");
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:str1 message:str2 delegate:nil cancelButtonTitle:str3 otherButtonTitles:nil,nil];
        [alter show];
    }
     
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if( m_pdf1 == nil )
    {
        m_pdf1 = [[RDPDFViewController alloc] initWithNibName:@"RDPDFViewController" bundle:nil];
    }
    NSString *Enterpassword =[[NSString alloc]initWithFormat:NSLocalizedString(@"Please Enter PassWord", @"Localizable")];
    NSString *ok = [[NSString alloc]initWithFormat:NSLocalizedString(@"OK", @"Localizable")];
    NSString *cancel = [[NSString alloc]initWithFormat:NSLocalizedString(@"Cancel", @"Localizable")];
    RDUPassWord* pwdDlg = [[RDUPassWord alloc]
                           initWithTitle:Enterpassword
                           message:nil
                           delegate:self
                           cancelButtonTitle:ok
                           otherButtonTitles:cancel, nil];
    NSString *pwd = pwdDlg.uPwd.text;
    
    NSArray *row_item = [m_files objectAtIndex:indexPath.row];
    NSString *path = [row_item objectAtIndex:0];
    NSArray *arr = [m_files objectAtIndex:indexPath.row];
    pdfName = (NSMutableString *)[[arr objectAtIndex:1] stringByAppendingFormat:@".pdf"];
    NSString *temp2=[arr objectAtIndex:2];
    int pageno = [temp2 intValue];
    otherpdfFullPath = path;
    int result = [m_pdf1 PDFOpen:path :pwd];
    
    if(result == 1)
    {  
        UINavigationController *nav = self.navigationController;
        m_pdf1.hidesBottomBarWhenPushed = YES;
        nav.hidesBottomBarWhenPushed =NO;
        [nav pushViewController:m_pdf1 animated:YES];
        [m_pdf1 initbar:pageno];
    }
    //Return value is encrypted document
    else if(result == 2)
    {
        [pwdDlg show];
    }
    else if (result == 0)
    {
        NSString *str1=NSLocalizedString(@"Alert", @"Localizable");
        NSString *str2=NSLocalizedString(@"Error Document,Can't open", @"Localizable");
        NSString *str3=NSLocalizedString(@"OK", @"Localizable");
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:str1 message:str2 delegate:nil cancelButtonTitle:str3 otherButtonTitles:nil,nil];
        [alter show];
    }
    
}

- (void)alertView:(UIAlertView *)pwdDlg clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int result;
    if(buttonIndex == 0)
    {
        
        NSString *pwd = text;
        result = [m_pdf1 PDFOpen:otherpdfFullPath :pwd];
    }else{
        result = 0;
    }
    if(result == 1)
    {  
        UINavigationController *nav = self.navigationController;
        m_pdf1.hidesBottomBarWhenPushed = YES;
        nav.hidesBottomBarWhenPushed =NO;
        [nav pushViewController:m_pdf1 animated:YES];
    }
    else if(result == 2)
    {
        NSString *str1=NSLocalizedString(@"Alert", @"Localizable");
        NSString *str2=NSLocalizedString(@"Error PassWord", @"Localizable");
        NSString *str3=NSLocalizedString(@"OK", @"Localizable");
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:str1 message:str2 delegate:nil cancelButtonTitle:str3 otherButtonTitles:nil,nil];
        [alter show];
        
    }
}
@end
