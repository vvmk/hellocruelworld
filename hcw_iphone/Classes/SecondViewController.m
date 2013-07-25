    //
//  SecondViewController.m
//  hcw_iphone
//
//  Created by Vince Masiello on 8/5/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import "SecondViewController.h"
#import "CloudResultsViewController.h"
#import "TutorialViewController.h"

@implementation SecondViewController
@synthesize cloudResultsViewController;

@synthesize touchDown;
@synthesize keyResults;

- (NSArray *)getResultsForKeyword:(NSString *)keyword {
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *plistPath = [bundle pathForResource:@"Alternatives3" ofType:@"plist"];
	NSDictionary *cardDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
	NSArray *cardTitles = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] 
														  pathForResource:@"titles" 
														  ofType:@"txt"] 
												encoding:NSUTF8StringEncoding
												   error:nil]
					  componentsSeparatedByString:@"\n"];
	
	NSMutableArray *tempList = [[NSMutableArray alloc] init];
	for (int i=0; i<101;i++) {
		NSArray *theCard = [cardDict objectForKey:[cardTitles objectAtIndex:i]];
		NSArray *kws = [[theCard objectAtIndex:4] componentsSeparatedByString:@", "];
		if ([kws containsObject:keyword])
			[tempList addObject:[cardTitles objectAtIndex:i]];
			
	}
	return tempList;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	self.touchDown = touch.view;

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	UILabel *label = (UILabel *)touch.view;
	if ([label respondsToSelector:@selector(setText:)]) {
		NSString *keyword = [[NSString alloc] initWithFormat:@"%@", label.text];
		NSArray *results = [self getResultsForKeyword:keyword];
		
		CloudResultsViewController *crViewController = [[CloudResultsViewController alloc]
														initWithNibName:@"CloudResultsView" 
														bundle:nil];
		
		crViewController.listData = results;
		[self.navigationController pushViewController:crViewController animated:YES];
		
		[keyword release];
		[results release];
		[crViewController release];
	}
	
}

- (void)viewWillAppear: (BOOL)animated {
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
	
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
