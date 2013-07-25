//
//  FeelingsViewController.m
//  hcw_iphone
//
//  Created by Vince Masiello on 8/17/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import "FeelingsViewController.h"



@implementation FeelingsViewController
@synthesize singlePicker;
@synthesize pickerData;
@synthesize currentCard;

- (IBAction)optionsPressed:(id)sender {
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Save or Share?" 
								  delegate:self 
								  cancelButtonTitle:@"Cancel" 
								  destructiveButtonTitle:nil 
								  otherButtonTitles:@"Save", @"Share", nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	NSInteger row = [singlePicker selectedRowInComponent:0];
	NSString *feeling = [pickerData objectAtIndex:row];
	
	if (buttonIndex != [actionSheet cancelButtonIndex])
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[array addObject:[NSNumber numberWithInt:1]];
		[array addObject:feeling];
		
		NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
		[favorites setObject:array forKey:self.currentCard];
		[favorites synchronize];
		[array release];
		
		if (buttonIndex == 0) {
			[self.navigationController popViewControllerAnimated:YES];
		} else {
			TweetViewController *tempViewController =[[TweetViewController alloc] 
														 initWithNibName:@"TweetView"
														 bundle:nil];
			tempViewController.currentCard = self.currentCard;
			tempViewController.feeling = feeling;
			[self.navigationController pushViewController:tempViewController animated:YES];		
			[tempViewController release];
		}
	}
}

- (void)viewWillAppear {
	self.navigationController.navigationBarHidden = NO;;
	//self.navigationItem.title = self.currentCard;
	self.navigationItem.backBarButtonItem.title = @"Back";
	UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																			target:self 
																			action:@selector(optionsPressed:)];
	self.navigationItem.rightBarButtonItem = action;
	[action release];
}

- (void)viewDidLoad {
	self.navigationController.navigationBarHidden = NO;;
	//self.navigationItem.title = self.currentCard;
	self.navigationItem.backBarButtonItem.title = @"Back";
	UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
															  target:self 
															  action:@selector(optionsPressed:)];
	self.navigationItem.rightBarButtonItem = action;
	[action release];
	
	NSArray *tempArray = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] 
														 pathForResource:@"feelings" 
														 ofType:@"txt"]
														  encoding:NSUTF8StringEncoding
														  error:nil]
							 componentsSeparatedByString:@"\n"];  
	self.pickerData = tempArray;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.singlePicker = nil;
	self.pickerData = nil;
	self.view = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[singlePicker release];
	[pickerData release];
	[currentCard release];
    [super dealloc];
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

#pragma mark Picker Delegate Methods
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [self.pickerData count];
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.pickerData objectAtIndex:row];
}

@end
