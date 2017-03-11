//
//  PlanViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "PlanViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import <UIKit/UIKit.h>
//#import "JSONKit.h"
@interface PlanViewController ()

@property WKWebViewJavascriptBridge* bridge;

@end

@implementation PlanViewController
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
    _PlayController
    = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mpvc"] ;
    _PlayController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _PlayController.player_delegate =self;
    _planlist =[[NSMutableArray alloc]init];
    // HTML 过来的的调用
   
    [_bridge registerHandler:@"PlanViewNativeHandler" handler:^(id data, WVJBResponseCallback responseCallback) {

        
     responseCallback(@"调用成功");

        //产品环境用这个。
       // NSDictionary *dicData =data;
        NSString *jsonDataString = data;
        NSData *newnsdata = [jsonDataString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:newnsdata options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableDictionary *jsonDictionary =NULL;
        if ([jsonObject isKindOfClass:[NSDictionary class]])
            jsonDictionary = (NSMutableDictionary*)jsonObject;
        
        
        NSMutableArray * classarray =[jsonDictionary objectForKey:@"params"];
        NSString* keyofmethod = [jsonDictionary objectForKey:@"methodId"];
        
        // 两个方法，一个初始化 一个启动播放
        //switch后
        //分开两个方法调用
        
       if ([keyofmethod isEqual:@"initClassList"])
       {
           NSLog(@"初始化classPlan list: %@", data);

           [self initClasslist:classarray];

           return ;
       }
        
     if ([keyofmethod isEqual:@"playClassListItem"])
     {
                 NSLog(@"播放课程: %@", data);
                 //1.启动播放器,设置代理。
                 //UIStoryboard *main = [[UIStoryboard alloc] init] ;
         
//         //***初始化数组的时候 tag 一定重0开始。
//             Music *music1=[self ininMusic1];
//             Music *music2=[self ininMusic2];
//             Music *music3=[self ininMusic3];
//         _PlayController.planlist  = [[NSMutableArray alloc]init];
//
//             [_PlayController.planlist addObject:music1];
//             [_PlayController.planlist addObject:music2];
//             [_PlayController.planlist addObject:music3];
         
         //这里应该便利哪个传来的id 和 要播放的一直 然后直接传给播放器。
          // Music* music =[_PlayController.planlist objectAtIndex:0];
         
         NSDictionary * classItem =[jsonDictionary objectForKey:@"params"];
         
         //生产
        Music* music1 =[self getMusicWithDic:classItem];
        //测试
        Music* music = [self getCorrentClassWhenclick:music1.title];
         for (Music * musicItem in _planlist) {
             NSLog(@"1~~%@ ~~~2%@",music.title,musicItem.title);
             if ([music.title isEqualToString: musicItem.title]) {
                //播放
                [self startPlayer:music];
                 break;
             }
         }
         //遍历 有点消耗性能。看能否改成词典。
         
         _PlayController.musiclist =_planlist;

         [self presentViewController:_PlayController animated:YES completion:nil];
         _PlayController.musiclist =_planlist;

     
     return ;
     }
     
        
        responseCallback(@"启动");
    }];
      //初始化？
    [self renderButtons:webView];
    [self loadExamplePage:webView];
}

-(Music*)getCorrentClassWhenclick:(NSString*)classname
{
    if ([classname isEqualToString:@"2_Intro_VOCAB.mp3"]) {
        
        return  [_planlist objectAtIndex:0];
    }
    if ([classname isEqualToString:@"3_Intro_MINI_STORY.mp3"]) {
        return[_planlist objectAtIndex:1];
    }
    if ([classname isEqualToString:@"1_Emotional_Mastery_MAIN.mp3"]) {
       return [_planlist objectAtIndex:2];
    }
    if ([classname isEqualToString:@"2_Emotional_Mastery_VOCAB.mp3"]) {
        return[_planlist objectAtIndex:3];
    }
    if ([classname isEqualToString:@"3_Emotional_Mastery_MINI_STORY.mp3"]) {
        return[_planlist objectAtIndex:4];
    }
    if ([classname isEqualToString:@""]) {
        return[_planlist objectAtIndex:5];
    }
    return [_planlist objectAtIndex:5];
}



- (void)renderButtons:(WKWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
//    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
//    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:callbackButton aboveSubview:webView];
//    callbackButton.frame = CGRectMake(10, 400, 100, 35);
//    callbackButton.titleLabel.font = font;
//    
    //这里selector的 reload 是说webview的reload吗
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(300, 50, 100, 50);
    reloadButton.titleLabel.font = font;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}


//native call js
- (void)callHandler:(id)sender {
    //id data = @{ @"greetingFromObjC": @"Hi there, JS!" }; // 给到js的数据
    id recorddata = @{@"recordId": @"123",@"classId":@"4",@"duration":@"800",@"isMove":@"0",@"location":@"123",@"startTime":@"12:12:14",@"endTime":@"12:12:14"};
    
    NSString* jsonString = [self dictionaryToJson:recorddata];
    NSLog(@"native log recordClassInfo jsonString: %@", jsonString);;
    [_bridge callHandler:@"recordClassInfo" data:jsonString responseCallback:^(id response) {
        NSLog(@"native log recordClassInfo responded: %@", response);
    }];
}
//
-(void)MusicPlayerViewController_DidFinishPlaying:(RecordClass*)record
{
    id recorddata = @{@"classId":record.classId,@"duration":record.studyduration,@"isMove":record.isMove,@"location":record.location,@"startTime":record.startTime,@"endTime":record.endTime};
    
    NSString* jsonString = [self dictionaryToJson:recorddata];
    NSLog(@"native log recordClassInfo jsonString: %@", jsonString);;
    [_bridge callHandler:@"recordClassInfo" data:jsonString responseCallback:^(id response) {
        NSLog(@"native log recordClassInfo responded: %@", response);
    }];

}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}



- (void)loadExamplePage:(WKWebView*)webView {

    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://114.215.94.189:3000/views/classInfo.html"]]];
    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/views/classInfo.html"]]];

    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"Plan_App" ofType:@"html"];
    //NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"loginMobile" ofType:@"html"];

    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];

}
// 选择某个cell 然后播放音乐
#pragma  mark -
#pragma  mark  初始化播放器 & 数组

-(void)initClasslist:(NSMutableArray*)array
{
            NSLog(@"可以听多少节课 ：%lu",(unsigned long)[array count]);
    
            int tagindex = 0;
            for (int i=0; i<[array count]; i++) {
                Music *music=nil;
                NSMutableDictionary  *dic = [array objectAtIndex:i];
                music = [self getMusicWithDic:dic];
                music.tag=tagindex++; //标号 区分section用的
                NSLog(@"class :%@ ~~~ currentMusic.tag:%d",music.title,0);

                [_planlist addObject:music];

            }
    

}
-(void)startPlayer:(Music*)music
{
   
    [_PlayController newPlay:music];
    
    [self playClassFromPlanItem];
    
}

-(NSString*)getCorrentClassName:(NSString*)classID
{
    if ([classID isEqualToString:@"1"]) {
        return @"1_Intro_MAIN.mp3";
    }
    if ([classID isEqualToString:@"2"]) {
        return @"2_Intro_VOCAB.mp3";
    }
    if ([classID isEqualToString:@"3"]) {
        return @"3_Intro_MINI_STORY.mp3";
    }
    if ([classID isEqualToString:@"4"]) {
        return @"1_Emotional_Mastery_MAIN.mp3";
    }
    if ([classID isEqualToString:@"5"]) {
        return @"2_Emotional_Mastery_VOCAB.mp3";
    }
    if ([classID isEqualToString:@"6"]) {
        return @"3_Emotional_Mastery_MINI_STORY.mp3";
    }
return @"";
}

-(Music*)getMusicWithDic:(NSDictionary*)dic
{
    Music *music=[[Music alloc] init];

    music.classID=[[dic objectForKey:@"classId"]stringValue];;
    music.section=[dic objectForKey:@"sectionId"];
    NSLog(@"class :%@ ~~~ currentMusic.tag:%d",[dic objectForKey:@"title"],0);
    
    //NSString* title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    music.title=[self getCorrentClassName:music.classID];//@"1_Intro_MAIN.mp3";//
    music.ClassTime=[[dic objectForKey:@"classTime"]doubleValue];      //课程时长
    music.DidTimes=[[dic objectForKey:@"didTimes"]intValue];;      //一共听times
    music.DidDays=[[dic objectForKey:@"didDays"]intValue];;      //听了days
    music.BestTimes=[[dic objectForKey:@"bestTimes"]intValue];;      //推荐times
    music.BestDays=[[dic objectForKey:@"bestDays"]intValue];;      //推荐days
    
    music.TodayTimes=[[dic objectForKey:@"todayTimes"]intValue];
    music.TodayDuation=[[dic objectForKey:@"todayDuration"]intValue];
    
    //                if (music.path == nil)
    //                {
    //                    music.path=[NSURL URLWithString:@"3_Intro_MINI_STORY.mp3"];
    //                }
    //path 赋值
    [self getPathfromApp:music];

    return music;
}



#pragma -
#pragma mark - 获取mp3 路径
//
-(BOOL)getPathfromDocument:(Music*)m //检查存在 并写入 路径 并给类型
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    // NSLog(@"file path%@",documentDir);
    
    for (NSString *filename in [fileManager enumeratorAtPath:documentDir]) {
        //NSLog(@"file name%@",filename);
        //NSLog(@"title %@",[NSString stringWithFormat:@"%@.mp3", m.title]);
        //如果从ipod取出来的歌曲 都是这样 那只能统一没有歌曲名了
        if ([filename isEqual: [NSString stringWithFormat:@"%@", m.title]]) {
            // NSLog(@"yes");
            
            NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
            NSString *yourLessonPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", m.title]];
            //NSLog(@"path %@",yourLessonPath);
            m.path=[NSURL fileURLWithPath:yourLessonPath];
            //m.type=@"local";
            
            return YES;
        }
        
    }
    return NO;
}
// 在APP 项目中使用。临时
-(BOOL)getPathfromApp:(Music*)m   //检查存在 并写入 路径
{
    NSArray *appArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:nil];
    int ipodNum =0;
    for (NSString *song in appArray) {
        NSRange range =[song rangeOfString:m.title];
        // NSLog(@"song: %@",song);
        NSString *path =nil;
        
        if (range.location!=NSNotFound)
        {
            //NSLog(@"NSBundle: %@",[[NSBundle mainBundle]pathForResource:m.title ofType:@"mp3"]);
            NSRange range=[m.title rangeOfString:@".mp3"];
            if (range.location!=NSNotFound)
            {
                NSMutableString* stringTemp=[NSMutableString stringWithFormat:m.title];
                [stringTemp deleteCharactersInRange:range];
                path=  [[NSBundle mainBundle]pathForResource:stringTemp ofType:@"mp3"];
                NSURL *url= [NSURL fileURLWithPath:path];
                m.path =url;
                m.iPodNum =ipodNum;
            }
            else
            {
                return NO;
            }
            return YES;
        }
        ipodNum++;
        
    }
    
    return NO;
}



#pragma  mark -
#pragma  mark 测试数据


- (Music*)ininMusic1
{
    Music *music=[[Music alloc] init];
    music.title=@"1_Intro_MAIN.mp3";
    music.type=@"App";
    
    //[self   checkEveryLesson:music];
    music.classID=@"3";
    //music.size=[NSString stringWithFormat:@"%d",[fileInfo fileSize]];课程大小
    music.tag=0; //标号 区分section用的
    music.ClassTime=3;      //课程时长
    music.DidTimes=4;      //一共听times
    music.DidDays=5;      //听了days
    music.BestTimes=5;      //推荐times
    music.BestDays=7;      //推荐days
    //music.iPodNum=3;      //（废弃）ipod
    //NSLog(@"days :%d",music.DidDays);
    //NSLog(@"bestdays :%d",music.BestTimes);
    
    music.section =@"3_Intro";
    music.TodayTimes=@"5";
    
    if (music.path == nil)
    {
        music.path=[NSURL URLWithString:@"3_Intro_MINI_STORY.mp3"];
    }
    //path 赋值该地方了
    [self getPathfromApp:music];
    
    return  music;
}
- (Music*)ininMusic2
{
    Music *music=[[Music alloc] init];
    music.title=@"2_Intro_VOCAB.mp3";
    music.type=@"App";
    
    //[self   checkEveryLesson:music];
    music.classID=@"3";
    //music.size=[NSString stringWithFormat:@"%d",[fileInfo fileSize]];课程大小
    music.tag=1; //标号 区分section用的
    music.ClassTime=3;      //课程时长
    music.DidTimes=4;      //一共听times
    music.DidDays=5;      //听了days
    music.BestTimes=5;      //推荐times
    music.BestDays=7;      //推荐days
    //music.iPodNum=3;      //（废弃）ipod
    //NSLog(@"days :%d",music.DidDays);
    //NSLog(@"bestdays :%d",music.BestTimes);
    
    music.section =@"3_Intro";
    music.TodayTimes=@"5";
    
    if (music.path == nil)
    {
        music.path=[NSURL URLWithString:@"3_Intro_MINI_STORY.mp3"];
    }
    //path 赋值该地方了
    [self getPathfromApp:music];
    NSLog(@"-----path :%@",music.path);
    
    return  music;
}
- (Music*)ininMusic3
{
    Music *music=[[Music alloc] init];
    music.title=@"3_Intro_MINI_STORY.mp3";
    music.type=@"App";
    
    //[self   checkEveryLesson:music];
    music.classID=@"3";
    //music.size=[NSString stringWithFormat:@"%d",[fileInfo fileSize]];课程大小
    music.tag=2; //标号 区分section用的
    music.ClassTime=3;      //课程时长
    music.DidTimes=4;      //一共听times
    music.DidDays=5;      //听了days
    music.BestTimes=5;      //推荐times
    music.BestDays=7;      //推荐days
    //music.iPodNum=3;      //（废弃）ipod
    //NSLog(@"days :%d",music.DidDays);
    //NSLog(@"bestdays :%d",music.BestTimes);
    
    music.section =@"3_Intro";
    music.TodayTimes=@"5";
    
    if (music.path == nil)
    {
        music.path=[NSURL URLWithString:@"3_Intro_MINI_STORY.mp3"];
    }
    //path 赋值该地方了
    [self getPathfromApp:music];
    NSLog(@"-----path :%@",music.path);
    
    return  music;
}
#pragma-
#pragma initList
//如果点击了未解锁的功能，弹出框提示****验证是否可以播放可以在H5上完成

-(void)playClassFromPlanItem
{
    
    //    if ([music.type isEqualToString:@"none"]) {
    ////        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat: @"Required Import!",appDelegate.currentMusic.title,appDelegate.currentMusic.DidTimes,appDelegate.currentMusic.DidDays] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    //        //这里可以加上 如果不想再次提醒 就点取消提醒
    ////        // optional - add more buttons:
    ////        //[alert addButtonWithTitle:@"Yes"];
    ////        [alert show];
    //        return;
    //    }
}


@end
