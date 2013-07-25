//
//  TutorialViewController.h
//  hcw_iphone
//
//  Created by Vince Masiello on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMinimumGestureLength	45
#define kMaximumVariance		5

@interface TutorialViewController : UIViewController {
	
	UIButton *bRight;
	UIButton *bLeft;
	
	UIView *view0;
	UIView *view1;
	UIView *view2;
	UIView *view3;
	
	CGPoint gestureStartPoint;
	
	NSInteger currentScreen;
	
	BOOL stop;
	
	UIButton *tutHelp;
}

@property (nonatomic, retain) IBOutlet UIButton *bRight;
@property (nonatomic, retain) IBOutlet UIButton *bLeft;

@property (nonatomic, retain) IBOutlet UIView *view0;
@property (nonatomic, retain) IBOutlet UIView *view1;
@property (nonatomic, retain) IBOutlet UIView *view2;
@property (nonatomic, retain) IBOutlet UIView *view3;

@property CGPoint gestureStartPoint;
@property NSInteger currentScreen;

@property (nonatomic, retain) IBOutlet UIButton *tutHelp;

- (IBAction)navLeft:(id)sender;
- (IBAction)navRight:(id)sender;
- (IBAction)showHelp:(id)sender;
@end
