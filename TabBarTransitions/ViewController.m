//
//  ViewController.m
//  TabBarTransitions
//
//  Created by Mike Keller on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "View1VC.h"
#import "View2VC.h"
#import "View3VC.h"

#import <QuartzCore/QuartzCore.h>

#define kTransitionTypeFade 0
#define kTransitionTypeSlide 1

#define kAnimationDuration 0.3

@implementation ViewController

@synthesize transitionStyle;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //***
    //***
    //Change this constant to change the transition style
    
    self.transitionStyle = kTransitionTypeSlide; 
    
    //***
    //***
    
    
    //View 1
    View1VC *v1 = [[View1VC alloc] initWithNibName:@"View1VC" bundle:nil];
    v1.title = @"View 1";
    v1.tabBarItem.image = [UIImage imageNamed:@"tab-1.png"];
    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:v1];
   
    //View 2
    View2VC *v2 = [[View2VC alloc] initWithNibName:@"View2VC" bundle:nil];
    v2.title = @"View 2";
    v2.tabBarItem.image = [UIImage imageNamed:@"tab-2.png"];
    UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:v2];
    
    //View 3
    View3VC *v3 = [[View3VC alloc] initWithNibName:@"View3VC" bundle:nil];
    v3.title = @"View 3";
    v3.tabBarItem.image = [UIImage imageNamed:@"tab-3.png"];    
    UINavigationController *nc3 = [[UINavigationController alloc] initWithRootViewController:v3];
    
    //Set up the tab bar controller
    NSArray *viewControllers = [NSArray arrayWithObjects:nc1, nc2, nc3, nil];
    [self setViewControllers:viewControllers];
    
    self.delegate = self;
    
}

#pragma mark - Animations
//Take a screen shot of all UIKit subview
- (UIImage*)screenshot 
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) 
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

//slide to the left
- (void) forwardAnimation {
    UIImage *screenshot = [self screenshot];
    
    UIImageView *screenshotView = [[UIImageView alloc] initWithImage:screenshot];
    [[screenshotView layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[screenshotView layer] setShadowOffset:CGSizeMake(5, 0)];
    [[screenshotView layer] setShadowOpacity:0.3f];
    [[screenshotView layer] setShadowRadius:5.0f];
    [[screenshotView layer] setShouldRasterize:YES];
    screenshotView.contentMode = UIViewContentModeTop;
    screenshotView.clipsToBounds = YES;
    screenshotView.frame = CGRectMake(-10,
                                      0,
                                      self.view.frame.size.width + 20,
                                      self.view.frame.size.height - self.tabBar.frame.size.height);
    
    [self.view addSubview:screenshotView];
    [self.view bringSubviewToFront:screenshotView];
    
    [UIView animateWithDuration:kAnimationDuration
                          delay:0.0f
                        options:UIViewAnimationCurveEaseIn
                     animations:^(void) {
                         screenshotView.center = CGPointMake(screenshotView.center.x - self.view.bounds.size.width,
                                                             screenshotView.center.y);
                     }
                     completion:^(BOOL finished) {
                         [screenshotView removeFromSuperview];
                     }];
}

//slide to the right
- (void) backwardAnimation {
    UIImage *screenshot = [self screenshot];
    
    UIImageView *screenshotView = [[UIImageView alloc] initWithImage:screenshot];
    [[screenshotView layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[screenshotView layer] setShadowOffset:CGSizeMake(-5, 0)];
    [[screenshotView layer] setShadowOpacity:0.3f];
    [[screenshotView layer] setShadowRadius:5.0f];
    [[screenshotView layer] setShouldRasterize:YES];
    screenshotView.contentMode = UIViewContentModeTop;
    screenshotView.clipsToBounds = YES; //necessarry to cut off the UITabBar of the frame
    screenshotView.frame = CGRectMake(10, //a fix for the shadow
                                      0,
                                      self.view.frame.size.width + 20,
                                      self.view.frame.size.height - self.tabBar.frame.size.height);
    
    [self.view addSubview:screenshotView];
    [self.view bringSubviewToFront:screenshotView];
    
    [UIView animateWithDuration:kAnimationDuration
                          delay:0.0f
                        options:UIViewAnimationCurveEaseIn
                     animations:^(void) {
                         screenshotView.center = CGPointMake(screenshotView.center.x + self.view.bounds.size.width,
                                                             screenshotView.center.y);
                     }
                     completion:^(BOOL finished) {
                         [screenshotView removeFromSuperview];
                     }];
}

//Fade animation
- (void) fadeAnimation {
    UIImage *screenshot = [self screenshot];
    
    UIImageView *screenshotView = [[UIImageView alloc] initWithImage:screenshot];
    screenshotView.contentMode = UIViewContentModeTop;
    screenshotView.clipsToBounds = YES;
    screenshotView.frame = CGRectMake(0, 
                                      0, 
                                      self.view.frame.size.width, 
                                      self.view.frame.size.height - self.tabBar.frame.size.height);
    screenshotView.alpha = 1.0f;
    
    [self.view addSubview:screenshotView];
    [self.view bringSubviewToFront:screenshotView];
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         screenshotView.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [screenshotView removeFromSuperview];
                     }];
}

#pragma mark - UITabBarControllerDelegate

//Implement this delegate method to intercept the tab change and call the transition animation
- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    int oldIndex = tabBarController.selectedIndex;
    int newIndex = [tabBarController.viewControllers indexOfObject:viewController];
    
    //Slide
    if (self.transitionStyle == kTransitionTypeSlide) {    
        //new tab to the right
        if (newIndex > oldIndex) {
            [self forwardAnimation];
            
        //new tab to the left
        } else if (newIndex < oldIndex) {
            [self backwardAnimation];
        }
    } else if (self.transitionStyle == kTransitionTypeFade) {
        if (newIndex != oldIndex) { //only transition if it's a different tab
            [self fadeAnimation];
        }
    }
    
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
