
//  DisplayViewController.m
//  hcw_iphone
//
//  Created by Vincent Masiello on 8/9/10.
//  Copyright 2010 Vincent Masiello All rights reserved.
//



#import "DisplayViewController.h"
#import "SHK.h"
#import "TouchTextView.h"
#import "FacebookViewController.h"
#import "VMCard.h"

@implementation DisplayViewController
@synthesize cardDictionary;
@synthesize cardTitles;
@synthesize currentCard;
@synthesize cardText;
@synthesize pickerData;
@synthesize picker;
@synthesize container;
@synthesize mainStar;

//top section
@synthesize uTitle;
@synthesize uSafe;
@synthesize uEff;
@synthesize uDiff;
@synthesize uAge;
@synthesize topBG;


- (void)viewWillAppear:(BOOL)animated {
	
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	
}

- (void)viewDidLoad {
	
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	
	//set up dictionary/array for previews
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *plistPath = [bundle pathForResource:@"Alternatives3" ofType:@"plist"];
	self.cardDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
	
	self.cardTitles = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] 
														  pathForResource:@"titles" 
														  ofType:@"txt"] 
												encoding:NSUTF8StringEncoding
												   error:nil]
					  componentsSeparatedByString:@"\n"];
	
	//setup top meta section
	VMCard *theCard = [[VMCard alloc] initWithIndex:[cardTitles indexOfObject:currentCard]];
	NSArray *sortMeta = theCard.meta;
	[theCard release];
	self.uTitle.text = currentCard;
	self.uSafe.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@safe.png",[sortMeta objectAtIndex:0]]];
	self.uEff.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@eff.png",[sortMeta objectAtIndex:1]]];
	self.uDiff.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@diff.png",[sortMeta objectAtIndex:2]]];
	self.uAge.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@age.png",[sortMeta objectAtIndex:3]]];
	
	
	CGSize full = [self.view bounds].size;
	CGRect tFrame = CGRectMake(0, 75, 
							   full.width,
							   336);
	
	TouchTextView *touchView = [[TouchTextView alloc] initWithFrame:tFrame];
	touchView.delegate = self;
	touchView.backgroundColor = [UIColor whiteColor];
	touchView.textColor = [UIColor blackColor];
	touchView.font = [UIFont fontWithName:@"Cochin" size:18.0f];
	touchView.text = [[self.cardDictionary objectForKey:currentCard] objectAtIndex:5];
	touchView.scrollEnabled = YES;
	touchView.editable = YES;
	touchView.opaque = YES;
	touchView.canCancelContentTouches = NO;
	touchView.delaysContentTouches = NO;
	[self.view addSubview:touchView];
	[touchView release];
	[self.view bringSubviewToFront:self.topBG];
	[self.view bringSubviewToFront:self.uTitle];
	[self.view bringSubviewToFront:self.uSafe];
	[self.view bringSubviewToFront:self.uEff];
	[self.view bringSubviewToFront:self.uDiff];
	[self.view bringSubviewToFront:self.uAge];
	[self.view bringSubviewToFront:mainStar];
	
	//create offscreen view - holds picker w/ toolbar
	self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 480, 320, 314)];
	
	UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	tools.barStyle = UIBarStyleBlackTranslucent;
	
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:7];
	
	//Done-----------------------------------------------------------
	UIBarButtonItem *barItem = [[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemDone
								target:self 
								action:@selector(hidePicker)];
	
	[buttons addObject:barItem];
	[barItem release];
	
	//large space-----------------------------------------------------------
	barItem = [[UIBarButtonItem alloc]
			   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	barItem.width = 51.0f;
	[buttons addObject:barItem];
	[barItem release];
	
	//Star-----------------------------------------------------------
	
	barItem = [[UIBarButtonItem alloc]
			   initWithImage:[UIImage imageNamed:@"goldstar.png"] 
							style:UIBarButtonItemStyleBordered 
							target:self 
							action:@selector(starClicked:)];
	[buttons addObject:barItem];
	[barItem release];
	
	//space-----------------------------------------------------------
	barItem = [[UIBarButtonItem alloc]
			  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[buttons addObject:barItem];
	[barItem release];
	
	//Facebook-----------------------------------------------------------
	barItem = [[UIBarButtonItem alloc]
			   initWithTitle:@"Facebook" 
			   style:UIBarButtonItemStyleBordered
			   target:self 
			   action:@selector(navFacebook)];
	
	[buttons addObject:barItem];
	[barItem release];
	
	//space-----------------------------------------------------------
	barItem = [[UIBarButtonItem alloc]
			initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[buttons addObject:barItem];
	[barItem release];
	
	//Twitter-----------------------------------------------------------
	barItem = [[UIBarButtonItem alloc]
			   initWithTitle:@"Twitter" 
			   style:UIBarButtonItemStyleBordered
			   target:self 
			   action:@selector(navToFeelings:)];
	
	[buttons addObject:barItem];
	[barItem release];
	
	//space-----------------------------------------------------------
	/*barItem = [[UIBarButtonItem alloc]
			initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[buttons addObject:barItem];
	[barItem release];*/
	
	//set
	[tools setItems:buttons animated:NO];
	[container addSubview:tools];
	[buttons release];
	[tools release];
	
	//picker
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 270)];
    picker.delegate = self;
    picker.dataSource = self;
	picker.showsSelectionIndicator = YES;
	
	self.pickerData = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] 
														   pathForResource:@"feelings" 
														   ofType:@"txt"]
												 encoding:NSUTF8StringEncoding
													error:nil]
					   componentsSeparatedByString:@"\n"];
    [container addSubview:picker];
	[self.view addSubview:container];
    [picker release];
	[container release];
}

- (IBAction)navToFeelings:(id)sender {
	//TODO:remove actionsheet intermediary crap
	NSInteger cardNumber = [cardTitles indexOfObject:currentCard]+1;
	
	NSString *str = [NSString stringWithFormat:@"I'm reading \"Hello Cruel World\" #%d: %@ #stayalive", 
					 cardNumber, 
					 currentCard];
	
	SHKItem *item = [SHKItem text:str];
	[NSClassFromString(@"SHKTwitter") performSelector:@selector(shareItem:) withObject:item];
	
	//SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	//[actionSheet showInView:self.view];
}

- (void)navFacebook {
	FacebookViewController *fb = [[FacebookViewController alloc] 
							   initWithNibName:@"FacebookView" 
							   bundle:nil];
	[self.navigationController pushViewController:fb animated:YES];
	[fb release];
}

- (IBAction)starClicked:(id)sender {
	
	//save to favorites
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	[favorites setBool:YES forKey:currentCard];
	
	//TODO: raise fading alert "card saved to favorites" possibly gray box w/ checkmark
	
	NSString *keystring = [[NSString alloc] initWithFormat:@"%@change",currentCard];
	[favorites setBool:YES forKey:keystring];
	[favorites synchronize];
	[keystring release];
}

-(IBAction)showPicker {
	[UIView beginAnimations:@"container" context:nil];
    [UIView setAnimationDuration:0.5];
	
    container.transform = CGAffineTransformMakeTranslation(0,-329);
    [UIView commitAnimations];
	
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	NSString *key = [[NSString alloc] initWithFormat:@"%@feeling",currentCard];
	
	if ([[favorites objectForKey:key] isKindOfClass:[NSString class]]) {
		NSInteger row = [pickerData indexOfObject:[favorites objectForKey:key]];
		[picker selectRow:row inComponent:0 animated:YES];
	} else {
		[favorites setObject:[pickerData objectAtIndex:0] forKey:key];
	}
	[key release];
	key = [[NSString alloc] initWithFormat:@"%@change",currentCard];
	[favorites setBool:YES forKey:key];
	[favorites synchronize];
	[key release];
}

-(void)hidePicker {
	[UIView beginAnimations:@"container" context:nil];
    [UIView setAnimationDuration:0.5];
	
    container.transform = CGAffineTransformMakeTranslation(0,329);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.picker = nil;
	self.mainStar = nil;
	self.mainStar = nil;
	self.uTitle = nil;
	self.uSafe = nil;
	self.uEff = nil;
	self.uDiff = nil;
	self.uAge = nil;
	self.topBG = nil;
	self.view = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[cardDictionary release];
	[cardTitles release];
	[currentCard release];
	[cardText release];
	[pickerData release];
	[picker release];
	[container release];
	[mainStar release];
	
	//
	[uTitle release];
	[uSafe release];
	[uEff release];
	[uDiff release];
	[uAge release];
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

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSString *feeling = [pickerData objectAtIndex:row];
		
	//save to favorites
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	
	NSString *keystring = [[NSString alloc] initWithFormat:@"%@feeling",currentCard];
	[favorites setObject:feeling forKey:keystring];
	[keystring release];
	
	keystring = [[NSString alloc] initWithFormat:@"%@change",currentCard];
	[favorites setBool:YES forKey:keystring];
	
	[favorites synchronize];
	[keystring release];
}

#pragma mark TextView Delegate Methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	
	return NO;
}

#pragma mark Touch Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"touches began");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"%i", [touches count]);
	if ([touches count] >= 2)
		[self.navigationController popViewControllerAnimated:YES];
}

@end
