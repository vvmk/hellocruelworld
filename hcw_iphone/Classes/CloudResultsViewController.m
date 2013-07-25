//
//  CloudResultsViewController.m
//  hcw_iphone
//
//  Created by Vince Masiello on 8/5/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import "CloudResultsViewController.h"
#import "DisplayViewController.h"

@implementation CloudResultsViewController
@synthesize cloudResultsView;

@synthesize listData;
@synthesize feelings;

- (void)viewWillAppear: (BOOL)animated {
	[[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
	[[self navigationController] setNavigationBarHidden:NO animated:NO];
	
	NSArray *array = [[NSArray alloc] initWithArray:[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] 
																						 pathForResource:@"feelings" 
																						 ofType:@"txt"]
																			   encoding:NSUTF8StringEncoding
																				  error:nil]
													 componentsSeparatedByString:@"\n"]];
	self.feelings = array;
	[array release];
	
	[super viewDidLoad];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cloudResults = @"cloudResults";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 cloudResults];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:cloudResults] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [listData objectAtIndex:row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	if ([favorites boolForKey:[listData objectAtIndex:row]])
		cell.imageView.image = [UIImage imageNamed:@"star.png"];
	cell.textLabel.textColor = [self colorForCard:[listData objectAtIndex:row]];
	
	return cell;
}


#pragma mark -
#pragma mark Table Delegate Methods


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	NSString *rowValue = [listData objectAtIndex:row];
	
	DisplayViewController *tempViewController =[[DisplayViewController alloc] 
												initWithNibName:@"DisplayView"
												bundle:nil];
	tempViewController.currentCard = rowValue;
	[self.navigationController pushViewController:tempViewController animated:YES];		
	[tempViewController release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[cloudResultsView release];
	[listData release];
	[feelings release];
    [super dealloc];
}

- (UIColor *)colorForCard:(NSString *)card {
	
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	NSString *key = [NSString stringWithFormat:@"%@feeling",card];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"txt"];
	NSString *contents = [NSString stringWithContentsOfFile:path  encoding:NSUTF8StringEncoding error:nil];
	NSArray *colors = [contents componentsSeparatedByString:@"\n"];
	
	int hexIndex = 0;
	if ([[favorites objectForKey:key] isKindOfClass:[NSString class]])
		hexIndex = [feelings indexOfObject:[favorites objectForKey:key]];
	else 
		return [UIColor blackColor];
	
	NSString *hex = [colors objectAtIndex:hexIndex];
	
    NSRange range;  
    range.location = 0;  
    range.length = 2;  
    NSString *rString = [hex substringWithRange:range];  
	
    range.location = 2;  
    NSString *gString = [hex substringWithRange:range];  
	
    range.location = 4;  
    NSString *bString = [hex substringWithRange:range];  
	
    unsigned int r, g, b;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];  
	
    return [UIColor colorWithRed:((float) r / 255.0f)  
                           green:((float) g / 255.0f)  
                            blue:((float) b / 255.0f)  
                           alpha:1.0f];
}

@end

