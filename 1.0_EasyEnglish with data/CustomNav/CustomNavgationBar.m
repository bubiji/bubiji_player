//
//  CustomNavgationBar.m
//  JokePlayer
//
//  Created by apple on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomNavgationBar.h"

@implementation CustomNavgationBar

-(id)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    self.backgroundColor=[UIColor clearColor];

    UIImage *imageBackground =[UIImage imageNamed:@"4.png"];
    [imageBackground drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) ];
//    UIImage *image = [UIImage imageNamed: @"4.png"];
//    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
- (UIBarButtonItem*)initWithLeftButton:(UIViewController *)owner{
    UIButton *playNowButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 40, 70)];
    [playNowButton setBackgroundImage:[UIImage imageNamed:@"help.png"] forState:UIControlStateNormal];
    [playNowButton addTarget:self action:@selector(AboutClick:)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *bar =[[UIBarButtonItem alloc] initWithCustomView:playNowButton];
    [playNowButton release];
    //self.buttonOwner = owner;
    return bar;
}
- (UIBarButtonItem*)initWithRightButton:(UIViewController *)owner{
    //NSLog(@"gogo");
    UIButton *playNowButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 40, 70)];
    [playNowButton setBackgroundImage:[UIImage imageNamed:@"Btn_playing.png"] forState:UIControlStateNormal];
    [playNowButton addTarget:self action:@selector(PlayClick:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *bar =[[UIBarButtonItem alloc] initWithCustomView:playNowButton];
    [playNowButton release];
    //self.buttonOwner = owner;
    return bar;
}
-(void)drawButton:(UIViewController*)view LeftEvent :(SEL)leftAction RightEvent:(SEL)rightAction;
{

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
}
@end
