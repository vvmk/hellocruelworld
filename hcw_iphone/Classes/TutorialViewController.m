//
//  TutorialViewController.m
//  hcw_iphone
//
//  Created by Vince Masiello on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "TutorialViewController.h"
#import "InfoViewController.h"


@implementation TutorialViewController

@synthesize bRight;
@synthesize bLeft;

@synthesize view0;
@synthesize view1;
@synthesize view2;
@synthesize view3;

@synthesize currentScreen;

@synthesize gestureStartPoint;

@synthesize tutHelp;

#pragma mark -
#pragma mark init

- (void)viewDidLoad {
	self.currentScreen = 0;
	[self.tutHelp setTitle:@"I need help RIGHT NOW" forState:UIControlStateNormal];
	[self.tutHelp setTitle:@"I need help RIGHT NOW" forState:UIControlStateHighlighted];
	[self.tutHelp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.tutHelp setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	//self.tutHelp.titleLabel.font = [UIFont fontWithName:@"Cochin" size:18.0f];
	[self.tutHelp setBackgroundImage:[[UIImage imageNamed:@"blacktoolbtn.png"] 
								stretchableImageWithLeftCapWidth:10.0 
								topCapHeight:0.0] 
					  forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark Navigation Buttons

- (IBAction)navLeft:(id)sender {
	if (currentScreen != 0) {
		self.currentScreen -= 1;
		[self.view bringSubviewToFront:[self.view viewWithTag:(currentScreen+1)]];
	}
}

- (IBAction)navRight:(id)sender {
	if (currentScreen != 3) {
		self.currentScreen += 1;
		[self.view bringSubviewToFront:[self.view viewWithTag:(currentScreen+1)]];
	} else {
		[self.view removeFromSuperview];
	}
}

- (IBAction)showHelp:(id)sender {
	InfoViewController *tempController = [[InfoViewController alloc]
										  initWithNibName:@"InfoView"
										  bundle:nil];
	tempController.infoTag = 4319;
	tempController.view.frame = CGRectMake(0, 20, 320, 460);
	[tempController shouldRemoveSelf:YES];
	[tempController updateFrame:CGRectMake(30, 0, 265, 460)];
	[self.view addSubview:tempController.view];	
	//[tempController release];
	//[self.view removeFromSuperview];
}

#pragma mark -
#pragma mark Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	stop = NO;
	UITouch *touch = [touches anyObject];
	gestureStartPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (stop)
		return;
	
	UITouch *touch = [touches anyObject];
	CGPoint currentPosition = [touch locationInView:self.view];
	
	CGFloat deltaX = fabs(gestureStartPoint.x - currentPosition.x);
	CGFloat deltaY = fabs(gestureStartPoint.y - currentPosition.y);
	
	CGFloat direction = gestureStartPoint.x - currentPosition.x;
	
	if (deltaX >= kMinimumGestureLength && deltaY <= kMaximumVariance) {
		stop = YES;
		if (direction < 0)
			[self performSelector:@selector(navRight:) withObject:nil];
		else
			[self performSelector:@selector(navLeft:) withObject:nil];
	}
}

#pragma mark -
#pragma mark Memory 

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.bLeft = nil;
	self.bRight = nil;
	self.view0 = nil;
	self.view1 = nil;
	self.view2 = nil;
	self.view3 = nil;
	self.tutHelp = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[bLeft release];
	[bRight release];
	[view0 release];
	[view1 release];
	[view2 release];
	[view3 release];
	[tutHelp release];
    [super dealloc];
}

@end
