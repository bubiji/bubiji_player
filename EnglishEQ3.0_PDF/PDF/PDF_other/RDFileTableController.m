 //
//  RDFileTableController.m
//  PDFViewer
//
//  Created by Radaee on 12-10-29.
//  Copyright (c) 2012年 Radaee. All rights reserved.
//

#import "RDFileTableController.h"
#define testUrlPath @"http://www.radaee.com/files/test.pdf"

@interface RDFileTableController ()

@end

//Open pdf file from filestream
@implementation PDFFileStream

-(void)open :(NSString *)filePath
{
    //fileHandle = [NSFileHandle fileHandleForReadingAtPath:testfile];
    const char *path = [filePath UTF8String];
    if((m_file = fopen(path, "rb+"))){
        m_writable = true;
    }
    else {
        m_file = fopen(path,"rb");
        m_writable = false;
    }
}
-(bool)writeable
{
    return m_writable;
}
-(void)close :(NSString *)filePath
{
    if( m_file )
        fclose(m_file);
    m_file = NULL;
}
-(int)read: (void *)buf : (int)len
{
    if( !m_file ) return 0;
    int read = (int)fread(buf, 1, len,m_file);
    return read;
}
-(int)write:(const void *)buf :(int)len
{
    if( !m_file ) return 0;
    return (int)fwrite(buf, 1, len, m_file);
}

-(unsigned long long)position
{
    if( !m_file ) return 0;
    int pos = (int)ftell(m_file);
    return pos;
}

-(unsigned long long)length
{
    if( !m_file ) return 0;
    int pos = (int)ftell(m_file);
    fseek(m_file, 0, SEEK_END);
    int filesize = (int)ftell(m_file);
    fseek(m_file, pos, SEEK_SET);
    return filesize;
}

-(bool)seek:(unsigned long long)pos
{
    if( !m_file ) return false;
    fseek(m_file, pos , SEEK_SET);
    return true;
}
@end


@implementation RDFileTableController

NSMutableString *pdfName;
NSMutableString *pdfPath;
NSString *pdfFullPath;
extern NSUserDefaults *userDefaults;
extern NSString *text;

extern int g_PDF_ViewMode;
extern float g_Ink_Width;
extern float g_swipe_speed;
extern float g_swipe_distance;
extern int g_render_quality;
extern bool g_DarkMode;
extern bool  g_CaseSensitive;
extern bool g_MatchWholeWord;
extern bool g_sel_right;
extern bool g_ScreenAwake;
extern int g_render_quality;
extern NSUserDefaults *userDefaults;

extern uint g_ink_color;
extern uint g_rect_color;
extern uint g_ellipse_color;
extern uint g_oval_color;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
    }
    return self;
}
#pragma mark -addFiles
- (void)addPDFs:(NSString *)dpath :(NSString *)subdir :(NSFileManager *)fm :(int)level
{
    NSString *path = [dpath stringByAppendingFormat:@"/%@", subdir];
    NSDirectoryEnumerator *fenum = [fm enumeratorAtPath:path];
    NSString *fName;
    while(fName = [fenum nextObject])
    {
        BOOL dir;
        NSString *dst = [path stringByAppendingFormat:@"%@",fName];
        pdfPath = (NSMutableString *)path;
        if( [fm fileExistsAtPath:dst isDirectory:&dir] )
        {
            if( dir )
            {
                [self addPDFs:dpath :dst :fm :level+1];
            }
            else if( [dst hasSuffix:@".pdf"] )
            {
                NSString *dis = [subdir stringByAppendingFormat:@"%@",fName];//display name
                
                //add to list
                NSArray *arr = [[NSArray alloc] initWithObjects:dis,dst,level, nil];
                [m_files addObject:arr];
            }
        }
    }
}

- (void)delPDFs:(NSString *)dpath :(NSString *)subdir :(NSFileManager *)fm :(int)level
{
    NSString *path = [dpath stringByAppendingFormat:@"/%@", subdir];
    NSDirectoryEnumerator *fenum = [fm enumeratorAtPath:path];
    NSString *fName;
    while(fName = [fenum nextObject])
    {
        BOOL dir;
        NSString *dst = [path stringByAppendingFormat:@"/%@",fName];
        if( [fm fileExistsAtPath:dst isDirectory:&dir] )
        {
            if( dir )
            {
                [self addPDFs:dpath :dst :fm :level+1];
            }
            else if( [dst hasSuffix:@".pdf"] )
            {
                NSString *dis = [subdir stringByAppendingFormat:@"%@",fName];//display name
               
                NSArray *arr = [[NSArray alloc] initWithObjects:dis,dst,level, nil];
                
                [m_files addObject:arr];
            }
        }
    }
}

-(BOOL)isFileInDocument:(NSString*)url

{
    
    NSString *filename =[url substringWithRange:NSMakeRange(url.length-34,34)];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths        objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return  [fileManager fileExistsAtPath:filepath];
}

-(BOOL)isFileInBundle:(NSString*)filename
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"mp3"];
    if(path==NULL)
    {
        return NO;
    }
    
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0)
    {
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dpath=[paths objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    m_files = [[NSMutableArray alloc] init];
    [self addPDFs:dpath :@"" :fm :0];
    
    NSString *Emotional_Mastery_2_Main_Text = [[NSBundle mainBundle]pathForResource:@"Emotional Mastery 2 Main Text" ofType:@"pdf" inDirectory:@"fdat"];
    NSString *Emotional_Mastery_Main_Text = [[NSBundle mainBundle]pathForResource:@"Emotional Mastery Main Text" ofType:@"pdf" inDirectory:@"fdat"];
    NSString *Identity_Main_Text = [[NSBundle mainBundle]pathForResource:@"Identity Main Text" ofType:@"pdf" inDirectory:@"fdat"];
    NSString *Intro_Main_Text = [[NSBundle mainBundle]pathForResource:@"Intro Main Text" ofType:@"pdf" inDirectory:@"fdat"];
    NSString *Kaizen_Main_Text = [[NSBundle mainBundle]pathForResource:@"Kaizen Main Text" ofType:@"pdf" inDirectory:@"fdat"];
    NSString *Thought_Mastery_Main_Text = [[NSBundle mainBundle]pathForResource:@"Thought Mastery Main Text" ofType:@"pdf" inDirectory:@"fdat"];
    NSString *Beliefs_Main_Text = [[NSBundle mainBundle]pathForResource:@"Beliefs Main Text" ofType:@"pdf" inDirectory:@"fdat"];

    NSString *Repetition_Main_Text = [[NSBundle mainBundle]pathForResource:@"Repetition Main Text" ofType:@"pdf" inDirectory:@"fdat"];
    NSString *Models_Main_Text = [[NSBundle mainBundle]pathForResource:@"Models Main Text" ofType:@"pdf" inDirectory:@"fdat"];


    //
//    NSString *hf = [[NSBundle mainBundle]pathForResource:@"help" ofType:@"pdf" inDirectory:@"fdat"];
//    NSString *hf = [[NSBundle mainBundle]pathForResource:@"help" ofType:@"pdf" inDirectory:@"fdat"];
    NSMutableArray * filenamelist =[[NSMutableArray alloc]init];
    [filenamelist addObject:Intro_Main_Text];
    [filenamelist addObject:Emotional_Mastery_Main_Text];

    [filenamelist addObject:Emotional_Mastery_2_Main_Text];

    [filenamelist addObject:Beliefs_Main_Text];
    [filenamelist addObject:Thought_Mastery_Main_Text];

    [filenamelist addObject:Models_Main_Text];

    [filenamelist addObject:Repetition_Main_Text];
    
    [filenamelist addObject:Kaizen_Main_Text];

    [filenamelist addObject:Identity_Main_Text];

    userDefaults = [NSUserDefaults standardUserDefaults];
    
//    [Identity_Main_Text rangeOfString:@"fdat"];
//    NSUInteger  pathlength = Identity_Main_Text.length- (range.location+range.length+1) ;
//    NSString *helpfile = [Identity_Main_Text substringFromIndex:Identity_Main_Text.length -26];


        for (NSString* path in filenamelist) {
          NSRange range =  [path rangeOfString:@"fdat"];
            NSUInteger  pathlength = path.length- (range.location+range.length+1)  ;

            NSString *helpfile = [path substringFromIndex:path.length -pathlength];
            if([self isFileInBundle:helpfile])
            {
                continue;
            }
            NSString *documentPath = [dpath stringByAppendingString: [NSString stringWithFormat:@"/%@",helpfile]];
            
            [[NSFileManager defaultManager] copyItemAtPath:path toPath:documentPath error:nil];
            [m_files addObject:[NSArray arrayWithObjects:helpfile,documentPath,0,nil]];

        }
        //[m_files addObject:[NSArray arrayWithObjects:helpfile, hf, 0, nil]];
      
    bool b_helpfile = [userDefaults boolForKey:@"helpfileLoaded"];
    if (!b_helpfile)
    {

        [userDefaults  setBool:true forKey:@"helpfileLoaded"];
        [userDefaults setBool:FALSE forKey:@"CaseSensitive"];
        g_CaseSensitive = FALSE;
        
        [userDefaults setBool:FALSE forKey:@"MatchWholeWord"];
        g_MatchWholeWord = FALSE;
        
        [userDefaults setFloat:0.1f forKey:@"SwipeSpeed"];
        g_swipe_speed = 0.15f;
        
        
        [userDefaults setInteger:1 forKey:@"RenderQuality"];
        g_render_quality =1;
      
        g_swipe_distance = 1.0f;
        [userDefaults setFloat:g_swipe_distance forKey:@"SwipeDistance"];
        
        [userDefaults setInteger:0 forKey:@"ViewMode"];
        g_def_view =0;
        
        [userDefaults  setBool:FALSE forKey:@"SelectTextRight"];
        g_sel_right = FALSE;
        
        [userDefaults  setBool:FALSE forKey:@"KeepScreenAwake"];
        g_ScreenAwake = FALSE;
        [[UIApplication sharedApplication] setIdleTimerDisabled:g_ScreenAwake];
        
        [userDefaults  setInteger:0xFF000000 forKey:@"InkColor"];
        g_ink_color = 0xFF000000;
        [userDefaults  setInteger:0xFF000000 forKey:@"RectColor"];
        g_rect_color = 0xFF000000;
        [userDefaults  setInteger:0xFF000000 forKey:@"OvalColor"];
        g_oval_color = 0xFF000000;
        g_Ink_Width = 2.0f;
        g_ellipse_color = 0xFF0000FF;
        [userDefaults synchronize];
        
    }

    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"All Files", @"Localizable")];
    self.title = title;
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:@"view_page.png"] tag:0];
   
    self.tabBarItem =item;
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"返回"
                                    style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(backAction)];
    
    
   //test demo for PDFMemOpen or PDFStreamOpen or HTTPPDFStream，click right button
   //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(selectRightAction)];
   //self.navigationItem.rightBarButtonItem = rightButton;
    
    
}
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{}];

}
-(void)selectRightAction
{
    NSLog(@"click right");
    if( m_pdf == nil )
    {
        m_pdf = [[RDPDFViewController alloc] initWithNibName:@"RDPDFViewController" bundle:nil];
    }
    
    NSString *testfile1 = [[NSTemporaryDirectory() stringByAppendingString:@""] stringByAppendingString:@"test1.pdf"];
    NSString *testfile2 = [[NSTemporaryDirectory() stringByAppendingString:@""] stringByAppendingString:@"test2.pdf"];
    NSString *cacheFile = [[NSTemporaryDirectory() stringByAppendingString:@""] stringByAppendingString:@"cache.dat"];
    
    PDFDoc *doc_dst = [[PDFDoc alloc] init];
    PDFDoc *doc_src = [[PDFDoc alloc] init];
    
    [doc_dst open:testfile1 :nil];
    [doc_dst setCache:cacheFile];
    [doc_src open:testfile2 :nil];
    
    PDFImportCtx *ctx = [doc_dst newImportCtx:doc_src];
    int dstno = [doc_dst pageCount];
    int srccount= [doc_src pageCount];
    int srcno = 0;
    while (srcno <srccount) {
        [ctx import :srcno :dstno];
        dstno++;
        srcno++;
    }
    [ctx importEnd];
    [doc_dst save];
    
    
    NSString *testfile = [[NSTemporaryDirectory() stringByAppendingString:@""] stringByAppendingString:@"aaaa.pdf"];
    //NSFileManager *fm = [NSFileManager defaultManager];
    //NSDictionary *attr =[fm fileAttributesAtPath:testfile1 traverseLink: NO] ; //文件属性
    //NSLog(@"file size is：%i bytes ",[[attr objectForKey:NSFileSize] intValue]);
    //NSData *data =[fm contentsAtPath:testfile1];//文件内容
    
    /*
    //Open PDF from Mem demo
    char *path1 = [testfile1 UTF8String];
    FILE *file1 = fopen(path1, "rb");
    fseek(file1, 0, SEEK_END);
    int filesize1 = ftell(file1);
    fseek(file1, 0, SEEK_SET);
    buffer = malloc((filesize1)*sizeof(char));
    fread(buffer, filesize1, 1, file1);
    fclose(file1);
    [m_pdf PDFopenMem: buffer :filesize1+filesize2 :nil];
    */
    
    
    //Open PDF from FileStream demo
     //stream = [[PDFFileStream alloc] init];
    
    
    //Open PDF HTTPStream demo
    //@testUrlPath: the http pdf path you requested,this url needs support [NSURLRequest forHTTPHeaderField:@"Range"] method
    //@testfile : You need set a temp path in sandbox to save the request file
     httpStream = [[PDFHttpStream alloc] init];
     [httpStream open:testUrlPath :testfile];
     [m_pdf PDFOpenStream:httpStream :@""];
    
    
    UINavigationController *nav = self.navigationController;
    m_pdf.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:m_pdf animated:YES];
   
    //use PDFopenMem ,here need release memory
    //free(buffer);
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"FileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *label = nil;
    //get  ios version
    if([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0)
    {
        //above ios7
        if( cell == nil )
        {
            CGRect rc = self.view.frame;
            CGRect rect = CGRectMake(0, 0, rc.size.width, 25);
            
            cell = [[UITableViewCell alloc] initWithFrame:rect];
            rect.origin.x += 70;
            rect.origin.y += 15;
            rect.size.width -= 4;
            rect.size.height -= 4;
            label = [[UILabel alloc] initWithFrame:rect];
            label.tag = 1;
            label.font = [UIFont systemFontOfSize:rect.size.height - 4];
            [cell.contentView addSubview:label];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if( label == nil )
            label = (UILabel *)[cell.contentView viewWithTag:1];
        
        NSUInteger row = [indexPath row];
        NSArray *arr = [m_files objectAtIndex:row];
        cell.textLabel.numberOfLines = 0;
        UIImage *image = [UIImage imageNamed:@"encrypt.png"];
        cell.imageView.image = image;
        label.text = [arr objectAtIndex:0];
        return cell;
    }
    else
    {
        if( cell == nil )
        {
            CGRect rc = self.view.frame;
            CGRect rect = CGRectMake(0, 0, rc.size.width, 25);
            
            cell = [[UITableViewCell alloc] initWithFrame:rect];
            rect.origin.x += 60;
            rect.origin.y += 15;
            rect.size.width -= 4;
            rect.size.height -= 4;
            label = [[UILabel alloc] initWithFrame:rect];
            label.tag = 1;
            label.font = [UIFont systemFontOfSize:rect.size.height - 4];
            [cell.contentView addSubview:label];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if( label == nil )
            label = (UILabel *)[cell.contentView viewWithTag:1];
        
        NSUInteger row = [indexPath row];
        NSArray *arr = [m_files objectAtIndex:row];
        cell.textLabel.numberOfLines = 0;
        UIImage *image = [UIImage imageNamed:@"encrypt.png"];
        cell.imageView.image = image;
        label.text = [arr objectAtIndex:0];
        return cell;

    }

}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSUInteger row = [indexPath row];
    
    if( m_pdf == nil )
    {
        m_pdf = [[RDPDFViewController alloc] initWithNibName:@"RDPDFViewController" bundle:nil];
    }
    
    NSArray *row_item = [m_files objectAtIndex:indexPath.row];
    NSString *path = [row_item objectAtIndex:1];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:nil];
    [m_files removeObjectAtIndex:row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
  
    //GEAR
    [self loadSettingsWithDefaults];
    //END
    NSArray *row_item = [m_files objectAtIndex:indexPath.row];
    NSString *path = [row_item objectAtIndex:1];
    
    pdfName = (NSMutableString *)[path substringFromIndex:pdfPath.length];
    pdfFullPath = path;
    if(g_def_view!=5)
    {
        if( m_pdf == nil )
        {
            m_pdf = [[RDPDFViewController alloc] initWithNibName:@"RDPDFViewController" bundle:nil];
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

        NSLock *theLock = [[NSLock alloc] init];
        if ([theLock tryLock])
        {
            NSString *pwd = NULL;

            //Open PDF file
            int result = [m_pdf PDFOpen:pdfFullPath :pwd];
            if(result == 1)
            {
                UINavigationController *nav = self.navigationController;
                m_pdf.hidesBottomBarWhenPushed = YES;
                [nav pushViewController:m_pdf animated:YES];
                int pageno =1;
                // [m_pdf initbar:pageno];
                [m_pdf PDFThumbNailinit:pageno];
            }
            //return value is encryption document
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
            [theLock unlock];
        }
    }
    else{
        m_pdfR = [[RDPDFReflowViewController alloc] initWithNibName:@"RDPDFReflowViewController" bundle:nil];
        [m_pdfR PDFOpen:pdfFullPath];
        
        UINavigationController *nav = self.navigationController;
        
        m_pdfR.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:m_pdfR animated:YES];
    }
}
- (void)alertView:(UIAlertView *)pwdDlg clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int result;
    NSString *pwd;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        UITextField *tf = [pwdDlg textFieldAtIndex:0];
        pwd = tf.text;
    }
    else{
        pwd = text;
    }
    if(buttonIndex == 0)
    {
        result = [m_pdf PDFOpen:pdfFullPath :pwd];
        if(result == 1)
        {
            UINavigationController *nav = self.navigationController;
            m_pdf.hidesBottomBarWhenPushed = YES;
            nav.hidesBottomBarWhenPushed =NO;
            [nav pushViewController:m_pdf animated:YES];
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
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
}

//GEAR
- (void)loadSettingsWithDefaults
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    g_CaseSensitive = [userDefaults boolForKey:@"CaseSensitive"];
    g_MatchWholeWord = [userDefaults boolForKey:@"MatchWholeWord"];
    
    g_ScreenAwake = [userDefaults boolForKey:@"KeepScreenAwake"];
    [[UIApplication sharedApplication] setIdleTimerDisabled:g_ScreenAwake];
    
    g_MatchWholeWord = [userDefaults floatForKey:@"MatchWholeWord"];
    g_CaseSensitive = [userDefaults floatForKey:@"CaseSensitive"];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    g_render_quality = (int)[userDefaults integerForKey:@"RenderQuality"];
    if(g_render_quality == 0)
    {
        g_render_quality =1;
    }
    renderQuality = g_render_quality;
    
    g_def_view =  (int)[userDefaults integerForKey:@"ViewMode"];
    g_ink_color = (int)[userDefaults integerForKey:@"InkColor"];
    if(g_ink_color ==0)
    {
        g_ink_color =0xFF0000FF;
    }

    g_Ink_Width = 2.0f;
    g_rect_color = (int)[userDefaults integerForKey:@"RectColor"];
    if(g_rect_color==0)
    {
        g_rect_color =0xFF0000FF;
    }
    
    annotUnderlineColor = (int)[userDefaults integerForKey:@"UnderlineColor"];
    if (annotUnderlineColor == 0) {
        annotUnderlineColor = 0xFF0000FF;
    }
    annotStrikeoutColor = (int)[userDefaults integerForKey:@"StrikeoutColor"];
    if (annotStrikeoutColor == 0) {
        annotStrikeoutColor = 0xFFFF0000;
    }
    annotHighlightColor = (int)[userDefaults integerForKey:@"HighlightColor"];
    if(annotHighlightColor ==0)
    {
        annotHighlightColor =0xFFFFFF00;
    }
    g_oval_color = (int)[userDefaults integerForKey:@"OvalColor"];
    if(g_oval_color ==0)
    {
        g_oval_color =0xFFFFFF00;
    }
    
}
- (BOOL)isPortrait
{
    return ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait ||
            [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown);
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NSThread detachNewThreadSelector:@selector(updateImageForCellAtIndexPath:) toTarget:self withObject:indexPath];
}
- (void)updateImageForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *row_item = [m_files objectAtIndex:indexPath.row];
    NSString *path = [row_item objectAtIndex:1];
    
    NSLock *theLock = [[NSLock alloc] init];
    if ([theLock tryLock])
    {
        const char *cpath = [path UTF8String];
        PDF_ERR err;
        PDF_DOC m_docThumb = Document_open(cpath,nil, &err);
        int result = 1;
        if( m_docThumb == NULL )
        {
            switch( err )
            {
                case err_password:
                    result = 2;
                    break;
                default: result = 0;
            }
        }
      
        PDF_PAGE page = Document_getPage(m_docThumb, 0);
        float w = Document_getPageWidth(m_docThumb,0);
        float h = Document_getPageHeight(m_docThumb,0);
        PDF_DIB m_dib = NULL;
        int iw = 89;
        int ih = 111;
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
        {
            ih = 105;
            iw = 80;
        }
        PDF_DIB bmp = Global_dibGet(m_dib, iw, ih);
        float ratiox = iw/w;
        float ratioy = ih/h;
        if( ratiox > ratioy ) ratiox = ratioy;
        PDF_MATRIX mat = Matrix_createScale(ratiox, -ratiox, 0, h * ratioy);
        Page_renderPrepare( page, bmp );
        Page_render(page, bmp, mat,false,1);
        Matrix_destroy(mat);
        Page_close(page);        
    
        if(m_docThumb)
        {
             Document_close(m_docThumb);
        }
         
        void *data = Global_dibGetData(bmp);
        CGDataProviderRef provider = CGDataProviderCreateWithData( NULL, data, iw * ih * 4, NULL );
        CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
        m_img = CGImageCreate( iw, ih, 8, 32, iw<<2, cs, kCGBitmapByteOrder32Little|kCGImageAlphaNoneSkipFirst, provider, NULL, FALSE, kCGRenderingIntentDefault );
        CGColorSpaceRelease(cs);
        CGDataProviderRelease( provider );
       
        [theLock unlock];
    }
     
    UIImage *img= [UIImage imageWithCGImage:m_img];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.imageView performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:NO];
 }

@end
