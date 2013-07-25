//
//  ThirdViewController.h
//  hcw_iphone
//
//  Created by Vince Masiello on 7/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThirdViewController : UIViewController <UIWebViewDelegate> {

	UIWebView	*twitterSearch;
	
	UIBarButtonItem *backButton;
	UIBarButtonItem *forwardButton;
	UIBarButtonItem *homeButton;
	UIBarButtonItem *activityButton;
	BOOL			isLoading;
}
@property (nonatomic, retain) IBOutlet UIWebView *twitterSearch;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *homeButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *activityButton;
- (IBAction)navForward;
- (IBAction)navBack;
- (IBAction)navHome;
- (IBAction)activity:(id)sender;
@end
