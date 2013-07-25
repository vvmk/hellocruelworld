//
//  FifthViewController.h
//  hcw_iphone
//
//  Created by Vince Masiello on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class TutorialViewController;
@interface FifthViewController : UIViewController <MFMailComposeViewControllerDelegate> {
	TutorialViewController *tutController;
}
@property (nonatomic, retain) TutorialViewController *tutController;
- (IBAction)resetDefaults;
- (IBAction)navToInfo:(id)sender;
- (IBAction)navToGOHF:(id)sender;
- (IBAction)showTutorial:(id)sender;
@end
