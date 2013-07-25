//
//  hcw_iphoneAppDelegate.m
//  hcw_iphone
//
//  Created by Daniel Siders on 7/26/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "hcw_iphoneAppDelegate.h"
#import "TutorialViewController.h"

//
//
//tutorial/welcome text
//
/*"Hello! First time using this?
- This app is all about staying alive. It's all about things you can do instead of suicide in order to #stayalive.
- Touch here to see some different ways to #stayalive. You can search by a number of factors [ danger, ease, age rating, etc? ]
- You can also just touch here to browse all the strategies and find one you like.
- [explanation of cloud?]
- If at any time while using this guide, you feel like you need immediate help, don't wait: click here to find ways to get help right now.
- That's all / enjoy using and #stayalive."*/


@implementation hcw_iphoneAppDelegate

@synthesize window;
@synthesize tabBarController;

@synthesize tutController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Hide the status bar
	//[[UIApplication sharedApplication] setStatusBarHidden:YES];
	[[ UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
	
	
    // Add the tab bar controller's view to the window and display.
    [window addSubview:tabBarController.view];
	
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	//[favorites setBool:NO forKey:@"skipTutorial"];
	if (![favorites boolForKey:@"skipTutorial"]) {
		TutorialViewController *tempController = [[TutorialViewController alloc] 
												  initWithNibName:@"TutorialView" 
												  bundle:nil];
		self.tutController = tempController;
		[window addSubview:tutController.view];
		[tempController release];
		[favorites setBool:YES forKey:@"skipTutorial"];
		[favorites synchronize];
	}
    [window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillFinishLaunching:(UIApplication *)application {
	
	
		
	/*NSMutableArray *controllers = self.tabBarController.viewControllers;
	ThirdViewController *thirdController = [[ThirdViewController alloc] init];
	[thirdController loadFeed];
	[controllers replaceObjectAtIndex:2 withObject:thirdController];
	self.tabBarController.viewControllers = controllers;
	[thirdController release];*/

}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[tutController release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

