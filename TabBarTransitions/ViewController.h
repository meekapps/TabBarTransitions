//
//  ViewController.h
//  TabBarTransitions
//
//  Created by Mike Keller on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITabBarController <UITabBarControllerDelegate, UITabBarDelegate> {
    int transitionStyle;
}

@property (nonatomic) int transitionStyle;

@end
