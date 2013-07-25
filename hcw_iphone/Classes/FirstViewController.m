//
//  FirstViewController.m
//  hcw_iphone
//
//  Created by Vince Masiello on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FirstViewController.h"
#import "AFOpenFlowView.h"
#import "openFlowViewController.h"
#import "TutorialViewController.h"
#import "VMCard.h"
#import "VMSlider.h"


#define heart_tag 888
#define umb_tag 999
#define diff_tag 2
#define age_tag 3

#define kAllCardsCount 101

@implementation FirstViewController

@synthesize flowController;
//@synthesize anyCard;

//sort control outlets
@synthesize iDiff;
@synthesize iAge;

//last stored sort values
@synthesize lastSafe;
@synthesize lastEff;
@synthesize lastDiff;
@synthesize lastAge;

//update/display card flow
@synthesize cardDictionary;
@synthesize finalCardList;
@synthesize cardTitles;
@synthesize feelings;

//sliders
@synthesize heartSlider;
@synthesize umbrellaSlider;

@synthesize arrayExists;
@synthesize loadCheck;

//hrt/umb slider hack
@synthesize gestureStartPoint;
@synthesize frameSafe;
@synthesize frameEff;

@synthesize VMCardList;
@synthesize myIndicator;
//for options menu
@synthesize fullSortList;
@synthesize optionsView;
@synthesize useIllustrations;
@synthesize useStrictSort;
@synthesize infoOnScreen;

@synthesize sortDisabled;

#pragma mark -
#pragma mark Sort Methods

- (IBAction)commitSort:(id)sender {
	VMSlider *slider = (VMSlider *)sender;
	NSString *str = slider.spec;
	if ([str isEqualToString:@"safe"])
		self.lastSafe = [NSNumber numberWithInt:slider.index];
	else 
		self.lastEff = [NSNumber numberWithInt:slider.index];
	
	//NSLog(@"entered commitsort");
	[self performSelectorInBackground:@selector(updateSearch:) withObject:str];
}

- (IBAction)segmentChanged:(id)sender {
	UISegmentedControl *segments = (UISegmentedControl *)sender;
	
	NSString *currentSegments = [NSString string];
	NSNumber *value = [NSNumber numberWithInt:1];
	
	if (segments.tag == diff_tag) {
		currentSegments = @"diff";
		NSNumber *num = [[NSNumber alloc] initWithInt:[sender selectedSegmentIndex]];
		
		self.lastDiff = num;
		value = num;
		[num release];
	} else if (segments.tag == age_tag) {
		currentSegments = @"age";
		NSNumber *num = [[NSNumber alloc] initWithInt:[sender selectedSegmentIndex]];
		self.lastAge = num;
		value = num;
		[num release];
	}
	[self performSelectorInBackground:@selector(updateSearch:) withObject:currentSegments];
	[currentSegments release];
}
 
- (void)updateSearch:(NSString *)whichSpec {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	self.view.userInteractionEnabled = NO;
	
	int uSafe = [self.lastSafe intValue];
	int uEff = [self.lastEff intValue];
	int uDiff = [self.lastDiff intValue];
	int uAge = [self.lastAge intValue];
	
	
	NSString *sDiff = [NSString string];
	NSString *sAge = [NSString string];
	
	switch (uDiff) {
		case 0:
			sDiff = @"easy";
			break;
		case 1:
			sDiff = @"tricky";
			break;
		case 2:
			sDiff = @"difficult";
			break;
		case 3:
			sDiff = @"too easy";
			break;
	}
	switch (uAge) {
		case 0:
			sAge = @"G";
			break;
		case 1:
			sAge = @"YG";
			break;
		case 2:
			sAge = @"YG-50";
			break;
		case 3:
			sAge = @"X";
			break;
		case 4:
			sAge = @"ASS";
			break;
	}
	
	int cardsTotal = 0;		//tracks cards added to final array
	
	NSMutableArray *tempFinalCardList = [[NSMutableArray alloc] initWithCapacity:kAllCardsCount];
	
	for (NSString *theTitle in fullSortList) {
		
		VMCard *theCard = [VMCardList objectForKey:theTitle];
		NSArray *sortMeta = theCard.meta;
		
		NSInteger cSafe = [[sortMeta objectAtIndex:0] intValue];
		if (uSafe == 5)
			cSafe = 5;
		
		NSInteger cEff = [[sortMeta objectAtIndex:1] intValue];
		if (uEff == 5)
			cEff = 5;
		
		NSString *cDiff = [sortMeta objectAtIndex:2];
		if ([sDiff isEqualToString:@"any"])
			cDiff = @"any";
		
		NSString *cAge = [sortMeta objectAtIndex:3];
		if ([sAge isEqualToString:@"any"])
			cAge = @"any";
		
		//TODO:loos sort is not that good. fix when time allows
		if (useStrictSort) {
			if ((cSafe == uSafe) && (cEff == uEff) && 
				([cDiff isEqualToString:sDiff]) && 
				([cAge isEqualToString:sAge])) {
				
				[tempFinalCardList insertObject:theCard.title atIndex:cardsTotal];
				
				cardsTotal++;
			}
		} else {
			if ((cSafe >= uSafe) && (cEff >= uEff) && 
				([cDiff isEqualToString:sDiff] || [cDiff isEqualToString:@"easy"]) && 
				([cAge isEqualToString:sAge] || [cAge isEqualToString:@"G"])) {
				
				[tempFinalCardList insertObject:theCard.title atIndex:cardsTotal];
				
				cardsTotal++;
			}
		}
	}
	
	if (([tempFinalCardList count] < 1) && useStrictSort) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Matches"
														message:@"This search returned no matches. Change a field to try another search or turn OFF \"Strict Search\" in the info menu below."
													   delegate:self
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else {
		
		self.finalCardList = tempFinalCardList;
		[self updateCoverFlow];
		[self resetNeedsChange];
	}
	[tempFinalCardList release];
	self.view.userInteractionEnabled = YES;
	[pool drain];
}

#pragma mark -
#pragma mark Load Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		[self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
	
	if (arrayExists) {
		if ([self shouldRefresh]) {
			//NSLog(@"entered should refresh on viewwillappear");
			[self updateCoverFlow];
			
		}
	} else {
		self.arrayExists = YES;
	}
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
	
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	
	self.arrayExists = NO;
	self.loadCheck = YES;
	self.useStrictSort = YES;
	self.useIllustrations = YES;
	self.infoOnScreen = NO;
	self.sortDisabled = NO;
	
	
	//init and set custom sliders
	//CGFloat ss = [[UIScreen mainScreen] scale];
	CGFloat ss = 1; 
	CGRect hFrame = CGRectMake(10, 300, (ss*141), (ss*34));
	VMSlider *heart = [[VMSlider alloc] initWithFrame:hFrame];
	heart.spec = @"safe";
	heart.backgroundColor = [UIColor whiteColor];
	NSString *imgPath = [NSString stringWithFormat:@"%@/4safe.png", [[NSBundle mainBundle] resourcePath]];
	heart.bgview.image = [UIImage imageWithContentsOfFile:imgPath];
	[heart addTarget:self action:@selector(commitSort:) forControlEvents:UIControlEventTouchUpInside];
	self.heartSlider = heart;
	[self.view addSubview:heartSlider];
	[heart release];
	
	CGRect uFrame = CGRectMake(170, 300, (ss*141), (ss*34));
	VMSlider *umbrella = [[VMSlider alloc] initWithFrame:uFrame];
	umbrella.spec = @"eff";
	umbrella.backgroundColor = [UIColor whiteColor];
	NSString *imgPathu = [NSString stringWithFormat:@"%@/4eff.png", [[NSBundle mainBundle] resourcePath]];
	umbrella.bgview.image = [UIImage imageWithContentsOfFile:imgPathu];
	[umbrella addTarget:self action:@selector(commitSort:) forControlEvents:UIControlEventTouchUpInside];
	self.umbrellaSlider = umbrella;
	[self.view addSubview:umbrellaSlider];
	[umbrella release];
	
	//put sort sliders on top of their frame
	[self.view bringSubviewToFront:heartSlider];
	[self.view bringSubviewToFront:umbrellaSlider];
	[self.view bringSubviewToFront:iDiff];
	[self.view bringSubviewToFront:iAge];
	
	self.lastSafe = [NSNumber numberWithInt:4];
	self.lastEff = [NSNumber numberWithInt:4];
	
	[self resetNeedsChange];
	
	NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithCapacity:101];
	self.VMCardList = tempDict;
	[tempDict release];
	NSMutableArray *tempList = [[NSMutableArray alloc] init];
	//create dict of VMCard objects
	for (int i=0; i < kAllCardsCount; i++) {
		VMCard *theCard = [[VMCard alloc] initWithIndex:i];
		[tempList addObject:theCard.title];
		[VMCardList setObject:theCard forKey:theCard.title];
		[theCard release];
	}
	
	self.finalCardList = tempList;
	self.fullSortList = tempList;
	[tempList release];
	[self updateCoverFlow];
	
	[self initInfoMenu];
	
	[super viewDidLoad];
}

#pragma mark -
#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
	//NSLog(@"mem warning firstViewController");
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.iDiff = nil;
	self.iAge = nil;
	self.optionsView = nil;
	
	[super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
	
	[heartSlider release];
	[umbrellaSlider release];
	
	[iDiff release];
	[iAge release];
	
	[lastSafe release];
	[lastEff release];
	[lastDiff release];
	[lastAge release];
	
	[cardDictionary release];
	[finalCardList release];
	[cardTitles release];
	
	[heartSlider release];
	[umbrellaSlider release];
	
	[VMCardList release];
	[myIndicator release];
	
	[optionsView release];
	[fullSortList release];
}

#pragma mark -
#pragma mark Touch Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
}

- (void)updateCoverFlow {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (loadCheck) {
		openFlowViewController *tempcontroller = [[openFlowViewController alloc] 
													 initWithNibName:@"openFlowView"
													 bundle:nil];
		self.flowController = tempcontroller;
		[tempcontroller release];
		[self.view insertSubview:flowController.view atIndex:0];
		self.loadCheck = NO;
	}
	self.flowController.useIllus = useIllustrations;
	[self.flowController refresh:self.finalCardList cards:self.VMCardList];
	//create tutorial (i) button
	UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
	
	CGRect btnRect = info.frame;
	CGRect frameRect = self.flowController.view.frame;
	
	btnRect.origin.x = frameRect.size.width - btnRect.size.width - 8;
	btnRect.origin.y = frameRect.size.height - btnRect.size.height - 25;
	
	[info setFrame:btnRect];
	
	[info addTarget:self action:@selector(animateInfo) forControlEvents:UIControlEventTouchDown];
	[info setFrame:btnRect];
	
	[self.flowController.view addSubview:info];
	
	//put sort sliders on top of their frame
	[self.view bringSubviewToFront:heartSlider];
	[self.view bringSubviewToFront:umbrellaSlider];
	[self.view bringSubviewToFront:iDiff];
	[self.view bringSubviewToFront:iAge];
	[self.view bringSubviewToFront:myIndicator];
	if (infoOnScreen) [self.view bringSubviewToFront:optionsView]; 
	
	[pool drain];
}

- (BOOL)shouldRefresh {
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	for (int i=0; i < [finalCardList count]; i++) {
		NSString *cardTitle = [self.finalCardList objectAtIndex:i];
		NSString *keystring = [NSString stringWithFormat:@"%@change",cardTitle];
		if ([favorites boolForKey:keystring])
			return YES;
	}
	return NO;
}

-(void)resetNeedsChange {
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	VMCard *anyCard = [[VMCard alloc] initWithIndex:0];
	for (int i=0; i <= 100; i++) {
		NSString *keystring = [[NSString alloc] initWithFormat:@"%@change",[[anyCard cardTitles] objectAtIndex:i]];
		[favorites setBool:NO forKey:keystring];
		[keystring release];
	}
	[favorites synchronize];
}

#pragma mark -
#pragma mark Info Menu Methods
- (void)initInfoMenu {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	UIControl *iView = [[UIControl alloc] initWithFrame:CGRectMake(0, 431.0f, 320.0f,118.0f)];
	iView.backgroundColor = [UIColor blackColor];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 89, 22)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.text = @"Strict Sort";
	label.font = [UIFont fontWithName:@"Cochin" size:18.0f];
	[iView addSubview:label];
	[label release];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(20, 43, 94, 22)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.text = @"Illustrations";
	label.font = [UIFont fontWithName:@"Cochin" size:18.0f];
	[iView addSubview:label];
	[label release];
	
	UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectMake(206, 3, 94, 27)];
	toggle.on = YES;
	[toggle addTarget:self action:@selector(toggleStrictSort) forControlEvents:UIControlEventValueChanged];
	[iView addSubview:toggle];
	[toggle release];
	
	toggle = [[UISwitch alloc] initWithFrame:CGRectMake(206, 41, 94, 27)];
	toggle.on = YES;
	[toggle addTarget:self action:@selector(switchImageSet) forControlEvents:UIControlEventValueChanged];
	[iView addSubview:toggle];
	[toggle release];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(20, 74, 280, 37);
	[button setTitle:@"Show All Cards" forState:UIControlStateNormal];
	[button setTitle:@"Show All Cards" forState:UIControlStateHighlighted];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	button.titleLabel.font = [UIFont fontWithName:@"Cochin" size:18.0f];
	[button setBackgroundImage:[[UIImage imageNamed:@"blacktoolbtn.png"] 
							   stretchableImageWithLeftCapWidth:10.0 
							   topCapHeight:0.0] 
	 forState:UIControlStateNormal];
	
	button.backgroundColor = [UIColor blackColor];
	//button.image = [UIImage imageNamed:@"showAllCards.png"];
	[button addTarget:self action:@selector(showAllCards) forControlEvents:UIControlEventTouchUpInside];
	[iView addSubview:button];
	//[button release];
	
	self.optionsView = iView;
	[iView release];
	[self.view addSubview:optionsView];
	
	[pool drain];
}

- (IBAction)showAllCards {
	self.finalCardList = self.fullSortList;
	[self updateCoverFlow];
	
	//[self hideInfoMenu];
}

- (IBAction)switchImageSet {
	BOOL temp = useIllustrations;
	self.useIllustrations = !temp;
	[self updateCoverFlow];
	
	//[self hideInfoMenu];
}

- (IBAction)toggleStrictSort {
	BOOL temp = useStrictSort;
	self.useStrictSort = !temp;
	
	//[self hideInfoMenu];
}

- (void)showInfoMenu {
	self.sortDisabled = YES;
	self.infoOnScreen = YES;
	[UIView beginAnimations:@"optionsView" context:nil];
    [UIView setAnimationDuration:0.5];
	
    optionsView.transform = CGAffineTransformMakeTranslation(0,-135);
    [UIView commitAnimations];
}

- (void)hideInfoMenu {
	//NSLog(@"hideInfoMenu");
	self.sortDisabled = NO;
	self.infoOnScreen = NO;
	[UIView beginAnimations:@"optionsView" context:nil];
    [UIView setAnimationDuration:0.5];
	
    optionsView.transform = CGAffineTransformMakeTranslation(0,135);
    [UIView commitAnimations];
}

- (void)animateInfo {
	[self.view bringSubviewToFront:optionsView];
	if (infoOnScreen) [self hideInfoMenu];
	else [self showInfoMenu];
}

@end

