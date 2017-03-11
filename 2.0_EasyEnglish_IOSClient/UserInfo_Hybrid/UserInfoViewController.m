//
//  PlanViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "UserInfoViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import <UIKit/UIKit.h>
//#import "JSONKit.h"
@interface UserInfoViewController ()

@property WKWebViewJavascriptBridge* bridge;

@end

@implementation UserInfoViewController
// 加载一个wkwebview
// 启动log
// 初始化_bridge
// 设置handler 和 call bacl
// 
- (void)viewWillAppear:(BOOL)animated {
    if (_bridge) { return; }
    
    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.view.bounds];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:webView];
    
    // HTML 过来的的调用
   
    [_bridge registerHandler:@"PlanViewNativeHandler" handler:^(id data, WVJBResponseCallback responseCallback) {

        
        
     responseCallback(@"调用成功");
     responseCallback(@"启动");
        
    }];
      //初始化？
    [self renderButtons:webView];
    [self loadExamplePage:webView];
}
//NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
//NSMutableDictionary *alert = [NSMutableDictionary dictionary]
//;NSMutableDictionary *aps = [NSMutableDictionary dictionary];
//[alert setObject:@"a msg come!" forKey:@"body"];
//[aps setObject:alert forKey:@"alert"];
//[aps setObject:@"3" forKey:@"bage" ];
//[aps setObject:@"def.mp3" forKey:@"sound"];
//[jsonDic setObject:aps forKey:@"aps"];
//NSString *strJson = [jsonDic JSONString];

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(WKWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
//    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
//    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:callbackButton aboveSubview:webView];
//    callbackButton.frame = CGRectMake(10, 400, 100, 35);
//    callbackButton.titleLabel.font = font;
    
    //这里selector的 reload 是说webview的reload吗
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(280, 45, 100, 50);
    reloadButton.titleLabel.font = font;
}

//native call js
- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" }; // 给到js的数据
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)loadExamplePage:(WKWebView*)webView {
    
http://114.215.94.189:3000/views/classInfo.html
   [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/views/loginMobile.html"]]];
    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://114.215.94.189:3000/views/loginMobile.html"]]];

//    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"Plan_App" ofType:@"html"];
//    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
//    [webView loadHTMLString:appHtml baseURL:baseURL];

}


@end
