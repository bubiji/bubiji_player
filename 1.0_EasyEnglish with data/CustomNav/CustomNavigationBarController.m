//
//  CustomNavigationBarController.m
//  JokePlayer
//
//  Created by apple on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationBarController.h"

@implementation CustomNavigationBarController
#define CustomImageViewTag 999

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *titleBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navtopbtn.jpg"]];
    titleBg.frame = self.navigationBar.bounds;
    titleBg.tag = CustomImageViewTag;
    NSLog(@"Test %d",2+CustomImageViewTag); 
    [self.navigationBar insertSubview:titleBg atIndex:0];
    [titleBg release];
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
#pragma mark - self API

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    UIImageView *titleBg = (UIImageView *)[self.navigationBar viewWithTag:CustomImageViewTag];
    [self.navigationBar sendSubviewToBack:titleBg];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    UIImageView *titleBg = (UIImageView *)[self.navigationBar viewWithTag:CustomImageViewTag];
    [self.navigationBar sendSubviewToBack:titleBg];
    return viewController;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *viewControllers = [super popToRootViewControllerAnimated:animated];
    UIImageView *titleBg = (UIImageView *)[self.navigationBar viewWithTag:CustomImageViewTag];
    [self.navigationBar sendSubviewToBack:titleBg];
    return viewControllers;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *viewControllers = [super popToViewController:viewController animated:animated];
    UIImageView *titleBg = (UIImageView *)[self.navigationBar viewWithTag:CustomImageViewTag];
    [self.navigationBar sendSubviewToBack:titleBg];
    return viewControllers;
}
@end
