//
//  hcw_iphoneAppDelegate.h
//  hcw_iphone
//
//  Created by Daniel Siders on 7/26/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TutorialViewController;

@interface hcw_iphoneAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	
    UIWindow *window;
    UITabBarController *tabBarController;
	
	TutorialViewController *tutController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet TutorialViewController *tutController;


@end
