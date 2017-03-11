//
//  TimeManger.m
//  JokePlayer
//
//  Created by apple on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TimeManger.h"

@implementation TimeManger

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Timer
-(void)LoopAction{
    if (TimeNum == 0) {
        //倒计时结束后要调用的语句
    }
    //lblNum.text = 
    
  NSLog(@"time : %@"  ,[[NSString alloc]
                   initWithFormat:@"%d",TimeNum]);
    TimeNum -= 1;
}
//在这里设置一个定时器 属性 
//全局只有一个
// 播放时开始 暂停时 暂停 新曲的时候 清零
//计算规则  如果 歌曲完成 或者 切换到下一首 对比 计数 不能少于歌曲长度5秒
//开始倒计时
-(void)startclock{
    [self LoopAction];
 // NSTimer * TimeToStart = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(LoopAction) userInfo:NULL repeats:YES];
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
