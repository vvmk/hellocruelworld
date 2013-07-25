//
//  InfoViewController.h
//  hcw_iphone
//
//  Created by Vince Masiello on 9/28/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchTextView;

@interface InfoViewController : UIViewController <UITextViewDelegate> {
	NSInteger infoTag;
	TouchTextView *touchView;
	CGRect tFrame;
	
	UIButton *xbutton;
}
@property NSInteger infoTag;
@property CGRect tFrame;
@property (nonatomic, retain) TouchTextView *touchView;
@property (nonatomic, retain) IBOutlet UIButton *xbutton;
- (void)updateFrame:(CGRect)newframe;
- (void)shouldRemoveSelf:(BOOL)shouldremove;
- (IBAction)closeInfo;
@end
