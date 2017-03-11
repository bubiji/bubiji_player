//
//  PDFScrollView.m
//  PDFViewer
//
//  Created by radaee on 13-3-3.
//
//

#import "PDFScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "mach/mach.h"

@implementation PDFScrollPage
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_pageno = -1;
        m_page = NULL;
        m_doc = NULL;
        m_cache = NULL;
        m_scale = [[UIScreen mainScreen] scale];
    }
    return self;
}

-(void)pSetPage:(PDF_DOC)doc:(int)pageno
{
    self.backgroundColor = [[UIColor alloc] initWithWhite:1 alpha:1];
    m_doc = doc;
    m_page = Document_getPage(doc, pageno);
    m_pageno = pageno;
    self.layer.opacity = 1;
}

-(void)pRender:(float)ratio:(dispatch_queue_t)backing
{
    if( !m_cache )//new render operation in backing dispatch
    {
        int w = Document_getPageWidth(m_doc, m_pageno) * m_scale * ratio;
        int h = Document_getPageHeight(m_doc, m_pageno) * m_scale * ratio;
        m_cache = (struct PDF_CACHE *)malloc(sizeof(struct PDF_CACHE));
        struct PDF_CACHE *cache = m_cache;
        cache->m_ratio = ratio;
        cache->m_img = NULL;
        cache->m_op = 1;

        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(backing, ^
        {
            cache->m_dib = Global_dibGet(NULL, w, h);
            Page_renderPrepare(m_page, cache->m_dib);
            PDF_MATRIX mat = Matrix_createScale(m_scale * ratio, -m_scale * ratio, 0, h);
            Page_render(m_page, cache->m_dib, mat, true, 1);
            Matrix_destroy(mat);
            void *data = Global_dibGetData(cache->m_dib);
            int w = Global_dibGetWidth(cache->m_dib);
            int h = Global_dibGetHeight(cache->m_dib);
            CGDataProviderRef provider = CGDataProviderCreateWithData( NULL, data, w * h * 4, NULL );
            CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
            cache->m_img = CGImageCreate( w, h, 8, 32, w<<2, cs, kCGBitmapByteOrder32Little|kCGImageAlphaNoneSkipFirst, provider, NULL, FALSE, kCGRenderingIntentDefault );
            CGColorSpaceRelease(cs);
            CGDataProviderRelease( provider );
            dispatch_async(mainQueue, ^
            {
                if( cache->m_op == 1 )//normal
                {
                    cache->m_op = 0;
                    self.layer.contents = (__bridge id)(cache->m_img);
                }
                else if( cache->m_op == 2 )//cancel
                {
                    CGImageRelease(cache->m_img);
                    Global_dibFree(cache->m_dib);
                    free( cache );
                    Page_close( m_page );//free cache in page object.
                    m_page = Document_getPage(m_doc, m_pageno);//get a page object without cache
                }
                else//canceled and free cache
                {
                    CGImageRelease(cache->m_img);
                    Global_dibFree(cache->m_dib);
                    free( cache );
                }
            });
        });
    }
    else//re-render
    {
        if( m_cache->m_op == 0 )//render finished?
        {
            if( m_cache->m_ratio == ratio ) return;
            self.layer.contents = nil;
            CGImageRelease(m_cache->m_img);
            Global_dibFree(m_cache->m_dib);
            free( m_cache );
        }
        else//cancel and free cache in next route
        {
            if( m_cache->m_op == 1 && m_cache->m_ratio == ratio ) return;
            self.layer.contents = nil;
            m_cache->m_op = 0;
            Page_renderCancel(m_page);
        }
        m_cache = NULL;
        [self pRender:ratio :backing];
    }
}

-(void)pClear
{
    self.layer.contents = nil;
    if( m_cache )
    {
        if( m_cache->m_op == 0 )//render finished?
        {
            CGImageRelease(m_cache->m_img);
            Global_dibFree(m_cache->m_dib);
            free( m_cache );
            Page_close( m_page );//free cache in page object.
            m_page = Document_getPage(m_doc, m_pageno);//get a page object without cache
        }
        else//cancel
        {
            m_cache->m_op = 2;
        }
        m_cache = NULL;
    }
}
@end

@implementation PDFScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_doc = NULL;
        m_ratio = 0;
        m_pages = NULL;
        m_page_gap = 4;
        m_max_page_w = 0;
        self.delegate = self;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self vLoadPages];
}

-(void)vLoadPages
{
    CGPoint pos = self.contentOffset;
    int page_no = 0;
    int page_cnt = Document_getPageCount(m_doc);
    while( page_no < page_cnt )
    {
        PDFScrollPage *pg = (PDFScrollPage *)m_pages[page_no];
        CGRect rect = pg.frame;
        int bot = rect.origin.y + rect.size.height + (m_page_gap + 1)/2;
        if( pos.y <= bot )
            break;
        page_no++;
    }
    if( page_no >= page_cnt ) return;
    int page_start = page_no - 1;
    
    int bottom = pos.y + self.bounds.size.height;
    while( page_no < page_cnt )
    {
        PDFScrollPage *pg = (PDFScrollPage *)m_pages[page_no];
        CGRect rect = pg.frame;
        int top = rect.origin.y - m_page_gap/2;
        if( bottom < top )
            break;
        page_no++;
    }
    if( page_no >= page_cnt ) return;
    int page_end = page_no + 1;
    
    if( page_start < 0 ) page_start = 0;
    if( page_end > page_cnt ) page_end = page_cnt;
    page_no = 0;
    while( page_no < page_start )
    {
        PDFScrollPage *pg = (PDFScrollPage *)m_pages[page_no];
        [pg pClear];
        page_no++;
    }
    while( page_no < page_end )
    {
        PDFScrollPage *pg = (PDFScrollPage *)m_pages[page_no];
        [pg pRender:m_ratio :m_backing];
        page_no++;
    }
    while( page_no < page_cnt )
    {
        PDFScrollPage *pg = (PDFScrollPage *)m_pages[page_no];
        [pg pClear];
        page_no++;
    }
}

-(void)vLayout
{
    int page_cnt = Document_getPageCount(m_doc);
    int page = 0;
    int top = m_page_gap/2;
    int left = m_page_gap/2;
    int total_w = 0;
    int total_h = 0;
    if( !m_pages )//initialize
    {
        m_pages = [[NSMutableArray alloc] init];
        while( page < page_cnt )
        {
            int w = Document_getPageWidth(m_doc, page) * m_ratio;
            int h = Document_getPageHeight(m_doc, page) * m_ratio;
            if( total_w < w + m_page_gap ) total_w = w + m_page_gap;
            total_h += h + m_page_gap;
            PDFScrollPage *pg = [[PDFScrollPage alloc] initWithFrame:CGRectMake(left, top, w, h)];
            [pg pSetPage:m_doc :page];
            [m_pages addObject:pg];
            [self addSubview:pg];
            top += h + m_page_gap;
            page++;
        }
        self.contentSize = CGSizeMake(total_w, total_h);
        [self layoutSubviews];
    }
    else//zooming
    {
        while( page < page_cnt )
        {
            int w = Document_getPageWidth(m_doc, page) * m_ratio;
            int h = Document_getPageHeight(m_doc, page) * m_ratio;
            if( total_w < w + m_page_gap ) total_w = w + m_page_gap;
            total_h += h + m_page_gap;
            PDFScrollPage *pg = (PDFScrollPage *)[m_pages objectAtIndex:page];
            [pg pClear];
            pg.frame = CGRectMake(left, top, w, h);
            top += h + m_page_gap;
            page++;
        }
        self.contentSize = CGSizeMake(total_w, total_h);
        [self layoutSubviews];
    }
}

-(void)vOpen:(PDF_DOC)doc
{
    [self vClose];
    m_doc = doc;
    m_ratio = 0;
    m_backing = dispatch_queue_create("PDFRender", NULL);
    m_event = dispatch_semaphore_create(0);
    self.backgroundColor = [[UIColor alloc] initWithWhite:0.5 alpha:1];
    m_max_page_w = 0;
    int page = 0;
    int page_cnt = Document_getPageCount(m_doc);
    while( page < page_cnt )
    {
        int w = Document_getPageWidth(m_doc, page);
        if( m_max_page_w < w ) m_max_page_w = w;
        page++;
    }
    m_ratio_min = (self.bounds.size.width - m_page_gap)/m_max_page_w;
    m_ratio_max = m_ratio_min * 3;
    if( m_ratio < m_ratio_min ) m_ratio = m_ratio_min;
    if( m_ratio > m_ratio_max ) m_ratio = m_ratio_max;
    [self vLayout];
    [self vLoadPages];
}

-(void)vOpenPage:(PDF_DOC)doc:(int)pageno:(float)x:(float)y
{
    [self vOpen:doc];
}

-(void)vSetDelegate:(id<PDFDelegate>)delegate
{
    m_delegate = delegate;
}

-(void)vGoto:(int)pageno
{
}

-(void)vClose
{
    if( !m_doc ) return;
    m_doc = NULL;
    dispatch_async(m_backing, ^
    {
        dispatch_semaphore_signal(m_event);
    });
    dispatch_semaphore_wait(m_event, DISPATCH_TIME_FOREVER);
    //dispatch_release(m_event);
    m_backing = NULL;
}
//invoke this method to set select mode, once you set this mode, you can select texts by touch and moving.
-(void)vSelStart
{
    
}
//you should invoke this method in select mode.
-(NSString *)vSelGetText
{
    return @"";
}

//you should invoke this method in select mode.
-(BOOL)vSelMarkup:(int)color :(int)type
{
    return @"";

}
//invoke this method to leave select mode
-(void)vSelEnd
{
    
}

-(void)vGetPos:(struct PDFV_POS*)pos
{
    
}
//invoke this method to set ink mode, once you set this mode, you can draw ink by touch and moving.

-(bool)vInkStart
{
    return YES;

}
-(void)vInkCancel
{
    
}
//invoke this method to leave ink mode.
-(void)vInkEnd
{
    
}

-(bool)vRectStart
{
    return YES;

}
-(void)vRectCancel
{
    
}
-(void)vRectEnd
{
    
}

-(void)onSingleTap:(float)x :(float)y
{
    
}
-(void)onLongPressed:(float)x :(float)y
{
    
}
-(void)onSwipe:(float)dx :(float)dy
{
    
}
-(void)vLockSide:(bool)lock
{
    
}
-(bool)vFindStart:(const char *)pat:(bool)match_case:(bool)whole_word
{
    return YES;

}
-(void)vFind:(int)dir
{
    
}
-(void)vFindEnd
{
    
}

@end
