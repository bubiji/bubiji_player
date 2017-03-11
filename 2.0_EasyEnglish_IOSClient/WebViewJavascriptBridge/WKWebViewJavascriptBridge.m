//
//  WKWebViewJavascriptBridge.m
//
//  Created by @LokiMeyburg on 10/15/14.
//  Copyright (c) 2014 @LokiMeyburg. All rights reserved.
//


#import "WKWebViewJavascriptBridge.h"
#import "Music.h"
#if defined(supportsWKWebKit)

@implementation WKWebViewJavascriptBridge {
    WKWebView* _webView;
    id<WKNavigationDelegate> _webViewDelegate;
    long _uniqueId;
    WebViewJavascriptBridgeBase *_base;
}

/* API
 *****/

+ (void)enableLogging { [WebViewJavascriptBridgeBase enableLogging]; }

+ (instancetype)bridgeForWebView:(WKWebView*)webView {
    WKWebViewJavascriptBridge* bridge = [[self alloc] init];
    [bridge _setupInstance:webView];
    [bridge reset];
    return bridge;
}

- (void)send:(id)data {
    [self send:data responseCallback:nil];
}

- (void)send:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    [_base sendData:data responseCallback:responseCallback handlerName:nil];
}

- (void)callHandler:(NSString *)handlerName {
    [self callHandler:handlerName data:nil responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data {
    [self callHandler:handlerName data:data responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    [_base sendData:data responseCallback:responseCallback handlerName:handlerName];
}

- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler {
    _base.messageHandlers[handlerName] = [handler copy];
}

- (void)reset {
    [_base reset];
}

- (void)setWebViewDelegate:(id<WKNavigationDelegate>)webViewDelegate {
    _webViewDelegate = webViewDelegate;
}

/* Internals
 ***********/

- (void)dealloc {
    _base = nil;
    _webView = nil;
    _webViewDelegate = nil;
    _webView.navigationDelegate = nil;
}


/* WKWebView Specific Internals
 ******************************/

- (void) _setupInstance:(WKWebView*)webView {
    _webView = webView;
    _webView.navigationDelegate = self;
    _base = [[WebViewJavascriptBridgeBase alloc] init];
    _base.delegate = self;
}


- (void)WKFlushMessageQueue {
    [_webView evaluateJavaScript:[_base webViewJavascriptFetchQueyCommand] completionHandler:^(NSString* result, NSError* error) {
        if (error != nil) {
            NSLog(@"WebViewJavascriptBridge: WARNING: Error when trying to fetch data from WKWebView: %@", error);
        }
        [_base flushMessageQueue:result];
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (webView != _webView) { return; }
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [strongDelegate webView:webView didFinishNavigation:navigation];
    }
}


- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (webView != _webView) { return; }
    NSURL *url = navigationAction.request.URL;
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;

    if ([_base isCorrectProcotocolScheme:url]) {
        if ([_base isBridgeLoadedURL:url]) {
            [_base injectJavascriptFile];
        } else if ([_base isQueueMessageURL:url]) {
            [self WKFlushMessageQueue];
        } else {
            [_base logUnkownMessage:url];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [_webViewDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (webView != _webView) { return; }
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [strongDelegate webView:webView didStartProvisionalNavigation:navigation];
    }
}


- (void)webView:(WKWebView *)webView
didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if (webView != _webView) { return; }
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [strongDelegate webView:webView didFailNavigation:navigation withError:error];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (webView != _webView) { return; }
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [strongDelegate webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
}

- (NSString*) _evaluateJavascript:(NSString*)javascriptCommand
{
    [_webView evaluateJavaScript:javascriptCommand completionHandler:nil];
    return NULL;
}




-(void)corp3LessonToLibrary
{
    // Get the path to the main bundle resource directory.
    
    NSString *pathsToReources = [[NSBundle mainBundle] resourcePath];//本地文件
    //NSLog(@"pathsToReources-- %@",pathsToReources);
    NSString *yourOriginalDatabasePath0 = [pathsToReources stringByAppendingPathComponent:@"1_Intro_MAIN.mp3"];
    NSString *yourOriginalDatabasePath1 = [pathsToReources stringByAppendingPathComponent:@"2_Intro_VOCAB.mp3"];
    NSString *yourOriginalDatabasePath2 = [pathsToReources stringByAppendingPathComponent:@"3_Intro_MINI_STORY.mp3"];
    // NSLog(@"yourOriginalDatabasePath-- %@",yourOriginalDatabasePath);
    
    // Create the path to the database in the Documents directory.
    
    NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
    //NSLog(@"documentsDirectory1-- %@",documentsDirectory);
    NSString *yourNewDatabasePath0 = [documentsDirectory stringByAppendingPathComponent:@"1_Intro_MAIN.mp3"];
    NSString *yourNewDatabasePath1 = [documentsDirectory stringByAppendingPathComponent:@"2_Intro_VOCAB.mp3"];
    NSString *yourNewDatabasePath2 = [documentsDirectory stringByAppendingPathComponent:@"3_Intro_MINI_STORY.mp3"];
    
    
    if (![[NSFileManager defaultManager] isReadableFileAtPath:yourNewDatabasePath0]) {
        
        if ([[NSFileManager defaultManager] copyItemAtPath:yourOriginalDatabasePath0 toPath:yourNewDatabasePath0 error:NULL] != YES)
            
            NSAssert2(0, @"Fail to copy database from %@ to %@", yourOriginalDatabasePath0, yourNewDatabasePath0);
        
    }
    if (![[NSFileManager defaultManager] isReadableFileAtPath:yourNewDatabasePath1]) {
        
        if ([[NSFileManager defaultManager] copyItemAtPath:yourOriginalDatabasePath1 toPath:yourNewDatabasePath1 error:NULL] != YES)
            
            NSAssert2(0, @"Fail to copy database from %@ to %@", yourOriginalDatabasePath1, yourNewDatabasePath1);
        
    }
    if (![[NSFileManager defaultManager] isReadableFileAtPath:yourNewDatabasePath2]) {
        
        if ([[NSFileManager defaultManager] copyItemAtPath:yourOriginalDatabasePath2 toPath:yourNewDatabasePath2 error:NULL] != YES)
            
            NSAssert2(0, @"Fail to copy database from %@ to %@", yourOriginalDatabasePath2, yourNewDatabasePath2);
        
    }
    
    
}

#pragma mark -
#pragma mark 把document 文件写入数据库
-(BOOL)checkFileAndDocument:(Music*)m //检查存在 并写入 路径
{
    //AppDelegate *appDelegate=[self getAppDelegate];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    //    NSLog(@"a")
    NSError *error = nil;
    //NSArray *fileList = [[[NSArray alloc] init]autorelease];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    
    //以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    //NSMutableArray *dirArray = [[[NSMutableArray alloc] init]autorelease];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *path = [documentDir stringByAppendingPathComponent:file];
        //NSLog(@"file path%@",path);
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) { //并且判断 他是否包含text 包含就不读取
            // [dirArray addObject:file];
            //只要是文件 就进去读他的所有文件
            //NSLog(@"file path :%@",path);
            for (NSString *filename in [fileManager enumeratorAtPath:path]) {
                
                if ([[filename pathExtension]isEqual: m.title]) {
                    
                    NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    
                    NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
                    NSString *yourLessonPath = [documentsDirectory stringByAppendingPathComponent:m.title];
                    // NSLog(@"path %@",yourLessonPath);
                    m.path=[NSURL fileURLWithPath:yourLessonPath];
                    return YES;
                }
                
            }
            
            
        }
        isDir = NO;
    }
    
    return NO;
}


@end


#endif
