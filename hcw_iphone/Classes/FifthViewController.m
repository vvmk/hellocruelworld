//
//  FifthViewController.m
//  hcw_iphone
//
//  Created by Vince Masiello on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FifthViewController.h"
#import "TutorialViewController.h"
#import "VMCard.h"
#import "InfoViewController.h"

@implementation FifthViewController
@synthesize tutController;

- (IBAction)resetDefaults {
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	for (int x=0;x<=100;x++) {
		VMCard *theCard = [[VMCard alloc] initWithIndex:x];
		NSString *key = [NSString stringWithFormat:@"%@", theCard.title];
		[favorites setBool:NO forKey:key];
		key = [NSString stringWithFormat:@"%@feeling",theCard.title];
		[favorites setObject:@"---" forKey:key];
		key = [NSString stringWithFormat:@"%@change",theCard.title];
		[favorites setBool:YES forKey:key];
		[theCard release];
		[favorites synchronize];
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favorites"
													message:@"You're favorites have been reset."
												   delegate:self
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (IBAction)navToInfo:(id)sender {
	//NSString *name = [sender titleForState:UIControlStateNormal];
	
	InfoViewController *tempController = [[InfoViewController alloc]
											  initWithNibName:@"InfoView"
											  bundle:nil];
	tempController.infoTag = [sender tag];
	tempController.tFrame = CGRectMake(30, 0, 265, 367);
	[tempController shouldRemoveSelf:NO];
	[self.navigationController pushViewController:tempController animated:YES];		
	[tempController release];
}

- (IBAction)navToGOHF:(id)sender {
	
	if ([MFMailComposeViewController canSendMail]) {
		
		MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
		mailComposer.mailComposeDelegate = self;
		[mailComposer setToRecipients:nil];
		[mailComposer setSubject:@"Get out of Hell Free!"];
		[mailComposer setMessageBody:@"<p>Hey! I wanted you to know I want you to #stayalive.</p><img height=\"169\"width=\"300\"src=\"http://cloudmir.com/hcw/get%20out%20of%20hell%20free%20card.jpg\" alternate=\"img_failsauce\" />" 
									isHTML:YES];
		
		[self presentModalViewController:mailComposer animated:YES];
		[mailComposer release];
	} else {
		NSLog(@"Device is unable to send email in its current state.");
	}
}

- (IBAction)showTutorial:(id)sender {
	TutorialViewController *tempController = [[TutorialViewController alloc] 
											  initWithNibName:@"TutorialView" 
											  bundle:nil];
	self.tutController = tempController;
	[tempController release];
	[[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:tutController.view];
	//tempController.hidesBottomBarWhenPushed = YES;
	//[[self navigationController] pushViewController:tempController animated:YES];
	//[[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	
	self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBarHidden = NO;
	self.navigationItem.title = @"Extras";
	
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[tutController release];
    [super dealloc];
}

#pragma mark -
#pragma mark MFMailComposeViewController Delegate Methods
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	[self dismissModalViewControllerAnimated:YES];
	
}
@end
