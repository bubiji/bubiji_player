//
//  CustomNavgationBar.h
//  JokePlayer
//
//  Created by apple on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomNavgationBar : UINavigationBar<UINavigationBarDelegate>
//-(void)drawRect:(CGRect)rect View:(UIViewController*)view;
-(void)drawButton:(UIViewController*)view LeftEvent :(SEL)leftAction RightEvent:(SEL)rightAction;

@end
