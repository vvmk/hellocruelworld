    //
//  InfoViewController.m
//  hcw_iphone
//
//  Created by Vince Masiello on 9/28/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import "InfoViewController.h"
#import "TouchTextView.h"

@implementation InfoViewController
@synthesize infoTag;
@synthesize touchView;
@synthesize tFrame;
@synthesize xbutton;

- (void)viewDidLoad {
	
	tFrame = CGRectMake(30, 0, 265, 367);
	
	self.touchView = [[TouchTextView alloc] initWithFrame:tFrame];
	touchView.delegate = self;
	touchView.backgroundColor = [UIColor clearColor];
	touchView.textColor = [UIColor blackColor];
	touchView.font = [UIFont fontWithName:@"Cochin" size:18.0f];
	
	int infoLocation = 0;
	if (infoTag == 4319)
		infoLocation = 1;
	
	NSArray *data = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"aboutHelp" ofType:@"txt"]
											   encoding:NSUTF8StringEncoding error:nil]
					  componentsSeparatedByString:@"\n#break#\n"];
	
	touchView.text = [data objectAtIndex:infoLocation];
	touchView.scrollEnabled = YES;
	touchView.editable = YES;
	touchView.opaque = NO;
	touchView.canCancelContentTouches = NO;
	touchView.delaysContentTouches = NO;
	[self.view addSubview:touchView];

	UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imgView.image = [UIImage imageNamed: @"aboutbkg.png"];
	imgView.backgroundColor = [UIColor clearColor];
	imgView.opaque = NO;
	[self.view addSubview:imgView];
	[self.view bringSubviewToFront:self.xbutton];
	self.xbutton.hidden = YES;
	[imgView release];
	
    [super viewDidLoad];
}

- (void)updateFrame:(CGRect)newframe {
	self.touchView.frame = newframe;
	[self.view bringSubviewToFront:self.xbutton];
}

- (void)shouldRemoveSelf:(BOOL)shouldremove {
	self.touchView.shouldRemoveSelf = shouldremove;
	if (shouldremove) {
		self.xbutton.hidden = NO;
		[self.view bringSubviewToFront:self.xbutton];
		
	}
}

#pragma mark TextView Delegate Methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	
	return NO;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.touchView = nil;
	self.xbutton = nil;
}


- (void)dealloc {
	[touchView release];
	[xbutton release];
    [super dealloc];
}

- (IBAction)closeInfo {
	[self.view removeFromSuperview];
}

@end
