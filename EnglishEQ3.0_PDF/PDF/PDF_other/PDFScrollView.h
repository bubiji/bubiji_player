//
//  PDFScrollView.h
//  PDFViewer
//
//  Created by radaee on 13-3-3.
//
//

#import <UIKit/UIKit.h>
#import "PDFIOS.h"

@interface PDFScrollPage : UIView
{
    int m_pageno;
    PDF_PAGE m_page;
    PDF_DOC m_doc;
    float m_scale;
    struct PDF_CACHE
    {
        float m_ratio;
        PDF_DIB m_dib;
        CGImageRef m_img;
        int m_op;
    }*m_cache;
}
-(void)pSetPage:(PDF_DOC)doc:(int)pageno;
-(void)pRender:(float)ratio:(dispatch_queue_t)backing;
-(void)pClear;
@end

@protocol PDFDelegate <NSObject>
- (void)OnPageChanged:(int)pageno;
@end

@interface PDFScrollView : UIScrollView
{
    PDF_DOC m_doc;
    float m_ratio;
    float m_ratio_min;
    float m_ratio_max;
    float m_max_page_w;
    int m_page_gap;
    dispatch_queue_t m_backing;
    dispatch_semaphore_t m_event;
    NSMutableArray *m_pages;
    id<PDFDelegate> m_delegate;
}

-(void)vOpen:(PDF_DOC)doc;
-(void)vOpenPage:(PDF_DOC)doc:(int)pageno:(float)x:(float)y;
-(void)vGoto:(int)pageno;
-(void)vLayout;
-(void)vSetDelegate:(id<PDFDelegate>)delegate;

-(void)vClose;
//invoke this method to set select mode, once you set this mode, you can select texts by touch and moving.
-(void)vSelStart;
//you should invoke this method in select mode.
-(NSString *)vSelGetText;
//you should invoke this method in select mode.
-(BOOL)vSelMarkup:(int)color :(int)type;
//invoke this method to leave select mode
-(void)vSelEnd;

//invoke this method to set ink mode, once you set this mode, you can draw ink by touch and moving.
-(bool)vInkStart;
-(void)vInkCancel;
//invoke this method to leave ink mode.
-(void)vInkEnd;

-(bool)vRectStart;
-(void)vRectCancel;
-(void)vRectEnd;

-(void)onSingleTap:(float)x :(float)y;
-(void)onLongPressed:(float)x :(float)y;
-(void)vLockSide:(bool)lock;
-(bool)vFindStart:(const char *)pat:(bool)match_case:(bool)whole_word;
-(void)vFind:(int)dir;
-(void)vFindEnd;

@end
